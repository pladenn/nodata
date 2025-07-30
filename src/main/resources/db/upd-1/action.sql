create table action
(
    id             uuid        not null
        primary key,
    code           varchar(50) not null
        unique,
    connection_id  uuid        not null
        constraint action_connection_fk
            references connection
            on delete set null,
    query          text        not null,
    content        text,
    execution_type varchar(10),
    title          text,
    post_process   text,
    description    text,
    redirect       varchar
);

alter table action
    owner to postgres;

INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('09a56638-c975-3b7b-2127-818ab535fc63', 'system-delete-action-link', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'delete from action_link where id = :id', null, 'SQL_DML', 'Delete link', null, 'Delete link', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('812af221-0b4d-25c7-435b-3c4b8f3de0ae', 'system-column-delete', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'delete from "column" where id = :id', null, 'SQL_DML', 'Delete column', null, 'Delete column', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('eb109b97-5fa6-2712-e517-b10d07976ca8', 'system-parameter-update', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'update public.parameter set
name = :name,
type = case when coalesce(:type, \'\') = \'\' then \'STRING\' else :type end,
default_value = :default_value,
title = :title,
editable = coalesce(:editable, true),
"order" = :order
where id = :id', null, 'SQL_DML', 'Update parameter', null, 'Update parameter for the action "{action_name}"({action_code})', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('081f536b-6882-46b1-bbf2-1fd976e4a3f5', 'system-connections', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select * from connection con
where (con.id = :id or :id::uuid is null)
and (con.code like :code or :code::varchar is null)', null, 'SQL_DQL', 'Connections', null, 'Connections', null);
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('4941d454-dc50-177f-e125-f5b031134fba', 'system-column-create-update', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'INSERT INTO "column" (id, action_id, name, path, "order")
VALUES (coalesce(:id, uuid_in(md5(random()::text || random()::text)::cstring)), :action_id, :name, :path, :order)
ON CONFLICT(id)
    DO UPDATE SET
      action_id = :action_id,
      name = :name,
      path = :path,
      "order" = :order', null, 'SQL_DML', 'Create/update column ', null, '{create-update} column for the action "{action_title}"({action_code})', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('27a15286-7c9e-fb12-b406-bc42ab29510c', 'system-create-property', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'INSERT INTO public.property (id, "group", property, value, category_id)
VALUES (
        uuid_in(md5(random()::text || random()::text)::cstring), 
        :group, 
        :property, 
        :value,
(select id from property_category
where (id = :category_id or :category_id::uuid is null )
and (code = :category_code or :category_code::varchar is null ))
)', null, 'SQL_DML', 'Create property', null, 'Create property', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('b0078e88-3425-ea62-606f-774f538bbcd9', 'system-delete-connection', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'DO $$declare
    connection_id uuid;
BEGIN
    select uuid_value::uuid into connection_id from sql_block_parameters where name = \'id\';

    delete from connection a where a.id = connection_id;

    delete from property_category where code = connection_id::varchar;

END $$', null, 'SQL_BLOCK', 'Delete connection', null, 'Delete connection', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('3d6fcc69-8b4f-c653-e23a-231452862ad7', 'system-create-action-link-mapping', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'insert into action_link_mapping
values (uuid_in(md5(random()::text || random()::text)::cstring),
        :action_link_id,
        :parameter_id,
        :mapping,
        :default_value)
ON CONFLICT ON CONSTRAINT unique_action_link_id_parameter_id
    DO update set mapping = EXCLUDED.mapping, default_value = :default_value', null, 'SQL_DML', 'Map link parameter', null, 'Map link parameter', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('4d45abd8-7edc-5b5b-b08f-1a0c151a722a', 'system-delete-action-link-mapping', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'delete from action_link_mapping 
where id = :id or action_link_id = :action_link_id', null, 'SQL_DML', 'Unmap link parameter', null, 'Unmap link parameter', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('a45d744d-339c-08f2-6993-8841e28f78fd', 'insert_action', 'b16c7ed6-3beb-495c-b38e-337f9adec0a1', '/content/system/system-welcome', e'{
  "code" : "${code}",
  "query" : "${query}",
  "content" : "${content}",
  "http_method" : "${http_method}",
  "connectionId" : "d48b9a97-e13c-4961-9eff-d76f39abdffb"}', 'HTTP_GET', 'Just for example', null, 'Just for example', null);
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('a01761a0-988e-3f81-ccb9-6b92c2ccf1df', 'system-update-action', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'update action set code = :code, connection_id = :connection_id, query = :query, content = :content, execution_type = :execution_type, title = :title, post_process = :post_process,
redirect = :redirect,
description = :description
where id = :id', null, 'SQL_DML', 'Update action', null, 'Update action', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('e6ea59cd-7b58-6a9f-9ddb-01f03de167f2', 'system-delete-property', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'delete from public.property where id = :id', null, 'SQL_DML', 'Delete property', null, 'Delete property', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('37cac08c-9f8c-3bf5-803c-1303a1129555', 'system-delete-parameter', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'delete from parameter where id = :id', null, 'SQL_DML', 'Delete parameter', null, 'Delete parameter', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('3310ffca-f928-e81b-2a9f-b0bd59d89225', 'system-update-connection', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'update connection set
description = :description,
type = :type,
url = :url,
login = :login,
password = :password,
code = :code
where id = :id', null, 'SQL_DML', 'Update connection', null, 'Update connection', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('b47c0f1f-5569-083f-ca7a-14d9a6736e4d', 'system-update-action-link', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'update action_link l set title = :title, 
is_action_target = :is_action_target::boolean, 
via_parameters = :via_parameters::boolean,
"order" = :order
where id = :id', null, 'SQL_DML', 'Update link', null, 'Update link', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('691dce23-aae8-e745-2f44-e5afad8996f6', 'system-columns', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select col.id,
       col.name,
       col.path,
       col.order,
       act.id action_id,
       coalesce(act.title, code) action_title,
       act.code action_code
from "column" col
         join action act on act.id = col.action_id
where (col.action_id = :action_id or :action_id::uuid is null)
  and (coalesce(:action_code::varchar, \'\') = \'\' OR act.code LIKE :action_code::varchar)
order by col.order', null, 'SQL_DQL', 'Columns', null, 'Columns for the action "{action_title}"({action_code})', null);
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('4b1d6290-beb8-f38a-dc57-a8801cff31cb', 'system-property-groups', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'with base_path as
         (select value bp
          from property p
                   join property_category pc on p.category_id = pc.id and pc.code = \'context\'
          where "group" = \'system\' and property = \'system-base-path\'),

     values as (
         select distinct p."group", pc.code,
                         case when pc.code = \'context\' then \'Envirinment\'
                              when pc.code = \'dictionaries\' then \'Dictionary\'
                              else \'Group\' end group_title,
                         case when pc.code = \'dictionaries\' then \'Label\'
                              else \'Property+name\' end property_title,
                         case when pc.code = \'dictionaries\' then \'Items\' end description
         from property p
                  join property_category pc on p.category_id = pc.id
         where (pc.id = :category_id or :category_id::uuid is null)
           and (pc.code = :category_code or :category_code::varchar is null))

select p."group" value,
       \'<a href="\' || (select bp from base_path) || \'system-properties?category_code=\'|| p.code ||
       \'&group=\'|| p."group" ||
       \'&title_for_group_column=\'|| group_title ||
       \'&title_for_property_column=\'|| property_title ||
       case when p.description is not null then \'&description=\'|| p.description
            else \'\' end ||
       \'">\'|| p."group" ||\'</a>\' link
from values p
order by 1', null, 'SQL_DQL', 'System property groups', null, '{description}', null);
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('95b9eda4-33d1-be18-c667-123b227ee2a1', 'system-set-available-values-view', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'insert into dictionary(
        id,
        parameter_id,
        action_id,
        name_column,
        value_column,
        editable
)
values (uuid_in(md5(random()::text || random()::text)::cstring),
        :parameter_id::uuid,
        :action_id::uuid,
        :name_column,
        :value_column,
        :editable)
ON CONFLICT ON CONSTRAINT dictionary_parameter_uk
    DO update set action_id = :action_id,
                  name_column = :name_column,
                  value_column = :value_column,
                  editable = :editable', null, 'SQL_DML', 'Set dictionary', null, 'Set dictionary', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('1b4e4d25-adc9-c116-ba99-1463ad51cec6', 'system-create-parameter', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'INSERT INTO public.parameter (id, action_id, name, type, title, editable, "order", default_value)
VALUES (uuid_in(md5(random()::text || random()::text)::cstring),
        (select id from action where code = :action_code),
        :name, 
        case when :type is null or :type = \'\' then \'STRING\' else :type end,
        :title,
        coalesce(:editable, true),
        :order,
        :default_value
)', null, 'SQL_DML', 'Create parameter', null, 'Create parameter for the action "{action_title}"({action_code})', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('e587b6a0-ef4c-2f7b-4a69-5c8fc19f22f2', 'custom-sub-menu', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'with items as (select null name, null link, null items where 1 = 2),

     main as (select json_agg(json_build_object(\'name\', m.name, \'link\', m.link, \'items\', m.items)) itms
              from (select * from items) m)

select json_agg(json_build_object(
        \'name\', \'Custom\',
        \'items\', m.itms))
from main m', null, 'SQL_DQL', 'Custom submenu', null, 'Custom submenu', null);
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('6e52b5a1-4b58-8992-2e51-1ec289b2dd83', 'system-remove-dictionary', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'delete from dictionary where parameter_id = :parameter_id::uuid', null, 'SQL_DML', 'Remove dictionary', null, 'Remove dictionary', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('924039ab-a63f-2ef3-2578-616eefe35c1b', 'system-environments-dictionary', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'with base_path as
         (select value bp
          from property p
          join property_category pc on p.category_id = pc.id and pc.code = \'context\'
          where "group" = \'system\' and property = \'system-base-path\'),

     values as (
         select \'\' "value"
         union all
         select distinct "group"
         from property p
         join property_category pc on p.category_id = pc.id and pc.category = \'context\')

select p."value",
       case when p."value" != \'\'
                then \'<a href="\' || (select bp from base_path) || \'system-properties?environment=\'|| p."value" ||\'">\'|| p."value" ||\'</a>\'
            else p."value" end link
from values p
where (coalesce(:environment::varchar, \'\') = \'\' or p."value" like :environment::varchar)
  and (coalesce(:empty_available, true) or p."value" != \'\')
order by 1', null, 'SQL_DQL', 'Environments', null, 'Environments', null);
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('9a327110-5e26-4d2a-8bc1-8eabeb2da397', 'system-actions', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select 
  a.title,
  a.code,
  a.description,
  c.description connection_description,
  c.type connection_type,
  a.id,
  a.connection_id,  
  a.query,
  a.content,
  a.execution_type,
  a.post_process,
  a.redirect
from action a 
join connection c on c.id = a.connection_id
where (a.id = :id or :id::uuid is null)
and (connection_id = :connection_id or :connection_id::uuid is null)
and (:code::varchar IS NULL OR :code::varchar = \'\' OR a.code LIKE :code::varchar)
order by a.title', null, 'SQL_DQL', 'Actions', null, 'Actions', null);
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('6265989e-67d2-68ef-9dee-12efe4a4d88d', 'system-action-link-mappings', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select
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
order by parent_action_name, child_action_name, p.order', null, 'SQL_DQL', 'Link mapping', null, 'Link mapping', null);
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('76b88064-d9ca-28f6-62c5-7f4bfe16fc40', 'system-dictionary-parameter-mapping', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select 
       p.title parameter_title,
       p.name parmeter_name,

       a.title action_name,
       a.code action_code,
      
       d.title dictionary_name,
       d.code dictionary_code,
       dict.id dictionary_id,

       dp.title dictionary_parameter_title,
       dp.name dictionary_parameter_name,

       ap.name action_parameter_name,
       ap.title action_parameter_title,
       ap.id action_parameter_id,

       dm.default_value,
       dm.id
from parameter p
         join dictionary dict on dict.parameter_id = p.id
         join parameter dp on dp.action_id = dict.action_id         
         join action d on d.id = dict.action_id
         join action a on p.action_id = a.id
         left join dictionary_mapping dm on dm.dictionary_id = dict.id and dm.dictionary_parameter_id = dp.id
         left join parameter ap on ap.id = dm.action_parameter_id
where (:parameter_id::uuid is null or p.id = :parameter_id::uuid)
order by dp.name', null, 'SQL_DQL', 'Dictionary parameters mapping', null, 'Dictionary parameters mapping', null);
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('ba7829af-09a9-e951-90fa-d04171739f46', 'system-delete-action', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'DO $$declare
    action_id uuid;
BEGIN
    select uuid_value::uuid into action_id from sql_block_parameters where name = \'id\';

    delete from action a where a.id = action_id;

    delete from property_category where code = action_id::varchar;

END $$', null, 'SQL_BLOCK', 'Delete action', null, 'Delete action', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('8d9f7add-2f20-0e56-7d53-5ea78c2ea052', 'system-properties', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select p.id, p.category_id, p."group", p.property, p.value, pc.code category_code from property p
join property_category pc on p.category_id = pc.id
where (p.category_id = :category_id or :category_id::uuid is null)
  and (p."group" like :group or :group::varchar is null)
  and (pc.code = :category_code or :category_code::varchar is null)
  and (category_id = (select id from property_category pc where pc.code = :category_code) or :category_code::varchar is null)
order by p."group", p.property, p.value', null, 'SQL_DQL', 'Properties', null, '{description}', null);
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('5dfc355d-bd88-c1c1-50e8-d67d5ad682d1', 'system-dictionary-parameter-unmap', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'delete
from dictionary_mapping
where id = :id', null, 'SQL_DML', 'Unmap dictionary parameter', null, 'Unmap dictionary parameter', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('9ac0f8b6-01a7-d1f4-2b23-b891bf39012f', 'system-create-action-link', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'insert into action_link values(
uuid_in(md5(random()::text || random()::text)::cstring),
case when :global = true then null else :parent_action_id end,
:child_action_id,
:title,
:is_action_target::boolean,
:via_parameters::boolean,
:order
)', null, 'SQL_DML', 'Create link', null, 'Create link', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('a8cb378b-60e8-d5d3-d1f7-b41730000c1f', 'system-edit-property', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'update public.property set "group" = :group, property = :property, value = :value where id = :id', null, 'SQL_DML', 'Update property', null, 'Update property', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('570aeb3f-d237-2c20-154b-8d8415c87792', 'system-welcome', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select '''' as "-" where 1 = 2', null, 'SQL_DQL', 'Welcome! NoData for you.', null, 'Welcome! NoData for you.', null);
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('a9b34d16-9fe4-0d3d-07da-694b9f67cd4d', 'system-dictionary-parameter-map', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'insert into dictionary_mapping
values (
        uuid_in(md5(random()::text || random()::text)::cstring),
        :action_parameter_id,
        (select p.id
         from action a
                  join parameter p on a.id = p.action_id
         where code = :dictionary_code
           and p.name = :dictionary_parameter_name),
        :default_value::varchar,
        :dictionary_id
)
ON CONFLICT ON CONSTRAINT dictionary_mapping_u_dictionary_id_dictionary_parameter_id
    DO update set action_parameter_id = EXCLUDED.action_parameter_id,
                  default_value       = EXCLUDED.default_value', null, 'SQL_DML', 'Map dictionary parameter', null, 'Map dictionary parameter', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('8096367c-cc1a-473e-a9d0-33041aa92d61', 'system-create-action', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'DO $$declare
    id uuid;
    title varchar;
    code varchar;
    connection_id uuid;
    query varchar;
    content varchar;
    execution_type varchar;
    post_process varchar;
    description varchar;
    redirect varchar;
BEGIN
    select string_value into title from sql_block_parameters where name = \'title\';
    select string_value into code from sql_block_parameters where name = \'code\';
    select uuid_value::uuid into connection_id from sql_block_parameters where name = \'connection_id\';
    select string_value into query from sql_block_parameters where name = \'query\';
    select string_value into content from sql_block_parameters where name = \'content\';
    select string_value into execution_type from sql_block_parameters where name = \'execution_type\';
    select string_value into post_process from sql_block_parameters where name = \'post_process\';

    id = uuid_in(md5(random()::text || random()::text)::cstring);

    INSERT INTO public.action
    VALUES (id,
            code,
            connection_id, query, content, execution_type,
            case when coalesce(trim(title), \'\') = \'\' then code else title end,
            post_process,
            description,
            redirect);


    insert into parameter
    with names as (select distinct replace((regexp_matches[1]), \':\', \'\') name
                   from regexp_matches(
                           replace(query, \'::\', \' \'),
                           \':[\\w]+\', \'g\'))

    select
        uuid_in(md5(random()::text || random()::text)::cstring) id,
        id action_id,
        names.name,
        \'_INSERTED\' type,
        null default_value
    from names;

    insert into property_category values(uuid_in(md5(random()::text || random()::text)::cstring), id, \'action properties\');

END $$', null, 'SQL_BLOCK', 'Create action', null, 'Create action', '/content/system/system-actions?code={code}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('2ec6e7bc-125d-19b8-4138-468bf5e6f994', 'system-sub-menu', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select $$
[
    {
      "name": "System",
      "link": null,
      "items": [
        {
          "name": "Actions",
          "link": null,
          "items": [
            {
              "name": "All",
              "link": "/content/system/system-actions",
              "items": null
            },
            {
              "name": "System actions",
              "link": "/content/system/system-actions?connection_id=d48b9a97-e13c-4961-9eff-d76f39abdffb",
              "items": null
            }
          ]
        },
        {
          "name": "Connections",
          "link": null,
          "items": [
            {
              "name": "All",
              "link": "/content/system/system-connections",
              "items": null
            },
            {
              "name": "System connections",
              "link": "/content/system/system-connections?code=system%25",
              "items": null
            }
          ]
        },
        {
          "name": "Properties",
          "link": null,
          "items": [
            {
              "name": "Environments",
              "link": "/content/system/system-property-groups?category_code=context&title_for_group_column=Environment&description=Environments",
              "items": null
            },
            {
              "name": "All properties",
              "link": "/content/system/system-properties?category_code=context&title_for_group_column=Environment&title_for_property_column=Property+name",
              "items": null
            },
            {
              "name": "Dictionaries",
              "link": "/content/system/system-property-groups?description=Dictionaries&category_code=dictionaries&title_for_group_column=Dictionary",
              "items": null
            }
          ]
        },
        {
          "name": "Menu",
          "link": "/content/system/system-actions?id=&code=%25-sub-menu&connection_id=&system.action-code=system-actions",
          "items": null
        }
      ]
    }
  ]
    $$::jsonb menu', null, 'SQL_DQL', 'System submenu', null, 'System submenu', null);
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('4141be2c-75e0-0384-c45f-a619e4fa131c', 'system-create-connection', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'DO $$declare
    id uuid;
    code varchar;
    type varchar;
    url varchar;
    login varchar;
    password varchar;
    description varchar;
BEGIN
    select string_value into type from sql_block_parameters where name = \'type\';
    select string_value into code from sql_block_parameters where name = \'code\';
    select string_value into url from sql_block_parameters where name = \'url\';
    select string_value into login from sql_block_parameters where name = \'login\';
    select string_value into password from sql_block_parameters where name = \'password\';
    select string_value into description from sql_block_parameters where name = \'description\';

    id = uuid_in(md5(random()::text || random()::text)::cstring);

    INSERT INTO public.connection (id, description, type, url, login, password, code) VALUES (id, description, type, url, login, password, code);

    insert into property_category values(uuid_in(md5(random()::text || random()::text)::cstring), id, \'connection properties\');

END $$', null, 'SQL_BLOCK', 'Create connection', null, 'Create connection', '{_original_url}');
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('fa35b5dd-6e29-6474-3f10-07b684c06a62', 'system-action-links', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'with action_mounted as (select l.id,
    \'mounted to action\' link_group,
    l."order"
 from action_link l
 where (parent_action_id = :parent_action_id or :parent_action_id::uuid is null or
        parent_action_id is null)
   and (child_action_id = :child_action_id or :child_action_id::uuid is null)
   and (l.id = :id or :id::uuid is null)
   and l.is_action_target),

row_mounted as (select l.id,
   \'mounted to row\' link_group,
    l."order"
from action_link l
where (parent_action_id = :parent_action_id or :parent_action_id::uuid is null or parent_action_id is null)
  and (child_action_id = :child_action_id or :child_action_id::uuid is null)
  and (l.id = :id or :id::uuid is null)
  and l.mounted_to_row),

dictionaries as (select l.id,
       case when p.action_id != coalesce(l.parent_action_id, p.action_id) then \'ERROR\'
            else \'\' end || \'dictionary\' link_group,
       null::integer "order"
from action_link l
    join parameter p on p.dictionary_id = l.id
where (p.action_id = :parent_action_id or :parent_action_id::uuid is null)
  and (l.child_action_id = :child_action_id or :child_action_id::uuid is null)
  and (l.id = :id or :id::uuid is null)),

groups as (select l.id,
       lg."group" link_group,
       lg."order"
from action_link l
         join action_link_group lg on l.id = lg.link_id
where (l.parent_action_id = :parent_action_id or :parent_action_id::uuid is null or l.parent_action_id is null)
  and (l.child_action_id = :child_action_id or :child_action_id::uuid is null)
  and (l.id = :id or :id::uuid is null)),

used_links as (
select * from action_mounted
union all select * from row_mounted
union all select * from dictionaries
union all select * from groups),

all_links as (select l.id,
    coalesce(us.link_group, \'unused\') "group",
    coalesce(us."order", l."order") "order"
from action_link l
left join used_links us on l.id = us.id
where (l.parent_action_id = :parent_action_id or :parent_action_id::uuid is null or l.parent_action_id is null)
  and (l.child_action_id = :child_action_id or :child_action_id::uuid is null)
  and (l.id = :id or :id::uuid is null))

select
    l.title,
    pa.id parent_action_id,
    pa.title parent_action_name,
    pa.code parent_action_code,
    ca.id child_action_id,
    ca.title child_action_name,
    ca.code child_action_code,
    al."group",
    l.via_parameters,
    l.id,
    al."order"
from action_link l
         join all_links al on al.id = l.id
         join action ca on ca.id = l.child_action_id
         join action pa on l.parent_action_id = pa.id
order by l.parent_action_id, al."group", "order"', null, 'SQL_DQL', 'Links', null, 'Links', null);
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('dfe67d96-5391-4534-aa8c-a706d985896c', 'system-parameters', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select p.id,
       p.name,
       p.type,
       p.title,
       p.action_id,
       p.default_value,
       p.editable,
       p."order",
       a.code action_code,
       coalesce(a.title, a.code) action_title,
       da.code dictionary_code,
       p.dictionary_id dictionary_action_id,
       p.name_column,
       p.value_column,
       p.editable dictionary_editable,
       da.title dictionary_name
from parameter p
         join action a on a.id = p.action_id
         left join action_link al  on p.dictionary_id = al.id
         left join action da on da.id = al.child_action_id
where (p.action_id = :action_id or :action_id::uuid is null)
  and (p.id = :id or :id::uuid is null)
  and (coalesce(:action_code::varchar, \'\') = \'\' OR a.code LIKE :action_code::varchar)
order by p.action_id, p."order"', null, 'SQL_DQL', 'Parameters', null, 'Parameters for the action "{action_title}"({action_code})', null);
INSERT INTO public.action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect) VALUES ('abdaa370-2c7b-dc78-65e1-5724bf54101a', 'system_extended_properties_for_propery_groups', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select
    case when pc.code = \'dictionaries\' then \'Dictionaries\'
         when pc.code = \'context\' then \'Environments\'
         else \'Property groups\'
    end "description",

    case when pc.code = \'dictionaries\' then \'Dictionary\'
         when pc.code = \'context\' then \'Environment\'
         else \'Group\'
        end column_name
from property_category pc
where (pc.code = :category_code or :category_code::varchar is null)
and (pc.id = :category_id or :category_id::uuid is null)
limit 1', null, 'SQL_DQL', 'Extended propertis for the action "system-property-groups"', null, null, null);
