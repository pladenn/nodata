create table tmp_properties
(
    id        uuid,
    parent_id uuid,
    key       varchar,
    value     text
);

alter table tmp_properties
    owner to postgres;

INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('f011a155-fa7a-8451-ddf5-d3a360405f19', null, 'dictionaries', null);
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('d2df981c-9a0c-4ace-91fe-d953ca9f2155', 'f011a155-fa7a-8451-ddf5-d3a360405f19', 'action_execution_type', 'action_execution_type');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('4f03acfa-6476-43b1-a327-14b44fa721ea', 'f011a155-fa7a-8451-ddf5-d3a360405f19', 'link_groups', 'link_groups');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('6626e301-ecc7-499f-8a5e-7a6cc3fa1971', 'f011a155-fa7a-8451-ddf5-d3a360405f19', 'connection-type', 'connection-type');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('419f7801-825f-49f1-84f8-1c7ce6f33c52', '1b126022-13c4-4e03-84c7-2c1f87588e20', 'DATE', 'DATE');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('9aa9892b-1a73-4d7c-b984-45ca6420f882', 'd2df981c-9a0c-4ace-91fe-d953ca9f2155', 'SQL_DML', 'SQL_DML');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('d7a3573f-9e9b-46fb-b771-8a0df5179940', 'd2df981c-9a0c-4ace-91fe-d953ca9f2155', 'SQL_BLOCK', 'SQL_BLOCK');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('1d29a86e-580b-4841-bce4-a91d465f56f5', 'd2df981c-9a0c-4ace-91fe-d953ca9f2155', 'HTTP_GET', 'HTTP_GET');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('89d21ec0-c03b-4e0e-a103-03f4ac4a0133', 'd2df981c-9a0c-4ace-91fe-d953ca9f2155', 'HTTP_POST', 'HTTP_POST');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('d7f8f117-1085-4713-bd7c-e0e3c2214fd2', 'd2df981c-9a0c-4ace-91fe-d953ca9f2155', 'HTTP_PUT', 'HTTP_PUT');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('53777418-03f6-45b5-b1dd-93c08b62ac12', 'd2df981c-9a0c-4ace-91fe-d953ca9f2155', 'HTTP_DELETE', 'HTTP_DELETE');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('3266e553-3176-4fdb-a275-aca1461af955', '6626e301-ecc7-499f-8a5e-7a6cc3fa1971', 'SQL', 'SQL');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('3edb8851-cb90-48c9-8627-48f76446c874', '1b126022-13c4-4e03-84c7-2c1f87588e20', 'UUID', 'UUID');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('acca2b0f-a3be-41dd-9cc1-19cf85e509a2', '1b126022-13c4-4e03-84c7-2c1f87588e20', 'BOOLEAN', 'BOOLEAN');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('17ed8048-4ade-4670-9e76-21f20cba3c19', '1b126022-13c4-4e03-84c7-2c1f87588e20', 'INTEGER', 'INTEGER');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('76cd7316-91de-45ff-aa31-dad71589c3af', '1b126022-13c4-4e03-84c7-2c1f87588e20', 'TEXT', 'TEXT');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('caf75983-74d1-41fc-aff9-bc1acdd4526e', '1b126022-13c4-4e03-84c7-2c1f87588e20', '_INSERTED', '_INSERTED');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('05e0fd44-8fdc-4297-8e0b-ea28718aa857', '1b126022-13c4-4e03-84c7-2c1f87588e20', 'STRING', 'STRING');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('818250b0-a989-4d01-acf8-2540e55801c4', 'd2df981c-9a0c-4ace-91fe-d953ca9f2155', 'SQL', 'SQL');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('14e32323-971f-4aab-9f1a-61b013f6a268', '1b126022-13c4-4e03-84c7-2c1f87588e20', 'LONG', 'LONG');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('5e76112c-fb74-4dd0-8fba-b6026cd2014c', '4f03acfa-6476-43b1-a327-14b44fa721ea', 'INITIALIZATION', 'INITIALIZATION');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('a7370402-0e39-481f-a53a-826c7787d08b', '4f03acfa-6476-43b1-a327-14b44fa721ea', 'PARAMETERS', 'PARAMETERS');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('a73570f1-abed-4ee7-bbc2-8f2e4543a6dd', '4f03acfa-6476-43b1-a327-14b44fa721ea', 'DATA', 'DATA');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('e8200130-9312-4111-8177-bce6684769f9', '4f03acfa-6476-43b1-a327-14b44fa721ea', 'MOUNTED_TO_ACTION', 'MOUNTED_TO_ACTION');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('f2055b16-4e8d-4fa4-ac4f-78a2ed18b386', '4f03acfa-6476-43b1-a327-14b44fa721ea', 'MOUNTED_TO_ROW', 'MOUNTED_TO_ROW');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('41d2e1ce-a77a-46c1-81bf-330301dc4635', '4f03acfa-6476-43b1-a327-14b44fa721ea', 'DICTIONARY', 'DICTIONARY');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('d9fde150-0d0f-463d-b202-8e0594b2c9ff', 'd2df981c-9a0c-4ace-91fe-d953ca9f2155', 'SQL_BLOCK_WITH_RESULT', 'SQL_BLOCK_WITH_RESULT');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('a60a9204-8562-44b6-ac02-076328f87c8e', '6626e301-ecc7-499f-8a5e-7a6cc3fa1971', 'HTTP', 'HTTP');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('1b126022-13c4-4e03-84c7-2c1f87588e20', 'f011a155-fa7a-8451-ddf5-d3a360405f19', 'parameter_types', 'Datatype');
