create table tmp_del_sys_obj
(
    id  uuid,
    tbl text
);

alter table tmp_del_sys_obj
    owner to postgres;

