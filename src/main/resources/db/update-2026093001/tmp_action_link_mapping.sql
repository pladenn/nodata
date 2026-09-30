--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: tmp_action_link_mapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tmp_action_link_mapping (
    id uuid,
    action_link_id uuid,
    parameter_id uuid,
    mapping text,
    default_value character varying
);


ALTER TABLE public.tmp_action_link_mapping OWNER TO postgres;

--
-- Data for Name: tmp_action_link_mapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('b40a7602-f64e-44eb-a8f8-214a9fd46874', '55dfe752-4cef-4d61-9bce-721dd4e52cd2', '7d8eff79-4c5a-4b1f-8238-691c16f3561d', '__object.id', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('b981264c-b888-0cb1-3ea3-c8dbe3cb447a', '61c658d8-49b8-eee1-d3b2-7ca733948455', '33786152-e95d-8e50-55c9-6a509b1fffe0', '__object.parameter.id', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('9fc8b76a-0db7-b2a7-c1c1-4055e2fc3f81', '61c658d8-49b8-eee1-d3b2-7ca733948455', '20c463ee-8051-d2a6-a4d7-93d1bc459293', '__object.action_link.id', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('d821d167-8850-82e1-c9c0-a6c1347d9a6c', 'f7f1f0b0-5d61-8b41-03d7-f3cffba7dbb1', '6374bbbb-4ec4-7376-b939-3ca54723d2c7', '__object.action_link_mapping.default_value', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('12f76712-d2f5-fe43-a142-cb2c399c3309', '61c658d8-49b8-eee1-d3b2-7ca733948455', '7ca68992-66cc-a021-4116-29787ebc2637', '__object.action_link_mapping.mapping', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('c24e3375-7d9f-861a-2158-15cb8ab5e508', 'f7f1f0b0-5d61-8b41-03d7-f3cffba7dbb1', '8f85a4e6-4db0-36f6-98e8-f65d6d249a0a', '__object.child_action.title', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('e4cce658-d5ed-7c3f-697a-c9032681d0a0', 'f7f1f0b0-5d61-8b41-03d7-f3cffba7dbb1', 'af7b1bc3-1ea1-a857-8997-7748adf543cb', '__object.parent_action.title', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('d13b26a3-e26c-e561-16bf-6132d0918b89', 'f7f1f0b0-5d61-8b41-03d7-f3cffba7dbb1', 'd5efbc4d-7df1-302a-cfeb-084e0abe886c', '__object.parameter.name', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('60e947d0-eea2-c247-2121-22d8d1dbdc94', 'f7f1f0b0-5d61-8b41-03d7-f3cffba7dbb1', '3a7381c4-c68d-b918-ae35-773169357a5d', '__object.action_link_mapping.mapping', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('351a68f0-5153-b4c4-ab85-844e2fff8db6', 'f7f1f0b0-5d61-8b41-03d7-f3cffba7dbb1', 'a9b4fcec-256f-e3d8-95c4-d2d85ad9bd09', '__object.parameter.title', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('9a3f716c-a7c5-46a6-b930-695508f23ab6', 'cb6f6494-8230-4fdf-8092-c022a6ae03ac', '7746c0d8-b55e-4ab3-8ec9-a745242ddfe4', '__object.id', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('fc2ac948-8b61-4fad-9f50-b9a6b685ace3', 'cb6f6494-8230-4fdf-8092-c022a6ae03ac', '4a276328-ac93-4c41-845f-ab1483965429', '__object.key', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('d5baf2dc-42f4-5b01-ac70-7fa139b501a4', '61c658d8-49b8-eee1-d3b2-7ca733948455', '96fbc0db-377b-162d-8f80-fe9bb469cd29', '__object.action_link_mapping.default_value', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('a64686e4-98f2-dbab-735c-467d15d39ef2', 'f7f1f0b0-5d61-8b41-03d7-f3cffba7dbb1', '48aef6f8-0895-92ed-644b-3ed4c6f847b9', '__object.action_link_mapping.id', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('5e34169a-3493-c3ea-5819-8ad4f7fbc6fc', '12880f8c-7f80-a6cf-5e52-6a42666708b7', 'd27bec70-b648-45d6-8dea-38131b63c947', '__object.parent_action.id', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('2053a3ad-6432-dcd8-fb29-5481aa34ca10', 'e3bc737b-d1cc-54c7-de94-ce5077dd9475', 'd27bec70-b648-45d6-8dea-38131b63c947', '__object.child_action.id', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('8c62c075-b5a5-fb99-6654-1ed25f631dbe', 'c66d34cc-f483-8680-65d1-279b93079851', 'e106a98e-e476-90ee-dcc9-dccd0342203f', '__object.action_link.id', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('45206be7-9080-642a-48ed-0dbe180da571', '4b1dd225-e333-40af-ac61-9ce2f9f3cd6d', '5bc814c5-ced6-454b-892d-2b44916dce54', '__object.action.code', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('98ecab99-70d1-e227-71dc-4b2cac683d5d', 'effa4760-15cb-337c-943a-bad4033f2431', 'c82fc54f-29cd-0a88-b2a8-49e1a1fde014', '__object.id', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('300ca3f3-eb63-eaba-e2e9-8019d1b83f0c', '75cbf065-7c9d-ee1d-1e16-b15746a5420b', 'a608e862-7467-ad0e-34df-05db28d8ad2c', '__object.parameter.id', NULL);


--
-- PostgreSQL database dump complete
--

