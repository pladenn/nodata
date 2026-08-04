package com.pladen.util;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Generates a Liquibase migration folder that copies the nodata <b>configuration</b>
 * (actions, links, parameters, columns, connections, properties) from the <b>dev</b>
 * instance DB ({@code nodata}, the {@code 9944} app) into the <b>work</b> instance DB
 * ({@code nodata1}, the {@code 9955} app).
 *
 * <p>This automates what used to be a manual three-step process
 * ({@code scripts/db_preparation.sql} + IntelliJ "SQL Insert" export + a hand-written
 * {@code upd_script.sql}). Run {@link #main(String[])} from the IDE; on the work
 * instance's next reboot Liquibase ({@code changelog.xml} → {@code <includeAll path="db"/>})
 * applies the generated folder.
 *
 * <p>What it does, in order:
 * <ol>
 *   <li><b>Prepare</b> (JDBC, against dev): snapshot every {@link #TABLES migrated table}
 *       into a {@code tmp_*} copy — but only the rows that are <i>new or changed</i> since the
 *       last migration, detected by comparing each row's {@code md5(to_jsonb(...))} content-hash
 *       against the {@code sys_obj} manifest (which now stores {@code (id, tbl, hash)}). Then
 *       rebuild the manifest with current hashes, compute {@code tmp_del_sys_obj} (objects
 *       deleted on dev, so their deletion propagates to work), and strip the
 *       {@link #EXCLUDED_ROWS work-only rows} (the custom sub-menu) so they are never
 *       overwritten in work.</li>
 *   <li><b>Dump</b> each {@code tmp_*} table with {@code pg_dump --column-inserts}
 *       (CREATE&nbsp;TABLE + INSERTs) into the new folder.</li>
 *   <li><b>Generate</b> {@code upd_script.sql} by <i>introspecting the current columns</i>
 *       of each table, so adding/removing a column or table only needs an edit to
 *       {@link #TABLES} — no hand-maintained SQL.</li>
 * </ol>
 *
 * <p>File naming guarantees load order inside the folder: every data file starts with
 * {@code tmp_} and the merge script is {@code upd_script.sql}; since {@code 't' < 'u'},
 * Liquibase's alphabetical sort always runs the data before the merge.
 */
public class MigrationGenerator {

    // ---------------------------------------------------------------------
    // Configuration — edit these.
    // ---------------------------------------------------------------------

    /**
     * Source (dev) database in libpq URI form. The login and password are taken from here
     * (and the same URI is handed to {@code pg_dump}).
     */
    private static final String SOURCE_DB_URI = "postgresql://postgres:postgres@localhost:5432/nodata";

    /** Root that Liquibase scans ({@code <includeAll path="db"/>}); new folders are created here. */
    private static final Path RESOURCES_DB_DIR =
            Paths.get("C:", "Workspace", "nodata", "src", "main", "resources", "db");

    /**
     * Full path to the {@code pg_dump} executable. Java's {@code ProcessBuilder} calls Windows
     * {@code CreateProcess} directly (no shell), so it does <b>not</b> search the PATH the way a
     * console does — give it the absolute path. Adjust if your PostgreSQL version/location differs.
     */
    private static final String PG_DUMP = "C:\\Program Files\\PostgreSQL\\16\\bin\\pg_dump.exe";

    /**
     * Tables to migrate, ordered <b>parent → child</b>. MERGE (insert/update by id) runs in
     * this order; delete-propagation runs in the <i>reverse</i> (child → parent) order. To add
     * or remove a table from the migration, just edit this list.
     */
    private static final List<String> TABLES = List.of(
            "connection",
            "action",
            "action_link",
            "column",
            "parameter",
            "action_link_mapping",
            "property_category",
            "property",
            "properties"
    );

    /**
     * Work-instance-only rows to exclude from the migration so a dev→work run never overwrites
     * them. These are removed from the {@code tmp_*} copies during preparation. Currently the
     * custom sub-menu (which is maintained only in the work instance).
     */
    private static final List<ExcludedRow> EXCLUDED_ROWS = List.of(
            new ExcludedRow("property_category", "6d0f1247-e398-03b4-aa5e-269ade84af52"),
            new ExcludedRow("action", "e587b6a0-ef4c-2f7b-4a69-5c8fc19f22f2")
    );

    // ---------------------------------------------------------------------

    /** A single row (by id) excluded from the migration. */
    private record ExcludedRow(String table, String id) {}

    /** Parsed source-DB coordinates. */
    private record Db(String jdbcUrl, String user, String password) {
        static Db parse(String uri) {
            // postgresql://user:pass@host:port/db
            String rest = uri.substring(uri.indexOf("://") + 3);
            int at = rest.lastIndexOf('@');
            String creds = rest.substring(0, at);
            String hostAndDb = rest.substring(at + 1);
            int colon = creds.indexOf(':');
            String user = creds.substring(0, colon);
            String password = creds.substring(colon + 1);
            return new Db("jdbc:postgresql://" + hostAndDb, user, password);
        }
    }

    public static void main(String[] args) throws Exception {
        Db db = Db.parse(SOURCE_DB_URI);
        Path outDir = createOutputDir();
        System.out.println("Migration folder: " + outDir);

        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException ignored) {
            // JDBC 4+ auto-registers via SPI; the explicit load is only a safety net.
        }

        try (Connection conn = DriverManager.getConnection(db.jdbcUrl(), db.user(), db.password())) {
            conn.setAutoCommit(true); // pg_dump reads committed data in a separate process
            prepare(conn);
            Map<String, List<String>> columns = introspectColumns(conn);

            dumpTables(outDir); // pg_dump reads the committed tmp_* tables

            Files.writeString(outDir.resolve("upd_script.sql"),
                    generateUpdScript(columns), StandardCharsets.UTF_8);
            System.out.println("Wrote upd_script.sql");

            // Drop the tmp_* tables from dev now that they are dumped. dev and work share this
            // codebase, so Liquibase will later apply the generated folder against dev too; its
            // tmp_*.sql files must be able to CREATE these tables, and leftovers would collide
            // with "relation already exists". (sys_obj is the persistent manifest — kept.)
            dropTmpTables(conn);
        }

        System.out.println("Done. Reboot the work instance to apply.");
    }

    // ---------------------------------------------------------------------
    // Step 1 — preparation (equivalent to scripts/db_preparation.sql)
    // ---------------------------------------------------------------------

    private static void prepare(Connection conn) throws SQLException {
        List<String> ddl = new ArrayList<>();

        // Ensure the manifest exists (bootstraps the very first run) and has the hash column
        // (upgrades an older 2-column sys_obj; pre-existing rows get hash = NULL, forcing a
        // one-time full re-export until the hashes are populated).
        ddl.add("create table if not exists sys_obj (id uuid, tbl text, hash text)");
        ddl.add("alter table sys_obj add column if not exists hash text");

        // Snapshot the PREVIOUS manifest (state as of the last migration), incl. its hashes.
        ddl.add("drop table if exists tmp_sys_obj");
        ddl.add("create table tmp_sys_obj as select * from sys_obj");

        // Rebuild the CURRENT manifest from the live tables, recording each row's content-hash.
        // This is the ONLY place rows are hashed — the tmp_* snapshots below reuse these hashes
        // instead of recomputing md5.
        StringBuilder manifest = new StringBuilder("create table sys_obj as\n");
        for (int i = 0; i < TABLES.size(); i++) {
            String name = TABLES.get(i);
            manifest.append(i == 0 ? "select" : "union all select")
                    .append(" x.id, '").append(name).append("' tbl, ").append(rowHash("x"))
                    .append(" hash from ").append(q(name)).append(" x\n");
        }
        ddl.add("drop table if exists sys_obj");
        ddl.add(manifest.toString().trim());

        // Build the delta SET once: new or changed rows, found by left-joining the current
        // manifest to the previous one. `is distinct from` is null-safe, so a new id (no old
        // row → null hash) and a changed hash both qualify; unchanged rows are excluded.
        ddl.add("drop table if exists tmp_changed");
        ddl.add("create table tmp_changed as\n"
                + "select s.id, s.tbl\n"
                + "from sys_obj s\n"
                + "left join tmp_sys_obj o on o.id = s.id\n"
                + "where o.hash is distinct from s.hash");

        // Each tmp_* snapshot = the live rows whose id is present in the delta set for that table.
        for (String t : TABLES) {
            ddl.add("drop table if exists " + tmp(t));
            ddl.add("create table " + tmp(t) + " as\n"
                    + "select x.* from " + q(t) + " x\n"
                    + "join tmp_changed c on c.id = x.id and c.tbl = '" + t + "'");
        }

        // Strip work-only rows so they are never overwritten in the work instance.
        for (ExcludedRow e : EXCLUDED_ROWS) {
            ddl.add("delete from " + tmp(e.table()) + " where id = '" + e.id() + "'");
        }

        // Objects present in the previous manifest but gone now = deleted on dev.
        ddl.add("drop table if exists tmp_del_sys_obj");
        ddl.add("create table tmp_del_sys_obj as "
                + "select * from tmp_sys_obj where id not in (select id from sys_obj)");

        // Re-snapshot the manifest so the new state travels to work.
        ddl.add("drop table tmp_sys_obj");
        ddl.add("create table tmp_sys_obj as select * from sys_obj");

        // Drop the dev-side delta scratch table (never dumped to work).
        ddl.add("drop table tmp_changed");

        try (Statement st = conn.createStatement()) {
            for (String sql : ddl) {
                st.execute(sql);
            }
        }
        System.out.println("Prepared " + TABLES.size() + " tmp_* tables + sys_obj manifest.");
    }

    // ---------------------------------------------------------------------
    // Column introspection
    // ---------------------------------------------------------------------

    private static Map<String, List<String>> introspectColumns(Connection conn) throws SQLException {
        Map<String, List<String>> result = new LinkedHashMap<>();
        String sql = "select column_name from information_schema.columns "
                + "where table_schema = 'public' and table_name = ? order by ordinal_position";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (String t : TABLES) {
                List<String> cols = new ArrayList<>();
                ps.setString(1, t);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        cols.add(rs.getString(1));
                    }
                }
                if (cols.isEmpty()) {
                    throw new IllegalStateException("No columns found for table '" + t
                            + "' — is the name correct?");
                }
                result.put(t, cols);
            }
        }
        return result;
    }

    // ---------------------------------------------------------------------
    // Step 2 — dump the tmp_* tables via pg_dump
    // ---------------------------------------------------------------------

    /** The tmp_* tables that make up a migration folder (dumped, and dropped from dev afterward). */
    private static List<String> migrationTmpTables() {
        List<String> tmpTables = new ArrayList<>();
        for (String t : TABLES) {
            tmpTables.add(tmp(t));
        }
        tmpTables.add("tmp_del_sys_obj");
        tmpTables.add("tmp_sys_obj");
        return tmpTables;
    }

    private static void dumpTables(Path outDir) throws IOException, InterruptedException {
        for (String tmpTable : migrationTmpTables()) {
            Path file = outDir.resolve(tmpTable + ".sql");
            List<String> cmd = List.of(
                    PG_DUMP,
                    "-d", SOURCE_DB_URI,
                    "-t", tmpTable,
                    "--column-inserts",
                    "-f", file.toString()
            );
            ProcessBuilder pb = new ProcessBuilder(cmd);
            pb.redirectErrorStream(true);
            Process p = pb.start();
            String output = new String(p.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
            int code = p.waitFor();
            if (code != 0) {
                throw new IllegalStateException("pg_dump failed for " + tmpTable
                        + " (exit " + code + "):\n" + output);
            }
            System.out.println("Dumped " + tmpTable + " -> " + file.getFileName());
        }
    }

    /**
     * Drop the {@code tmp_*} tables from the source (dev) DB once they have been dumped. Because
     * dev and work share this codebase, Liquibase will apply the generated folder against dev too,
     * and its {@code tmp_*.sql} files CREATE these tables — leftovers on dev would collide. The
     * {@code sys_obj} manifest is intentionally kept (it is the baseline for the next run).
     */
    private static void dropTmpTables(Connection conn) throws SQLException {
        List<String> tmpTables = migrationTmpTables();
        try (Statement st = conn.createStatement()) {
            for (String tmpTable : tmpTables) {
                st.execute("drop table if exists " + tmpTable);
            }
        }
        System.out.println("Dropped " + tmpTables.size() + " tmp_* tables from dev.");
    }

    // ---------------------------------------------------------------------
    // Step 3 — generate upd_script.sql from the introspected columns
    // ---------------------------------------------------------------------

    private static String generateUpdScript(Map<String, List<String>> columns) {
        StringBuilder sb = new StringBuilder();

        // MERGE (insert/update by id) each table, parent -> child.
        for (String t : TABLES) {
            List<String> cols = columns.get(t);
            sb.append("MERGE INTO ").append(q(t)).append(" t1 USING ").append(tmp(t))
                    .append(" t2 ON t1.id = t2.id\n");

            sb.append("WHEN NOT MATCHED THEN\n    INSERT (");
            sb.append(joinCols(cols, ""));
            sb.append(")\n    VALUES (");
            sb.append(joinCols(cols, "t2."));
            sb.append(")\n");

            sb.append("WHEN MATCHED THEN\n    UPDATE SET\n");
            List<String> setters = new ArrayList<>();
            for (String c : cols) {
                if (c.equals("id")) {
                    continue; // join key
                }
                setters.add("        " + qc(c) + " = t2." + qc(c));
            }
            sb.append(String.join(",\n", setters)).append("\n;\n\n");
        }

        // Restore the manifest in work.
        sb.append("drop table sys_obj;\n");
        sb.append("create table sys_obj as select * from tmp_sys_obj;\n\n");

        // Propagate deletions, child -> parent.
        for (int i = TABLES.size() - 1; i >= 0; i--) {
            sb.append("delete from ").append(q(TABLES.get(i)))
                    .append(" where id in (select id from tmp_del_sys_obj);\n");
        }
        sb.append('\n');

        // Clean up all tmp_* tables in work.
        for (String t : TABLES) {
            sb.append("drop table ").append(tmp(t)).append(";\n");
        }
        sb.append("drop table tmp_del_sys_obj;\n");
        sb.append("drop table tmp_sys_obj;\n");

        return sb.toString();
    }

    private static String joinCols(List<String> cols, String prefix) {
        List<String> parts = new ArrayList<>(cols.size());
        for (String c : cols) {
            parts.add(prefix + qc(c));
        }
        return String.join(", ", parts);
    }

    // ---------------------------------------------------------------------
    // Output folder: db/update-<yyyyMMdd><NN>
    // ---------------------------------------------------------------------

    private static Path createOutputDir() throws IOException {
        String stamp = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String prefix = "update-" + stamp;
        int max = 0;
        if (Files.isDirectory(RESOURCES_DB_DIR)) {
            try (DirectoryStream<Path> ds = Files.newDirectoryStream(RESOURCES_DB_DIR, prefix + "*")) {
                for (Path p : ds) {
                    String tail = p.getFileName().toString().substring(prefix.length());
                    try {
                        max = Math.max(max, Integer.parseInt(tail));
                    } catch (NumberFormatException ignored) {
                        // not a NN-suffixed folder; skip
                    }
                }
            }
        }
        Path dir = RESOURCES_DB_DIR.resolve(prefix + String.format("%02d", max + 1));
        Files.createDirectories(dir);
        return dir;
    }

    // ---------------------------------------------------------------------
    // Identifier quoting
    // ---------------------------------------------------------------------

    /** Quote a real table name (may be a reserved word such as {@code column}). */
    private static String q(String name) {
        return "\"" + name + "\"";
    }

    /** The tmp_ snapshot table name (never a reserved word, so left unquoted). */
    private static String tmp(String name) {
        return "tmp_" + name;
    }

    /** Quote a column name (safe for reserved words like {@code order}/{@code group}). */
    private static String qc(String column) {
        return "\"" + column + "\"";
    }

    /**
     * Content-hash expression for a whole row referenced by {@code alias}. Used identically in
     * the snapshot filter and the manifest rebuild so a row's hash is stable across runs (as long
     * as the table's column set is unchanged — a schema change re-hashes every row once).
     */
    private static String rowHash(String alias) {
        return "md5(to_jsonb(" + alias + ")::text)";
    }

    private MigrationGenerator() {
    }
}
