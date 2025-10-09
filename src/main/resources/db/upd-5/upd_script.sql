MERGE INTO connection t1
USING tmp_connection t2
ON t1.id = t2.id
WHEN NOT MATCHED THEN
    INSERT values (
t2.id,
t2.description,
t2.type,
t2.url,
t2.login,
t2.password,
t2.code
)
WHEN MATCHED THEN
    UPDATE SET
description = t2.description,
type = t2.type,
url = t2.url,
login = t2.login,
password = t2.password,
code = t2.code
;

MERGE INTO action t1 USING tmp_action t2 ON t1.id = t2.id WHEN NOT MATCHED THEN INSERT values (
t2.id,
t2.code,
t2.connection_id,
t2.query,
t2.content,
t2.execution_type,
t2.title,
t2.post_process,
t2.description,
t2.redirect
) WHEN MATCHED THEN UPDATE SET
id = t2.id,
code = t2.code,
connection_id = t2.connection_id,
query = t2.query,
content = t2.content,
execution_type = t2.execution_type,
title = t2.title,
post_process = t2.post_process,
description = t2.description,
redirect = t2.redirect
;

MERGE INTO action_link t1 USING tmp_action_link t2 ON t1.id = t2.id WHEN NOT MATCHED THEN INSERT values (
t2.id,
t2.parent_action_id,
t2.child_action_id,
t2.title,
t2.is_action_target,
t2.via_parameters,
t2."order",
t2.mounted_to_row,
t2.category,
t2.variable
) WHEN MATCHED THEN UPDATE SET
parent_action_id = t2.parent_action_id,
child_action_id = t2.child_action_id,
title = t2.title,
is_action_target = t2.is_action_target,
via_parameters = t2.via_parameters,
"order" = t2."order",
mounted_to_row = t2.mounted_to_row,
category = t2.category,
variable = t2.variable
;

MERGE INTO action_link_group t1 USING tmp_action_link_group t2 ON t1.id = t2.id WHEN NOT MATCHED THEN INSERT values (
t2.id,
t2.link_id,
t2."group",
t2."order",
t2.variable
) WHEN MATCHED THEN UPDATE SET
link_id = t2.link_id,
"group" = t2."group",
"order" = t2."order",
variable = t2.variable
;

MERGE INTO "column" t1 USING tmp_column t2 ON t1.id = t2.id WHEN NOT MATCHED THEN INSERT values (
t2.id,
t2.action_id,
t2.name,
t2.path,
t2."order"
) WHEN MATCHED THEN UPDATE SET
action_id = t2.action_id,
name = t2.name,
path = t2.path,
"order" = t2."order"
;

MERGE INTO parameter t1 USING tmp_parameter t2 ON t1.id = t2.id WHEN NOT MATCHED THEN INSERT values (
t2.id,
t2.action_id,
t2.name,
t2.type,
t2.default_value,
t2.title,
t2.editable,
t2."order",
t2.dictionary_id,
t2.name_column,
t2.value_column,
t2.editable_dictionary,
t2.dict_null_value
) WHEN MATCHED THEN UPDATE SET
action_id = t2.action_id,
name = t2.name,
type = t2.type,
default_value = t2.default_value,
title = t2.title,
editable = t2.editable,
"order" = t2."order",
dictionary_id = t2.dictionary_id,
name_column = t2.name_column,
value_column = t2.value_column,
editable_dictionary = t2.editable_dictionary,
dict_null_value = t2.dict_null_value
;

MERGE INTO action_link_mapping t1 USING tmp_action_link_mapping t2 ON t1.id = t2.id WHEN NOT MATCHED THEN INSERT values (
        t2.id,
        t2.action_link_id,
        t2.parameter_id,
        t2.mapping,
        t2.default_value
    ) WHEN MATCHED THEN UPDATE SET
    action_link_id = t2.action_link_id,
    parameter_id = t2.parameter_id,
    mapping = t2.mapping,
    default_value = t2.default_value
;

MERGE INTO property_category t1 USING tmp_property_category t2 ON t1.id = t2.id WHEN NOT MATCHED THEN INSERT values (
        t2.id,
        t2.code,
        t2.name
    ) WHEN MATCHED THEN UPDATE SET
    code = t2.code,
    name = t2.name
;

MERGE INTO property t1 USING tmp_property t2 ON t1.id = t2.id WHEN NOT MATCHED THEN INSERT values (
t2.id,
t2."group",
t2.property,
t2.value,
t2.category_id
) WHEN MATCHED THEN UPDATE SET
"group" = t2."group",
property = t2.property,
value = t2.value,
category_id = t2.category_id
;


--with tbl as (select 'action' tbl),
--with tbl as (select 'action_link' tbl),
--with tbl as (select 'action_link_group' tbl),
--with tbl as (select 'action_link_mapping' tbl),
--with tbl as (select 'column' tbl),
--with tbl as (select 'connection' tbl),
--with tbl as (select 'parameter' tbl),
--with tbl as (select 'property' tbl),
-- with tbl as (select 'property_category' tbl),
--
-- ins as (
-- select 1 ord, 'MERGE INTO '|| tt.tbl ||' t1 USING tmp_'|| tt.tbl ||' t2 ON t1.id = t2.id WHEN NOT MATCHED THEN INSERT values (' qry
-- from tbl tt),
--
-- ins_cols as (
--     SELECT
--     2 ord, 't2.'|| case when column_name = 'order' then '"order"' else column_name end ||',' "insert"
--     FROM information_schema.columns
--     WHERE table_schema = 'public'
--     AND table_name = (select tt.tbl from tbl tt)
--     ),
--
-- upd as (select 3 ord, ') WHEN MATCHED THEN UPDATE SET ' from tbl tt),
--
--  upd_cols as (
--      SELECT
--          4 ord, case when column_name = 'order' then '"order"' else column_name end ||' = t2.'
--                     || case when column_name = 'order' then '"order"' else column_name end ||',' "update"
--      FROM information_schema.columns
--      WHERE table_schema = 'public'
--        AND table_name = (select tt.tbl from tbl tt)
--      and column_name != 'id'
--  ),
--
-- sel as (select *
--         from ins
--         union all
--         select *
--         from ins_cols
--         union all
--         select *
--         from upd
--         union all
--         select *
--         from upd_cols)
--
-- select qry from sel order by ord
-- ;

drop table sys_obj;
create table sys_obj as select * from tmp_sys_obj;

delete from property where id in (select id from tmp_del_sys_obj);
delete from property_category where id in (select id from tmp_del_sys_obj);
delete from action_link_group where id in (select id from tmp_del_sys_obj);
delete from action_link_mapping where id in (select id from tmp_del_sys_obj);
delete from parameter where id in (select id from tmp_del_sys_obj);
delete from action_link where id in (select id from tmp_del_sys_obj);
delete from "column" where id in (select id from tmp_del_sys_obj);
delete from action where id in (select id from tmp_del_sys_obj);
delete from connection where id in (select id from tmp_del_sys_obj);

drop table tmp_action;
drop table tmp_action_link;
drop table tmp_action_link_group;
drop table tmp_action_link_mapping;
drop table tmp_column;
drop table tmp_connection;
drop table tmp_parameter;
drop table tmp_property;
drop table tmp_property_category;
drop table tmp_del_sys_obj;
drop table tmp_sys_obj;

