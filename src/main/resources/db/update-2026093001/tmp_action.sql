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

INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('97775d1b-b328-4667-93b7-8a16fb054bcd', 'storage-entry-prettify-json', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'update properties set value = case when value is json then jsonb_pretty(value::jsonb) else value end where id = :id::uuid and parent_id = ''387b57d2-3fcd-485c-9777-913d51b8610c''', NULL, 'SQL_DML', NULL, NULL, 'Formats a storage entry''s stored value with jsonb_pretty() when the value is valid JSON; leaves the value untouched (silent no-op) when it is not.', '{request-parameters._original_url}', 'Prettify JSON');
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
--    p.id parameter_id,
--    al.id action_link_id,
--    alm.id action_link_mapping_id,
--    al.parent_action_id,
--    al.child_action_id,
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
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('f46d9d65-acbf-4282-97d9-fb5f99540554', 'storage-entry-copy', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'insert into properties (id, parent_id, key, value) select gen_random_uuid(), p.parent_id, case when nullif(trim(:name::text), '''') is null or trim(:name::text) = p.key then p.key || '' '' || to_char(clock_timestamp(), ''YYYY-MM-DD HH24:MI:SS.MS'') else :name::varchar end, p.value from properties p where p.id = :id::uuid and p.parent_id = ''387b57d2-3fcd-485c-9777-913d51b8610c''', NULL, 'SQL_DML', NULL, NULL, 'Copies a storage entry''s value into a new entry under the same storage root. The new name defaults to the original entry''s name plus a millisecond-precision timestamp when the given name is blank/omitted OR equal to the original entry''s own name; otherwise the given name is used as-is.', NULL, 'Copy entry');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('eeaece13-e0bb-40e1-b093-c6e05658be57', 'system-any-post-http-request', '6fdfb5ed-816e-77a1-3e13-d84bbb452939', NULL, '{body}', 'HTTP_POST', 'Any POST http request', NULL, 'Generic HTTP POST proxy, twin of system-any-get-http-request. POSTs {body} (raw text) to the full URL given as {url}. Same ''Any HTTP'' connection (url = {parameters.url}), so it works against any downstream target, internal or external.', NULL, 'Any POST http request');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('c3532f35-be82-043c-7a80-700d5dc87d6f', 'password-generator', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with a as (select chr, random() r, row_number() over () rn
           from regexp_split_to_table(''ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%&()*+-:<=>?[]{}~'', '''')  chr),

     b as (select string_agg(chr, '''' order by r) str from a)

select a.rn length , substr(b.str, 1, a.rn::int)  password 
from a
  cross join b
where a.rn >= 6
', NULL, 'SQL', 'Password generator', NULL, 'Password generator', NULL, 'Password generator');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('92cb9478-8f04-4e67-92b5-72c9c6063044', 'generate-uuid', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select gen_random_uuid() as uuid
from generate_series(1, 5)
', NULL, 'SQL', 'Generate UUID', NULL, 'Generates 5 random UUIDs', NULL, 'Generate UUID');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('4cdb1b7c-3913-4b60-a100-9fb659a06679', 'timestamp-to-datetime', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select case when length(trim(:timestamp_value::varchar)) > 10
            then to_timestamp(:timestamp_value::bigint / 1000.0)
            else to_timestamp(:timestamp_value::bigint)
       end as datetime
', NULL, 'SQL', 'Timestamp to datetime', NULL, 'Converts a Unix epoch timestamp (seconds or milliseconds) to a datetime', NULL, 'Timestamp to datetime');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('b44a0e2b-ca69-44d0-9f02-7ae31e7d6103', 'datetime-to-timestamp', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select extract(epoch from :datetime_value::timestamp)::bigint      as timestamp_seconds,
       (extract(epoch from :datetime_value::timestamp) * 1000)::bigint as timestamp_millis
', NULL, 'SQL', 'Datetime to timestamp', NULL, 'Converts a datetime to Unix epoch timestamp (seconds and milliseconds)', NULL, 'Datetime to timestamp');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('37ff260c-4cab-486c-9abc-0ef7c0f90198', 'base64-to-text', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select convert_from(decode(:base64_value, ''base64''), ''UTF8'') as text
', NULL, 'SQL', 'Base64 to text', NULL, 'Decodes a base64 string to text', NULL, 'Base64 to text');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('2f8b4ebf-d425-4e6c-ae74-24b8d3ff6c2c', 'text-to-base64', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select encode(convert_to(:text_value, ''UTF8''), ''base64'') as base64
', NULL, 'SQL', 'Text to base64', NULL, 'Encodes text to a base64 string', NULL, 'Text to base64');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('cb2677d6-2334-cd9e-5fe8-b2d76a05360f', 'table-ddl', '280508e7-9ad9-0607-bf04-eee56d322ab7', '-- Query behind the "get table DDL" endpoint.
--
-- Three ways to select rows (use one or more):
--   1. by table-name mask (:tables)       -- "give me the DDL for the tables named like this"
--   2. by fuzzy search over the DDL text (:ddl_contains) -- "which tables'' DDL mentions X?"
--   3. by exact catalog row id (:id)      -- used by the "DDL" drill-down link''s self-referencing __view
--
-- (2) is a reverse-reference lookup: because ddl_script contains the full CREATE TABLE incl.
-- foreign-key `REFERENCES ...` clauses, searching the DDL for a table name finds every table
-- that references it (or otherwise mentions it). This discovers the *bridge / junction / firm*
-- table that links into a set of tables and carries the filter column (e.g. wld_id) -- without
-- guessing names, and it also finds how an otherwise-disconnected table (e.g. fl_tag_platform)
-- is wired in.
--
-- DDL is environment-independent: the catalog `tables` row is registered once per
-- (schema_name, table_name), so there is no environment parameter.
--
-- Catalog table:
--   tables(id, schema_name, table_name, description, ddl_script)
--
-- Named parameters (at least one should be provided; a NULL/empty one contributes nothing):
--   :tables        comma-separated MASKS matched against the fully-qualified `schema.table`
--                  name, case-insensitively. A mask is a SUBSTRING by default, so all of
--                  `wld.practice_area`, `practice_area`, `practice` and `wld.` match
--                  `wld.practice_area`. A mask that CONTAINS a `%` is used as an ILIKE
--                  pattern verbatim (no implicit wrapping), so it can be anchored:
--                  `wld.%` = every table in schema wld, `%_area` = names ending in `_area`.
--                  (`_` is always the single-character ILIKE wildcard -- harmless here since
--                  it also matches a literal underscore.) A row matches if ANY mask hits.
--   :ddl_contains  comma-separated substrings; returns tables whose ddl_script contains ANY of
--                  them (case-insensitive `ILIKE ''%value%''`). Typically a single table name to
--                  find everything that references it.
--   :id            exact catalog row id (integer). Used to fetch exactly one row unambiguously
--                  -- the mask/ddl_contains filters above are fuzzy and can match more than one
--                  table, which would break a single-row drill-down.
--
-- Returns one row per matched table. The visible columns are just table + description; the DDL
-- itself is in __object.table.ddl_script (along with the rest of the catalog row, nested under
-- "table") -- keeping it out of the flat list means a fuzzy search returns a readable table
-- instead of walls of DDL.
-- __object is shaped {"table": {...full catalog row...}, "__view": {...}} -- the catalog row is
-- nested under "table" rather than merged into __object directly (matching the chat-leads
-- event/chat and open-reports-all-reports "report" convention). __view is a drill-down (table
-- name + full ddl, rendered via view-any-object, row link titled "DDL") -- see
-- nodata-view-any-object.md.
-- A row matches if it satisfies ANY provided filter (name mask, ddl-contains, or exact id).
-- If no parameter is provided, nothing is returned.

SELECT t.schema_name || ''.'' || t.table_name AS "table",
       t.description,
       jsonb_build_object(''table'', to_jsonb(t)) || jsonb_build_object(
           ''__view'', jsonb_build_object(
               ''url'', ''{properties.system.localhost-http-url}/content/system/table-ddl/data?id='' || t.id,
               ''fields'', jsonb_build_array(
                   jsonb_build_array(''data.table'', ''Table name'', ''string''),
                   jsonb_build_array(''data.__object.table.ddl_script'', ''DDL'', ''text'')
               )
           )
       ) AS __object
FROM tables t
WHERE (nullif(trim(:tables::varchar), '''') IS NOT NULL
       AND t.schema_name || ''.'' || t.table_name ILIKE ANY (ARRAY(
               SELECT CASE WHEN strpos(m, ''%'') > 0 THEN m ELSE ''%'' || m || ''%'' END
               FROM (SELECT trim(x) AS m
                     FROM unnest(string_to_array(:tables::varchar, '','')) AS x) s
               WHERE m <> '''')))
   OR (nullif(trim(:ddl_contains::varchar), '''') IS NOT NULL
       AND t.ddl_script ILIKE ANY (ARRAY(
               SELECT ''%'' || trim(y) || ''%''
               FROM unnest(string_to_array(:ddl_contains::varchar, '','')) AS y
               WHERE nullif(trim(y), '''') IS NOT NULL)))
   OR (:id::integer IS NOT NULL AND t.id = :id::integer)
ORDER BY "table"
', NULL, 'SQL', 'Table ddl', NULL, '## Purpose

Look up the stored **DDL** (`CREATE TABLE` script) and description for one or more tables, from the
"Database structure" catalog -- a small, separate PostgreSQL metadata database
(`jdbc:postgresql://localhost:5432/kb`, connection **"Knowlege base"**, id
`280508e7-9ad9-0607-bf04-eee56d322ab7`). This catalog is metadata *about* the shared qa/stage/prod
PostgreSQL database used by many services -- it is **not** nodata''s own config DB, and **not** a
live qa/stage/prod connection itself.

## Parameters (at least one should be provided -- with none, 0 rows are returned)

Provide any combination; a row matches if it satisfies **ANY** of the three (OR):

- **`tables`** (STRING) -- comma-separated table-name **masks**, matched case-insensitively against
  the fully-qualified `schema.table` name.
  - A mask with **no `%`** is a plain substring (wrapped `%mask%`) -- e.g. `practice_area`,
    `practice`, and `wld.` all match `wld.practice_area`.
  - A mask **containing `%`** is used verbatim as the ILIKE pattern, so it can be anchored:
    `wld.%` = every table in schema `wld`; `%_area` = names ending in `_area`.
  - `_` is always the ILIKE single-char wildcard (harmless in practice -- it also matches a literal
    underscore).
  - Because a `%`-free mask is always substring-wrapped, there is **no way to express one exact
    name** through this parameter -- e.g. `tables=wld.practice_area` can return several rows (the
    table itself plus suffixed/other-schema variants). Use `find-login-for-tables` when strict exact
    matching is required instead.
- **`ddl_contains`** (STRING) -- comma-separated substrings, matched case-insensitively
  (`ILIKE ''%value%''`) against the table''s own generated `ddl_script` text. Because `ddl_script`
  includes each table''s FK `REFERENCES ...` clauses, this doubles as a **reverse-reference search**:
  it finds every table that mentions (typically references) the given table name -- the way to
  discover an unnamed bridge/junction/firm table that links a set of tables together, without
  guessing names.
- **`id`** (INTEGER) -- exact catalog `tables.id`. Used by a row''s own "DDL" drill-down link to fetch
  exactly one row unambiguously, since the two filters above are fuzzy and can match more than one
  table. Not meant for manual use -- you don''t normally know a row''s id ahead of time.

`tables` and `ddl_contains` are each comma-separated lists; blank tokens are dropped (a trailing
comma is safe).

## What it returns

One row per matched table: `table` (`schema.table_name`) and `description`. **The DDL itself is not
a flat column** -- it lives in `__object.table.ddl_script` (nested under `"table"`, alongside the
rest of the catalog row: `id`, `schema_name`, `table_name`, `description`, `ddl_script`), which keeps
a fuzzy multi-table result readable instead of a wall of DDL text. `__object` also carries a
self-referencing `__view` (rendered as the row''s "DDL" link via `view-any-object`) that reopens this
same action filtered by the row''s exact `id`, showing the table''s full name and DDL as a read-only
two-field card.

## DDL caveats

- **Environment-independent** -- a table is registered once regardless of environment, so there is
  no `envs` parameter here; if the same `schema.table` differs between environments, the stored DDL
  is whichever connection''s copy was refreshed **last**.
- **Lossy, not executable.** Generated by a hand-rolled query in `C:\IB\export-data\Tables.java`:
  a trailing comma before `);` (always a syntax error), unquoted identifiers/constraint names, an
  unqualified table name, constraint-backed indexes re-emitted redundantly, and column order riding
  on incidental `UNION ALL` behavior. Most importantly, **referential actions are dropped** --
  `ON DELETE CASCADE` / `SET NULL` never appear anywhere in the stored DDL -- and single-column
  `UNIQUE` constraints surface only as a bare index. Treat this DDL as an approximate structure
  summary for understanding/AI-context purposes, not as ground truth or a runnable script.
- The catalog reflects DDL/privileges **as of the last manual run** of `Tables.java` -- nothing
  refreshes it automatically.

## Related actions on the same catalog

`user-table-privileges` (fuzzy select/insert/update/delete matrix), `find-login-for-tables` (exact-
table-set login lookup for a single statement/transaction), `catalog-connections` (the registered
service logins), `toggle-connection-active` (include/exclude a connection from the next manual
`Tables.java` refresh).
', NULL, 'Table ddl');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('b6512014-7f6c-4440-ab22-363a3bf4a351', 'return-request-body', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select :__request_body content', NULL, 'HTTP_GET', 'return-request-body', NULL, '## Purpose

Echoes the raw HTTP request body straight back as `{"content": "<body>"}`. A plain-`SQL` action
(`select :__request_body content`) whose `connection_id` points at **System SQL** -- nodata''s own
config DB -- but the query never actually reads from any table; it is a pure pass-through, used as
a diagnostic/echo tool and, historically, as the read half of a "store a JSON document in an
action" trick.

## Parameter

- **`__request_body`** (TEXT) -- the reserved request-body parameter every action can bind. It is
  bound as a genuine JDBC `:name` parameter (`NamedParameterJdbcTemplate`), never
  string-interpolated into the SQL, so quotes/apostrophes in the body cannot break the query and
  need no escaping.

## History -- the JSON-document-in-an-action pattern (superseded 2026-09-08)

This action used to be the read half of a small, reusable trick for keeping a static JSON document
in the config DB and serving it as an action result: a document-holding action (e.g. the old
`custom-sub-menu-json`) had `execution_type = HTTP_POST`, connection `system-http`, `query =
/content/system/return-request-body/data/short/first`, and its own `content` column held the JSON
document as the HTTP body template -- so calling that action made nodata POST its own stored
document straight back to `return-request-body`, which echoed it into `{"content": "..."}`, and
`/data/short/first` unwrapped the single row. It worked because a JSON *array* survives
`isValidJson`''s splat check intact in `__request_body` instead of being exploded into per-key
params.

Both `custom-sub-menu-json` and `system-sub-menu-json` have since been **deleted**; their documents
now live as plain `properties` rows instead, which is the simpler choice whenever a document doesn''t
need its own dedicated URL/action identity. **No action on either nodata instance still calls
`return-request-body`** (verified live on both dev and work) -- it survives only as a
diagnostic/echo endpoint and as a documented, reusable technique for a future need.

## Gotcha this action''s own history demonstrates (fixed 2026-08-07)

It originally read `select ''{request-parameters.__request_body}'' content` -- placeholder
substitution is a plain, unescaped `replace`, so a single apostrophe anywhere in a stored document
(e.g. a label like "Firm''s leads") broke the SQL outright. Switching to the bound
`:__request_body` parameter, as it stands today, fixed that permanently. This only works because
execution stays plain `SQL`: `SQL_BLOCK`/`SQL_BLOCK_WITH_RESULT` route parameters through the
`sql_block_parameters` temp table instead of a JDBC bind, and would need the interpolation approach
back.

## Note: the stored `execution_type` currently reads `HTTP_GET`, not `SQL`

Despite the above, this row''s own `execution_type` column is currently `HTTP_GET` rather than plain
`SQL`. It still works correctly as the SQL echo described here -- verified live: a POSTed body comes
back unchanged as `{"content": "..."}` -- because the actual data-provider choice is driven by the
**connection''s** type (`System SQL`, i.e. `SqlDataProvider`), and `SqlDataProvider` appears to treat
anything other than `SQL_DML`/`SQL_BLOCK*` as the same plain bound-parameter read path that `SQL`
takes. This is worth double-checking before this action is edited again -- the stored value doesn''t
match the "must stay plain SQL" requirement above, even though it currently behaves as if it does.

## Practical use today

A generic "show me exactly what body nodata received" diagnostic -- useful for confirming a client
(curl, the `nd` CLI, a POST from another tool) actually sent a payload byte-identical, e.g.
verifying that `--data-binary` round-trips non-ASCII text or a multi-kB body without the corruption
a naive PowerShell `Invoke-WebRequest`/`ConvertTo-Json` call would introduce.
', NULL, 'return-request-body');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('d89d6127-2e92-5ea3-d9b7-fb485b2250a0', 'system-set-dictionary-action', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'DO $$declare
    parameter_id uuid;
    dict_action_id uuid;
    new_link_id uuid;
    link_id uuid;
    param_name_column varchar;
    param_value_column varchar;
BEGIN
    select uuid_value::uuid into parameter_id from sql_block_parameters where name = ''parameter_id'';
    select uuid_value::uuid into dict_action_id from sql_block_parameters where name = ''action_id'';
    select string_value into param_name_column from sql_block_parameters where name = ''name_column'';
    select string_value into param_value_column from sql_block_parameters where name = ''value_column'';

    select parameter.dictionary_id into link_id from parameter where id = parameter_id;

    update parameter set 
        dictionary_id = null,
        name_column = null,
        value_column = null
    where id = parameter_id;

    new_link_id = uuid_in(md5(random()::text || random()::text)::cstring);

    insert into action_link
    select
        new_link_id,
        (select p.action_id from parameter p where id = parameter_id),
        dict_action_id,
        null,
        false,
        false,
        0,
        false,
        ''DICTIONARY'',
        null
    where dict_action_id is not null;

    update parameter set
                         dictionary_id = new_link_id,
                         name_column = param_name_column,
                         value_column = param_value_column
    where id = parameter_id and dict_action_id is not null;

    delete from action_link ll where ll.id in (
        select l.id from action_link l
        where l.id = link_id and l.category = ''DICTIONARY''
          and not exists(select 1 from parameter p where p.dictionary_id = link_id));

END $$', NULL, 'SQL_BLOCK', 'Set dictionary  action', NULL, 'Wires a parameter''s dropdown to an ACTION as its value source -- the OTHER "dictionary" concept in nodata, unrelated to the properties-tree dictionaries (system-dictionaries et al.) besides sharing the word. This is the mechanism behind the `parameter` table''s `dictionary_id` / `name_column` / `value_column` columns: `dictionary_id` points at an `action_link` (category `DICTIONARY`) whose child action''s result rows populate the dropdown, and `name_column`/`value_column` pick which output columns of that action become each option''s displayed label and underlying value.

Parameters:
- parameter_id (UUID, required) -- the parameter (on any action) whose dropdown is being set.
- action_id (UUID, optional) -- the action whose result rows should populate the dropdown. Omit to just detach/clear the parameter''s current dictionary.
- name_column (STRING) -- the source action''s output column to use as each option''s label.
- value_column (STRING) -- the source action''s output column to use as each option''s value.

Mechanics (SQL_BLOCK -- parameters arrive via `sql_block_parameters`, not `:name` binds):
1. Reads the parameter''s CURRENT `dictionary_id` (an action_link id) into a local variable, for cleanup later.
2. Unconditionally clears the parameter''s `dictionary_id` / `name_column` / `value_column`.
3. If action_id is given: creates a brand-new `action_link` row (parent_action_id = the OWNING action of that parameter, looked up via `parameter.action_id`; child_action_id = the given action_id; category = ''DICTIONARY''; via_parameters = false; order = 0; mounted_to_row = false; title/variable left NULL), then re-points the parameter at that new link and sets its name_column/value_column.
4. Cleanup: deletes the link captured in step 1 if it was category ''DICTIONARY'' and no parameter still references it -- prevents orphaned DICTIONARY links from piling up in action_link every time a dropdown source is reassigned or cleared.

Note on the action_link insert: its `insert into action_link select ...` supplies only 10 of the table''s 11 columns (no explicit column list). This is NOT a bug -- verified live (2026-09-29) via psql: a bare `INSERT ... SELECT` without a column list matches values to columns positionally left-to-right and only errors if MORE values than columns are given; a shorter list simply leaves the trailing column(s) (here, `mapping`) at their default/NULL. (Contrast with the different, genuinely-broken 10-into-12 case documented for `system-create-action`''s own `action` insert.)

Gotcha found while verifying the above: the new-link insert in step 3 is gated only on `action_id is not null` -- it does NOT check that `parameter_id` actually resolves to an existing `parameter` row. Passing a made-up parameter_id together with a real action_id still creates a "global" (parent_action_id NULL) DICTIONARY action_link that nothing ever points at, since the parameter update in the same step is separately (and correctly) gated on `parameter_id` matching. Clean up any such orphan by hand with system-delete-action-link.

Family: this is the admin tool behind the dropdowns you see elsewhere in nodata''s own UI (e.g. the pickers on system-create-action-link''s own parameters, which are DICTIONARY-linked to system-dictionary-items / system-actions).', '{request-parameters._original_url}', 'Set dictionary  action');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('2e3ecaad-d6f5-3a72-c858-cf5df2758949', 'system-any-get-http-request-processed-with-sql', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', '{parameters.sql}', NULL, 'SQL', 'Any GET http request processed with SQL', NULL, 'Ad-hoc scratchpad for the [HTTP-via-proxy pattern](nodata-http-proxy-pattern.md): runs **arbitrary SQL you supply**, on the fly, against nodata''s own **System SQL** connection (its own config-DB Postgres, the one with the `http` extension installed) -- without first creating a dedicated action. `execution_type = SQL`, and `action.query` is literally `{parameters.sql}`: your `sql` parameter''s text is placeholder-substituted in as the actual query to execute, the same "your text becomes the query" trick `call-any-select-sql` uses for `{request-parameters.__request_body}`, just via a normal declared parameter instead of the raw POST body.

Typical use: write a `sql` body that calls `http_get(''{properties.system.system-any-get-http-request-nodata-data-short}'' || :url)` (or similar) to fetch a URL through the `system-any-get-http-request` proxy and reshape the JSON response with Postgres jsonb functions -- exactly the pattern documented for `searchapi-wldid-profile` in `nodata-http-proxy-pattern.md`, but without persisting a new action first. `:url` and `:payload` bind normally inside your `sql` text because they''re declared parameters of *this* action, so `NamedParameterJdbcTemplate` resolves them even though they don''t appear in the base `{parameters.sql}` query itself.

Parameters:
- `url` (STRING) -- a URL value your `sql` can reference as `:url` (e.g. the real downstream target to `http_get`).
- `sql` (TEXT) -- the query to actually run; substituted in verbatim as the executed statement.
- `payload` (STRING) -- an extra value your `sql` can reference as `:payload` (e.g. a request body for an `http_post`, or any other ad-hoc bind value).

⚠️ Same risk class as `call-any-select-sql` -- this executes caller-supplied SQL, here against nodata''s **own** config database (the `action`/`connection`/`property`/etc. tables that drive the tool itself) rather than an external catalogued connection. It is covered by the same JDBC-level read-only enforcement added 2026-09-10 for every `execution_type = SQL` action (see `call-any-select-sql.md`''s security-fix section) -- a plain `SELECT` works, but a write disguised in a data-modifying CTE with `RETURNING` is rejected with `HTTP 500`, not silently executed.', NULL, 'Any GET http request processed with SQL');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('23b6ee85-a2fc-4782-84d4-43ab5b4e9b34', 'system-add-dictionary-item', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'insert into properties
select
    gen_random_uuid(),
    :dictionary_id::uuid,
    :item_code::varchar,
    :item_label::varchar', NULL, 'SQL_DML', 'Add dictionary item', NULL, 'Adds one key/value item under an existing dictionary (see system-dictionaries for what a "dictionary" is in this family -- a node in the `properties` tree).

Parameters:
- dictionary_id (UUID, required) -- the parent dictionary''s own `properties.id` (as listed by system-dictionaries).
- item_code (STRING) -- stored as the new row''s `key`.
- item_label (STRING) -- stored as the new row''s `value`.

Mechanics: SQL_DML. `insert into properties select gen_random_uuid(), :dictionary_id, :item_code, :item_label` -- no explicit column list, relies on the table''s physical column order (id, parent_id, key, value).

Gotcha: no duplicate-code guard beyond the DB''s own `(parent_id, key)` unique index -- adding an item_code that already exists under the same dictionary_id fails with a constraint-violation error rather than updating in place. Use system-update-dictionary-item to edit an existing item instead.

redirect = `{request-parameters._original_url}` -- meant to be triggered from a form on the dictionary-items page and bounce the browser back there, like the rest of this family.', '{request-parameters._original_url}', 'Add dictionary item');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('9a327110-5e26-4d2a-8bc1-8eabeb2da397', 'system-actions', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select
  a.name "Name",
  a.code "Action code",
  c.description "Connection",
  c.type "Connection type",
  a.execution_type "Method",
  jsonb_build_object(
    ''action'', to_jsonb(a),
    ''parameters'', coalesce(
      (select jsonb_agg(jsonb_build_object(
                ''id'', p.id,
                ''name'', p.name,
                ''title'', p.title,
                ''type'', p.type,
                ''default_value'', p.default_value,
                ''description'', p.description
              ) order by p."order")
       from parameter p
       where p.action_id = a.id),
      ''[]''::jsonb)
  ) __object
from action a
join connection c on c.id = a.connection_id
where (a.id = :id or :id::uuid is null)
and (connection_id = :connection_id or :connection_id::uuid is null)
and (:code::varchar IS NULL OR :code::varchar = '''' OR a.code LIKE :code::varchar)
and (
  nullif(trim(:search_words::varchar), '''') IS NULL
  OR (coalesce(a.description, '''') || '' '' || a.code) ILIKE ANY ( ARRAY(
         SELECT CASE WHEN strpos(m, ''%'') > 0 THEN m ELSE ''%'' || m || ''%'' END
         FROM (SELECT trim(x) AS m
               FROM unnest( string_to_array(:search_words::varchar, '','') ) AS x) s
         WHERE m <> '''' ) )
)
order by coalesce(a.name, a.title, a.code)
', NULL, 'SQL', 'Actions', NULL, 'Actions', NULL, 'Actions');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('abdaa370-2c7b-dc78-65e1-5724bf54101a', 'system_extended_properties_for_propery_groups', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select
    case when pc.code = ''dictionaries'' then ''Dictionaries''
         when pc.code = ''context'' then ''Environments''
         else ''Property groups''
    end "description",

    case when pc.code = ''dictionaries'' then ''Dictionary''
         when pc.code = ''context'' then ''Environment''
         else ''Group''
        end column_name,
    $$
{
"aaa": {
    "bbb": [
       {"ddd": "zzz"}
    ]
  }
}
$$::jsonb num
from property_category pc
where (pc.code = :category_code or :category_code::varchar is null)
and (pc.id = :category_id or :category_id::uuid is null)
limit 1', NULL, 'SQL', 'Extended propertis for the action "system-property-groups"', NULL, 'Supplies dynamic UI labels for one `property_category` row, keyed by `category_code` or `category_id`. Given the category, returns exactly one row with:
- `description` -- a human label for the category kind: `''Environments''` when `pc.code = ''context''`, `''Dictionaries''` when `pc.code = ''dictionaries''`, else `''Property groups''`.
- `column_name` -- the matching column header: `''Environment''` / `''Dictionary''` / `''Group''`.
- `num` -- a **hardcoded dummy jsonb value** (`{"aaa":{"bbb":[{"ddd":"zzz"}]}}`), identical for every category. Nothing observed in this dev instance reads `num`; it looks like leftover scaffolding from testing a nested-jsonb column rather than a finished feature -- treat it as inert, not as documented behavior to build on.

Not meant to be called directly -- it''s the **child** of a previously-undocumented `action_link.category = ''PARAMETERS''` link (title `extended_properties`) from `system-property-groups`, which forwards that parent''s own `category_code` request parameter into this action''s `category_code`. `PARAMETERS`-category links are a third `action_link.category` value alongside the UI-drill-down `MOUNTED_TO_ACTION`/`MOUNTED_TO_ROW` links and the credential-injecting `DATA` link documented in `call-any-select-sql.md`''s "DATA action-link mechanism" section -- this one instead appears to let a parent action pull extra, context-dependent values (here, category-specific display labels) computed by a *child* action''s own query, based on the parent''s live request parameters. The same pattern recurs (with per-instance link titles `__system-dictionary-items_extended-parameters` and `__system-parameters_extended_parameters`) feeding `{extended-parameters.*}` / `{extended_parameters.*}`-style placeholders used in those actions'' own `title`/`description` fields.

The two typos in this action''s own identity -- code `system_extended_properties_for_propery_groups` and its stored name `Extended propertis for the action "system-property-groups"` -- are the actual code/name in the DB; they''re quoted verbatim here for lookup accuracy, not "corrected."

Parameters:
- `category_code` (STRING) -- `property_category.code` to look up (e.g. `context`, `dictionaries`, or any other group code); `NULL`/omitted matches any.
- `category_id` (UUID) -- `property_category.id` to look up directly; `NULL`/omitted matches any.

Both filters are optional and OR-independent (`pc.code = :category_code OR :category_code IS NULL`, same for `category_id`); if both are omitted the query still returns exactly one arbitrary `property_category` row (`LIMIT 1`, no `ORDER BY`), so in practice it should always be called with the specific category being described.', NULL, 'Extended propertis for the action "system-property-groups"');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('f1b8b927-efdf-43e0-a0d2-0c1d0243f6c8', 'system-update-dictionary-item', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'update properties
set key = :item_code::varchar,
    value = :item_label::varchar
where id = :item_id::uuid', NULL, 'SQL_DML', 'Update dictionary item', NULL, 'Renames/relabels one existing dictionary item in place (see system-dictionaries for the family).

Parameters:
- item_id (UUID, required) -- the item''s own `properties.id`.
- item_code (STRING) -- new `key`.
- item_label (STRING) -- new `value`.

Mechanics: SQL_DML. `update properties set key = :item_code, value = :item_label where id = :item_id`. As a plain SQL_DML action, 0 matching rows (a bad/missing item_id) fails loudly rather than silently doing nothing.

Only the key/value pair is editable this way -- `parent_id` is left untouched, so this cannot be used to move an item to a different dictionary.

redirect = `{request-parameters._original_url}`, same bounce-back pattern as the rest of this family.', '{request-parameters._original_url}', 'Update dictionary item');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('7e0fe3e1-4c70-44d3-8c85-c52e0d7b10ac', 'system-action-description', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with code_terms as (
  select trim(x) as term
  from unnest(string_to_array(:action_code, '','')) x
  where trim(x) <> ''''
),
desc_terms as (
  select trim(x) as term
  from unnest(string_to_array(:description_search, '','')) x
  where trim(x) <> ''''
),
matched as (
  select distinct a.id, a.code, a.name, a.description
  from action a
  where exists (select 1 from code_terms c where a.code ilike (''%'' || c.term || ''%''))
     or exists (select 1 from desc_terms d where a.description ilike (''%'' || d.term || ''%''))
),
blocks as (
  select
    m.code,
    ''## `'' || m.code || ''`'' ||
    case when m.name is not null then '' -- '' || m.name else '''' end ||
    E''\n\n'' ||
    coalesce(m.description, '''') ||

    E''\n\n#### Parameters\n\n'' ||
    coalesce(
      (select
         ''| Name | Type | Title | Default | Description |'' || E''\n'' ||
         ''|---|---|---|---|---|'' || E''\n'' ||
         string_agg(
           ''| '' || p.name
             || '' | '' || coalesce(p.type, '''')
             || '' | '' || coalesce(p.title, '''')
             || '' | '' || coalesce(p.default_value, '''')
             || '' | '' || coalesce(p.description, '''')
             || '' |'',
           E''\n'' order by p."order")
       from parameter p
       where p.action_id = m.id),
      ''_no parameters_''
    ) ||

    E''\n\n#### Links\n\n'' ||
    coalesce(
      (select string_agg(
         ''**'' || coalesce(al.title, ca.code) || ''** &rarr; `'' || ca.code || ''` ('' || al.category || '')'' || E''\n\n'' ||
         coalesce(
           (select
              ''| Parameter | Mapped from |'' || E''\n'' ||
              ''|---|---|'' || E''\n'' ||
              string_agg(
                ''| '' || cp.name || '' | '' || coalesce(alm.mapping, ''_(default: '' || coalesce(alm.default_value, ''none'') || '')_'') || '' |'',
                E''\n'' order by cp."order")
            from action_link_mapping alm
            join parameter cp on cp.id = alm.parameter_id
            where alm.action_link_id = al.id),
           ''_no parameter mapping_''
         ),
         E''\n\n'' order by al.category, al."order")
       from action_link al
       join action ca on ca.id = al.child_action_id
       where al.parent_action_id = m.id),
      ''_no links_''
    ) as block
  from matched m
)
select
  ''<zero-md><script type="text/markdown">'' ||
  coalesce(
    (select string_agg(block, E''\n\n---\n\n'' order by code) from blocks),
    ''_no actions matched for code~`'' || coalesce(:action_code, '''') || ''`, description~`'' || coalesce(:description_search, '''') || ''`_''
  ) ||
  ''<\/script></zero-md>'' "Description"
', NULL, 'SQL', NULL, NULL, 'Fuzzy-find and describe one or more actions in a single call. Two independent, optional filters are OR''d together (each accepts a comma-separated list of terms, ILIKE %term% per term):
- action_code: matched against action.code.
- description_search: matched against the action''s raw description column only (generated parameters/links tables below are not searched).

Matches are deduplicated and aggregated into ONE "Description" value -- there is always exactly one output row. Each matched action becomes a block: "## `code` -- name" heading, then its raw description, then a generated "#### Parameters" table (name/type/title/default/description) and a generated "#### Links" table (this action''s own outgoing action_link rows, i.e. what shows in its Actions dropdown -- title, target code, category, and its parameter mapping table). Blocks are separated by a "---" rule, ordered by code. No match -> a single "_no actions matched for ..._" placeholder.

The whole aggregate is wrapped once in < zero-md>< script type="text/markdown">...</ script></ zero-md> so a markdown-rendering front end can display it. The closing tags'' slash is built at query time via chr(92) (never typed as a literal backslash) because the JSP bootstrap page embeds the whole Data envelope inline as `var mainData = ${mainData};` -- a literal "</ script>" substring anywhere in that JSON prematurely terminates that bootstrap < script> block regardless of JSON/string quoting, corrupting the page. Building it from chr(92) at runtime, rather than typing a backslash escape sequence into the SQL text directly, also sidesteps JSON-based tool layers silently decoding such an escape sequence back into a real slash character before it ever reaches the database.

Linked from system-actions as a MOUNTED_TO_ROW action link ("Description"), mapping __object.action.code -> action_code, so every row of the Actions list can drill into this.', NULL, 'Action description');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('9ae4808e-d6bd-47ed-a4b4-b76e40f46884', 'storage-entry-update', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'update properties
set key   = :name::varchar,
    value = :data::text
where id = :id::uuid
  and parent_id = (select id from properties where parent_id is null and key = ''storage'')
', NULL, 'SQL_DML', NULL, NULL, '# Storage entry update

## Purpose

Updates an existing entry''s name/data in the `storage-entries` generic key-value store -- see
`storage-entries`'' own description for the full picture.

## Parameters

| Param  | Type   | Meaning |
|--------|--------|---------|
| `id`   | `UUID`   | the entry''s `properties.id` |
| `name` | `STRING` | new value for `properties.key` |
| `data` | `TEXT`   | new value for `properties.value` |

Always sets **both** `key` and `value` -- there is no partial-update form (a blank/omitted `name`
or `data` overwrites with an empty value, it does not "leave as-is").

## Mechanics / safety

```sql
update properties
set key   = :name::varchar,
    value = :data::text
where id = :id::uuid
  and parent_id = (select id from properties where parent_id is null and key = ''storage'')
```

Scoping the `WHERE` by the storage root (not just `id`) means an `id` that doesn''t actually
belong to this tree matches **zero rows** -- and nodata''s `SQL_DML` handler turns a zero-row
update into a **loud HTTP 500** ("nothing modified") instead of a silent no-op. Verified live with
a bogus id.

## Wiring

Linked as the **"Edit"** row link on `storage-entries` (`MOUNTED_TO_ROW`, `via_parameters=true`),
with its form **pre-filled** from the row''s own current values: mapping
`__object.id`→`id`, `__object.key`→`name`, `__object.value`→`data`.

## See also

KB doc `nodata-storage-entries.md`.
', '{request-parameters._original_url}', 'Storage entry update');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('86e487cc-027c-4c09-9df2-6eed0f0fd1db', 'add-connection', '280508e7-9ad9-0607-bf04-eee56d322ab7', '
-- Insert-or-update one "Database structure" catalog connection (service login) row.
--
-- Catalog table: connections(id, service_name, environment, url, login, password, active)
-- Unique key: (login, environment, url, service_name) -- see database-catalog.md.
--
-- Upserts on that key so the action is safe to re-run (e.g. to fix a typo''d password or flip
-- active) instead of erroring with a duplicate-key violation on a second call for the same row.
--
-- Defensively strips a leading "jdbc:aws-wrapper:" from :url -- every consumer of a catalog
-- row''s url (call-any-select-sql, Tables.java as it stands today) expects a plain
-- jdbc:postgresql://... URL; nodata''s own classpath has no AWS Advanced JDBC Wrapper driver.
-- See database-catalog.md''s "Always strip aws-wrapper: from a connection''s url" note.

INSERT INTO connections (service_name, environment, url, login, password, active)
VALUES (
    nullif(trim(:service_name::varchar), ''''),
    :environment::varchar,
    regexp_replace(:url::varchar, ''^jdbc:aws-wrapper:'', ''jdbc:''),
    :login::varchar,
    :password::varchar,
    coalesce(:active::boolean, false)
)
ON CONFLICT (login, environment, url, service_name)
DO UPDATE SET
    password = excluded.password,
    active   = excluded.active', NULL, 'SQL_DML', NULL, NULL, 'Insert-or-update one Database-structure catalog connection (service login), keyed by (login, environment, url, service_name); safe to re-run. Strips a leading jdbc:aws-wrapper: from url automatically. Mounted as the action-level Add connection link on catalog-connections.', '{request-parameters._original_url}', 'Add connection');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('9cc55a3e-b522-409b-a221-9aa163453ef5', 'call-any-select-sql', '20a9693e-d032-f7f1-d197-6f11ffab6ba7', '{request-parameters.__request_body}', NULL, 'SQL', NULL, NULL, 'Runs **ad-hoc SQL you supply, as raw HTTP POST body text**, against **any connection registered in the [Database structure catalog](database-catalog.md)** -- picked at request time by fuzzy `login`/`environment` matches, not against nodata''s own config DB. Full detail (including a real security finding) lives in the dedicated KB doc `call-any-select-sql.md`; this is a summary.

Dev only (`localhost:9944`) -- confirmed absent from work (`9955`).

```
POST http://localhost:9944/content/system/call-any-select-sql/data/short?environment=qa&login=woofer_app
Content-Type: text/plain

select 1 as num
```

Mechanism: `action.query` is literally `{request-parameters.__request_body}` -- your raw POST body becomes the executed SQL, verbatim, no JSON escaping (same raw-body trick as `system-update-action-field`). Its connection (`any-sql-connection`) has placeholder `url`/`login`/`password` (`{credentials.url}` etc.) resolved by a previously-undocumented `DATA`-category `action_link` to `catalog-connections`: nodata first calls `catalog-connections?logins=<login>&envs=<environment>`, takes **row 0** of the result, and opens the real JDBC connection with those credentials before running your SQL.

Parameters:
- `__request_body` (TEXT, default `select 1 num`) -- the SQL to execute, sent as the raw body.
- `environment` (STRING) -- fuzzy-matched (substring) against `catalog-connections`'' environment; forwarded as its `envs` filter (`"___"` sentinel when blank, so a blank value matches nothing rather than "all rows").
- `login` (STRING) -- fuzzy-matched (substring) against `catalog-connections`'' login; forwarded as its `logins` filter (same `"___"` blank-sentinel behavior).

⚠️ **Fuzzy-match risk**: a loose `login`/`environment` mask that matches more than one catalog row silently connects to row 0 (alphabetical/`ORDER BY` tie-break) with no warning -- e.g. `environment=a` always resolves to `qa` over `stage`. Always pass the **exact** login/environment; a zero-match combo fails loudly (`HTTP 500`), so the real danger is an *ambiguous*, not a missing, match.

⚠️ **Not actually select-only until the 2026-09-10 fix.** Despite the name and `execution_type = SQL` (`executeQuery()`), Postgres allows a genuine write hidden in a data-modifying CTE with `RETURNING` (proven live against `liveperson.convrstn_msg` in qa). Now enforced read-only at the JDBC/`Connection` level (explicit `autoCommit(false)` + `setReadOnly(true)`, reset before the pooled connection is returned) -- covers every `execution_type = SQL` action, not just this one. A plain `SELECT` is unaffected; a disguised write now gets `HTTP 500` instead of silently succeeding.', NULL, 'Call any "select" SQL');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('dec16dae-0b50-48f0-9252-8d130fc93a01', 'storage-entry-create', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'insert into properties (id, parent_id, key, value)
values (
    gen_random_uuid(),
    (select id from properties where parent_id is null and key = ''storage''),
    :name::varchar,
    :data::text
)
', NULL, 'SQL_DML', NULL, NULL, '# Storage entry create

## Purpose

Adds a new entry to the `storage-entries` generic key-value store -- see `storage-entries`'' own
description for the full picture of what the store is, why it reuses nodata''s `properties` table,
and how the `storage` root is addressed. This action inserts one new child row under that root.

## Parameters

| Param  | Type   | Meaning |
|--------|--------|---------|
| `name` | `STRING` | the entry''s name -- stored as `properties.key` |
| `data` | `TEXT`   | the entry''s data (plain text or JSON, stored verbatim) -- stored as `properties.value` |

## Mechanics

```sql
insert into properties (id, parent_id, key, value)
values (
    gen_random_uuid(),
    (select id from properties where parent_id is null and key = ''storage''),
    :name::varchar,
    :data::text
)
```

The parent id is looked up by `key = ''storage''` fresh on every call, never hardcoded, so this
keeps working against a rebuilt DB as long as `storage-root-init` has run once first.

## Wiring

Linked as the **"New entry"** row link on `storage-entries` (`MOUNTED_TO_ACTION`,
`via_parameters=true` so it opens a blank parameter form -- there''s no row to map from, since a
new entry isn''t tied to an existing one).

## See also

KB doc `nodata-storage-entries.md`.
', '{request-parameters._original_url}', 'Storage entry create');
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

SELECT
    c.service_name,
    c.login,
    c.environment,
    t.schema_name || ''.'' || t.table_name AS "table",
    p.can_select,
    p.can_insert,
    p.can_update,
    p.can_delete
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
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('1ca07cd8-9aa0-47f1-a7be-5747fd4a64df', 'storage-entry-delete', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'delete from properties
where id = :id::uuid
  and parent_id = (select id from properties where parent_id is null and key = ''storage'')
', NULL, 'SQL_DML', NULL, NULL, '# Storage entry delete

## Purpose

Deletes an entry from the `storage-entries` generic key-value store -- see `storage-entries`'' own
description for the full picture.

## Parameters

| Param | Type   | Meaning |
|-------|--------|---------|
| `id`  | `UUID` | the entry''s `properties.id` |

## Mechanics / safety

```sql
delete from properties
where id = :id::uuid
  and parent_id = (select id from properties where parent_id is null and key = ''storage'')
```

Same root-scoping as `storage-entry-update`: an `id` that doesn''t belong to this tree matches
**zero rows** and fails loudly (HTTP 500, "nothing modified") rather than silently no-op''ing.

## Wiring

Linked as the **"Delete"** row link on `storage-entries` (`MOUNTED_TO_ROW`, `via_parameters=true`
so it opens as a confirmation form rather than firing immediately on click).

## See also

KB doc `nodata-storage-entries.md`.
', '{request-parameters._original_url}', 'Storage entry delete');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('91b78475-df95-e996-f490-5fa510237dbb', 'find-login-for-tables', '280508e7-9ad9-0607-bf04-eee56d322ab7', '-- Query behind the "find a login for a set of tables" endpoint (the XYZ endpoint).
--
-- Given an EXACT set of fully-qualified tables and (optionally) an environment, return the
-- privilege matrix: for every login that has ANY privilege on any of those tables, which of
-- select/insert/update/delete it holds, per table. The caller then checks this matrix
-- against the operations each table actually needs, to pick a single covering login -- or,
-- if none covers everything, to work out how to split the work across logins/transactions.
--
-- The endpoint deliberately does NOT know which operation each table needs; it just returns
-- the raw capability data. The analysis lives in the caller.
--
-- Catalog tables:
--   connections(id, service_name, environment, url, login, password, active)
--   tables(id, schema_name, table_name, ...)
--   privileges(id, connection_id, table_id, can_select, can_insert, can_update, can_delete)
--
-- Named parameters:
--   :tables  required; comma-separated fully-qualified `schema.table` names, matched EXACTLY
--            (case-insensitive) -- no fuzzy substring.
--   :envs    optional; comma-separated environments (exact, case-insensitive). NULL/empty = all.
--
-- Returns one row per (connection, table): service_name, login, environment, table, can_*.

SELECT c.service_name,
       c.login,
       c.environment,
       t.schema_name || ''.'' || t.table_name AS "table",
       p.can_select,
       p.can_insert,
       p.can_update,
       p.can_delete
FROM connections c
         JOIN privileges p ON p.connection_id = c.id
         JOIN tables t     ON t.id = p.table_id
WHERE lower(t.schema_name || ''.'' || t.table_name) = ANY (
          SELECT lower(trim(x))
          FROM unnest(string_to_array(:tables::varchar, '','')) AS x
          WHERE nullif(trim(x), '''') IS NOT NULL)
  AND (nullif(trim(:envs::varchar), '''') IS NULL
       OR lower(c.environment) = ANY (
              SELECT lower(trim(e)) FROM unnest(string_to_array(:envs::varchar, '','')) AS e))
ORDER BY c.environment, c.service_name, c.login, "table"
', NULL, 'SQL', 'Find login for tables', NULL, '## Purpose

Given an **exact** set of fully-qualified tables (and optionally a set of environments), return the
full select/insert/update/delete privilege matrix for every login that holds ANY privilege on ANY of
them -- from the same "Database structure" catalog as `table-ddl` / `user-table-privileges`
(connection **"Knowlege base"**, `jdbc:postgresql://localhost:5432/kb`, id
`280508e7-9ad9-0607-bf04-eee56d322ab7`; a small metadata database *about* the shared qa/stage/prod
database, refreshed manually -- not a live connection itself).

This is the endpoint for "which login can run my multi-table statement, or do I need to split it
into more than one transaction" -- because a transaction runs as exactly one login, any operations
that must happen atomically together must all be covered by that same login.

## Parameters

- **`tables`** (required) -- comma-separated, fully-qualified `schema.table` names, matched
  **EXACTLY** (case-insensitive). Deliberately **no fuzzy substring** here, unlike
  `table-ddl`/`user-table-privileges` -- a multi-table coverage check must not be polluted by
  unrelated tables that merely share a substring.
- **`envs`** (optional) -- comma-separated environments, exact and case-insensitive. Blank/omitted
  means every environment.

## What it returns

One row per `(connection, table)`: `service_name`, `login`, `environment`, `table`, and the four
`can_*` booleans -- the same row shape as `user-table-privileges`, but restricted to exactly the
requested tables. A requested table that isn''t in the catalog, or a login with no privilege on it,
simply produces no row for that pair. **The endpoint returns raw capability data only** -- it has no
idea which operation each table actually needs; that analysis (grouping by login, checking every
required table/operation is satisfied) is the caller''s job.

## How to use it for the "pick a login" task

1. Work out each table''s required operation(s), the target environment, and which writes must be
   atomic (same transaction).
2. Call this endpoint once with the exact table list and environment.
3. Group the response rows by `(service_name, login, environment)`. A login **covers** the task only
   if it has a `true` row for every required `(table, operation)` -- a missing row for a required
   table means that login can''t be used for it at all.
4. If one or more logins cover everything, use any of them. If none do, split the work along
   transaction boundaries and pick a separate covering login per atomic group (e.g. one login for
   the write transaction, another for read-only lookups).
', NULL, 'Find login for tables');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('dea2600c-e1e7-d8d5-f3ee-cb3239e1fd56', 'system-dictionaries', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with base_path as
     (select value bp
      from property p
               join property_category pc on p.category_id = pc.id and pc.code = ''context''
      where "group" = ''system'' and property = ''system-base-path'')

select
    ''<a href="'' || (select bp from base_path) || ''system-dictionary-items?dictionary_id='' || p.id || ''">''
        || p.value || ''</a>'' "Dictionary",
    to_jsonb(p) __object
from properties p
where parent_id = (select id from properties where parent_id is null and key = ''dictionaries'')', NULL, 'SQL', 'Dictionaries', NULL, 'Lists the top-level "dictionaries" -- simple, editable key/value lookup lists stored as a tree in the `properties` table. (This is unrelated to the OTHER "dictionary" concept in nodata: a parameter''s `dictionary_id` pointing at a DICTIONARY-category `action_link` -- see system-set-dictionary-action for that one.)

No parameters -- always returns the whole tree.

Mechanics: finds the singleton root `properties` row (`parent_id is null and key = ''dictionaries''`), then lists its direct children. Each child row IS one dictionary: its `key` is the dictionary''s short code, its `value` is the display name, and its own `id` is the `dictionary_id` used everywhere else in this family (system-dictionary-items, system-add/update/delete-dictionary-item, system-delete-dictionary).

The "Dictionary" output column is literal `<a href="...">name</a>` HTML, not a plain value: a `base_path` CTE reads the `system-base-path` property (group `system`, category `context`) and prefixes it to `system-dictionary-items?dictionary_id=<id>`, so the query itself builds the drill-down link rather than relying on an action_link/DICTIONARY dropdown. `__object` is the raw properties row (id/key/value/parent_id).

Family: this is the index of what system-add/update/delete-dictionary-item operate on, and what system-delete-dictionary removes wholesale (a dictionary row plus all its items in one delete).', NULL, 'Dictionaries');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('b5786c6c-f631-41ed-996a-f7cf2c26bd34', 'system-delete-dictionary-item', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with params as (
    select :code::varchar, :value::varchar
)

delete from properties
where id = :id::uuid', NULL, 'SQL_DML', 'Delete dictionary item', NULL, 'Deletes a single item from a dictionary by id (see system-dictionaries for the family).

Parameters:
- id (UUID, required) -- the item''s own `properties.id`. This is the only one actually used.
- code (STRING), value (STRING) -- accepted but dead: the query builds `with params as (select :code::varchar, :value::varchar)` and never references that CTE anywhere in the actual `delete from properties where id = :id::uuid`. Changing code/value has no effect on the delete; they are presumably carried along only because the calling UI row already has them in its payload. Don''t assume they do anything.

Mechanics: SQL_DML delete by primary key. redirect = `{request-parameters._original_url}`, same bounce-back pattern as the rest of this family. Deleting an item does not touch its dictionary (the parent row) or sibling items -- for removing a whole dictionary at once, see system-delete-dictionary.', '{request-parameters._original_url}', 'Delete dictionary item');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('a21fdfc4-ffa7-41c0-9bf7-8c1355adbf32', 'system-delete-dictionary', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with params as (
    select :code::varchar, :name::varchar
)

delete from properties
where parent_id = :id::uuid or id = :id::uuid
', NULL, 'SQL_DML', 'Delete dictionary', NULL, 'Deletes an entire dictionary AND all of its items in one statement (see system-dictionaries for the family).

Parameters:
- id (UUID, required) -- the dictionary''s own `properties.id`. This is the only one actually used.
- code (STRING), name (STRING) -- accepted but dead, same pattern as system-delete-dictionary-item: `with params as (select :code::varchar, :name::varchar)` is built and never referenced by the actual delete. They have no effect.

Mechanics: SQL_DML. `delete from properties where parent_id = :id::uuid or id = :id::uuid` -- one statement removes the dictionary row itself (`id = :id`) and every direct child under it (`parent_id = :id`, i.e. every item) together. This is non-recursive: it relies on the dictionary tree being exactly two levels deep (root "dictionaries" -> dictionary -> items). If an item ever had children of its own, those grandchildren would NOT be reached by this delete and would be orphaned.

Irreversible, no confirmation beyond whatever the UI''s own delete affordance provides. redirect = `{request-parameters._original_url}`.', '{request-parameters._original_url}', 'Delete dictionary');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('8ddf46e0-1019-14f7-6680-80c505fefb5e', 'system-any-get-http-request', '6fdfb5ed-816e-77a1-3e13-d84bbb452939', NULL, NULL, 'HTTP_GET', 'Any GET http request', 'if (mainData.actionParameters.columns) {
  const str = mainData.actionParameters.columns.value;
  if (str && str.trim() !== "") {

    mainData.columns = str.split(",") // Split by comma
      .map(s => s.trim())             // Trim extra spaces
      .filter(Boolean)                // Remove empty entries
      .map(s => ({ path: s, name: s }));
  }
}


if (mainData.actionParameters["data-path"]) {
  const dp = mainData.actionParameters["data-path"].value;
  if (dp && dp.trim() !== "") {
    mainData.data = eval("mainData.data." + dp);
  }
}
', 'Generic outbound HTTP **GET** proxy -- the base of the [HTTP-via-proxy pattern](nodata-http-proxy-pattern.md). `HTTP_GET` action on the **`Any HTTP`** connection (`connection.url = "{parameters.url}"`, no login/password), and `action.query` is null (no path is appended), so the entire outbound request URL is exactly whatever full URL you pass as the `url` parameter -- unauthenticated GETs only, since the shared `Any HTTP` connection carries no credentials.

Called two ways:
1. **Directly**, as a plain HTTP fetch-any-URL tool (params below reshape the JSON response for display).
2. **From a SQL action''s `http_get(...)` call**, as nodata''s own TLS-terminating proxy so Postgres never needs certificates -- see `nodata-http-proxy-pattern.md` for the full mechanism (base URL is the property `{properties.system.system-any-get-http-request-nodata-data-short}`, ending in `?url=` so the real target URL is concatenated on).

Parameters:
- `url` (STRING) -- the full target URL to GET.
- `columns` (STRING) -- comma-separated list of JSON field names; when set, its `post_process` (client-side JS, runs after render) overrides the result table''s columns to exactly these paths/names, letting a caller reshape an arbitrary response into a flat table without a dedicated action.
- `data-path` (STRING) -- a dotted JS property path (e.g. `body.results`); when set, the same `post_process` does `mainData.data = eval("mainData.data." + dp)` to drill into a nested part of the response before display.

⚠️ `data-path` is spliced directly into a JS `eval()` call in the browser (`post_process` runs as page JS on every load). Nothing sanitizes it -- pass only a trusted dotted-path expression. Since `post_process` only executes in the caller''s own browser tab, this is at worst a self-inflicted client-side issue (no server-side or stored-XSS impact), but it is genuine arbitrary JS execution driven by a request parameter.

Response shape: raw JSON parsed automatically into the `data` node under a `body` column (native HTTP action). Since 2026-09-18 a non-JSON (e.g. XML) response no longer 500s -- it comes back as `{"content": "<raw body text>"}` instead (see `HttpDataProvider`''s `isParsableJson` fix in `nodata-http-proxy-pattern.md`).', NULL, 'Any GET http request');


--
-- PostgreSQL database dump complete
--

