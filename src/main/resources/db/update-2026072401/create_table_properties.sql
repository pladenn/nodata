create table IF NOT EXISTS properties
(
    id        uuid    not null
        constraint properties_pk
            primary key,
    parent_id uuid
        constraint properties_properties_id_fk
            references properties,
    key       varchar not null,
    value     text
);

alter table properties
    owner to postgres;

create unique index IF NOT EXISTS properties_parent_id_key_uindex
    on properties (parent_id, key);