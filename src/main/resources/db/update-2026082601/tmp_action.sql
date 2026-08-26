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
                "name": "System DB tables"
            }
        ]
    }
]', 'HTTP_POST', 'System submenu JSON', NULL, NULL, NULL, false, 'System submenu JSON');
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
', NULL, 'SQL', 'System DB tables + DDL (dependency order)', NULL, 'All tables of nodata''s own config database (liquibase tables excluded), ordered so a table always appears after every table it depends on via a foreign key. Visible columns: order, name. Everything else -- schema, table, owner, dependency level, in_cycle, self_referencing, depends_on, referenced_by and the generated ddl_script -- is in __object.', NULL, false, 'System DB tables + DDL (dependency order)');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('a01761a0-988e-3f81-ccb9-6b92c2ccf1df', 'system-update-action', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'update action set
    code = :code,
    connection_id = :connection_id,
    query = :query,
    content = :content,
    execution_type = :execution_type,
    title = :title,
    name = :name,
    post_process = :post_process,
    redirect = :redirect,
    description = :description,
    post_request = :post_request
where id = :id', '''null''', 'SQL_DML', 'Update action', '''null''', 'Update action', '{request-parameters._original_url}', true, 'Update action');
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
order by w.k', NULL, 'SQL', 'Menu tree', NULL, 'Numbered pseudographic view of a nodata interface menu, read straight from the *-sub-menu-json document. Each row carries its path (e.g. 2-1-3) for use with menu-put / menu-remove / menu-rename / menu-move.', NULL, false, 'Menu tree');
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
order by coalesce(a.name, a.title, a.code)', NULL, 'SQL', 'Actions', NULL, 'Actions', NULL, false, 'Actions');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('130ade7a-359d-4b02-a5fe-0858f5702e67', 'system-update-action-field', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'update action set
    query        = case when :field = ''query''        then :__request_body else query        end,
    content      = case when :field = ''content''      then :__request_body else content      end,
    post_process = case when :field = ''post_process'' then :__request_body else post_process end,
    description  = case when :field = ''description''  then :__request_body else description  end,
    title        = case when :field = ''title''        then :__request_body else title        end,
    name         = case when :field = ''name''         then :__request_body else name         end,
    redirect     = case when :field = ''redirect''     then :__request_body else redirect     end
where code = :action_code
  and :field in (''query'', ''content'', ''post_process'', ''description'', ''title'', ''name'', ''redirect'')', NULL, 'SQL_DML', 'Update one action field from the request body', NULL, 'Sets ONE column of an action from the raw POST body. Query params: action_code, field (query|content|post_process|description|title|redirect). Body = the new value as raw text; send Content-Type text/plain so it is not parsed as JSON. Unknown field or code => 0 rows => HTTP 500.', NULL, true, 'Update one action field from the request body');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('69130fb8-abcc-43b9-a1dc-e1e9ae046fc1', 'qqq1', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select 55 "ffff"', NULL, 'SQL', 'qqq1', NULL, NULL, NULL, false, 'qqq1');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('8096367c-cc1a-473e-a9d0-33041aa92d61', 'system-create-action', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'DO $$declare
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
         title, post_process, description, redirect, post_request, name)
    VALUES (id,
            code,
            connection_id, query, content, execution_type,
            nullif(trim(title), ''''),
            post_process,
            description,
            redirect,
            false,
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

END $$', NULL, 'SQL_BLOCK', 'Create action', NULL, 'Create action', '/content/system/system-actions?code={request-parameters.code}', true, 'Create action');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('7e3b1c4a-9f52-4d18-b0a6-3c8d5e2f10ab', 'system-blocked-actions', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', '-- Actions that `nd read` must refuse to invoke.
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
order by a.code', NULL, 'SQL', 'Blocked actions', NULL, 'Actions that `nd read` must refuse: non-read execution types minus a fixed allow list.', NULL, false, 'Blocked actions');
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
select doc menu from fold order by i desc limit 1', NULL, 'SQL', 'System submenu', NULL, 'System submenu', NULL, false, 'System submenu');
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
                            title, name, post_process, description, redirect, post_request)
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
            name           = case when coalesce((vals -> ''name''           ->> ''from_request'')::boolean, false)
                                  then nullif(vals -> ''name'' ->> ''string_value'', '''') else a.name end,
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
end $$', NULL, 'SQL_BLOCK', 'Create or update an action (partial update)', NULL, 'Upsert an action. Target = id if given (lets code be renamed), else code. On UPDATE only the columns whose parameters arrived with the request change; omitted ones are left as-is. A supplied-but-empty text value sets NULL. action_parameters = JSON array of parameter objects (replaced by name); delete_parameters = JSON array of names.', NULL, true, 'Create or update an action (partial update)');


--
-- PostgreSQL database dump complete
--

