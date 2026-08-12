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
-- Two ways to select rows (use either, or both):
--   1. by table-name mask (:tables)       -- "give me the DDL for the tables named like this"
--   2. by fuzzy search over the DDL text (:ddl_contains) -- "which tables'' DDL mentions X?"
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
--
-- Returns one row per matched table. The visible columns are just table + description; the DDL
-- itself is in __object.ddl_script (along with the rest of the catalog row) -- keeping it out of
-- the flat list means a fuzzy search returns a readable table instead of walls of DDL.
-- A row matches if it satisfies EITHER provided filter (name mask OR ddl-contains).
-- If neither parameter is provided, nothing is returned.

SELECT t.schema_name || ''.'' || t.table_name AS "table",
       t.description,
       to_jsonb(t) AS __object
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
ORDER BY "table"
', NULL, 'SQL', 'Table ddl', NULL, NULL, NULL, false, 'Table ddl');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('dad7e0ad-b47a-4e6c-ae10-876bdb4a7cc1', 'system-sub-menu-json', 'b16c7ed6-3beb-495c-b38e-337f9adec0a1', '/content/system/return-request-body/data/short/first', '[
    {
        "link": null,
        "name": "System",
        "items": [
            {
                "link": null,
                "name": "Actions",
                "items": [
                    {
                        "link": "/content/system/system-actions",
                        "name": "All",
                        "items": null
                    },
                    {
                        "link": "/content/system/system-actions?connection_id=d48b9a97-e13c-4961-9eff-d76f39abdffb",
                        "name": "System actions",
                        "items": null
                    }
                ]
            },
            {
                "link": null,
                "name": "Connections",
                "items": [
                    {
                        "link": "/content/system/system-connections",
                        "name": "All",
                        "items": null
                    },
                    {
                        "link": "/content/system/system-connections?code=system%25",
                        "name": "System connections",
                        "items": null
                    }
                ]
            },
            {
                "link": null,
                "name": "Properties",
                "items": [
                    {
                        "link": "/content/system/system-property-groups?category_code=context&title_for_group_column=Environment&description=Environments",
                        "name": "Environments",
                        "items": null
                    },
                    {
                        "link": "/content/system/system-properties?category_code=context&title_for_group_column=Environment&title_for_property_column=Property+name",
                        "name": "All properties",
                        "items": null
                    },
                    {
                        "link": "/content/system/system-dictionaries",
                        "name": "Dictionaries",
                        "items": null
                    }
                ]
            },
            {
                "link": "/content/system/system-actions?id=&code=%25-sub-menu&connection_id=&system.action-code=system-actions",
                "name": "Menu",
                "items": null
            },
            {
                "name": "Database catalog",
                "items": [
                    {
                        "code": "user-table-privileges",
                        "parameters": true
                    },
                    {
                        "code": "find-login-for-tables",
                        "parameters": true
                    },
                    {
                        "code": "table-ddl",
                        "parameters": true
                    },
                    {
                        "code": "catalog-connections",
                        "name": "Service connections",
                        "parameters": true
                    }
                ]
            },
            {
                "code": "system-tables-ddl",
                "name": "Config DB tables"
            }
        ]
    }
]', 'HTTP_POST', 'System submenu JSON', NULL, NULL, NULL, false, 'System submenu JSON');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('b1f70839-ccf6-bb42-b618-311bd6d92361', '__system-update-action_parameters', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select * from action
where (id = :action_id::uuid or :action_id::uuid is null)
and (code = :code::varchar or :code::varchar is null)', NULL, 'SQL', '__system-update-action_parameters', NULL, NULL, NULL, false, '__system-update-action_parameters');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('691dce23-aae8-e745-2f44-e5afad8996f6', 'system-columns', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select col.id,
       col.name,
       col.path,
       col.order,
       act.id action_id,
       coalesce(act.title, code) action_title,
       act.code action_code
from "column" col
         join action act on act.id = col.action_id
where (col.action_id = :action_id or :action_id::uuid is null)
  and (coalesce(:action_code::varchar, '''') = '''' OR act.code LIKE :action_code::varchar)
order by col.order', NULL, 'SQL', 'Columns for the action "{action_title}"({action_code})', NULL, 'Columns for the action "{action_title}"({action_code})', NULL, false, 'Action columns');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('cccdac53-ba4b-4df8-96c1-b2c0c4ecbfd5', 'system-tables-ddl', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with recursive tbl as (
    select c.oid                        as table_oid,
           n.nspname                    as schema_name,
           c.relname                    as table_name,
           pg_get_userbyid(c.relowner)  as table_owner
    from pg_class c
             join pg_namespace n on n.oid = c.relnamespace
    where c.relkind in (''r'', ''p'')
      -- public only; this also keeps out the per-session pg_temp_NN schemas, where a pooled
      -- connection may still be holding a SQL_BLOCK action''s sql_block_parameters table
      and n.nspname = ''public''
      and c.relname not in (''databasechangelog'', ''databasechangeloglock'')
),

-- child depends on parent; self-references are not ordering constraints
edge as (
    select distinct con.conrelid as child, con.confrelid as parent
    from pg_constraint con
    where con.contype = ''f''
      and con.conrelid <> con.confrelid
      and con.conrelid in (select table_oid from tbl)
      and con.confrelid in (select table_oid from tbl)
),

-- every table seeded at 0 so cyclic tables still appear; path array terminates cycles
walk as (
    select t.table_oid as table_oid, 0 as lvl, array [t.table_oid] as path, false as cyclic
    from tbl t
    union all
    select e.child, w.lvl + 1, w.path || e.child, e.child = any (w.path)
    from walk w
             join edge e on e.parent = w.table_oid
    where not w.cyclic
),

lvl as (
    select table_oid, max(lvl) as level, bool_or(cyclic) as in_cycle
    from walk
    group by table_oid
),

-- optional filters: comma-separated, blank tokens dropped, no rows => filter not applied
-- strict: exact match, case-insensitive, on either "action" or "public.action"
name_filter as (
    select lower(btrim(m)) as mask
    from unnest(string_to_array(coalesce(:tables::text, ''''), '','')) m
    where btrim(m) <> ''''
),

-- fuzzy: a mask with no % is wrapped to %mask%; a mask that has one is used verbatim so it
-- can be anchored (same convention as the catalog''s table-ddl action)
ddl_filter as (
    select case when strpos(btrim(m), ''%'') > 0 then btrim(m) else ''%'' || btrim(m) || ''%'' end as mask
    from unnest(string_to_array(coalesce(:ddl_contains::text, ''''), '','')) m
    where btrim(m) <> ''''
),

col as (
    select t.table_oid,
           a.attnum::int as attnum,
           rtrim(''    '' || rpad(quote_ident(a.attname), 24) || '' '' ||
                 rpad(format_type(a.atttypid, a.atttypmod), 26) ||
                 case when a.attnotnull then '' not null'' else '''' end ||
                 case a.attidentity
                     when ''a'' then '' generated always as identity''
                     when ''d'' then '' generated by default as identity''
                     else '''' end ||
                 case
                     when a.attgenerated = ''s''
                         then '' generated always as ('' || pg_get_expr(d.adbin, d.adrelid) || '') stored''
                     when d.adbin is not null
                         then '' default '' || pg_get_expr(d.adbin, d.adrelid)
                     else '''' end) as line
    from tbl t
             join pg_attribute a on a.attrelid = t.table_oid and a.attnum > 0 and not a.attisdropped
             left join pg_attrdef d on d.adrelid = t.table_oid and d.adnum = a.attnum
),

con as (
    select t.table_oid,
           case con.contype when ''p'' then 1 when ''u'' then 2 when ''f'' then 3 else 4 end as ord,
           con.conname,
           ''    constraint '' || quote_ident(con.conname) || '' '' || pg_get_constraintdef(con.oid) as line
    from tbl t
             join pg_constraint con on con.conrelid = t.table_oid
    where con.contype in (''p'', ''u'', ''f'', ''c'')
),

-- indexes that are not already emitted as a constraint
idx as (
    select t.table_oid, ic.relname as index_name, pg_get_indexdef(i.indexrelid) || '';'' as line
    from tbl t
             join pg_index i on i.indrelid = t.table_oid
             join pg_class ic on ic.oid = i.indexrelid
    where not exists (select 1
                      from pg_constraint c2
                      where c2.conindid = i.indexrelid
                        and c2.contype in (''p'', ''u'', ''x''))
),

body as (
    select table_oid, 1 as grp, attnum as k1, '''' as k2, line from col
    union all
    select table_oid, 2, ord, conname, line from con
),

ddl as (
    select t.table_oid,
           ''create table '' || quote_ident(t.schema_name) || ''.'' || quote_ident(t.table_name) || E''\n(\n'' ||
           coalesce((select string_agg(b.line, E'',\n'' order by b.grp, b.k1, b.k2)
                     from body b
                     where b.table_oid = t.table_oid), '''') || E''\n);'' ||
           E''\nalter table '' || quote_ident(t.schema_name) || ''.'' || quote_ident(t.table_name) ||
           '' owner to '' || quote_ident(t.table_owner) || '';'' ||
           coalesce((select E''\n'' || string_agg(i.line, E''\n'' order by i.index_name)
                     from idx i
                     where i.table_oid = t.table_oid), '''') as ddl_script
    from tbl t
),

selected as (
    select t.table_oid,
           t.schema_name,
           t.table_name,
           t.table_owner,
           lvl.level,
           lvl.in_cycle,
           ddl.ddl_script
    from tbl t
             join lvl on lvl.table_oid = t.table_oid
             join ddl on ddl.table_oid = t.table_oid
    where (not exists (select 1 from name_filter)
        or lower(t.table_name) in (select mask from name_filter)
        or lower(t.schema_name || ''.'' || t.table_name) in (select mask from name_filter))
      and (not exists (select 1 from ddl_filter)
        or exists (select 1 from ddl_filter f where ddl.ddl_script ilike f.mask))
)

select row_number() over (order by s.level, s.table_name)                       as "order",
       s.schema_name || ''.'' || s.table_name                                     as name,
       jsonb_build_object(
               ''order'', row_number() over (order by s.level, s.table_name),
               ''name'', s.schema_name || ''.'' || s.table_name,
               ''schema'', s.schema_name,
               ''table'', s.table_name,
               ''owner'', s.table_owner,
               ''level'', s.level,
               ''in_cycle'', s.in_cycle,
               ''self_referencing'', exists (select 1
                                           from pg_constraint sc
                                           where sc.conrelid = s.table_oid
                                             and sc.contype = ''f''
                                             and sc.confrelid = s.table_oid),
               ''depends_on'', coalesce((select jsonb_agg(distinct p.schema_name || ''.'' || p.table_name)
                                       from edge e
                                                join tbl p on p.table_oid = e.parent
                                       where e.child = s.table_oid), ''[]''::jsonb),
               ''referenced_by'', coalesce((select jsonb_agg(distinct ch.schema_name || ''.'' || ch.table_name)
                                          from edge e
                                                   join tbl ch on ch.table_oid = e.child
                                          where e.parent = s.table_oid), ''[]''::jsonb),
               ''ddl_script'', s.ddl_script
       )                                                                        as __object
from selected s
order by s.level, s.table_name
', NULL, 'SQL', 'Config DB tables + DDL (dependency order)', NULL, 'All tables of nodata''s own config database (liquibase tables excluded), ordered so a table always appears after every table it depends on via a foreign key. Visible columns: order, name. Everything else -- schema, table, owner, dependency level, in_cycle, self_referencing, depends_on, referenced_by and the generated ddl_script -- is in __object.', NULL, false, NULL);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('ab69c504-e716-5bd6-f67e-11b186f98c49', 'user-table-privileges', '280508e7-9ad9-0607-bf04-eee56d322ab7', '-- Report: privileges across catalogued connections, filtered by fuzzy user/table lists
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
ORDER BY c.environment, c.login, "table"', NULL, 'SQL', 'User/table priveleges', NULL, NULL, NULL, false, 'User/table priveleges');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('d89d6127-2e92-5ea3-d9b7-fb485b2250a0', 'system-set-dictionary-action', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'DO $$declare
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

END $$', NULL, 'SQL_BLOCK', 'Set dictionary  action', NULL, NULL, '{request-parameters._original_url}', false, 'Set dictionary  action');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('b6512014-7f6c-4440-ab22-363a3bf4a351', 'return-request-body', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select :__request_body content', NULL, 'HTTP_GET', 'return-request-body', NULL, NULL, NULL, false, 'return-request-body');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('1b4e4d25-adc9-c116-ba99-1463ad51cec6', 'system-create-parameter', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'INSERT INTO public.parameter (id, action_id, name, type, title, editable, "order", default_value)
VALUES (gen_random_uuid(),
        (select id from action where code = :action_code),
        :name, 
        case when :type is null or :type = '''' then ''STRING'' else :type end,
        :title,
        coalesce(:editable, true),
        :order,
        :default_value
)', NULL, 'SQL_DML', 'Create parameter for the action "{PARAMETERS.action_title}"({PARAMETERS.action_code})', NULL, 'Create parameter for the action "{PARAMETERS.action_title}"({PARAMETERS.action_code})', '{request-parameters._original_url}', true, 'Create parameter');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('eb109b97-5fa6-2712-e517-b10d07976ca8', 'system-parameter-update', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'update public.parameter set
name = :name,
type = case when coalesce(:type, '''') = '''' then ''STRING'' else :type end,
default_value = :default_value,
title = :title,
editable = coalesce(:editable, true),
"order" = :order
where id = :id', NULL, 'SQL_DML', 'Update parameter for the action "{action_name}"({action_code})', NULL, 'Update parameter for the action "{action_name}"({action_code})', '{request-parameters._original_url}', false, 'Update parameter');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('2b9c7e2d-c035-4416-a0c4-8e2b3d8c069d', 'catalog-connections', '280508e7-9ad9-0607-bf04-eee56d322ab7', '-- Query behind the "database-catalog connections" endpoint.
--
-- Lists the service logins registered in the "Database structure" catalog: one row per
-- (service login x environment). This is the `connections` side of the catalog -- the privilege
-- matrix is `user-table-privileges` / `find-login-for-tables`, table structure is `table-ddl`.
--
-- Only connections with active = true are refreshed by the catalog loader, so an inactive row
-- may hold stale privileges; the flag is in __object.
--
-- Catalog table:
--   connections(id, service_name, environment, url, login, password, active)
--
-- Named parameter (OPTIONAL -- omitted / blank / all-spaces returns ALL connections):
--   :logins  comma-separated MASKS, matched case-insensitively against BOTH `login` AND
--            `service_name`. A row matches if ANY mask hits EITHER column, so `woofer` finds
--            service_name `woofer` and login `woofer_app` alike. A mask with no `%` is a
--            SUBSTRING (wrapped as ILIKE ''%mask%''); a mask that CONTAINS a `%` is used as the
--            ILIKE pattern verbatim, so it can be anchored -- `chat%` = starts with,
--            `%_app` = ends with. Same mask rules as :tables in `table-ddl`.
--            (In a GET query string a literal `%` must be sent as `%25`.)
--
-- Returns service_name, login, environment + the full catalog row in __object -- which also
-- carries id, url, the `active` refresh flag, and the connection''s PASSWORD.

SELECT c.service_name,
       c.login,
       c.environment,
       to_jsonb(c) AS __object
FROM connections c
WHERE nullif(trim(:logins::varchar), '''') IS NULL
   OR EXISTS (SELECT 1
              FROM (SELECT CASE WHEN strpos(m, ''%'') > 0 THEN m ELSE ''%'' || m || ''%'' END AS pat
                    FROM (SELECT trim(x) AS m
                          FROM unnest(string_to_array(:logins::varchar, '','')) AS x) tok
                    WHERE m <> '''') p
              WHERE c.login ILIKE p.pat
                 OR c.service_name ILIKE p.pat)
ORDER BY c.service_name NULLS LAST, c.login, c.environment
', NULL, 'SQL', 'Catalog connections', NULL, 'Service DB logins registered in the Database structure catalog; fuzzy mask search over login + service name.', NULL, false, 'Catalog connections');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('4941d454-dc50-177f-e125-f5b031134fba', 'system-column-create-update', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'INSERT INTO "column" (id, action_id, name, path, "order")
VALUES (coalesce(:id, uuid_in(md5(random()::text || random()::text)::cstring)), :action_id, :name, :path, :order)
ON CONFLICT(id)
    DO UPDATE SET
      action_id = :action_id,
      name = :name,
      path = :path,
      "order" = :order', NULL, 'SQL_DML', '{create-update} column for the action "{action_title}"({action_code})', NULL, '{create-update} column for the action "{action_title}"({action_code})', '{request-parameters._original_url}', false, 'Create/update column');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('2e3ecaad-d6f5-3a72-c858-cf5df2758949', 'system-any-get-http-request-processed-with-sql', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', '{parameters.sql}', NULL, 'SQL', 'Any GET http request processed with SQL', NULL, NULL, NULL, false, 'Any GET http request processed with SQL');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('ed2ec51a-53c6-4b6d-b643-ca8dd9ccfe49', 'menu-put', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with
src as (select content::jsonb menu from action where code = :menu_code::varchar),
p   as (select string_to_array(replace(:path::varchar, '' '', ''''), ''-'')::int[] a),
jp  as (
    select a,
           (select coalesce(array_agg(part order by ord, sub), ''{}''::text[])
            from unnest(trim_array(a, 1)) with ordinality s(v, ord)
            cross join lateral unnest(case when s.ord = 1 then array[(s.v - 1)::text]
                                           else array[''items'', (s.v - 1)::text] end)
                 with ordinality q(part, sub)) parent_node
    from p),
tgt as (
    select a, parent_node,
           case when array_length(a, 1) = 1 then ''{}''::text[]
                else parent_node || array[''items''] end                              parent_arr,
           case when array_length(a, 1) = 1 then array[(a[1] - 1)::text]
                else parent_node || array[''items'', (a[array_length(a, 1)] - 1)::text] end ipath
    from jp),
node as (
    -- blank-safe: an empty string is treated as absent, so jsonb_strip_nulls drops the key.
    -- No action_code => a code-less FOLDER node (name required).
    select jsonb_strip_nulls(jsonb_build_object(
               ''name'',       nullif(trim(:name::varchar), ''''),
               ''code'',       nullif(trim(:action_code::varchar), ''''),
               ''parameters'', case when :show_parameters::boolean then true end)) n),
built as (
    select jsonb_insert(
               case when array_length(t.a, 1) = 1 then s.menu
                    else jsonb_set(s.menu, t.parent_arr,
                                   coalesce(s.menu #> t.parent_arr, ''[]''::jsonb), true) end,
               t.ipath, nd.n) newmenu
    from src s, tgt t, node nd
    where (array_length(t.a, 1) = 1 or s.menu #> t.parent_node is not null)
      and (exists (select 1 from action
                   where code = nullif(trim(:action_code::varchar), ''''))
           or (nullif(trim(:action_code::varchar), '''') is null
               and nullif(trim(:name::varchar), '''') is not null)))
update action set content = jsonb_pretty(b.newmenu)
from built b
where action.code = :menu_code::varchar
  and b.newmenu is distinct from action.content::jsonb
', NULL, 'SQL_DML', 'Menu: put action', NULL, 'Insert an action into the menu at a 1-based path (e.g. 2-1-3). Blank name => the renderer falls back to the action title. Errors if the action code or the parent path does not exist.', '/content/system/menu-tree', true, 'Menu: put action');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('23b6ee85-a2fc-4782-84d4-43ab5b4e9b34', 'system-add-dictionary-item', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'insert into properties
select
    gen_random_uuid(),
    :dictionary_id::uuid,
    :item_code::varchar,
    :item_label::varchar', NULL, 'SQL_DML', 'Add dictionary item', NULL, NULL, '{request-parameters._original_url}', true, 'Add dictionary item');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('b5786c6c-f631-41ed-996a-f7cf2c26bd34', 'system-delete-dictionary-item', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with params as (
    select :code::varchar, :value::varchar
)

delete from properties
where id = :id::uuid', NULL, 'SQL_DML', 'Delete dictionary item', NULL, NULL, '{request-parameters._original_url}', false, 'Delete dictionary item');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('a21fdfc4-ffa7-41c0-9bf7-8c1355adbf32', 'system-delete-dictionary', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with params as (
    select :code::varchar, :name::varchar
)

delete from properties
where parent_id = :id::uuid or id = :id::uuid
', NULL, 'SQL_DML', 'Delete dictionary', NULL, NULL, '{request-parameters._original_url}', true, 'Delete dictionary');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('dea2600c-e1e7-d8d5-f3ee-cb3239e1fd56', 'system-dictionaries', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with base_path as
     (select value bp
      from property p
               join property_category pc on p.category_id = pc.id and pc.code = ''context''
      where "group" = ''system'' and property = ''system-base-path'')

select
    ''<a href="'' || (select bp from base_path) || ''system-dictionary-items?dictionary_id='' || p.id || ''">''
        || p.value || ''</a>'' "Dictionary",
    to_jsonb(p) __object
from properties p
where parent_id = (select id from properties where parent_id is null and key = ''dictionaries'')', NULL, 'SQL', 'Dictionaries', NULL, NULL, NULL, false, 'Dictionaries');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('abdaa370-2c7b-dc78-65e1-5724bf54101a', 'system_extended_properties_for_propery_groups', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select
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
limit 1', NULL, 'SQL', 'Extended propertis for the action "system-property-groups"', NULL, NULL, NULL, false, 'Extended propertis for the action "system-property-groups"');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('9a327110-5e26-4d2a-8bc1-8eabeb2da397', 'system-actions', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select 
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
order by a.title', NULL, 'SQL', 'Actions', NULL, 'Actions', NULL, false, 'Actions');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('69130fb8-abcc-43b9-a1dc-e1e9ae046fc1', 'qqq1', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select 55 "ffff"', NULL, 'SQL', 'qqq1', NULL, NULL, NULL, false, NULL);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('f52aef46-d5be-4653-88b4-c74e23c9004e', 'menu-tree', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with recursive walk as (
    select array[ord::int] k, node
    from action, jsonb_array_elements(content::jsonb) with ordinality t(node, ord)
    where code = :menu_code::varchar
  union all
    select w.k || c.ord::int, c.node
    from walk w
    cross join lateral jsonb_array_elements(
             coalesce(nullif(w.node -> ''items'', ''null''::jsonb), ''[]''::jsonb))
         with ordinality c(node, ord)
)
select array_to_string(w.k, ''-'')                                   as path,
       repeat(''   '', array_length(w.k, 1) - 1)
         || array_to_string(w.k, ''-'') || ''  ''
         || coalesce(w.node ->> ''name'', a.title, w.node ->> ''code'', ''(unnamed)'')
         || coalesce(''  -> '' || (w.node ->> ''code''),
                     ''  -> '' || nullif(w.node ->> ''link'', ''''), '''')
         || case when (w.node ->> ''parameters'')::boolean then ''  [P]'' else '''' end
         || case when w.node ->> ''code'' is not null and a.id is null
                 then ''  <<< NO SUCH ACTION'' else '''' end            as menu,
       w.node ->> ''name''                                            as name,
       w.node ->> ''code''                                            as code,
       w.node ->> ''link''                                            as link,
       coalesce((w.node ->> ''parameters'')::boolean, false)          as parameters,
       nullif(w.node -> ''items'', ''null''::jsonb) is not null          as is_folder,
       (w.node ->> ''code'' is null) or (a.id is not null)            as action_exists,
       w.node                                                       as __object
from walk w
left join action a on a.code = w.node ->> ''code''
order by w.k
', NULL, 'SQL', 'Menu tree', NULL, 'Numbered pseudographic view of a nodata interface menu, read straight from the *-sub-menu-json document. Each row carries its path (e.g. 2-1-3) for use with menu-put / menu-remove / menu-rename / menu-move.', NULL, false, 'Menu tree');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('f4261fc2-cfff-456d-bfc0-c886a3ef3c70', 'menu-move', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with
src  as (select content::jsonb menu from action where code = :menu_code::varchar),
p    as (select string_to_array(replace(:path::varchar,    '' '', ''''), ''-'')::int[] fa,
                string_to_array(replace(:to_path::varchar, '' '', ''''), ''-'')::int[] ta),
k    as (select fa, ta, array_length(fa, 1) klen from p),
pref as (
    select k.fa, k.ta, k.klen,
           (array_length(k.ta, 1) >= k.klen
            and not exists (select 1 from unnest(k.fa) with ordinality f(v, ord)
                            where f.v is distinct from k.ta[f.ord]))            fa_is_prefix,
           not exists (select 1 from unnest(k.fa) with ordinality f(v, ord)
                       where f.ord < k.klen and f.v is distinct from k.ta[f.ord]) head_match
    from k),
adj  as (
    select pref.fa, pref.klen, pref.fa_is_prefix,
           (select array_agg(case when u.ord = pref.klen
                                   and pref.head_match
                                   and array_length(pref.ta, 1) > pref.klen
                                   and u.v > pref.fa[pref.klen]
                                  then u.v - 1 else u.v end order by u.ord)
            from unnest(pref.ta) with ordinality u(v, ord))                      nta
    from pref),
j    as (
    select adj.fa, adj.nta, adj.fa_is_prefix, f.p fpath, t.p tparent,
           case when array_length(adj.nta, 1) = 1 then ''{}''::text[]
                else t.p || array[''items''] end                                   tarr,
           case when array_length(adj.nta, 1) = 1 then array[(adj.nta[1] - 1)::text]
                else t.p || array[''items'', (adj.nta[array_length(adj.nta, 1)] - 1)::text] end ipath
    from adj
    cross join lateral (
        select coalesce(array_agg(part order by ord, sub), ''{}''::text[]) p
        from unnest(adj.fa) with ordinality s(v, ord)
        cross join lateral unnest(case when s.ord = 1 then array[(s.v - 1)::text]
                                       else array[''items'', (s.v - 1)::text] end)
             with ordinality q(part, sub)) f
    cross join lateral (
        select coalesce(array_agg(part order by ord, sub), ''{}''::text[]) p
        from unnest(trim_array(adj.nta, 1)) with ordinality s(v, ord)
        cross join lateral unnest(case when s.ord = 1 then array[(s.v - 1)::text]
                                       else array[''items'', (s.v - 1)::text] end)
             with ordinality q(part, sub)) t),
calc as (
    select jsonb_insert(
               case when array_length(j.nta, 1) = 1 then (s.menu #- j.fpath)
                    else jsonb_set(s.menu #- j.fpath, j.tarr,
                                   coalesce((s.menu #- j.fpath) #> j.tarr, ''[]''::jsonb), true) end,
               j.ipath, s.menu #> j.fpath) newmenu
    from src s, j
    where s.menu #> j.fpath is not null
      and not j.fa_is_prefix
      and (array_length(j.nta, 1) = 1
           or (s.menu #- j.fpath) #> j.tparent is not null))
update action set content = jsonb_pretty(c.newmenu)
from calc c
where action.code = :menu_code::varchar
  and c.newmenu is distinct from action.content::jsonb
', NULL, 'SQL_DML', 'Menu: move item', NULL, 'Move the item at path to to_path; it ends up AT that position. Refuses to move an item into its own subtree.', '/content/system/menu-tree', true, 'Menu: move item');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('130ade7a-359d-4b02-a5fe-0858f5702e67', 'system-update-action-field', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'update action set
    query        = case when :field = ''query''        then :__request_body else query        end,
    content      = case when :field = ''content''      then :__request_body else content      end,
    post_process = case when :field = ''post_process'' then :__request_body else post_process end,
    description  = case when :field = ''description''  then :__request_body else description  end,
    title        = case when :field = ''title''        then :__request_body else title        end,
    redirect     = case when :field = ''redirect''     then :__request_body else redirect     end
where code = :action_code
  and :field in (''query'', ''content'', ''post_process'', ''description'', ''title'', ''redirect'')', NULL, 'SQL_DML', 'Update one action field from the request body', NULL, 'Sets ONE column of an action from the raw POST body. Query params: action_code, field (query|content|post_process|description|title|redirect). Body = the new value as raw text; send Content-Type text/plain so it is not parsed as JSON. Unknown field or code => 0 rows => HTTP 500.', NULL, true, NULL);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('f1b8b927-efdf-43e0-a0d2-0c1d0243f6c8', 'system-update-dictionary-item', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'update properties
set key = :item_code::varchar,
    value = :item_label::varchar
where id = :item_id::uuid', NULL, 'SQL_DML', 'Update dictionary item', NULL, NULL, '{request-parameters._original_url}', true, 'Update dictionary item');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('8226da50-68c5-4b39-98c0-d87a5870371e', 'menu-remove', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with
src as (select content::jsonb menu from action where code = :menu_code::varchar),
p   as (select string_to_array(replace(:path::varchar, '' '', ''''), ''-'')::int[] a),
jp  as (
    select (select coalesce(array_agg(part order by ord, sub), ''{}''::text[])
            from unnest(a) with ordinality s(v, ord)
            cross join lateral unnest(case when s.ord = 1 then array[(s.v - 1)::text]
                                           else array[''items'', (s.v - 1)::text] end)
                 with ordinality q(part, sub)) np
    from p)
update action set content = jsonb_pretty(s.menu #- j.np)
from src s, jp j
where action.code = :menu_code::varchar
  and s.menu #> j.np is not null
  and (s.menu #- j.np) is distinct from action.content::jsonb
', NULL, 'SQL_DML', 'Menu: remove item', NULL, 'Remove the menu item at the given path (with its whole subtree).', '/content/system/menu-tree', true, 'Menu: remove item');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('6e9e9e46-e340-430e-849e-2d8485a8dc5e', 'system-upsert-action', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'DO $$
declare
    vals     jsonb;
    target   uuid;
    existing uuid;
    is_new   boolean := false;
    jp       jsonb;
    jd       jsonb;
begin
    -- one map of every declared parameter: name -> {from_request, string_value, uuid_value, ...}
    select coalesce(jsonb_object_agg(sp.name, to_jsonb(sp)), jsonb_build_object())
      into vals
      from sql_block_parameters sp;

    -- resolve the target: explicit id wins (so `code` can be renamed), else look up by code
    if (vals -> ''id'' ->> ''uuid_value'') is not null then
        target := (vals -> ''id'' ->> ''uuid_value'')::uuid;
        select a.id into existing from action a where a.id = target;
    else
        select a.id into existing from action a where a.code = vals -> ''code'' ->> ''string_value'';
        target := existing;
    end if;

    is_new := existing is null;

    if is_new then
        if coalesce(vals -> ''code'' ->> ''string_value'', '''') = '''' then
            raise exception ''code is required to create an action'';
        end if;
        if (vals -> ''connection_id'' ->> ''uuid_value'') is null then
            raise exception ''connection_id is required to create an action (code=%)'',
                            vals -> ''code'' ->> ''string_value'';
        end if;

        target := coalesce(target, gen_random_uuid());

        insert into action (id, code, connection_id, query, content, execution_type,
                            title, post_process, description, redirect, post_request)
        values (target,
                vals -> ''code''           ->> ''string_value'',
                (vals -> ''connection_id'' ->> ''uuid_value'')::uuid,
                nullif(vals -> ''query''          ->> ''string_value'', ''''),
                nullif(vals -> ''content''        ->> ''string_value'', ''''),
                nullif(vals -> ''execution_type'' ->> ''string_value'', ''''),
                nullif(vals -> ''title''          ->> ''string_value'', ''''),
                nullif(vals -> ''post_process''   ->> ''string_value'', ''''),
                nullif(vals -> ''description''    ->> ''string_value'', ''''),
                nullif(vals -> ''redirect''       ->> ''string_value'', ''''),
                coalesce((vals -> ''post_request'' ->> ''boolean_value'')::boolean, false));

        insert into property_category values (gen_random_uuid(), target, ''action properties'');
    else
        -- partial update: a column moves ONLY when its parameter came with the request.
        -- supplied-but-empty means "set NULL" (STRING/TEXT never map '''' to NULL themselves).
        update action a set
            code           = case when coalesce((vals -> ''code''           ->> ''from_request'')::boolean, false)
                                  then vals -> ''code'' ->> ''string_value'' else a.code end,
            connection_id  = case when coalesce((vals -> ''connection_id''  ->> ''from_request'')::boolean, false)
                                  then (vals -> ''connection_id'' ->> ''uuid_value'')::uuid else a.connection_id end,
            query          = case when coalesce((vals -> ''query''          ->> ''from_request'')::boolean, false)
                                  then nullif(vals -> ''query'' ->> ''string_value'', '''') else a.query end,
            content        = case when coalesce((vals -> ''content''        ->> ''from_request'')::boolean, false)
                                  then nullif(vals -> ''content'' ->> ''string_value'', '''') else a.content end,
            execution_type = case when coalesce((vals -> ''execution_type'' ->> ''from_request'')::boolean, false)
                                  then nullif(vals -> ''execution_type'' ->> ''string_value'', '''') else a.execution_type end,
            title          = case when coalesce((vals -> ''title''          ->> ''from_request'')::boolean, false)
                                  then nullif(vals -> ''title'' ->> ''string_value'', '''') else a.title end,
            post_process   = case when coalesce((vals -> ''post_process''   ->> ''from_request'')::boolean, false)
                                  then nullif(vals -> ''post_process'' ->> ''string_value'', '''') else a.post_process end,
            description    = case when coalesce((vals -> ''description''    ->> ''from_request'')::boolean, false)
                                  then nullif(vals -> ''description'' ->> ''string_value'', '''') else a.description end,
            redirect       = case when coalesce((vals -> ''redirect''       ->> ''from_request'')::boolean, false)
                                  then nullif(vals -> ''redirect'' ->> ''string_value'', '''') else a.redirect end,
            post_request   = case when coalesce((vals -> ''post_request''   ->> ''from_request'')::boolean, false)
                                  then coalesce((vals -> ''post_request'' ->> ''boolean_value'')::boolean, false)
                                  else a.post_request end
        where a.id = target;
    end if;

    -- delete_parameters: JSON array of parameter names
    if coalesce((vals -> ''delete_parameters'' ->> ''from_request'')::boolean, false) then
        jd := coalesce(nullif(vals -> ''delete_parameters'' ->> ''string_value'', '''')::jsonb, ''[]''::jsonb);

        delete from parameter p
        where p.action_id = target
          and p.name in (select jsonb_array_elements_text(jd));
    end if;

    -- action_parameters: JSON array of parameter objects, replaced wholesale by name
    if coalesce((vals -> ''action_parameters'' ->> ''from_request'')::boolean, false) then
        jp := coalesce(nullif(vals -> ''action_parameters'' ->> ''string_value'', '''')::jsonb, ''[]''::jsonb);

        if exists (select 1 from jsonb_array_elements(jp) e
                   where coalesce(e ->> ''name'', '''') = '''') then
            raise exception ''every entry in action_parameters needs a name'';
        end if;

        delete from parameter p
        where p.action_id = target
          and p.name in (select e ->> ''name'' from jsonb_array_elements(jp) e);

        insert into parameter (id, action_id, name, type, title, editable, "order",
                               default_value, description,
                               dictionary_id, name_column, value_column, editable_dictionary)
        select gen_random_uuid(),
               target,
               e ->> ''name'',
               coalesce(nullif(e ->> ''type'', ''''), ''STRING''),
               e ->> ''title'',
               coalesce((e ->> ''editable'')::boolean, true),
               coalesce((e ->> ''order'')::int, 0),
               e ->> ''default_value'',
               e ->> ''description'',
               (e ->> ''dictionary_id'')::uuid,
               e ->> ''name_column'',
               e ->> ''value_column'',
               (e ->> ''editable_dictionary'')::boolean
        from jsonb_array_elements(jp) e;
    end if;
end $$
', NULL, 'SQL_BLOCK', 'Create or update an action (partial update)', NULL, 'Upsert an action. Target = id if given (lets code be renamed), else code. On UPDATE only the columns whose parameters arrived with the request change; omitted ones are left as-is. A supplied-but-empty text value sets NULL. action_parameters = JSON array of parameter objects (replaced by name); delete_parameters = JSON array of names.', NULL, true, NULL);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('f777a55e-e019-44b3-bfdc-2df687195867', 'menu-rename', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with
src as (select content::jsonb menu from action where code = :menu_code::varchar),
p   as (select string_to_array(replace(:path::varchar, '' '', ''''), ''-'')::int[] a),
jp  as (
    select (select coalesce(array_agg(part order by ord, sub), ''{}''::text[])
            from unnest(a) with ordinality s(v, ord)
            cross join lateral unnest(case when s.ord = 1 then array[(s.v - 1)::text]
                                           else array[''items'', (s.v - 1)::text] end)
                 with ordinality q(part, sub)) np
    from p),
calc as (
    select case when :name::varchar is null
                then s.menu #- (j.np || array[''name''])
                else jsonb_set(s.menu, j.np || array[''name''],
                               to_jsonb(:name::varchar), true) end nm
    from src s, jp j
    where s.menu #> j.np is not null)
update action set content = jsonb_pretty(c.nm)
from calc c
where action.code = :menu_code::varchar
  and c.nm is distinct from action.content::jsonb
', NULL, 'SQL_DML', 'Menu: rename item', NULL, 'Set the name of the menu item at the given path. Blank name drops the name key, so the renderer falls back to the action title.', '/content/system/menu-tree', true, 'Menu: rename item');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('50c515f0-2224-52ab-b0df-36a7d2da7b49', '__system-parameters_extended_parameters', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with act as (
select * from action
where id = :action_id::uuid)

select ''Parameters for the "'' || act.title || ''"('' || act.code  || '') action'' title
from act
union all
select ''Action parameters''
where not exists (select 1 from act)', NULL, 'SQL', '__system-parameters_extended_parameters', NULL, NULL, NULL, false, '__system-parameters_extended_parameters');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('91b78475-df95-e996-f490-5fa510237dbb', 'find-login-for-tables', '280508e7-9ad9-0607-bf04-eee56d322ab7', '-- Query behind the "find a login for a set of tables" endpoint (the XYZ endpoint).
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
', NULL, 'SQL', 'Find login for tables', NULL, NULL, NULL, false, 'Find login for tables');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('8ddf46e0-1019-14f7-6680-80c505fefb5e', 'system-any-get-http-request', '6fdfb5ed-816e-77a1-3e13-d84bbb452939', NULL, NULL, 'HTTP_GET', 'Any GET http request', 'if (mainData.actionParameters.columns) {
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
', NULL, NULL, false, 'Any GET http request');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('7c1333a8-4ac8-3221-fb6d-55bcef1d5e18', '__system-create-parameter_parameters', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select a.code action_code, a.title action_title
from action a
where id = :action_id::uuid', NULL, 'SQL', '__system-create-parameter_parameters', NULL, NULL, NULL, false, '__system-create-parameter_parameters');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('8d9f7add-2f20-0e56-7d53-5ea78c2ea052', 'system-properties', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select p.id, p.category_id, p."group", 

case pc.code when ''context'' then p.property || '' - {properties.'' || case p."group" when ''system'' then ''system'' else ''environment'' end || ''.'' || p.property || ''}''
else p.property end property, 

p.property property_name,

p.value, pc.code category_code from property p
join property_category pc on p.category_id = pc.id
where (p.category_id = :category_id or :category_id::uuid is null)
  and (p."group" like :group or :group::varchar is null)
  and (pc.code = :category_code or :category_code::varchar is null)
  and (category_id = (select id from property_category pc where pc.code = :category_code) or :category_code::varchar is null)
order by p."group", p.property, p.value', NULL, 'SQL', '{parameters.description}', NULL, '{parameters.description}', NULL, false, 'Properties');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('1fab5dda-e8bf-48b4-9e97-ef3fc3bba8cf', '__system-dictionary-items_extended-parameters', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select p.value || '' ('' || p.key || '')'' dictionary_title from properties p
where id = :dictionary_id::uuid and :dictionary_id::uuid is not null
union all
select ''Dictionary items'' where :dictionary_id::uuid is null', NULL, 'SQL', '__system-dictionary-items_extended-parameters', NULL, NULL, NULL, false, '__system-dictionary-items_extended-parameters');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('4b1d6290-beb8-f38a-dc57-a8801cff31cb', 'system-property-groups', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with base_path as
         (select value bp
          from property p
                   join property_category pc on p.category_id = pc.id and pc.code = ''context''
          where "group" = ''system'' and property = ''system-base-path''),

     values as (
         select distinct 
p."group", 

pc.code,

case when pc.code = ''context'' then ''Environment''
when pc.code = ''dictionaries'' then ''Dictionary''
else ''Group'' end group_title,

case when pc.code = ''dictionaries'' then ''Label''
else ''Property+name'' end property_title,

case when pc.code = ''dictionaries'' then ''Dictionary items'' end description

         from property p
                  join property_category pc on p.category_id = pc.id
         where (pc.id = :category_id or :category_id::uuid is null)
           and (pc.code = :category_code or :category_code::varchar is null))

select p."group" value,
       ''<a href="'' || (select bp from base_path) || ''system-properties?category_code=''|| p.code ||
       ''&group=''|| p."group" ||
       ''&title_for_group_column=''|| group_title ||
       ''&title_for_property_column=''|| property_title ||
       case when p.description is not null then ''&description=''|| p.description
            else '''' end ||
       ''">''|| p."group" ||''</a>'' link
from values p
order by 1', NULL, 'SQL', '{request-parameters.description}', NULL, '{request-parameters.description}', NULL, false, 'Property groups ');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('d91e9ae3-1447-2e28-932a-2fb184305461', 'system-dictionary-items', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with dict_id as (
select id from properties
where parent_id = (select id from properties where parent_id is null and key = ''dictionaries'')
and (key = :dictionary_code or :dictionary_code::varchar is null)
and (id = :dictionary_id or :dictionary_id::uuid is null)
and (:dictionary_id::uuid is not null or :dictionary_code::varchar is not null)
)

select 
p.value "Label",
p.key "Code",
to_jsonb(p) __object
from properties p
where parent_id = (select id from dict_id)
and (key like :wildcard or :wildcard::varchar is null)', NULL, 'SQL', '{extended-parameters.dictionary_title}', NULL, '{extended-parameters.dictionary_title}', NULL, false, 'Dictionary items');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('dfe67d96-5391-4534-aa8c-a706d985896c', 'system-parameters', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select 
       p.title "Title",
       p.name "Name",
       p.type "Data type",
       p.editable "Editable",
       p.default_value "Default value",

       (select p.value
        from properties p
        where parent_id = (select id from properties where parent_id is null and key = ''dictionaries'')
        and key = alm.default_value) "Dictionary",

       da.title "Dictionary action",
       case when d.code is null then p.name_column end "Dictionary name column",
       case when d.code is null then p.value_column end "Dictionary value column",
       p.editable "Dictionary editable",
       p."order" "Order",

       jsonb_build_object(
               ''parameter'', to_jsonb(p),
               ''action'', to_jsonb(a),
               ''dictionary_action_id'', da.id, 
               ''dictionary_code'', alm.default_value
       ) __object
from parameter p
    join action a on a.id = p.action_id
    left join action_link al  on p.dictionary_id = al.id
    left join action da on da.id = al.child_action_id and da.code != ''system-dictionary-items''
    left join action d on d.id = al.child_action_id and d.code = ''system-dictionary-items''
    left join action_link_mapping alm on alm.action_link_id = al.id
        and d.code is not null and alm.parameter_id = ''5233dd2e-96dc-8673-a92d-e08b1f21325d''
where (p.action_id = :action_id or :action_id::uuid is null)
  and (p.id = :id or :id::uuid is null)
order by p.action_id, p."order"', NULL, 'SQL', '{extended_parameters.title}', NULL, '{extended_parameters.title}', NULL, false, 'Parameters');


--
-- PostgreSQL database dump complete
--

