create table connection
(
    id          uuid        not null
        primary key,
    description text,
    type        varchar(50) not null,
    url         text        not null,
    login       varchar(50),
    password    varchar(50),
    code        varchar     not null
        constraint connection_code_uk
            unique
);

alter table connection
    owner to postgres;

INSERT INTO public.connection (id, description, type, url, login, password, code) VALUES ('d48b9a97-e13c-4961-9eff-d76f39abdffb', 'System SQL', 'SQL', '{context.system.data-base-url}', '{context.system.data-base-username}', '{context.system.data-base-password}', 'system-sql');
INSERT INTO public.connection (id, description, type, url, login, password, code) VALUES ('b16c7ed6-3beb-495c-b38e-337f9adec0a1', 'Sytem HTTP', 'HTTP', 'http://localhost:9955', null, null, 'system-http');
