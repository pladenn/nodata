create table tmp_del_sys_obj
(
    id  uuid,
    tbl text
);

alter table tmp_del_sys_obj
    owner to postgres;

INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('5dfc355d-bd88-c1c1-50e8-d67d5ad682d1', 'action');
INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('e73bbe26-e434-d684-369f-ca0bd1a48424', 'action_link');
INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('70c0b196-23b0-0755-4873-833e9eec40c3', 'action_link_group');
INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('522f0d4a-189f-9815-bec3-cfafd10b04c9', 'action_link_mapping');
INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('4ff67024-73bd-4493-10c4-ca28b1ff0f81', 'action_link_mapping');
INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('ea209757-66b0-279e-17dd-92ac5f757e37', 'action_link_mapping');
INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('28c2938a-b2b2-f535-8297-319f266f8bd3', 'action_link_mapping');
INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('251df126-c294-88a7-1bd2-f670657ecaa7', 'action_link_mapping');
INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('16de4ae3-766c-1e9e-cdab-7ccb2e9817aa', 'action_link_mapping');
INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('5003b487-cd44-3eee-dce9-9ac38a679a8d', 'action_link_mapping');
INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('4f918818-676d-2636-2784-65714438ee1f', 'action_link_mapping');
INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('34bc390a-b632-f1d9-58f1-07a7e66e02cc', 'action_link_mapping');
INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('2d8d67b5-3429-2d93-17bd-630af8e25e5c', 'action_link_mapping');
INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('b88dc769-f7b2-3dad-82fc-a8ede529faf8', 'action_link_mapping');
INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('5db008ed-7e01-a95e-61ab-eddad4650413', 'action_link_mapping');
INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('fe87b00d-0af9-9b10-6b92-0b88fc382bab', 'parameter');
INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('73d777e7-6ba2-962e-e6f3-aeeab630fab6', 'parameter');
INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('46741616-74be-da34-4fc9-ec673d5d7542', 'parameter');
INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('5b6c1f3b-35e7-c051-4abe-1a564d5af2b3', 'property_category');
