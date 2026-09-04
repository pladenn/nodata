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
    post_request boolean,
    name text
);


ALTER TABLE public.tmp_action OWNER TO postgres;

--
-- Data for Name: tmp_action; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('cb2677d6-2334-cd9e-5fe8-b2d76a05360f', 'table-ddl', '280508e7-9ad9-0607-bf04-eee56d322ab7', '-- Query behind the "get table DDL" endpoint.
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
', NULL, 'SQL', 'Table ddl', NULL, NULL, NULL, false, 'Table ddl');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('84f7269c-68a3-b278-f5fc-d807a5f4b1e8', 'view-any-object', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', '--with v as (
--select
--    $$
--    {
--        "url": "http://localhost:{properties.system.localhost-port}/content/prod/lead-notifications/data?customer_lead_event_id=125410114",
--        "fields": [["data.__object.alert_message_sent_to","Sent to"],
--                   ["data.__object.alert_message_sent","Body","text"]]
--    }
--    $$::jsonb v
--),

with v as (select :view::jsonb v),

content as (
select
    content::jsonb content
from http_get((select v.v ->> ''url'' from v)) resp),

flds as (select
    (''$.'' || (field ->> 0))::jsonpath path,
     coalesce ((field ->> 1), (field ->> 0)) label,
    coalesce((field ->> 2), ''string'') type
from jsonb_array_elements((select ((v.v -> ''fields'')#>>''{}'')::jsonb from v)) field)

select
    label,

    case type
        when ''string'' then ''''
        when ''html'' then ''<div>''
        when ''text'' then ''<textarea cols="300" rows="35" readonly>''
    end ||

    (jsonb_path_query((select content from content), path)#>>''{}'') ||

    case type
        when ''string'' then ''''
        when ''html'' then ''</div>''
        when ''text'' then ''</textarea>''
    end as value

from flds field', NULL, 'SQL', 'View', NULL, '# View Any Object

## Purpose

A **generic, domain-agnostic "detail card" renderer**. It doesn''t know about leads,
notifications, reports, or anything else — given a **`__view` descriptor** (a URL plus a list of
fields to pull out of whatever that URL returns), it fetches the URL and renders **one label /
value row per requested field**.

This is the shared engine behind every "Notification"/"Report"-style row-link drill-down in the
tool (`chat-leads` → "Notification", `lead-notifications` → "Notification",
`open-reports-all-reports` → "Report", …). A caller never needs to write its own bespoke "detail"
action — it just embeds a `__view` object inside its own `__object`/`__objekt` payload and adds a
row link pointing here.

## Input: the `view` parameter

One parameter, **`view`** (`TEXT`) — a JSON object:

```json
{
  "url": "http://localhost:9955/content/{env}/<some-action>/data?<param>=<value>",
  "fields": [
    ["<jsonpath into the fetched response>", "<label>", "<type: string|html|text>"]
  ]
}
```

- **`url`** — must be an action''s **`/data`** endpoint (the full `Data` envelope, with a
  top-level `data` array) — **not** `/data/short`. In every existing caller this is a **plain
  HTTP call back to nodata''s own `localhost`** (never an external HTTPS target).
- **`fields`** — array of `[path, label?, type?]` triples.
  - `label` defaults to `path` if omitted.
  - `type` defaults to `''string''`. See render types below.
  - `path` is addressed as **`data.__object.<...>`** (or `data.__objekt.<...>`) against the
    *fetched* response — e.g. `data.__object.alert_message_sent_to`,
    `data.__object.report.guid`. No `[0]` index is needed even though `data` is an array:
    Postgres jsonpath''s default **lax mode** auto-unwraps a single-element array.
  - `fields` may be sent as a real **jsonb array** or as a **string containing JSON array
    text** — this action normalizes either shape the same way.

## Mechanics (how it works, step by step)

```sql
with v as (select :view::jsonb v),

content as (
select
    content::jsonb content
from http_get((select v.v ->> ''url'' from v)) resp),

flds as (select
    (''$.'' || (field ->> 0))::jsonpath path,
     coalesce ((field ->> 1), (field ->> 0)) label,
    coalesce((field ->> 2), ''string'') type
from jsonb_array_elements((select ((v.v -> ''fields'')#>>''{}'')::jsonb from v)) field)

select
    label,
    case type
        when ''string'' then ''''
        when ''html'' then ''<div>''
        when ''text'' then ''<textarea cols="300" rows="35" readonly>''
    end ||
    (jsonb_path_query((select content from content), path)#>>''{}'') ||
    case type
        when ''string'' then ''''
        when ''html'' then ''</div>''
        when ''text'' then ''</textarea>''
    end as value
from flds field
```

1. **`v`** — parse `:view` as jsonb.
2. **`content`** — `http_get(v.v ->> ''url'')` actually performs the HTTP call and parses the
   response body as jsonb. Because the target is always local plain HTTP, this needs **no
   TLS/certificate setup** on the Postgres side.
3. **`flds`** — unnests `fields` into one row per requested field: builds the jsonpath, applies
   the label/type defaults.
4. **Final `select`** — for each field, `jsonb_path_query(content, path)` extracts the value from
   the fetched response, then wraps it per `type`. Emits exactly **one `label`/`value` row per
   field**.

### Render types

| `type` | Wraps value in | Use for |
| ------ | --------------- | ------- |
| `string` (default) | nothing (bare) | short, single-line values — ids, guids, names |
| `html` | `<div>…</div>` | a value that is already HTML (e.g. an HTML-templated email body) |
| `text` | `<textarea cols="300" rows="35" readonly>…</textarea>` | long or multi-line plain text (a SQL query, a plain-text email body) |

Pick the type **per field**, by that field''s expected shape — `text` renders as a large
multi-line box, which looks wrong for a short value like a guid or a name.

### Gotcha

If a field''s jsonpath finds **no match** in the fetched response (wrong id, wrong environment
baked into the `url`, etc.), that field''s row is **silently dropped** from the output — not shown
with an empty value. A set-returning function used in a `SELECT` list produces zero output rows
when it has zero matches. If the whole result comes back `[]` when you expected N rows, suspect
the `url` before the SQL.

## Example

Given a real `chat-leads`/`lead-notifications` row''s `__view`:

```json
{
  "url": "http://localhost:9955/content/qa/lead-notifications/data?notification_id=60517325",
  "fields": [
    ["data.__object.alert_message_sent_to", "Sent to"],
    ["data.__object.alert_message_sent", "Body", "text"]
  ]
}
```

Calling this action with that whole object as `view` returns:

```json
[
  { "label": "Sent to", "value": "mark@denizdefense.com" },
  { "label": "Body", "value": "<textarea cols=\"300\" rows=\"35\" readonly>*** PLEASE DO NOT REPLY ...</textarea>" }
]
```

## Wiring up a new caller

1. In your action''s SQL, build a `__view` object inside `__object` — usually **self-referencing**
   (pointing back at the same action, filtered down to the one row just fetched via its own
   `/data` endpoint).
2. Create the row link **and** its parameter mapping in one call via `system-upsert-action-link`:
   ```
   title=<link label>
   parent_action_id=<your action''s id>
   child_action_id=84f7269c-68a3-b278-f5fc-d807a5f4b1e8   -- this action''s id
   group=MOUNTED_TO_ROW
   via_parameters=false
   mapping=[{"path":"__object.__view","parameter_name":"view"}]
   ```
3. Verify by pulling one real row''s `__view` and feeding it straight to this action, bypassing
   the UI entirely.

## Live callers today

| Parent action | Link title | Fields shown |
| -------------- | ---------- | ------------ |
| `chat-leads` | "Notification" | Sent to (string), Body (html or text) |
| `lead-notifications` | "Notification" | Sent to (string), Body (html or text) |
| `open-reports-all-reports` | "Report" | Guid (string), Name (string), Postgres report query (text), Description (text) |

## See also

KB doc `nodata-view-any-object.md` — the canonical write-up (this description is a condensed
copy of it, kept in the tool itself for discoverability).
', NULL, false, 'View');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('002d3444-b227-47f7-a059-adee55f1f78d', 'toggle-connection-active', '280508e7-9ad9-0607-bf04-eee56d322ab7', '-- Flip the "active" refresh flag on one "Database structure" catalog connection (service login).
--
-- :id = connections.id (the catalog row''s own PK; see catalog-connections'' __object.id).
-- Toggling active does not touch privileges/DDL already recorded for this login -- it only
-- controls whether the next manual Tables.java catalog refresh processes this login.
-- An unknown id updates 0 rows, which SQL_DML reports as "Nothing is modified" (HTTP 500).

UPDATE connections
SET active = NOT active
WHERE id = :id::integer
', NULL, 'SQL_DML', NULL, NULL, 'Flip the active refresh flag on a Database-structure catalog connection (service login), by its connections.id. Row action mounted on catalog-connections.', '/content/system/catalog-connections', true, 'Toggle connection active');


--
-- PostgreSQL database dump complete
--

