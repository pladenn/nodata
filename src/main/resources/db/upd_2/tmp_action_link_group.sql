create table tmp_action_link_group
(
    id       uuid,
    link_id  uuid,
    "group"  varchar,
    "order"  integer,
    variable varchar
);

alter table tmp_action_link_group
    owner to postgres;

