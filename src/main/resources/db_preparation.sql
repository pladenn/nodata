create table tmp_action as select * from action;
create table tmp_action_link as select * from action_link;
create table tmp_action_link_group as select * from action_link_group;
create table tmp_action_link_mapping as select * from action_link_mapping;
create table tmp_column as select * from "column";
create table tmp_connection as select * from connection;
create table tmp_parameter as select * from parameter;
create table tmp_property as select * from property;
create table tmp_property_category as select * from property_category;
create table tmp_sys_obj as select * from sys_obj;

drop table if exists sys_obj;

create table sys_obj as
select id, 'action' tbl from action
union all select id, 'action_link' tbl from action_link
union all select id, 'action_link_group' tbl from action_link_group
union all select id, 'action_link_mapping' tbl from action_link_mapping
union all select id, 'column' tbl from "column"
union all select id, 'connection' tbl from connection
union all select id, 'parameter' tbl from parameter
union all select id, 'property' tbl from property
union all select id, 'property_category' tbl from property_category;

create table tmp_del_sys_obj as
select * from tmp_sys_obj
where id not in (select id from sys_obj);

drop table tmp_sys_obj;