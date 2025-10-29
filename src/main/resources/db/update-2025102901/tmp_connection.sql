create table tmp_connection
(
    id          uuid,
    description text,
    type        varchar(50),
    url         text,
    login       varchar(250),
    password    varchar(250),
    code        varchar
);

alter table tmp_connection
    owner to postgres;

INSERT INTO public.tmp_connection (id, description, type, url, login, password, code) VALUES ('d48b9a97-e13c-4961-9eff-d76f39abdffb', 'System SQL', 'SQL', '{properties.system.data-base-url}', '{properties.system.data-base-username}', '{properties.system.data-base-password}', 'system-sql');
INSERT INTO public.tmp_connection (id, description, type, url, login, password, code) VALUES ('6fdfb5ed-816e-77a1-3e13-d84bbb452939', 'Any HTTP', 'HTTP', '{parameters.url}', null, null, 'system-any-http-request');
INSERT INTO public.tmp_connection (id, description, type, url, login, password, code) VALUES ('b16c7ed6-3beb-495c-b38e-337f9adec0a1', 'Sytem HTTP', 'HTTP', 'http://localhost:{properties.system.localhost-port}', null, null, 'system-http');
