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
       c.active,
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
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('f4261fc2-cfff-456d-bfc0-c886a3ef3c70', 'menu-move', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with
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
', NULL, 'SQL_DML', 'Menu: move item', NULL, 'Move the item at path to to_path; it ends up AT that position. Refuses to move an item into its own subtree.', '/content/system/menu-tree', true, 'Menu: move item');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('f52aef46-d5be-4653-88b4-c74e23c9004e', 'menu-tree', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with recursive walk as (
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
', NULL, 'SQL', 'Menu tree', NULL, 'Numbered pseudographic view of a nodata interface menu, read straight from the *-sub-menu-json document. Each row carries its path (e.g. 2-1-3) for use with menu-put / menu-remove / menu-rename / menu-move.', NULL, false, 'Menu tree');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('8226da50-68c5-4b39-98c0-d87a5870371e', 'menu-remove', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with
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
', NULL, 'SQL_DML', 'Menu: remove item', NULL, 'Remove the menu item at the given path (with its whole subtree).', '/content/system/menu-tree', true, 'Menu: remove item');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('002d3444-b227-47f7-a059-adee55f1f78d', 'toggle-connection-active', '280508e7-9ad9-0607-bf04-eee56d322ab7', '-- Flip the "active" refresh flag on one "Database structure" catalog connection (service login).
--
-- :id = connections.id (the catalog row''s own PK; see catalog-connections'' __object.id).
-- Toggling active does not touch privileges/DDL already recorded for this login -- it only
-- controls whether the next manual Tables.java catalog refresh processes this login.
-- An unknown id updates 0 rows, which SQL_DML reports as "Nothing is modified" (HTTP 500).

UPDATE connections
SET active = NOT active
WHERE id = :id::integer
', NULL, 'SQL_DML', NULL, NULL, 'Flip the active refresh flag on a Database-structure catalog connection (service login), by its connections.id. Row action mounted on catalog-connections.', '{request-parameters._original_url}', true, 'Toggle connection active');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('325e7262-43f7-4a57-b053-d17cb6852977', 'storage-entries', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select
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
', NULL, false, 'Storage entries');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('dec16dae-0b50-48f0-9252-8d130fc93a01', 'storage-entry-create', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'insert into properties (id, parent_id, key, value)
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
', NULL, false, 'Storage entry create');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('1ca07cd8-9aa0-47f1-a7be-5747fd4a64df', 'storage-entry-delete', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'delete from properties
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
', NULL, false, 'Storage entry delete');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('06d9ecd0-41b1-4e99-96b2-a6e13cf513d2', 'storage-root-init', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'insert into properties (id, parent_id, key, value)
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
', NULL, false, 'Storage root init (one-time bootstrap)');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('f777a55e-e019-44b3-bfdc-2df687195867', 'menu-rename', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with
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
', NULL, 'SQL_DML', 'Menu: rename item', NULL, 'Set the name of the menu item at the given path. Blank name drops the name key, so the renderer falls back to the action title.', '/content/system/menu-tree', true, 'Menu: rename item');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('2ec6e7bc-125d-19b8-4138-468bf5e6f994', 'system-sub-menu', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with recursive
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
', NULL, 'SQL', 'System submenu', NULL, 'System submenu', NULL, false, 'System submenu');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('ed2ec51a-53c6-4b6d-b643-ca8dd9ccfe49', 'menu-put', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'with
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
', NULL, 'SQL_DML', 'Menu: put action', NULL, 'Insert an action into the menu at a 1-based path (e.g. 2-1-3). Blank name => the renderer falls back to the action title. Errors if the action code or the parent path does not exist.', '/content/system/menu-tree', true, 'Menu: put action');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('9ae4808e-d6bd-47ed-a4b4-b76e40f46884', 'storage-entry-update', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'update properties
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
', NULL, false, 'Storage entry update');


--
-- PostgreSQL database dump complete
--

