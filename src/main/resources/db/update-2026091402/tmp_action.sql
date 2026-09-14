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

INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('c6b6dafc-5a7c-4dcd-819c-888cd72396cb', 'system-upsert-action-link', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'DO $$
declare
    vals        jsonb;
    parent_eff  uuid;
    link_id     uuid;
    existing_id uuid;
    child_id    uuid;
    grp         varchar;
    jm          jsonb;
    m           jsonb;
    param_id    uuid;
begin
    select coalesce(jsonb_object_agg(sp.name, to_jsonb(sp)), jsonb_build_object())
      into vals
      from sql_block_parameters sp;

    child_id   := (vals -> ''child_action_id'' ->> ''uuid_value'')::uuid;
    grp        := nullif(trim(vals -> ''group'' ->> ''string_value''), '''');
    parent_eff := case when coalesce((vals -> ''global'' ->> ''boolean_value'')::boolean, false)
                       then null
                       else (vals -> ''parent_action_id'' ->> ''uuid_value'')::uuid end;

    if child_id is null then
        raise exception ''child_action_id is required'';
    end if;
    if not exists (select 1 from action where id = child_id) then
        raise exception ''no action with id % (child_action_id)'', child_id;
    end if;
    if grp not in (''MOUNTED_TO_ACTION'', ''MOUNTED_TO_ROW'') then
        raise exception ''group must be MOUNTED_TO_ACTION or MOUNTED_TO_ROW, got %'', grp;
    end if;

    -- upsert the link itself, keyed by (child, title, effective parent)
    select id into existing_id
    from action_link
    where child_action_id = child_id
      and title is not distinct from (vals -> ''title'' ->> ''string_value'')
      and parent_action_id is not distinct from parent_eff;

    if existing_id is null then
        link_id := gen_random_uuid();
        insert into action_link(id, parent_action_id, child_action_id, title, is_action_target,
                                 via_parameters, "order", mounted_to_row, category, variable, mapping)
        values (link_id, parent_eff, child_id, vals -> ''title'' ->> ''string_value'', false,
                coalesce((vals -> ''via_parameters'' ->> ''boolean_value'')::boolean, false),
                coalesce((vals -> ''order'' ->> ''integer_value'')::integer, 0),
                false, grp, null, null);
    else
        link_id := existing_id;
        update action_link set
            via_parameters = coalesce((vals -> ''via_parameters'' ->> ''boolean_value'')::boolean, false),
            "order"        = coalesce((vals -> ''order'' ->> ''integer_value'')::integer, 0),
            category       = grp
        where id = link_id;
    end if;

    -- mapping: JSON array of {"path": "...", "parameter_name": "..."}; replaces existing mappings wholesale
    jm := coalesce(nullif(vals -> ''mapping'' ->> ''string_value'', '''')::jsonb, ''[]''::jsonb);

    if exists (select 1 from jsonb_array_elements(jm) e
               where coalesce(e ->> ''path'', '''') = '''' or coalesce(e ->> ''parameter_name'', '''') = '''') then
        raise exception ''every mapping entry needs both path and parameter_name'';
    end if;

    delete from action_link_mapping where action_link_id = link_id;

    for m in select * from jsonb_array_elements(jm)
    loop
        select id into param_id from parameter
        where action_id = child_id and name = m ->> ''parameter_name'';

        if param_id is null then
            raise exception ''child action has no parameter named %'', m ->> ''parameter_name'';
        end if;

        insert into action_link_mapping(id, action_link_id, parameter_id, mapping, default_value)
        values (gen_random_uuid(), link_id, param_id, m ->> ''path'', null);
    end loop;
end $$;', NULL, 'SQL_BLOCK', NULL, NULL, 'Create-or-update an action_link plus its action_link_mapping rows in one call. group must be MOUNTED_TO_ACTION or MOUNTED_TO_ROW. mapping is a JSON array of {path, parameter_name} pairs. path is evaluated directly against the rows own JSON (same addressing as column.path) -- there is no row. prefix. Reference a top-level row column by its bare name, or drill into the nested full-row payload via __object.<path> (the rows __objekt/__object key), e.g. __object.wld_id or __object.chat.wld_id. Verified 2026-08-28 against coportal-customer-name -> ngage-chats: row.wld_id silently resolved to nothing, __object.wld_id worked. Mappings are replaced wholesale on every call. Upsert key: (child_action_id, title, effective parent_action_id).', '{request-parameters._original_url}', 'Upsert action link (with parameter mappings)');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('09a56638-c975-3b7b-2127-818ab535fc63', 'system-delete-action-link', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'delete from action_link where id = :id', NULL, 'SQL_DML', 'Delete link', NULL, 'Delete link', '{request-parameters._original_url}', 'Delete link');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('f777a55e-e019-44b3-bfdc-2df687195867', 'menu-rename', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with
root as (select id from properties where parent_id is null and key = ''storage''),
src as (select value::jsonb menu from properties, root where properties.parent_id = root.id and properties.key = :menu_code::varchar),
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
update properties set value = jsonb_pretty(c.nm)
from calc c, root
where properties.parent_id = root.id
  and properties.key = :menu_code::varchar
  and c.nm is distinct from properties.value::jsonb
', NULL, 'SQL_DML', 'Menu: rename item', NULL, 'Set the name of the menu item at the given path. Blank name drops the name key, so the renderer falls back to the action title.', '/content/system/menu-tree', 'Menu: rename item');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('2ec6e7bc-125d-19b8-4138-468bf5e6f994', 'system-sub-menu', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with recursive
src as (
    select value::jsonb doc from properties
    where parent_id = (select id from properties where parent_id is null and key = ''storage'')
      and key = ''system-sub-menu-json''
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
    -- name falls back to the action''s own name, then its title, then the code, mirroring
    -- build_menu, so a node inserted without an explicit name is not rendered anonymous.
    select row_number() over (order by array_length(w.p, 1), w.p) rn,
           w.p,
           ''/content/system/'' || (w.node ->> ''code'')
             || case when (w.node ->> ''parameters'')::boolean then ''/parameters'' else '''' end newlink,
           coalesce(w.node ->> ''name'', a.name, a.title, w.node ->> ''code'')                newname
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
', NULL, 'SQL', 'System submenu', NULL, 'System submenu', NULL, 'System submenu');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('924039ab-a63f-2ef3-2578-616eefe35c1b', 'system-environments-dictionary', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with base_path as
         (select value bp
          from property p
          join property_category pc on p.category_id = pc.id and pc.code = ''context''
          where "group" = ''system'' and property = ''system-base-path''),

     values as (
         select '''' "value"
         union all
         select distinct "group"
         from property p
         join property_category pc on p.category_id = pc.id and pc.category = ''context'')

select p."value",
       case when p."value" != ''''
                then ''<a href="'' || (select bp from base_path) || ''system-properties?environment=''|| p."value" ||''">''|| p."value" ||''</a>''
            else p."value" end link
from values p
where (coalesce(:environment::varchar, '''') = '''' or p."value" like :environment::varchar)
  and (coalesce(:empty_available, true) or p."value" != '''')
order by 1', NULL, 'SQL', 'Environments', NULL, 'Environments', NULL, 'Environments');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('081f536b-6882-46b1-bbf2-1fd976e4a3f5', 'system-connections', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select 
  con.description "Name",
  con.url "URL",
  con.login "Login",
  con.type "Type",
to_jsonb(con) __object
from connection con
where (con.id = :id or :id::uuid is null)
and (con.code like :code or :code::varchar is null)', NULL, 'SQL', 'Connections', NULL, 'Connections', NULL, 'Connections');
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
', NULL, 'SQL', 'Table ddl', NULL, NULL, NULL, 'Table ddl');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('b1f70839-ccf6-bb42-b618-311bd6d92361', '__system-update-action_parameters', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select * from action
where (id = :action_id::uuid or :action_id::uuid is null)
and (code = :code::varchar or :code::varchar is null)', NULL, 'SQL', '__system-update-action_parameters', NULL, NULL, NULL, '__system-update-action_parameters');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('691dce23-aae8-e745-2f44-e5afad8996f6', 'system-columns', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select col.id,
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
order by col.order', NULL, 'SQL', 'Columns for the action "{action_title}"({action_code})', NULL, 'Columns for the action "{action_title}"({action_code})', NULL, 'Action columns');
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
ORDER BY c.environment, c.login, "table"', NULL, 'SQL', 'User/table priveleges', NULL, NULL, NULL, 'User/table priveleges');
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

END $$', NULL, 'SQL_BLOCK', 'Set dictionary  action', NULL, NULL, '{request-parameters._original_url}', 'Set dictionary  action');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('b6512014-7f6c-4440-ab22-363a3bf4a351', 'return-request-body', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select :__request_body content', NULL, 'HTTP_GET', 'return-request-body', NULL, NULL, NULL, 'return-request-body');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('23b6ee85-a2fc-4782-84d4-43ab5b4e9b34', 'system-add-dictionary-item', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'insert into properties
select
    gen_random_uuid(),
    :dictionary_id::uuid,
    :item_code::varchar,
    :item_label::varchar', NULL, 'SQL_DML', 'Add dictionary item', NULL, NULL, '{request-parameters._original_url}', 'Add dictionary item');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('a21fdfc4-ffa7-41c0-9bf7-8c1355adbf32', 'system-delete-dictionary', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with params as (
    select :code::varchar, :name::varchar
)

delete from properties
where parent_id = :id::uuid or id = :id::uuid
', NULL, 'SQL_DML', 'Delete dictionary', NULL, NULL, '{request-parameters._original_url}', 'Delete dictionary');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('b0078e88-3425-ea62-606f-774f538bbcd9', 'system-delete-connection', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'DO $$declare
    connection_id uuid;
BEGIN
    select uuid_value::uuid into connection_id from sql_block_parameters where name = ''id'';

    delete from connection a where a.id = connection_id;

    delete from property_category where code = connection_id::varchar;

END $$', NULL, 'SQL_BLOCK', 'Delete connection', NULL, 'Delete connection', '{request-parameters._original_url}', 'Delete connection');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('b47c0f1f-5569-083f-ca7a-14d9a6736e4d', 'system-update-action-link', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'update action_link l set title = :title, 
via_parameters = :via_parameters::boolean,
category = :group::varchar,
"order" = :order,
variable = :variable,
mapping = :mapping
where id = :id', NULL, 'SQL_DML', 'Update link', NULL, 'Update link', '{request-parameters._original_url}', 'Update link');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('1b4e4d25-adc9-c116-ba99-1463ad51cec6', 'system-create-parameter', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'INSERT INTO public.parameter (id, action_id, name, type, title, editable, "order", default_value)
VALUES (gen_random_uuid(),
        (select id from action where code = :action_code),
        :name, 
        case when :type is null or :type = '''' then ''STRING'' else :type end,
        :title,
        coalesce(:editable, true),
        :order,
        :default_value
)', NULL, 'SQL_DML', 'Create parameter for the action "{PARAMETERS.action_title}"({PARAMETERS.action_code})', NULL, 'Create parameter for the action "{PARAMETERS.action_title}"({PARAMETERS.action_code})', '{request-parameters._original_url}', 'Create parameter');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('eb109b97-5fa6-2712-e517-b10d07976ca8', 'system-parameter-update', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'update public.parameter set
name = :name,
type = case when coalesce(:type, '''') = '''' then ''STRING'' else :type end,
default_value = :default_value,
title = :title,
editable = coalesce(:editable, true),
"order" = :order
where id = :id', NULL, 'SQL_DML', 'Update parameter for the action "{action_name}"({action_code})', NULL, 'Update parameter for the action "{action_name}"({action_code})', '{request-parameters._original_url}', 'Update parameter');
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
where parent_id = (select id from properties where parent_id is null and key = ''dictionaries'')', NULL, 'SQL', 'Dictionaries', NULL, NULL, NULL, 'Dictionaries');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('ff53d3e8-780f-43f1-ae7b-8a1d5037e142', 'system-update-dictionary', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'update properties
set value = :dictionary_name::varchar,
    key = :dictionary_code::varchar
where id = :dictionary_id::uuid', NULL, 'SQL_DML', 'Edit dictionary', NULL, 'Edit dictionary', '{request-parameters._original_url}', 'Edit dictionary');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('5d38171a-bd9b-4be9-9c38-5121ae471e69', 'system-create-dictionary', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'insert into properties
select
    gen_random_uuid(),
    (select id from properties where parent_id is null and key = ''dictionaries''),
    :dictionary_code::varchar,
    :dictionary_name::varchar', NULL, 'SQL_DML', 'Create dictionary', NULL, 'Create dictionary', '{request-parameters._original_url}', 'Create dictionary');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('812af221-0b4d-25c7-435b-3c4b8f3de0ae', 'system-column-delete', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'delete from "column" where id = :id', NULL, 'SQL_DML', 'Delete column', NULL, 'Delete column', '{request-parameters._original_url}', 'Delete column');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('27a15286-7c9e-fb12-b406-bc42ab29510c', 'system-create-property', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'INSERT INTO public.property (id, "group", property, value, category_id)
VALUES (
        uuid_in(md5(random()::text || random()::text)::cstring), 
        :group, 
        :property, 
        :value,
(select id from property_category
where (id = :category_id or :category_id::uuid is null )
and (code = :category_code or :category_code::varchar is null ))
)', NULL, 'SQL_DML', 'Create property', NULL, 'Create property', '{request-parameters._original_url}', 'Create property');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('4941d454-dc50-177f-e125-f5b031134fba', 'system-column-create-update', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'INSERT INTO "column" (id, action_id, name, path, "order")
VALUES (coalesce(:id, uuid_in(md5(random()::text || random()::text)::cstring)), :action_id, :name, :path, :order)
ON CONFLICT(id)
    DO UPDATE SET
      action_id = :action_id,
      name = :name,
      path = :path,
      "order" = :order', NULL, 'SQL_DML', '{create-update} column for the action "{action_title}"({action_code})', NULL, '{create-update} column for the action "{action_title}"({action_code})', '{request-parameters._original_url}', 'Create/update column');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('2e3ecaad-d6f5-3a72-c858-cf5df2758949', 'system-any-get-http-request-processed-with-sql', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', '{parameters.sql}', NULL, 'SQL', 'Any GET http request processed with SQL', NULL, NULL, NULL, 'Any GET http request processed with SQL');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('e6ea59cd-7b58-6a9f-9ddb-01f03de167f2', 'system-delete-property', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'delete from public.property where id = :id', NULL, 'SQL_DML', 'Delete property', NULL, 'Delete property', '{request-parameters._original_url}', 'Delete property');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('b5786c6c-f631-41ed-996a-f7cf2c26bd34', 'system-delete-dictionary-item', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with params as (
    select :code::varchar, :value::varchar
)

delete from properties
where id = :id::uuid', NULL, 'SQL_DML', 'Delete dictionary item', NULL, NULL, '{request-parameters._original_url}', 'Delete dictionary item');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('a45d744d-339c-08f2-6993-8841e28f78fd', 'insert_action', 'b16c7ed6-3beb-495c-b38e-337f9adec0a1', '/content/system/system-welcome/data', '{
  "code" : "${code}",
  "query" : "${query}",
  "content" : "${content}",
  "http_method" : "${http_method}",
  "connectionId" : "d48b9a97-e13c-4961-9eff-d76f39abdffb"}', 'HTTP_GET', 'Just for example', NULL, 'Just for example', NULL, 'Just for example');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('a01761a0-988e-3f81-ccb9-6b92c2ccf1df', 'system-update-action', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'update action set
    code = :code,
    connection_id = :connection_id,
    query = :query,
    content = :content,
    execution_type = :execution_type,
    title = :title,
    name = :name,
    post_process = :post_process,
    redirect = :redirect,
    description = :description
where id = :id', '''null''', 'SQL_DML', 'Update action', '''null''', 'Update action', '{request-parameters._original_url}', 'Update action');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('4d45abd8-7edc-5b5b-b08f-1a0c151a722a', 'system-delete-action-link-mapping', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'delete from action_link_mapping 
where id = :id or action_link_id = :action_link_id', NULL, 'SQL_DML', 'Unmap link parameter', NULL, 'Unmap link parameter', '{request-parameters._original_url}', 'Unmap link parameter');
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
limit 1', NULL, 'SQL', 'Extended propertis for the action "system-property-groups"', NULL, NULL, NULL, 'Extended propertis for the action "system-property-groups"');
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
order by coalesce(a.name, a.title, a.code)', NULL, 'SQL', 'Actions', NULL, 'Actions', NULL, 'Actions');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('f4261fc2-cfff-456d-bfc0-c886a3ef3c70', 'menu-move', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with
root as (select id from properties where parent_id is null and key = ''storage''),
src  as (select value::jsonb menu from properties, root where properties.parent_id = root.id and properties.key = :menu_code::varchar),
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
update properties set value = jsonb_pretty(c.newmenu)
from calc c, root
where properties.parent_id = root.id
  and properties.key = :menu_code::varchar
  and c.newmenu is distinct from properties.value::jsonb
', NULL, 'SQL_DML', 'Menu: move item', NULL, 'Move the item at path to to_path; it ends up AT that position. Refuses to move an item into its own subtree.', '/content/system/menu-tree', 'Menu: move item');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('fa35b5dd-6e29-6474-3f10-07b684c06a62', 'system-action-links', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select
    l.title,
    pa.id parent_action_id,
    pa.name parent_action_name,
    pa.code parent_action_code,
    ca.id child_action_id,
    ca.title child_action_name,
    ca.code child_action_code,
    l.category "group",
    l.via_parameters,
    l.id,
    l."order",
    case when l.parent_action_id is null then true else false end global,
    l.variable,
    l.mapping
from action_link l
         join action ca on ca.id = l.child_action_id
         left join action pa on l.parent_action_id = pa.id
where (parent_action_id = :parent_action_id or :parent_action_id::uuid is null or
       (parent_action_id is null and :global = true))
  and (child_action_id = :child_action_id or :child_action_id::uuid is null)
  and (l.id = :id or :id::uuid is null)
order by l.parent_action_id, l.category, l."order"', NULL, 'SQL', 'Links', NULL, 'Links', NULL, 'Links');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('6265989e-67d2-68ef-9dee-12efe4a4d88d', 'system-action-link-mappings', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select
    al.title link_title,
    pa.title parent_action_name,
    pa.code parent_action_code,
    ca.title child_action_name,
    ca.code child_action_code,
    p.title,
    alm.default_value,
    p.name,
    p.type,
    p.id parameter_id,
    alm.mapping,
    al.id action_link_id,
    alm.id action_link_mapping_id,
    al.parent_action_id,
    al.child_action_id
from action_link al
         join action ca on al.child_action_id = ca.id
         left join action pa on al.parent_action_id = pa.id
         join parameter p on ca.id = p.action_id
         left join action_link_mapping alm on al.id = alm.action_link_id and alm.parameter_id = p.id
where (:action_link_id::uuid is null or al.id = :action_link_id)
and (:parameter_id::uuid is null or (p.id = :parameter_id and alm.id is not null))
and (:action_link_id::uuid is not null or :parameter_id::uuid is not null)
order by parent_action_name, child_action_name, p.order', NULL, 'SQL', 'Link mapping', NULL, 'Link mapping', NULL, 'Link mapping');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('f1b8b927-efdf-43e0-a0d2-0c1d0243f6c8', 'system-update-dictionary-item', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'update properties
set key = :item_code::varchar,
    value = :item_label::varchar
where id = :item_id::uuid', NULL, 'SQL_DML', 'Update dictionary item', NULL, NULL, '{request-parameters._original_url}', 'Update dictionary item');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('dfe67d96-5391-4534-aa8c-a706d985896c', 'system-parameters', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select 
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
order by p.action_id, p."order"', NULL, 'SQL', '{extended_parameters.title}', NULL, '{extended_parameters.title}', NULL, 'Parameters');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('3d6fcc69-8b4f-c653-e23a-231452862ad7', 'system-create-action-link-mapping', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'insert into action_link_mapping
values (uuid_in(md5(random()::text || random()::text)::cstring),
        :action_link_id,
        :parameter_id,
        :mapping,
        :default_value)
ON CONFLICT ON CONSTRAINT unique_action_link_id_parameter_id
    DO update set mapping = EXCLUDED.mapping, default_value = :default_value', NULL, 'SQL_DML', 'Map link parameter', NULL, 'Map link parameter', '{request-parameters._original_url}', 'Map link parameter');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('84f7269c-68a3-b278-f5fc-d807a5f4b1e8', 'view-any-object', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', '--with v as (
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
', NULL, 'View');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('ed2ec51a-53c6-4b6d-b643-ca8dd9ccfe49', 'menu-put', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with
root as (select id from properties where parent_id is null and key = ''storage''),
src as (select value::jsonb menu from properties, root where properties.parent_id = root.id and properties.key = :menu_code::varchar),
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
update properties set value = jsonb_pretty(b.newmenu)
from built b, root
where properties.parent_id = root.id
  and properties.key = :menu_code::varchar
  and b.newmenu is distinct from properties.value::jsonb
', NULL, 'SQL_DML', 'Menu: put action', NULL, 'Insert an action into the menu at a 1-based path (e.g. 2-1-3). Blank name => the renderer falls back to the action title. Errors if the action code or the parent path does not exist.', '/content/system/menu-tree', 'Menu: put action');
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
', NULL, 'Storage entry update');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('7e3b1c4a-9f52-4d18-b0a6-3c8d5e2f10ab', 'system-blocked-actions', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', '-- Actions that `nd read` must refuse to invoke.
--
-- Computed as "every action whose execution_type is NOT a read method", rather than by listing the
-- mutating methods: a newly introduced execution type is then blocked by default instead of
-- slipping through unnoticed. A NULL execution_type is blocked for the same reason.
--
-- The second predicate is the fixed allow list -- mutating actions deliberately re-permitted.
-- It is intentionally EMPTY; add codes to the array only with a concrete reason.
--
-- __object deliberately omits query/content/post_process: `nd` fetches this list on every call, and
-- carrying every blocked action''s full SQL would make each read cost tens of kilobytes of payload
-- that no caller reads.
select a.code                                              as "code",
       a.execution_type                                    as "execution type",
       coalesce(a.title, a.name, a.code)                   as "title",
       to_jsonb(a) - ''query'' - ''content'' - ''post_process''  as __object
from action a
where (a.execution_type is null
        or a.execution_type::varchar <> all (array[''SQL'', ''HTTP_GET'']::varchar[]))
  and a.code <> all (array[]::varchar[])
order by a.code', NULL, 'SQL', 'Blocked actions', NULL, 'Actions that `nd read` must refuse: non-read execution types minus a fixed allow list.', NULL, 'Blocked actions');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('ba7829af-09a9-e951-90fa-d04171739f46', 'system-delete-action', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'DO $$declare
    action_id uuid;
BEGIN
    select uuid_value::uuid into action_id from sql_block_parameters where name = ''id'';

    delete from action a where a.id = action_id;

    delete from property_category where code = action_id::varchar;

END $$', NULL, 'SQL_BLOCK', 'Delete action', NULL, 'Delete action', '{request-parameters._original_url}', 'Delete action');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('002d3444-b227-47f7-a059-adee55f1f78d', 'toggle-connection-active', '280508e7-9ad9-0607-bf04-eee56d322ab7', '-- Flip the "active" refresh flag on one "Database structure" catalog connection (service login).
--
-- :id = connections.id (the catalog row''s own PK; see catalog-connections'' __object.id).
-- Toggling active does not touch privileges/DDL already recorded for this login -- it only
-- controls whether the next manual Tables.java catalog refresh processes this login.
-- An unknown id updates 0 rows, which SQL_DML reports as "Nothing is modified" (HTTP 500).

UPDATE connections
SET active = NOT active
WHERE id = :id::integer
', NULL, 'SQL_DML', NULL, NULL, 'Flip the active refresh flag on a Database-structure catalog connection (service login), by its connections.id. Row action mounted on catalog-connections.', '{request-parameters._original_url}', 'Toggle connection active');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('f0a9485a-550a-4c5c-aa1f-c3d686cd1323', 'update-connection', '280508e7-9ad9-0607-bf04-eee56d322ab7', '
-- Update one row in the "Database structure" catalog connections table, by connections.id.
-- Row action mounted on catalog-connections (via_parameters=true, pre-filled from the row).

UPDATE connections
SET service_name = :service_name,
    environment  = :environment,
    url          = :url,
    login        = :login,
    password     = :password,
    active       = :active
WHERE id = :id::integer
', NULL, 'SQL_DML', NULL, NULL, 'Update one Database-structure catalog connection row, by connections.id. Row action mounted on catalog-connections.', '{request-parameters._original_url}', 'Update connection');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('3c8229ce-6f04-47e3-9b4f-888c0e355eb1', 'delete-connection', '280508e7-9ad9-0607-bf04-eee56d322ab7', '
-- Delete one row from the "Database structure" catalog connections table, by connections.id.
-- Row action mounted on catalog-connections (via_parameters=true).
-- Cascades to that connections privileges rows (privileges.connection_id ON DELETE CASCADE).

DELETE FROM connections
WHERE id = :id::integer
', NULL, 'SQL_DML', NULL, NULL, 'Delete one Database-structure catalog connection row, by connections.id (cascades to its privileges rows). Row action mounted on catalog-connections.', '{request-parameters._original_url}', 'Delete connection');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('6ae6cff9-d041-4ba8-83ba-3fc7bae39aac', 'create-connection', '280508e7-9ad9-0607-bf04-eee56d322ab7', '
-- Insert one row into the "Database structure" catalog connections table
-- (a service login to the shared PostgreSQL DB, one row per login x environment).
--
-- All of service_name/environment/url/login/password are required; active defaults to
-- false (matches the column default) if omitted -- pass active=true so the next manual
-- Tables.java catalog refresh picks this login up and records its table privileges/DDL.

INSERT INTO connections (service_name, environment, url, login, password, active)
VALUES (:service_name, :environment, :url, :login, :password, coalesce(:active::boolean, false))
', NULL, 'SQL_DML', NULL, NULL, 'Insert one service-login row into the Database-structure catalog''s connections table (service_name, environment, url, login, password, active).', '{request-parameters._original_url}', 'Create connection');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('325e7262-43f7-4a57-b053-d17cb6852977', 'storage-entries', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select
    p.id "Id",
    p.key "Name",
    to_jsonb(p) || jsonb_build_object(
        ''__view'', jsonb_build_object(
            ''url'', ''{properties.system.localhost-http-url}/content/system/storage-entries/data?id='' || p.id,
            ''fields'', jsonb_build_array(
                jsonb_build_array(''data.__object.id'', ''Id'', ''string''),
                jsonb_build_array(''data.__object.key'', ''Name'', ''string''),
                jsonb_build_array(''data.__object.value'', ''Data'', ''text'')
            )
        )
    ) __object
from properties p
where parent_id = (select id from properties where parent_id is null and key = ''storage'')
  and (:id::uuid is null or p.id = :id::uuid)
  and (nullif(trim(:name::text), '''') is null or p.key ILIKE ''%'' || :name || ''%'')
  and (nullif(trim(:data::text), '''') is null or p.value ILIKE ''%'' || :data || ''%'')
order by p.key
', NULL, 'SQL', NULL, NULL, '# Storage entries

## Purpose

Lists entries from a **generic name/data key-value store**, built by reusing nodata''s own
`properties` table -- the same self-referencing `id`/`parent_id`/`key`/`value` tree that otherwise
backs the UI''s "Dictionaries" feature (`system-dictionaries` / `system-dictionary-items`). This
feature seeds a **second, unrelated root** in that same table, keyed `key = ''storage''`
(`parent_id is null`), created once by `storage-root-init`. Every entry underneath is a child row
of that root: `key` = the entry''s name, `value` = its data (arbitrary plain text or JSON, stored
verbatim). Lets the user stash ad-hoc texts/JSON blobs from inside nodata without inventing a new
table.

## Columns -- `Data` is deliberately NOT a flat column

Visible columns are just `Id` and `Name`. An entry''s `value` can be arbitrarily large, and flat
columns are meant to stay a short, safe preview -- so `Data` was pulled after initially being a
flat column, per explicit direction. The full value is never lost: it''s always present in
`__object.value`, per the always-emit-`__object` convention (see `nodata-endpoint-sql.md`).
Consumers must read the data from `__object`, not from a flat column.

## Filters (all optional, null-ignored, combined with AND)

| Param  | Type   | Match |
|--------|--------|-------|
| `id`   | `UUID`   | **strict** -- exact row. Added specifically to make the self-referencing `__view.url` below unambiguous (same reason `table-ddl`''s "DDL" link needed an exact `id` param). |
| `name` | `STRING` | **fuzzy** -- `p.key ILIKE ''%value%''` |
| `data` | `STRING` | **fuzzy** -- `p.value ILIKE ''%value%''` |

No filter given ⇒ every entry under the storage root.

## The `__view` (drill-down)

`__object` also carries a `__view` object pointing back at **this same action**, filtered to the
row''s own `id`, with fields `Id` (string), `Name` (string), `Data` (**text** -- renders as a
read-only `<textarea>`, safe even for a large value). This is consumed by the generic
`view-any-object` action via the "View" row link. See `view-any-object`''s own description /
`nodata-view-any-object.md` for the mechanism.

## SQL

```sql
select
    p.id "Id",
    p.key "Name",
    to_jsonb(p) || jsonb_build_object(
        ''__view'', jsonb_build_object(
            ''url'', ''{properties.system.localhost-http-url}/content/system/storage-entries/data?id='' || p.id,
            ''fields'', jsonb_build_array(
                jsonb_build_array(''data.__object.id'', ''Id'', ''string''),
                jsonb_build_array(''data.__object.key'', ''Name'', ''string''),
                jsonb_build_array(''data.__object.value'', ''Data'', ''text'')
            )
        )
    ) __object
from properties p
where parent_id = (select id from properties where parent_id is null and key = ''storage'')
  and (:id::uuid is null or p.id = :id::uuid)
  and (nullif(trim(:name::text), '''') is null or p.key ILIKE ''%'' || :name || ''%'')
  and (nullif(trim(:data::text), '''') is null or p.value ILIKE ''%'' || :data || ''%'')
order by p.key
```

## Sibling actions / row links

- `storage-entry-create` -- linked as "New entry" (`MOUNTED_TO_ACTION`, blank form).
- `storage-entry-update` -- linked as "Edit" (`MOUNTED_TO_ROW`, form pre-filled from the row''s own
  `id`/`key`/`value`).
- `storage-entry-delete` -- linked as "Delete" (`MOUNTED_TO_ROW`, confirmation form).
- `view-any-object` -- linked as "View" (`MOUNTED_TO_ROW`, runs directly, no form).
- `storage-root-init` -- the one-time bootstrap that created the `storage` root this action reads
  from; not linked, run once.

## Menu

System › **Storage** (path `1-7`).

## See also

KB doc `nodata-storage-entries.md` -- the canonical write-up (this description is a condensed
copy of it, kept in the tool itself for discoverability).
', NULL, 'Storage entries');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('50c515f0-2224-52ab-b0df-36a7d2da7b49', '__system-parameters_extended_parameters', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with act as (
select * from action
where id = :action_id::uuid)

select ''Parameters for the "'' || act.title || ''"('' || act.code  || '') action'' title
from act
union all
select ''Action parameters''
where not exists (select 1 from act)', NULL, 'SQL', '__system-parameters_extended_parameters', NULL, NULL, NULL, '__system-parameters_extended_parameters');
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
', NULL, 'Storage entry create');
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
', NULL, 'Storage entry delete');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('9cc55a3e-b522-409b-a221-9aa163453ef5', 'call-any-select-sql', '20a9693e-d032-f7f1-d197-6f11ffab6ba7', '{request-parameters.__request_body}', NULL, 'SQL', NULL, NULL, NULL, NULL, 'Call any "select" SQL');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('9ac0f8b6-01a7-d1f4-2b23-b891bf39012f', 'system-create-action-link', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'insert into action_link values(
    uuid_in(md5(random()::text || random()::text)::cstring),
    case when :global = true then null else :parent_action_id end,
    :child_action_id,
    :title,
    false,
    :via_parameters::boolean,
    :order,
    false,
    :group,
    :variable,
    :mapping
)', NULL, 'SQL_DML', 'Create link', NULL, 'Create link', '{request-parameters._original_url}', 'Create link');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('37cac08c-9f8c-3bf5-803c-1303a1129555', 'system-delete-parameter', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'delete from parameter where id = :id', NULL, 'SQL_DML', 'Delete parameter', NULL, 'Delete parameter', '{request-parameters._original_url}', 'Delete parameter');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('570aeb3f-d237-2c20-154b-8d8415c87792', 'system-welcome', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select '''' as "-" where 1 = 2', NULL, 'SQL', 'Welcome! NoData for you.', NULL, 'Welcome! NoData for you.', NULL, 'Welcome! NoData for you.');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('2b9c7e2d-c035-4416-a0c4-8e2b3d8c069d', 'catalog-connections', '280508e7-9ad9-0607-bf04-eee56d322ab7', '-- Query behind the "database-catalog connections" endpoint.
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
-- Named parameters (ALL OPTIONAL -- omitted / blank / all-spaces disables that filter; multiple
-- filters combine with AND):
--   :logins  comma-separated MASKS, matched case-insensitively against BOTH `login` AND
--            `service_name`. A row matches if ANY mask hits EITHER column, so `woofer` finds
--            service_name `woofer` and login `woofer_app` alike. A mask with no `%` is a
--            SUBSTRING (wrapped as ILIKE ''%mask%''); a mask that CONTAINS a `%` is used as the
--            ILIKE pattern verbatim, so it can be anchored -- `chat%` = starts with,
--            `%_app` = ends with. Same mask rules as :tables in `table-ddl`.
--            (In a GET query string a literal `%` must be sent as `%25`.)
--   :envs    comma-separated MASKS, matched case-insensitively against `environment` (e.g.
--            `qa`, `stage`, `prod`). Same mask rules as :logins -- fuzzy substring unless the
--            mask itself contains `%`, ANY-of-masks. E.g. `envs=qa,prod` returns qa and prod
--            rows; `envs=sta` matches `stage` via substring.
--
-- Returns service_name, login, environment + the full catalog row in __object -- which also
-- carries id, url, the `active` refresh flag, and the connection''s PASSWORD.

SELECT c.service_name,
       c.login,
       c.environment,
       c.active,
       to_jsonb(c) AS __object
FROM connections c
WHERE (
    nullif(trim(:logins::varchar), '''') IS NULL
    OR EXISTS (SELECT 1
               FROM (SELECT CASE WHEN strpos(m, ''%'') > 0 THEN m ELSE ''%'' || m || ''%'' END AS pat
                     FROM (SELECT trim(x) AS m
                           FROM unnest(string_to_array(:logins::varchar, '','')) AS x) tok
                     WHERE m <> '''') p
               WHERE c.login ILIKE p.pat
                  OR c.service_name ILIKE p.pat)
  )
  AND (
    nullif(trim(:envs::varchar), '''') IS NULL
    OR EXISTS (SELECT 1
               FROM (SELECT CASE WHEN strpos(m, ''%'') > 0 THEN m ELSE ''%'' || m || ''%'' END AS pat
                     FROM (SELECT trim(x) AS m
                           FROM unnest(string_to_array(:envs::varchar, '','')) AS x) tok
                     WHERE m <> '''') p
               WHERE c.environment ILIKE p.pat)
  )
ORDER BY c.service_name NULLS LAST, c.login, c.environment
', NULL, 'SQL', 'Catalog connections', NULL, 'Service DB logins registered in the Database structure catalog; fuzzy mask search over login + service name and/or environment.', NULL, 'Catalog connections');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('8096367c-cc1a-473e-a9d0-33041aa92d61', 'system-create-action', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'DO $$declare
    id uuid;
    title varchar;
    action_name varchar;
    code varchar;
    connection_id uuid;
    query varchar;
    content varchar;
    execution_type varchar;
    post_process varchar;
    description varchar;
    redirect varchar;
BEGIN
    select string_value into title from sql_block_parameters where name = ''title'';
    select string_value into action_name from sql_block_parameters where name = ''name'';
    select string_value into code from sql_block_parameters where name = ''code'';
    select uuid_value::uuid into connection_id from sql_block_parameters where name = ''connection_id'';
    select string_value into query from sql_block_parameters where name = ''query'';
    select string_value into content from sql_block_parameters where name = ''content'';
    select string_value into execution_type from sql_block_parameters where name = ''execution_type'';
    select string_value into post_process from sql_block_parameters where name = ''post_process'';

    id = gen_random_uuid();

    INSERT INTO public.action
        (id, code, connection_id, query, content, execution_type,
         title, post_process, description, redirect, name)
    VALUES (id,
            code,
            connection_id, query, content, execution_type,
            nullif(trim(title), ''''),
            post_process,
            description,
            redirect,
            nullif(trim(action_name), ''''));

    insert into parameter(id,action_id,name,type,"order")
    with param as (
    select
        distinct
        lower(m[1]) as parameter_name,
        nullif(m[2], '''') as parameter_type
    from (
             select regexp_matches(
                        query,
                        '':([a-zA-Z_]\w*)(?:::(?![:])([a-zA-Z_]\w*))?'',
                        ''g''
             ) as m
   ) sub)

    select
        gen_random_uuid(),
        id action_id,
        r.*,
        (ROW_NUMBER() OVER ())*10 AS row_num
    from
    (select
        distinct
        p.parameter_name,
        coalesce(
        case upper(pt.parameter_type)
            when ''INT'' then ''INTEGER''
            when ''VARCHAR'' then ''STRING''
            else upper(pt.parameter_type)
        end, ''_INSERTED'') parameter_type
    from param p
    left join param pt on p.parameter_name = pt.parameter_name and pt.parameter_type is not null) r
;

    insert into property_category values(gen_random_uuid(), id, ''action properties'');

END $$', NULL, 'SQL_BLOCK', 'Create action', NULL, 'Create action', '/content/system/system-actions?code={request-parameters.code}', 'Create action');
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
', NULL, 'SQL', 'Find login for tables', NULL, NULL, NULL, 'Find login for tables');
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
', NULL, NULL, 'Any GET http request');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('7c1333a8-4ac8-3221-fb6d-55bcef1d5e18', '__system-create-parameter_parameters', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select a.code action_code, a.title action_title
from action a
where id = :action_id::uuid', NULL, 'SQL', '__system-create-parameter_parameters', NULL, NULL, NULL, '__system-create-parameter_parameters');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('8d9f7add-2f20-0e56-7d53-5ea78c2ea052', 'system-properties', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select p.id, p.category_id, p."group", 

case pc.code when ''context'' then p.property || '' - {properties.'' || case p."group" when ''system'' then ''system'' else ''environment'' end || ''.'' || p.property || ''}''
else p.property end property, 

p.property property_name,

p.value, pc.code category_code from property p
join property_category pc on p.category_id = pc.id
where (p.category_id = :category_id or :category_id::uuid is null)
  and (p."group" like :group or :group::varchar is null)
  and (pc.code = :category_code or :category_code::varchar is null)
  and (category_id = (select id from property_category pc where pc.code = :category_code) or :category_code::varchar is null)
order by p."group", p.property, p.value', NULL, 'SQL', '{parameters.description}', NULL, '{parameters.description}', NULL, 'Properties');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('f52aef46-d5be-4653-88b4-c74e23c9004e', 'menu-tree', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with recursive walk as (
    select array[ord::int] k, node
    from properties, jsonb_array_elements(value::jsonb) with ordinality t(node, ord)
    where parent_id = (select id from properties where parent_id is null and key = ''storage'')
      and key = :menu_code::varchar
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
         || coalesce(w.node ->> ''name'', a.name, a.title, w.node ->> ''code'', ''(unnamed)'')
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
', NULL, 'SQL', 'Menu tree', NULL, 'Numbered pseudographic view of a nodata interface menu, read straight from the *-sub-menu-json document. Each row carries its path (e.g. 2-1-3) for use with menu-put / menu-remove / menu-rename / menu-move.', NULL, 'Menu tree');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('1fab5dda-e8bf-48b4-9e97-ef3fc3bba8cf', '__system-dictionary-items_extended-parameters', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select p.value || '' ('' || p.key || '')'' dictionary_title from properties p
where id = :dictionary_id::uuid and :dictionary_id::uuid is not null
union all
select ''Dictionary items'' where :dictionary_id::uuid is null', NULL, 'SQL', '__system-dictionary-items_extended-parameters', NULL, NULL, NULL, '__system-dictionary-items_extended-parameters');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('6703218f-54a0-94b7-42b3-ed9e0e4c6685', 'system-set-dictionary', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'DO $$declare
    dictionary_code varchar;
    parameter_id uuid;
    new_link_id uuid;
    link_id uuid;
BEGIN
    select string_value into dictionary_code from sql_block_parameters where name = ''dictionary_code'';
    select uuid_value::uuid into parameter_id from sql_block_parameters where name = ''parameter_id'';

    select parameter.dictionary_id into link_id from parameter where id = parameter_id;

    update parameter set dictionary_id = null where id = parameter_id;

    new_link_id = gen_random_uuid();

    insert into action_link
    select
        new_link_id,
        (select action_id from parameter where id = parameter_id),
        (select id from action where code = ''system-dictionary-items''),
        null,
        false,
        false,
        0,
        false,
        ''DICTIONARY'',
        null
    where dictionary_code is not null;

    insert into action_link_mapping
    select
        gen_random_uuid(),
        new_link_id,
        p.id,
        null,
        dictionary_code
    from parameter p
             join action a on p.action_id = a.id
    where a.code = ''system-dictionary-items''
      and p.name = ''dictionary_code''
      and dictionary_code is not null;

    update parameter set dictionary_id = new_link_id,
    name_column = ''__object.value'',
    value_column = ''__object.key'' 
    where id = parameter_id and dictionary_code is not null;

    delete from action_link ll where ll.id in (
        select l.id from action_link l
        where l.id = link_id and l.category = ''DICTIONARY''
          and not exists(select 1 from parameter p where p.dictionary_id = link_id));

END $$', NULL, 'SQL_BLOCK', 'Set dictionary', NULL, 'Set dictionary', '{request-parameters._original_url}', 'Set dictionary');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('8226da50-68c5-4b39-98c0-d87a5870371e', 'menu-remove', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with
root as (select id from properties where parent_id is null and key = ''storage''),
src as (select value::jsonb menu from properties, root where properties.parent_id = root.id and properties.key = :menu_code::varchar),
p   as (select string_to_array(replace(:path::varchar, '' '', ''''), ''-'')::int[] a),
jp  as (
    select (select coalesce(array_agg(part order by ord, sub), ''{}''::text[])
            from unnest(a) with ordinality s(v, ord)
            cross join lateral unnest(case when s.ord = 1 then array[(s.v - 1)::text]
                                           else array[''items'', (s.v - 1)::text] end)
                 with ordinality q(part, sub)) np
    from p)
update properties set value = jsonb_pretty(s.menu #- j.np)
from src s, jp j, root
where properties.parent_id = root.id
  and properties.key = :menu_code::varchar
  and s.menu #> j.np is not null
  and (s.menu #- j.np) is distinct from properties.value::jsonb
', NULL, 'SQL_DML', 'Menu: remove item', NULL, 'Remove the menu item at the given path (with its whole subtree).', '/content/system/menu-tree', 'Menu: remove item');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('a8cb378b-60e8-d5d3-d1f7-b41730000c1f', 'system-edit-property', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'update public.property set "group" = :group, property = :property, value = :value where id = :id', NULL, 'SQL_DML', 'Update property', NULL, 'Update property', '{request-parameters._original_url}', 'Update property');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('3310ffca-f928-e81b-2a9f-b0bd59d89225', 'system-update-connection', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'update connection set
description = :description,
type = :type,
url = :url,
login = :login,
password = :password,
code = :code
where id = :id', NULL, 'SQL_DML', 'Update connection', NULL, 'Update connection', '{request-parameters._original_url}', 'Update connection');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('06d9ecd0-41b1-4e99-96b2-a6e13cf513d2', 'storage-root-init', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'insert into properties (id, parent_id, key, value)
select gen_random_uuid(), null, ''storage'', ''Storage''
where not exists (
    select 1 from properties where parent_id is null and key = ''storage''
);
', NULL, 'SQL_DML', NULL, NULL, '# Storage root init

## Purpose

One-time, idempotent bootstrap for the `storage-entries` key/value store (see `storage-entries`''
own description for the full picture of what that store is). Creates the single root row --
`parent_id` null, `key = ''storage''` -- that every `storage-entry-*` action locates its parent by
(a key lookup done fresh in every query, never a hardcoded id).

## Mechanics

```sql
insert into properties (id, parent_id, key, value)
select gen_random_uuid(), null, ''storage'', ''Storage''
where not exists (
    select 1 from properties where parent_id is null and key = ''storage''
);
```

The `where not exists` guard is what makes re-running this action safe. It is load-bearing, not
defensive boilerplate: Postgres treats NULLs as distinct for uniqueness purposes, so there is no
unique constraint that would reject a second `(null, ''storage'')` row on its own -- without the
guard, running this twice would silently create two competing storage roots.

## Reuses an existing table

`properties` (`id`/`parent_id`/`key`/`value`, self-referencing via `parent_id`) already exists to
back nodata''s own "Dictionaries" UI feature (`system-dictionaries` / `system-dictionary-items` /
`system-create-dictionary` / `system-delete-dictionary*`), whose root is the sibling row
`key = ''dictionaries''`. This action seeds a second, unrelated root in the same table -- the two
trees never interact because each is only ever looked up by its own root `key`.

## See also

KB doc `nodata-storage-entries.md` -- the canonical write-up. This action is **not** linked from
any menu or row link; run it once when bootstrapping the feature on a fresh DB (dev, or after a
future migration to work).
', NULL, 'Storage root init (one-time bootstrap)');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('4141be2c-75e0-0384-c45f-a619e4fa131c', 'system-create-connection', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'DO $$declare
    id uuid;
    code varchar;
    type varchar;
    url varchar;
    login varchar;
    password varchar;
    description varchar;
BEGIN
    select string_value into type from sql_block_parameters where name = ''type'';
    select string_value into code from sql_block_parameters where name = ''code'';
    select string_value into url from sql_block_parameters where name = ''url'';
    select string_value into login from sql_block_parameters where name = ''login'';
    select string_value into password from sql_block_parameters where name = ''password'';
    select string_value into description from sql_block_parameters where name = ''description'';

    id = uuid_in(md5(random()::text || random()::text)::cstring);

    INSERT INTO public.connection (id, description, type, url, login, password, code) VALUES (id, description, type, url, login, password, code);

    insert into property_category values(uuid_in(md5(random()::text || random()::text)::cstring), id, ''connection properties'');

END $$', NULL, 'SQL_BLOCK', 'Create connection', NULL, 'Create connection', '{request-parameters._original_url}', 'Create connection');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('4b1d6290-beb8-f38a-dc57-a8801cff31cb', 'system-property-groups', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with base_path as
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
order by 1', NULL, 'SQL', '{request-parameters.description}', NULL, '{request-parameters.description}', NULL, 'Property groups ');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('d91e9ae3-1447-2e28-932a-2fb184305461', 'system-dictionary-items', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with dict_id as (
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
and (key like :wildcard or :wildcard::varchar is null)', NULL, 'SQL', '{extended-parameters.dictionary_title}', NULL, '{extended-parameters.dictionary_title}', NULL, 'Dictionary items');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('cccdac53-ba4b-4df8-96c1-b2c0c4ecbfd5', 'system-tables-ddl', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with recursive tbl as (
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
', NULL, 'SQL', 'System DB tables + DDL (dependency order)', NULL, 'All tables of nodata''s own config database (liquibase tables excluded), ordered so a table always appears after every table it depends on via a foreign key. Visible columns: order, name. Everything else -- schema, table, owner, dependency level, in_cycle, self_referencing, depends_on, referenced_by and the generated ddl_script -- is in __object.', NULL, 'System DB tables + DDL (dependency order)');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('130ade7a-359d-4b02-a5fe-0858f5702e67', 'system-update-action-field', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'update action set
    query        = case when :field = ''query''        then :__request_body else query        end,
    content      = case when :field = ''content''      then :__request_body else content      end,
    post_process = case when :field = ''post_process'' then :__request_body else post_process end,
    description  = case when :field = ''description''  then :__request_body else description  end,
    title        = case when :field = ''title''        then :__request_body else title        end,
    name         = case when :field = ''name''         then :__request_body else name         end,
    redirect     = case when :field = ''redirect''     then :__request_body else redirect     end
where code = :action_code
  and :field in (''query'', ''content'', ''post_process'', ''description'', ''title'', ''name'', ''redirect'')', NULL, 'SQL_DML', 'Update one action field from the request body', NULL, 'Sets ONE column of an action from the raw POST body. Query params: action_code, field (query|content|post_process|description|title|redirect). Body = the new value as raw text; send Content-Type text/plain so it is not parsed as JSON. Unknown field or code => 0 rows => HTTP 500.', NULL, 'Update one action field from the request body');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('69130fb8-abcc-43b9-a1dc-e1e9ae046fc1', 'qqq1', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select 55 "ffff"', NULL, 'SQL', 'qqq1', NULL, NULL, NULL, 'qqq1');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('6e9e9e46-e340-430e-849e-2d8485a8dc5e', 'system-upsert-action', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'DO $$
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
                            title, name, post_process, description, redirect)
        values (target,
                vals -> ''code''           ->> ''string_value'',
                (vals -> ''connection_id'' ->> ''uuid_value'')::uuid,
                nullif(vals -> ''query''          ->> ''string_value'', ''''),
                nullif(vals -> ''content''        ->> ''string_value'', ''''),
                nullif(vals -> ''execution_type'' ->> ''string_value'', ''''),
                nullif(vals -> ''title''          ->> ''string_value'', ''''),
                nullif(vals -> ''name''           ->> ''string_value'', ''''),
                nullif(vals -> ''post_process''   ->> ''string_value'', ''''),
                nullif(vals -> ''description''    ->> ''string_value'', ''''),
                nullif(vals -> ''redirect''       ->> ''string_value'', ''''));

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
            name           = case when coalesce((vals -> ''name''           ->> ''from_request'')::boolean, false)
                                  then nullif(vals -> ''name'' ->> ''string_value'', '''') else a.name end,
            post_process   = case when coalesce((vals -> ''post_process''   ->> ''from_request'')::boolean, false)
                                  then nullif(vals -> ''post_process'' ->> ''string_value'', '''') else a.post_process end,
            description    = case when coalesce((vals -> ''description''    ->> ''from_request'')::boolean, false)
                                  then nullif(vals -> ''description'' ->> ''string_value'', '''') else a.description end,
            redirect       = case when coalesce((vals -> ''redirect''       ->> ''from_request'')::boolean, false)
                                  then nullif(vals -> ''redirect'' ->> ''string_value'', '''') else a.redirect end
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
end $$', NULL, 'SQL_BLOCK', 'Create or update an action (partial update)', NULL, 'Upsert an action. Target = id if given (lets code be renamed), else code. On UPDATE only the columns whose parameters arrived with the request change; omitted ones are left as-is. A supplied-but-empty text value sets NULL. action_parameters = JSON array of parameter objects (replaced by name); delete_parameters = JSON array of names.', NULL, 'Create or update an action (partial update)');


--
-- PostgreSQL database dump complete
--

