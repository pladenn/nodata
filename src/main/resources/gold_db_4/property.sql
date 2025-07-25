create table property
(
    id          uuid                                                      not null
        primary key,
    "group"     varchar(50)                                               not null,
    property    text                                                      not null,
    value       text,
    category_id uuid default '884504a5-53fe-4ace-a6a8-d7d6a9223a88'::uuid not null
        constraint "property-property_category_fk"
            references property_category
            on delete cascade
);

alter table property
    owner to postgres;

INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('d189e3ec-15f3-48cc-b3a4-cdd4318bde6a', 'system', 'system-sub-menu', 'system-sub-menu', '884504a5-53fe-4ace-a6a8-d7d6a9223a88');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('4fadff59-bc80-4067-b0df-da0d7e3d5deb', 'system', 'custom-sub-menu', 'custom-sub-menu', '884504a5-53fe-4ace-a6a8-d7d6a9223a88');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('4a6e2cc2-2a6d-d575-5bc4-6b07d7019b6b', 'system', 'system-base-path', '/content/system/', '884504a5-53fe-4ace-a6a8-d7d6a9223a88');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('d0f767fb-86c3-0a30-d085-b4a932c7e01c', 'action_execution_type', 'SQL_DQL', 'SQL_DQL', 'f011a155-fa7a-8451-ddf5-d3a360405f19');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('e118b817-641c-c464-ce54-6e9a122c020a', 'action_execution_type', 'SQL_DML', 'SQL_DML', 'f011a155-fa7a-8451-ddf5-d3a360405f19');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('da4f91b6-6af7-fb25-62d8-feeaf4bfe77b', 'action_execution_type', 'SQL_BLOCK', 'SQL_BLOCK', 'f011a155-fa7a-8451-ddf5-d3a360405f19');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('21f7ae3b-41b3-829d-9be8-589bd2f4c08f', 'action_execution_type', 'HTTP_GET', 'HTTP_GET', 'f011a155-fa7a-8451-ddf5-d3a360405f19');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('a5a1b797-1116-7ff0-6958-2fc846600d25', 'action_execution_type', 'HTTP_POST', 'HTTP_POST', 'f011a155-fa7a-8451-ddf5-d3a360405f19');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('1e65829e-cfd1-2adf-15b5-f3eb7791418c', 'action_execution_type', 'HTTP_PUT', 'HTTP_PUT', 'f011a155-fa7a-8451-ddf5-d3a360405f19');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('b941c56e-581b-9350-f13f-02ee904a976f', 'action_execution_type', 'HTTP_DELETE', 'HTTP_DELETE', 'f011a155-fa7a-8451-ddf5-d3a360405f19');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('ec0fdca9-495f-c5ea-5254-749b7d26d1ec', 'connection-type', 'HTTP', 'HTTP', 'f011a155-fa7a-8451-ddf5-d3a360405f19');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('fba6d2b8-f5cb-0945-526e-ee469b0fdfa5', 'connection-type', 'SQL', 'SQL', 'f011a155-fa7a-8451-ddf5-d3a360405f19');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('5522621c-930b-c372-6775-def8fabdb602', 'parameter_types', 'UUID', 'UUID', 'f011a155-fa7a-8451-ddf5-d3a360405f19');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('8b09b742-d202-c5f3-30a5-d0d592ac1120', 'parameter_types', 'BOOLEAN', 'BOOLEAN', 'f011a155-fa7a-8451-ddf5-d3a360405f19');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('4b1d7478-1d46-b808-ec6d-9e61cb8987bc', 'parameter_types', 'INTEGER', 'INTEGER', 'f011a155-fa7a-8451-ddf5-d3a360405f19');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('e4489725-88ec-35be-62fa-99600a01d427', 'parameter_types', 'TEXT', 'TEXT', 'f011a155-fa7a-8451-ddf5-d3a360405f19');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('59341486-e7d1-fc8b-2a1d-e878b9d47e20', 'parameter_types', '_INSERTED', '_INSERTED', 'f011a155-fa7a-8451-ddf5-d3a360405f19');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('edc61121-9c48-4426-58a8-aad7b126f395', 'parameter_types', 'STRING', 'STRING', 'f011a155-fa7a-8451-ddf5-d3a360405f19');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('b98ed4f0-e3f2-5162-d20c-ab2171a602e1', 'dddd', 'dddd', 'ddd', 'f011a155-fa7a-8451-ddf5-d3a360405f19');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('99bc1fc0-a7e7-81c8-c491-cbe2981e1b56', 'vvv', 'vv', 'vvv', 'f011a155-fa7a-8451-ddf5-d3a360405f19');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('5d2f37a9-d067-4ec5-0c44-377e673299be', 'header', 'x-conn-header', 'qqq', '88e566f7-1a23-9cfb-b611-977739327e20');
INSERT INTO public.property (id, "group", property, value, category_id) VALUES ('c561163a-98e3-ad9d-f9aa-2e438d069225', 'header', 'x-test-header', 'www', 'd9e3fb6b-ecac-09ed-563a-9e4910573d56');
