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
                    }
                ]
            }
        ]
    }
]', 'HTTP_POST', 'System submenu JSON', NULL, NULL, NULL, false, NULL);
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
', NULL, 'SQL_DML', 'Menu: put action', NULL, 'Insert an action into the menu at a 1-based path (e.g. 2-1-3). Blank name => the renderer falls back to the action title. Errors if the action code or the parent path does not exist.', '/content/system/menu-tree', true, NULL);
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
', NULL, 'SQL_DML', 'Menu: remove item', NULL, 'Remove the menu item at the given path (with its whole subtree).', '/content/system/menu-tree', true, NULL);
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
', NULL, 'SQL_DML', 'Menu: rename item', NULL, 'Set the name of the menu item at the given path. Blank name drops the name key, so the renderer falls back to the action title.', '/content/system/menu-tree', true, NULL);
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
', NULL, 'SQL_DML', 'Menu: move item', NULL, 'Move the item at path to to_path; it ends up AT that position. Refuses to move an item into its own subtree.', '/content/system/menu-tree', true, NULL);
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
', NULL, 'SQL', 'Find login for tables', NULL, NULL, NULL, false, NULL);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('cb2677d6-2334-cd9e-5fe8-b2d76a05360f', 'table-ddl', '280508e7-9ad9-0607-bf04-eee56d322ab7', '-- Query behind the "get table DDL" endpoint.
--
-- Two ways to select rows (use either, or both):
--   1. by exact fully-qualified name  (:tables)      -- "give me the DDL for these tables"
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
--   :tables        comma-separated fully-qualified `schema.table` names, matched EXACTLY
--                  (case-insensitive) -- no fuzzy substring.
--   :ddl_contains  comma-separated substrings; returns tables whose ddl_script contains ANY of
--                  them (case-insensitive `ILIKE ''%value%''`). Typically a single table name to
--                  find everything that references it.
--
-- Returns one row per matched table: table, description, ddl_script. A row matches if it
-- satisfies EITHER provided filter (exact name OR ddl-contains). If neither parameter is
-- provided, nothing is returned.

SELECT t.schema_name || ''.'' || t.table_name AS "table",
       t.description,
       t.ddl_script
FROM tables t
WHERE (nullif(trim(:tables::varchar), '''') IS NOT NULL
       AND lower(t.schema_name || ''.'' || t.table_name) = ANY (
               SELECT lower(trim(x))
               FROM unnest(string_to_array(:tables::varchar, '','')) AS x
               WHERE nullif(trim(x), '''') IS NOT NULL))
   OR (nullif(trim(:ddl_contains::varchar), '''') IS NOT NULL
       AND t.ddl_script ILIKE ANY (ARRAY(
               SELECT ''%'' || trim(y) || ''%''
               FROM unnest(string_to_array(:ddl_contains::varchar, '','')) AS y
               WHERE nullif(trim(y), '''') IS NOT NULL)))
ORDER BY "table"
', NULL, 'SQL', 'Table ddl', NULL, NULL, NULL, false, NULL);
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
ORDER BY c.environment, c.login, "table"', NULL, 'SQL', 'User/table priveleges', NULL, NULL, NULL, false, NULL);
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
', NULL, 'SQL', 'Menu tree', NULL, 'Numbered pseudographic view of a nodata interface menu, read straight from the *-sub-menu-json document. Each row carries its path (e.g. 2-1-3) for use with menu-put / menu-remove / menu-rename / menu-move.', NULL, false, NULL);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('2ec6e7bc-125d-19b8-4138-468bf5e6f994', 'system-sub-menu', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with recursive
src as (
    select content::jsonb doc from action where code = ''system-sub-menu-json''
),
walk as (
    select array[(ord - 1)::text] p, node
    from src, jsonb_array_elements(src.doc) with ordinality t(node, ord)
  union all
    select w.p || array[''items'', (c.ord - 1)::text], c.node
    from walk w
    cross join lateral jsonb_array_elements(
             coalesce(nullif(w.node -> ''items'', ''null''::jsonb), ''[]''::jsonb))
         with ordinality c(node, ord)
),
targets as (
    -- every node carrying a code; "code wins", so an existing link is overwritten.
    -- name falls back to the action title then the code, mirroring build_menu, so a node
    -- inserted without an explicit name is not rendered anonymous.
    select row_number() over (order by array_length(w.p, 1), w.p) rn,
           w.p,
           ''/content/system/'' || (w.node ->> ''code'')
             || case when (w.node ->> ''parameters'')::boolean then ''/parameters'' else '''' end newlink,
           coalesce(w.node ->> ''name'', a.title, w.node ->> ''code'')                        newname
    from walk w
    left join action a on a.code = w.node ->> ''code''
    where w.node ->> ''code'' is not null
),
fold as (
    -- iterative fold: set link + name, then drop code/parameters so the emitted tree is exactly
    -- {name, link, items} (what MenuItem deserializes). Only scalar keys are added/removed,
    -- never array elements, so every precomputed path stays valid for the whole fold.
    select 0 i, (select doc from src) doc
  union all
    select f.i + 1,
           (jsonb_set(
                jsonb_set(f.doc, t.p || array[''link''], to_jsonb(t.newlink), true),
                t.p || array[''name''], to_jsonb(t.newname), true)
                #- (t.p || array[''code''])) #- (t.p || array[''parameters''])
    from fold f
    join targets t on t.rn = f.i + 1
)
select doc menu from fold order by i desc limit 1
', NULL, 'SQL', 'System submenu', NULL, 'System submenu', NULL, false, 'System submenu');


--
-- PostgreSQL database dump complete
--

