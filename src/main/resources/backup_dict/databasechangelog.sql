create table databasechangelog
(
    id            varchar(255) not null,
    author        varchar(255) not null,
    filename      varchar(255) not null,
    dateexecuted  timestamp    not null,
    orderexecuted integer      not null,
    exectype      varchar(10)  not null,
    md5sum        varchar(35),
    description   varchar(255),
    comments      varchar(255),
    tag           varchar(255),
    liquibase     varchar(20),
    contexts      varchar(255),
    labels        varchar(255),
    deployment_id varchar(10)
);

alter table databasechangelog
    owner to postgres;

INSERT INTO public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) VALUES ('raw', 'includeAll', 'gold_db/connection.sql', '2025-07-19 17:20:27.665331', 1, 'EXECUTED', '9:1dcf2c46ec9d2256be0ae90b15a4a889', 'sql', '', null, '4.27.0', null, null, '2934827591');
INSERT INTO public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) VALUES ('raw', 'includeAll', 'gold_db/action.sql', '2025-07-19 17:20:27.756981', 2, 'EXECUTED', '9:51ea71444852a9a4ac432df8a3424303', 'sql', '', null, '4.27.0', null, null, '2934827591');
INSERT INTO public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) VALUES ('raw', 'includeAll', 'gold_db/action_link.sql', '2025-07-19 17:20:27.827604', 3, 'EXECUTED', '9:5fdd8957046f6bc0649df68a75b9f85a', 'sql', '', null, '4.27.0', null, null, '2934827591');
INSERT INTO public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) VALUES ('raw', 'includeAll', 'gold_db/parameter.sql', '2025-07-19 17:20:28.021671', 4, 'EXECUTED', '9:72df10917b14c014b1a28cb12e3cfb8e', 'sql', '', null, '4.27.0', null, null, '2934827591');
INSERT INTO public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) VALUES ('raw', 'includeAll', 'gold_db/action_link_mapping.sql', '2025-07-19 17:20:28.156231', 5, 'EXECUTED', '9:eff356c05587598eb9335c0e9cadfaef', 'sql', '', null, '4.27.0', null, null, '2934827591');
INSERT INTO public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) VALUES ('raw', 'includeAll', 'gold_db/column.sql', '2025-07-19 17:20:28.212243', 6, 'EXECUTED', '9:ab9f14212a4c5caa5acadc7bd2f9462b', 'sql', '', null, '4.27.0', null, null, '2934827591');
INSERT INTO public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) VALUES ('raw', 'includeAll', 'gold_db/property_category.sql', '2025-07-19 17:20:28.251014', 7, 'EXECUTED', '9:95b49b369b62ab738537f5f8c6bf0311', 'sql', '', null, '4.27.0', null, null, '2934827591');
INSERT INTO public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) VALUES ('raw', 'includeAll', 'gold_db/property.sql', '2025-07-19 17:20:28.288295', 8, 'EXECUTED', '9:a140188ed1846fce43b4240445e287e6', 'sql', '', null, '4.27.0', null, null, '2934827591');
INSERT INTO public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) VALUES ('raw', 'includeAll', 'gold_db/dictionary.sql', '2025-07-19 17:20:28.327816', 9, 'EXECUTED', '9:356277d14b948173d43524ee0a0a355d', 'sql', '', null, '4.27.0', null, null, '2934827591');
INSERT INTO public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) VALUES ('raw', 'includeAll', 'gold_db/dictionary_mapping.sql', '2025-07-19 17:20:28.365540', 10, 'EXECUTED', '9:565af73eaa402de5161bb44d2831bd72', 'sql', '', null, '4.27.0', null, null, '2934827591');
