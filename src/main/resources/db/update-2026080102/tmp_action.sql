create table tmp_action
(
    id             uuid,
    code           varchar(50),
    connection_id  uuid,
    query          text,
    content        text,
    execution_type varchar(40),
    title          text,
    post_process   text,
    description    text,
    redirect       varchar,
    post_request   boolean,
    name           text
);

alter table tmp_action
    owner to postgres;

INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('b1f70839-ccf6-bb42-b618-311bd6d92361', '__system-update-action_parameters', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select * from action
where (id = :action_id::uuid or :action_id::uuid is null)
and (code = :code::varchar or :code::varchar is null)', null, 'SQL', '__system-update-action_parameters', null, null, null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('09a56638-c975-3b7b-2127-818ab535fc63', 'system-delete-action-link', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'delete from action_link where id = :id', null, 'SQL_DML', 'Delete link', null, 'Delete link', '{request-parameters._original_url}', false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('b0078e88-3425-ea62-606f-774f538bbcd9', 'system-delete-connection', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'DO $$declare
    connection_id uuid;
BEGIN
    select uuid_value::uuid into connection_id from sql_block_parameters where name = \'id\';

    delete from connection a where a.id = connection_id;

    delete from property_category where code = connection_id::varchar;

END $$', null, 'SQL_BLOCK', 'Delete connection', null, 'Delete connection', '{request-parameters._original_url}', false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('84f7269c-68a3-b278-f5fc-d807a5f4b1e8', 'view-any-object', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'--with v as (
--select
--    $$
--    {
--        "url": "http://localhost:{properties.system.localhost-port}/content/prod/lead-notifications/data?customer_lead_event_id=125410114",
--        "fields": [["data.__objekt.alert_message_sent_to","Sent to"],
--                   ["data.__objekt.alert_message_sent","Body","text"]]
--    }
--    $$::jsonb v
--),

with v as (select :view::jsonb v),

cert as (SELECT http_set_curlopt(\'CURLOPT_CAINFO\', \'C:\\Program Files\\PostgreSQL\\16\\ca-bundle.crt\') res),

content as (
select
    content::jsonb content
from http_get((select v.v ->> \'url\' from v)) resp
where exists(select * from cert)),

flds as (select
    (\'$.\' || (field ->> 0))::jsonpath path,
     coalesce ((field ->> 1), (field ->> 0)) label,
    coalesce((field ->> 2), \'string\') type
from jsonb_array_elements((select ((v.v -> \'fields\')#>>\'{}\')::jsonb from v)) field)

select
    label,

    case type
        when \'string\' then \'\'
        when \'html\' then \'<div>\'
        when \'text\' then \'<textarea cols="300" rows="35" readonly>\'
    end ||

    (jsonb_path_query((select content from content), path)#>>\'{}\') ||

    case type
        when \'string\' then \'\'
        when \'html\' then \'</div>\'
        when \'text\' then \'</textarea>\'
    end as value

from flds field', null, 'SQL', 'View', null, 'View', null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('1b4e4d25-adc9-c116-ba99-1463ad51cec6', 'system-create-parameter', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'INSERT INTO public.parameter (id, action_id, name, type, title, editable, "order", default_value)
VALUES (gen_random_uuid(),
        (select id from action where code = :action_code),
        :name, 
        case when :type is null or :type = \'\' then \'STRING\' else :type end,
        :title,
        coalesce(:editable, true),
        :order,
        :default_value
)', null, 'SQL_DML', 'Create parameter for the action "{PARAMETERS.action_title}"({PARAMETERS.action_code})', null, 'Create parameter for the action "{PARAMETERS.action_title}"({PARAMETERS.action_code})', '{request-parameters._original_url}', true, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('8096367c-cc1a-473e-a9d0-33041aa92d61', 'system-create-action', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'DO $$declare
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

    id = gen_random_uuid();

    INSERT INTO public.action
    VALUES (id,
            code,
            connection_id, query, content, execution_type,
            case when coalesce(trim(title), \'\') = \'\' then code else title end,
            post_process,
            description,
            redirect);

    insert into parameter(id,action_id,name,type,"order")
    with param as (
    select
        distinct
        lower(m[1]) as parameter_name,
        nullif(m[2], \'\') as parameter_type
    from (
             select regexp_matches(
                        query,
                        \':([a-zA-Z_]\\w*)(?:::(?![:])([a-zA-Z_]\\w*))?\',
                        \'g\'
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
            when \'INT\' then \'INTEGER\'
            when \'VARCHAR\' then \'STRING\'
            else upper(pt.parameter_type)
        end, \'_INSERTED\') parameter_type
    from param p
    left join param pt on p.parameter_name = pt.parameter_name and pt.parameter_type is not null) r
;

    insert into property_category values(gen_random_uuid(), id, \'action properties\');

END $$', null, 'SQL_BLOCK', 'Create action', null, 'Create action', '/content/system/system-actions?code={request-parameters.code}', false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('3d6fcc69-8b4f-c653-e23a-231452862ad7', 'system-create-action-link-mapping', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'insert into action_link_mapping
values (uuid_in(md5(random()::text || random()::text)::cstring),
        :action_link_id,
        :parameter_id,
        :mapping,
        :default_value)
ON CONFLICT ON CONSTRAINT unique_action_link_id_parameter_id
    DO update set mapping = EXCLUDED.mapping, default_value = :default_value', null, 'SQL_DML', 'Map link parameter', null, 'Map link parameter', '{request-parameters._original_url}', false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('b47c0f1f-5569-083f-ca7a-14d9a6736e4d', 'system-update-action-link', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'update action_link l set title = :title, 
via_parameters = :via_parameters::boolean,
category = :group::varchar,
"order" = :order,
variable = :variable,
mapping = :mapping
where id = :id', null, 'SQL_DML', 'Update link', null, 'Update link', '{request-parameters._original_url}', false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('ba7829af-09a9-e951-90fa-d04171739f46', 'system-delete-action', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'DO $$declare
    action_id uuid;
BEGIN
    select uuid_value::uuid into action_id from sql_block_parameters where name = \'id\';

    delete from action a where a.id = action_id;

    delete from property_category where code = action_id::varchar;

END $$', null, 'SQL_BLOCK', 'Delete action', null, 'Delete action', '{request-parameters._original_url}', false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('ff53d3e8-780f-43f1-ae7b-8a1d5037e142', 'system-update-dictionary', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'update properties
set value = :dictionary_name::varchar,
    key = :dictionary_code::varchar
where id = :dictionary_id::uuid', null, 'SQL_DML', 'Edit dictionary', null, 'Edit dictionary', '{request-parameters._original_url}', true, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('5d38171a-bd9b-4be9-9c38-5121ae471e69', 'system-create-dictionary', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'insert into properties
select
    gen_random_uuid(),
    (select id from properties where parent_id is null and key = \'dictionaries\'),
    :dictionary_code::varchar,
    :dictionary_name::varchar', null, 'SQL_DML', 'Create dictionary', null, 'Create dictionary', '{request-parameters._original_url}', true, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('812af221-0b4d-25c7-435b-3c4b8f3de0ae', 'system-column-delete', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'delete from "column" where id = :id', null, 'SQL_DML', 'Delete column', null, 'Delete column', '{request-parameters._original_url}', false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('eb109b97-5fa6-2712-e517-b10d07976ca8', 'system-parameter-update', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'update public.parameter set
name = :name,
type = case when coalesce(:type, \'\') = \'\' then \'STRING\' else :type end,
default_value = :default_value,
title = :title,
editable = coalesce(:editable, true),
"order" = :order
where id = :id', null, 'SQL_DML', 'Update parameter for the action "{action_name}"({action_code})', null, 'Update parameter for the action "{action_name}"({action_code})', '{request-parameters._original_url}', false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('4941d454-dc50-177f-e125-f5b031134fba', 'system-column-create-update', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'INSERT INTO "column" (id, action_id, name, path, "order")
VALUES (coalesce(:id, uuid_in(md5(random()::text || random()::text)::cstring)), :action_id, :name, :path, :order)
ON CONFLICT(id)
    DO UPDATE SET
      action_id = :action_id,
      name = :name,
      path = :path,
      "order" = :order', null, 'SQL_DML', '{create-update} column for the action "{action_title}"({action_code})', null, '{create-update} column for the action "{action_title}"({action_code})', '{request-parameters._original_url}', false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('27a15286-7c9e-fb12-b406-bc42ab29510c', 'system-create-property', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'INSERT INTO public.property (id, "group", property, value, category_id)
VALUES (
        uuid_in(md5(random()::text || random()::text)::cstring), 
        :group, 
        :property, 
        :value,
(select id from property_category
where (id = :category_id or :category_id::uuid is null )
and (code = :category_code or :category_code::varchar is null ))
)', null, 'SQL_DML', 'Create property', null, 'Create property', '{request-parameters._original_url}', false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('4d45abd8-7edc-5b5b-b08f-1a0c151a722a', 'system-delete-action-link-mapping', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'delete from action_link_mapping 
where id = :id or action_link_id = :action_link_id', null, 'SQL_DML', 'Unmap link parameter', null, 'Unmap link parameter', '{request-parameters._original_url}', false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('2e3ecaad-d6f5-3a72-c858-cf5df2758949', 'system-any-get-http-request-processed-with-sql', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', '{parameters.sql}', null, 'SQL', 'Any GET http request processed with SQL', null, null, null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('081f536b-6882-46b1-bbf2-1fd976e4a3f5', 'system-connections', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select * from connection con
where (con.id = :id or :id::uuid is null)
and (con.code like :code or :code::varchar is null)', null, 'SQL', 'Connections', null, 'Connections', null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('d89d6127-2e92-5ea3-d9b7-fb485b2250a0', 'system-set-dictionary-action', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'DO $$declare
    parameter_id uuid;
    dict_action_id uuid;
    new_link_id uuid;
    link_id uuid;
    param_name_column varchar;
    param_value_column varchar;
BEGIN
    select uuid_value::uuid into parameter_id from sql_block_parameters where name = \'parameter_id\';
    select uuid_value::uuid into dict_action_id from sql_block_parameters where name = \'action_id\';
    select string_value into param_name_column from sql_block_parameters where name = \'name_column\';
    select string_value into param_value_column from sql_block_parameters where name = \'value_column\';

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
        \'DICTIONARY\',
        null
    where dict_action_id is not null;

    update parameter set
                         dictionary_id = new_link_id,
                         name_column = param_name_column,
                         value_column = param_value_column
    where id = parameter_id and dict_action_id is not null;

    delete from action_link ll where ll.id in (
        select l.id from action_link l
        where l.id = link_id and l.category = \'DICTIONARY\'
          and not exists(select 1 from parameter p where p.dictionary_id = link_id));

END $$', null, 'SQL_BLOCK', 'Set dictionary  action', null, null, '{request-parameters._original_url}', false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('e6ea59cd-7b58-6a9f-9ddb-01f03de167f2', 'system-delete-property', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'delete from public.property where id = :id', null, 'SQL_DML', 'Delete property', null, 'Delete property', '{request-parameters._original_url}', false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('a45d744d-339c-08f2-6993-8841e28f78fd', 'insert_action', 'b16c7ed6-3beb-495c-b38e-337f9adec0a1', '/content/system/system-welcome/data', e'{
  "code" : "${code}",
  "query" : "${query}",
  "content" : "${content}",
  "http_method" : "${http_method}",
  "connectionId" : "d48b9a97-e13c-4961-9eff-d76f39abdffb"}', 'HTTP_GET', 'Just for example', null, 'Just for example', null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('a01761a0-988e-3f81-ccb9-6b92c2ccf1df', 'system-update-action', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'update action set 
    code = :code, 
    connection_id = :connection_id, 
    query = :query, 
    content = :content, 
    execution_type = :execution_type, 
    title = :title, 
    post_process = :post_process,
    redirect = :redirect,
    description = :description,
    post_request = :post_request
where id = :id', '''null''', 'SQL_DML', 'Update action', '''null''', 'Update action', '{request-parameters._original_url}', true, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('abdaa370-2c7b-dc78-65e1-5724bf54101a', 'system_extended_properties_for_propery_groups', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select
    case when pc.code = \'dictionaries\' then \'Dictionaries\'
         when pc.code = \'context\' then \'Environments\'
         else \'Property groups\'
    end "description",

    case when pc.code = \'dictionaries\' then \'Dictionary\'
         when pc.code = \'context\' then \'Environment\'
         else \'Group\'
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
limit 1', null, 'SQL', 'Extended propertis for the action "system-property-groups"', null, null, null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('23b6ee85-a2fc-4782-84d4-43ab5b4e9b34', 'system-add-dictionary-item', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'insert into properties
select
    gen_random_uuid(),
    :dictionary_id::uuid,
    :item_code::varchar,
    :item_label::varchar', null, 'SQL_DML', 'Add dictionary item', null, null, '{request-parameters._original_url}', true, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('b5786c6c-f631-41ed-996a-f7cf2c26bd34', 'system-delete-dictionary-item', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'with params as (
    select :code::varchar, :value::varchar
)

delete from properties
where id = :id::uuid', null, 'SQL_DML', 'Delete dictionary item', null, null, '{request-parameters._original_url}', false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('a21fdfc4-ffa7-41c0-9bf7-8c1355adbf32', 'system-delete-dictionary', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'with params as (
    select :code::varchar, :name::varchar
)

delete from properties
where parent_id = :id::uuid or id = :id::uuid
', null, 'SQL_DML', 'Delete dictionary', null, null, '{request-parameters._original_url}', true, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('fa35b5dd-6e29-6474-3f10-07b684c06a62', 'system-action-links', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select
    l.title,
    pa.id parent_action_id,
    pa.title parent_action_name,
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
order by l.parent_action_id, l.category, l."order"', null, 'SQL', 'Links', null, 'Links', null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('50c515f0-2224-52ab-b0df-36a7d2da7b49', '__system-parameters_extended_parameters', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'with act as (
select * from action
where id = :action_id::uuid)

select \'Parameters for the "\' || act.title || \'"(\' || act.code  || \') action\' title
from act
union all
select \'Action parameters\'
where not exists (select 1 from act)', null, 'SQL', '__system-parameters_extended_parameters', null, null, null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('1fab5dda-e8bf-48b4-9e97-ef3fc3bba8cf', '__system-dictionary-items_extended-parameters', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select p.value || \' (\' || p.key || \')\' dictionary_title from properties p
where id = :dictionary_id::uuid and :dictionary_id::uuid is not null
union all
select \'Dictionary items\' where :dictionary_id::uuid is null', null, 'SQL', '__system-dictionary-items_extended-parameters', null, null, null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('f1b8b927-efdf-43e0-a0d2-0c1d0243f6c8', 'system-update-dictionary-item', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'update properties
set key = :item_code::varchar,
    value = :item_label::varchar
where id = :item_id::uuid', null, 'SQL_DML', 'Update dictionary item', null, null, '{request-parameters._original_url}', true, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('2ec6e7bc-125d-19b8-4138-468bf5e6f994', 'system-sub-menu', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select $$
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
              "link": "/content/system/system-dictionaries",
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
    $$::jsonb menu', null, 'SQL', 'System submenu', null, 'System submenu', null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('6703218f-54a0-94b7-42b3-ed9e0e4c6685', 'system-set-dictionary', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'DO $$declare
    dictionary_code varchar;
    parameter_id uuid;
    new_link_id uuid;
    link_id uuid;
BEGIN
    select string_value into dictionary_code from sql_block_parameters where name = \'dictionary_code\';
    select uuid_value::uuid into parameter_id from sql_block_parameters where name = \'parameter_id\';

    select parameter.dictionary_id into link_id from parameter where id = parameter_id;

    update parameter set dictionary_id = null where id = parameter_id;

    new_link_id = gen_random_uuid();

    insert into action_link
    select
        new_link_id,
        (select action_id from parameter where id = parameter_id),
        (select id from action where code = \'system-dictionary-items\'),
        null,
        false,
        false,
        0,
        false,
        \'DICTIONARY\',
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
    where a.code = \'system-dictionary-items\'
      and p.name = \'dictionary_code\'
      and dictionary_code is not null;

    update parameter set dictionary_id = new_link_id,
    name_column = \'__object.value\',
    value_column = \'__object.key\' 
    where id = parameter_id and dictionary_code is not null;

    delete from action_link ll where ll.id in (
        select l.id from action_link l
        where l.id = link_id and l.category = \'DICTIONARY\'
          and not exists(select 1 from parameter p where p.dictionary_id = link_id));

END $$', null, 'SQL_BLOCK', 'Set dictionary', null, 'Set dictionary', '{request-parameters._original_url}', false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('37cac08c-9f8c-3bf5-803c-1303a1129555', 'system-delete-parameter', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'delete from parameter where id = :id', null, 'SQL_DML', 'Delete parameter', null, 'Delete parameter', '{request-parameters._original_url}', false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('570aeb3f-d237-2c20-154b-8d8415c87792', 'system-welcome', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select '''' as "-" where 1 = 2', null, 'SQL', 'Welcome! NoData for you.', null, 'Welcome! NoData for you.', null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('7c1333a8-4ac8-3221-fb6d-55bcef1d5e18', '__system-create-parameter_parameters', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select a.code action_code, a.title action_title
from action a
where id = :action_id::uuid', null, 'SQL', '__system-create-parameter_parameters', null, null, null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('4b1d6290-beb8-f38a-dc57-a8801cff31cb', 'system-property-groups', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'with base_path as
         (select value bp
          from property p
                   join property_category pc on p.category_id = pc.id and pc.code = \'context\'
          where "group" = \'system\' and property = \'system-base-path\'),

     values as (
         select distinct 
p."group", 

pc.code,

case when pc.code = \'context\' then \'Environment\'
when pc.code = \'dictionaries\' then \'Dictionary\'
else \'Group\' end group_title,

case when pc.code = \'dictionaries\' then \'Label\'
else \'Property+name\' end property_title,

case when pc.code = \'dictionaries\' then \'Dictionary items\' end description

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
order by 1', null, 'SQL', '{request-parameters.description}', null, '{request-parameters.description}', null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('691dce23-aae8-e745-2f44-e5afad8996f6', 'system-columns', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select col.id,
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
order by col.order', null, 'SQL', 'Columns for the action "{action_title}"({action_code})', null, 'Columns for the action "{action_title}"({action_code})', null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('8ddf46e0-1019-14f7-6680-80c505fefb5e', 'system-any-get-http-request', '6fdfb5ed-816e-77a1-3e13-d84bbb452939', null, null, 'HTTP_GET', 'Any GET http request', e'if (mainData.actionParameters.columns) {
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
', null, null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('8d9f7add-2f20-0e56-7d53-5ea78c2ea052', 'system-properties', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select p.id, p.category_id, p."group", 

case pc.code when \'context\' then p.property || \' - {properties.\' || case p."group" when \'system\' then \'system\' else \'environment\' end || \'.\' || p.property || \'}\'
else p.property end property, 

p.property property_name,

p.value, pc.code category_code from property p
join property_category pc on p.category_id = pc.id
where (p.category_id = :category_id or :category_id::uuid is null)
  and (p."group" like :group or :group::varchar is null)
  and (pc.code = :category_code or :category_code::varchar is null)
  and (category_id = (select id from property_category pc where pc.code = :category_code) or :category_code::varchar is null)
order by p."group", p.property, p.value', null, 'SQL', '{parameters.description}', null, '{parameters.description}', null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('924039ab-a63f-2ef3-2578-616eefe35c1b', 'system-environments-dictionary', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'with base_path as
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
order by 1', null, 'SQL', 'Environments', null, 'Environments', null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('9a327110-5e26-4d2a-8bc1-8eabeb2da397', 'system-actions', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select 
  a.title "Name",
  a.code "Action code",
  c.description "Connection",
  c.type "Connection type",
  a.execution_type "Method",
  to_jsonb(a) __objekt,
  to_jsonb(a) __object
from action a 
join connection c on c.id = a.connection_id
where (a.id = :id or :id::uuid is null)
and (connection_id = :connection_id or :connection_id::uuid is null)
and (:code::varchar IS NULL OR :code::varchar = \'\' OR a.code LIKE :code::varchar)
order by a.title', null, 'SQL', 'Actions', null, 'Actions', null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('a8cb378b-60e8-d5d3-d1f7-b41730000c1f', 'system-edit-property', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'update public.property set "group" = :group, property = :property, value = :value where id = :id', null, 'SQL_DML', 'Update property', null, 'Update property', '{request-parameters._original_url}', false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('d91e9ae3-1447-2e28-932a-2fb184305461', 'system-dictionary-items', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'with dict_id as (
select id from properties
where parent_id = (select id from properties where parent_id is null and key = \'dictionaries\')
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
and (key like :wildcard or :wildcard::varchar is null)', null, 'SQL', '{extended-parameters.dictionary_title}', null, '{extended-parameters.dictionary_title}', null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('3310ffca-f928-e81b-2a9f-b0bd59d89225', 'system-update-connection', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'update connection set
description = :description,
type = :type,
url = :url,
login = :login,
password = :password,
code = :code
where id = :id', null, 'SQL_DML', 'Update connection', null, 'Update connection', '{request-parameters._original_url}', false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('6265989e-67d2-68ef-9dee-12efe4a4d88d', 'system-action-link-mappings', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select
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
order by parent_action_name, child_action_name, p.order', null, 'SQL', 'Link mapping', null, 'Link mapping', null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('dfe67d96-5391-4534-aa8c-a706d985896c', 'system-parameters', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'select 
       p.title "Title",
       p.name "Name",
       p.type "Data type",
       p.editable "Editable",
       p.default_value "Default value",

       (select p.value
        from properties p
        where parent_id = (select id from properties where parent_id is null and key = \'dictionaries\')
        and key = alm.default_value) "Dictionary",

       da.title "Dictionary action",
       case when d.code is null then p.name_column end "Dictionary name column",
       case when d.code is null then p.value_column end "Dictionary value column",
       p.editable "Dictionary editable",
       p."order" "Order",

       jsonb_build_object(
               \'parameter\', to_jsonb(p),
               \'action\', to_jsonb(a),
               \'dictionary_action_id\', da.id, 
               \'dictionary_code\', alm.default_value
       ) __object
from parameter p
    join action a on a.id = p.action_id
    left join action_link al  on p.dictionary_id = al.id
    left join action da on da.id = al.child_action_id and da.code != \'system-dictionary-items\'
    left join action d on d.id = al.child_action_id and d.code = \'system-dictionary-items\'
    left join action_link_mapping alm on alm.action_link_id = al.id
        and d.code is not null and alm.parameter_id = \'5233dd2e-96dc-8673-a92d-e08b1f21325d\'
where (p.action_id = :action_id or :action_id::uuid is null)
  and (p.id = :id or :id::uuid is null)
order by p.action_id, p."order"', null, 'SQL', '{extended_parameters.title}', null, '{extended_parameters.title}', null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('dea2600c-e1e7-d8d5-f3ee-cb3239e1fd56', 'system-dictionaries', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'with base_path as
     (select value bp
      from property p
               join property_category pc on p.category_id = pc.id and pc.code = \'context\'
      where "group" = \'system\' and property = \'system-base-path\')

select
    \'<a href="\' || (select bp from base_path) || \'system-dictionary-items?dictionary_id=\' || p.id || \'">\'
        || p.value || \'</a>\' "Dictionary",
    to_jsonb(p) __object
from properties p
where parent_id = (select id from properties where parent_id is null and key = \'dictionaries\')', null, 'SQL', 'Dictionaries', null, null, null, false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('4141be2c-75e0-0384-c45f-a619e4fa131c', 'system-create-connection', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'DO $$declare
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

END $$', null, 'SQL_BLOCK', 'Create connection', null, 'Create connection', '{request-parameters._original_url}', false, null);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('9ac0f8b6-01a7-d1f4-2b23-b891bf39012f', 'system-create-action-link', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', e'insert into action_link values(
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
)', null, 'SQL_DML', 'Create link', null, 'Create link', '{request-parameters._original_url}', false, null);
