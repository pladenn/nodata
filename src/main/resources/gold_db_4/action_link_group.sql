create table action_link_group
(
    id       uuid    not null
        constraint action_link_group_pk
            primary key,
    link_id  uuid    not null
        constraint "action_link_group-action_link_fk"
            references action_link
            on delete cascade,
    "group"  varchar not null,
    "order"  integer,
    variable varchar
);

alter table action_link_group
    owner to postgres;

