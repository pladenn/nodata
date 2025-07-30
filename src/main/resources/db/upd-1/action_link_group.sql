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

INSERT INTO public.action_link_group (id, link_id, "group", "order", variable) VALUES ('70c0b196-23b0-0755-4873-833e9eec40c3', 'ae27e88c-2df5-a77a-0792-2b87e8a3444d', 'extended_properties', 0, 'return');
