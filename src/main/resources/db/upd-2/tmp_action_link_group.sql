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

INSERT INTO public.tmp_action_link_group (id, link_id, "group", "order", variable) VALUES ('70c0b196-23b0-0755-4873-833e9eec40c3', 'ae27e88c-2df5-a77a-0792-2b87e8a3444d', 'extended_properties', 0, 'return');
