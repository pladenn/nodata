--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: tmp_action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tmp_action (
    id uuid,
    code character varying(50),
    connection_id uuid,
    query text,
    content text,
    execution_type character varying(40),
    title text,
    post_process text,
    description text,
    redirect character varying,
    name text
);


ALTER TABLE public.tmp_action OWNER TO postgres;

--
-- Data for Name: tmp_action; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('ab69c504-e716-5bd6-f67e-11b186f98c49', 'user-table-privileges', '280508e7-9ad9-0607-bf04-eee56d322ab7', '-- Report: privileges across catalogued connections, filtered by fuzzy user/table lists
-- and an environment list.
--
-- Catalog tables:
--   connections(id, service_name, environment, url, login, password, active)
--   tables(id, schema_name, table_name, description, ddl_script)
--   privileges(id, connection_id, table_id, can_select, can_insert, can_update, can_delete)
--
-- Named parameters:
--   :logins e.g. ''chat, woofer''  -> matches login OR service_name ILIKE ''%chat%'' OR ''%woofer%''
--   :tables e.g. ''lead, config''  -> matches schema.table ILIKE ''%lead%'' OR ''%config%''
--   :envs   e.g. ''prod, stage''   -> environment IN (''prod'',''stage'') (case-insensitive)
--
-- Each comma-separated value is trimmed; users/tables are wrapped as %value% and matched
-- case-insensitively with ILIKE ANY; environments are matched exactly (lower-cased).
-- Any parameter passed as NULL, empty, or whitespace-only disables its filter
-- (that dimension is not restricted).
--
-- __object: {"privileges": <full privileges row>, "table": <full tables row, plus
-- full_table_name = schema_name || ''.'' || table_name>}. __object.table.full_table_name feeds the
-- "Table DDL" row link into table-ddl.

SELECT
    c.service_name,
    c.login,
    c.environment,
    t.schema_name || ''.'' || t.table_name AS "table",
    p.can_select,
    p.can_insert,
    p.can_update,
    p.can_delete,
    jsonb_build_object(
        ''privileges'', to_jsonb(p),
        ''table'', to_jsonb(t) || jsonb_build_object(
            ''full_table_name'', t.schema_name || ''.'' || t.table_name
        )
    ) AS __object
FROM privileges p
         JOIN connections c ON c.id = p.connection_id
         JOIN tables t ON t.id = p.table_id
WHERE (nullif(trim(:logins::varchar), '''') IS NULL
          OR c.login ILIKE ANY (ARRAY(
              SELECT ''%'' || trim(x) || ''%'' FROM unnest(string_to_array(:logins::varchar, '','')) AS x))
          OR c.service_name ILIKE ANY (ARRAY(
              SELECT ''%'' || trim(x) || ''%'' FROM unnest(string_to_array(:logins::varchar, '','')) AS x)))
  AND (nullif(trim(:tables::varchar), '''') IS NULL OR (t.schema_name || ''.'' || t.table_name) ILIKE ANY (ARRAY(
          SELECT ''%'' || trim(tb) || ''%'' FROM unnest(string_to_array(:tables::varchar, '','')) AS tb)))
  AND (nullif(trim(:envs::varchar), '''') IS NULL OR lower(c.environment) = ANY (
          SELECT lower(trim(e)) FROM unnest(string_to_array(:envs::varchar, '','')) AS e))
ORDER BY c.environment, c.login, "table"', NULL, 'SQL', 'User/table priveleges', NULL, '## Purpose

Explore the **privilege matrix** -- which service login can select/insert/update/delete which table
-- across the "Database structure" catalog, a small, separate PostgreSQL metadata database
(`jdbc:postgresql://localhost:5432/kb`, connection **"Knowlege base"**, id
`280508e7-9ad9-0607-bf04-eee56d322ab7`). This catalog holds metadata *about* the shared
qa/stage/prod PostgreSQL database, refreshed by manually re-running
`C:\IB\export-data\Tables.java` -- it can drift from the live database between runs, and it is not
itself a live qa/stage/prod connection.

## Parameters (all optional; omit all for every row -- roughly 3,800 unfiltered)

Each parameter is a comma-separated list; values within one parameter combine with **OR**, and the
three parameters combine with **AND**:

- **`logins`** -- fuzzy substring (`ILIKE ''%value%''`), matched against **either**
  `connections.login` **or** `connections.service_name`. E.g. `logins=chat, woofer` matches any row
  whose login or service name contains "chat" OR "woofer".
- **`tables`** -- fuzzy substring against the fully-qualified `schema.table_name`.
- **`envs`** -- **exact**, case-insensitive match against `connections.environment` (e.g. `qa`,
  `stage`, `prod` -- there are **no `dev` rows** in this catalog).

A parameter that is omitted, empty, or whitespace-only disables that filter dimension entirely.

## What it returns

One row per `(connection, table)` privilege: `service_name`, `login`, `environment`, `table`
(`schema.table_name`), and the four booleans `can_select` / `can_insert` / `can_update` /
`can_delete`. Ordered by `environment`, `login`, `table`.

## Use case

This endpoint is for **exploration** -- e.g. "who can write to this table in qa?" -- and, since
`tables` is a plain substring match with no DDL attached, it doubles as a lightweight table-name
search. Each returned row stands alone; it does not tell you whether any *single* login covers a
whole set of tables at once. For the actual "pick one login for my multi-table statement" task, use
**`find-login-for-tables`** instead -- it takes an exact table set so the result can be grouped by
login and checked for full coverage.
', NULL, 'User/table priveleges');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('6265989e-67d2-68ef-9dee-12efe4a4d88d', 'system-action-link-mappings', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select
    al.title "Link title",
    pa.title "Parent action name",
    pa.code "Parent action code",
    ca.title "Child action name",
    ca.code "Child action code",
    p.title "Child parmater title",
    alm.mapping "Parent action value",
    alm.default_value "Default value",
    p.name "Child parmater name",
    p.type "Child parmater type",
    jsonb_build_object(
        ''action_link'', to_jsonb(al),
        ''parent_action'', COALESCE(to_jsonb(pa), ''{}''::jsonb),
        ''child_action'', to_jsonb(ca),
        ''parameter'', to_jsonb(p),
        ''action_link_mapping'', COALESCE(to_jsonb(alm), ''{}''::jsonb)
    ) __object
from action_link al
         join action ca on al.child_action_id = ca.id
         left join action pa on al.parent_action_id = pa.id
         join parameter p on ca.id = p.action_id
         left join action_link_mapping alm on al.id = alm.action_link_id and alm.parameter_id = p.id
where (:action_link_id::uuid is null or al.id = :action_link_id)
and (:parameter_id::uuid is null or (p.id = :parameter_id and alm.id is not null))
and (:action_link_id::uuid is not null or :parameter_id::uuid is not null)
order by pa.title, ca.title, p.order', NULL, 'SQL', 'Link mapping', NULL, 'Link mapping', NULL, 'Link mapping');


--
-- PostgreSQL database dump complete
--

