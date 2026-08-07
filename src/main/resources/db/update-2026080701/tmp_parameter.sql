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
-- Name: tmp_parameter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tmp_parameter (
    id uuid,
    action_id uuid,
    name character varying(50),
    type character varying(50),
    default_value text,
    title text,
    editable boolean,
    "order" integer,
    dictionary_id uuid,
    name_column character varying,
    value_column character varying,
    editable_dictionary boolean,
    dict_null_value boolean,
    description text
);


ALTER TABLE public.tmp_parameter OWNER TO postgres;

--
-- Data for Name: tmp_parameter; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('1014febf-0730-41ac-8aed-979955046d0f', 'f52aef46-d5be-4653-88b4-c74e23c9004e', 'menu_code', 'STRING', 'custom-sub-menu-json', 'Menu document action code', true, 90, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('702b3699-6a9e-4df7-b371-9fe141908a14', 'ed2ec51a-53c6-4b6d-b643-ca8dd9ccfe49', 'path', 'STRING', NULL, 'Path, 1-based (e.g. 2-1-3)', true, 10, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('a46f6b4a-bce6-46b9-ac9e-8e13ce89e628', 'ed2ec51a-53c6-4b6d-b643-ca8dd9ccfe49', 'action_code', 'STRING', NULL, 'Action code to insert', true, 20, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('95e1f98c-6286-4f6a-9843-c64211ce016a', 'ed2ec51a-53c6-4b6d-b643-ca8dd9ccfe49', 'name', 'STRING', NULL, 'Name (blank = use the action title)', true, 30, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('90e90927-b752-49c4-873a-b992cc2364f7', 'ed2ec51a-53c6-4b6d-b643-ca8dd9ccfe49', 'show_parameters', 'BOOLEAN', NULL, 'Append /parameters to the link', true, 40, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('b55c4f5e-6d4b-4dc8-85d8-e79064ffc94a', 'ed2ec51a-53c6-4b6d-b643-ca8dd9ccfe49', 'menu_code', 'STRING', 'custom-sub-menu-json', 'Menu document action code', true, 90, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('94219dd7-3ad3-4ed7-9b31-4f9d7db653cf', '8226da50-68c5-4b39-98c0-d87a5870371e', 'path', 'STRING', NULL, 'Path, 1-based (e.g. 2-1-3)', true, 10, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('80124d28-e092-40cd-8100-3635c7be6214', '8226da50-68c5-4b39-98c0-d87a5870371e', 'menu_code', 'STRING', 'custom-sub-menu-json', 'Menu document action code', true, 90, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('bce8354e-ab69-4977-88a3-4067c4a89320', 'f777a55e-e019-44b3-bfdc-2df687195867', 'path', 'STRING', NULL, 'Path, 1-based (e.g. 2-1-3)', true, 10, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('97de38a4-09e4-4aa0-bb17-68918ca54be7', 'f777a55e-e019-44b3-bfdc-2df687195867', 'name', 'STRING', NULL, 'New name (blank = use the action title)', true, 20, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('93c87164-1abb-433a-8d88-22e2bcacc06e', 'f777a55e-e019-44b3-bfdc-2df687195867', 'menu_code', 'STRING', 'custom-sub-menu-json', 'Menu document action code', true, 90, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('69fe48c2-89ab-49ad-90f5-339b962cf36a', 'f4261fc2-cfff-456d-bfc0-c886a3ef3c70', 'path', 'STRING', NULL, 'Source path, 1-based', true, 10, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('9c49f6ed-2d81-4f2a-9d60-ef76ffe0bf0e', 'f4261fc2-cfff-456d-bfc0-c886a3ef3c70', 'to_path', 'STRING', NULL, 'Destination path (item ends up AT this position)', true, 20, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('dd841a5a-313c-470c-8e9f-8fa5390393e3', 'f4261fc2-cfff-456d-bfc0-c886a3ef3c70', 'menu_code', 'STRING', 'custom-sub-menu-json', 'Menu document action code', true, 90, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('a4538a5f-7197-ec6d-b459-e196a1752eab', '91b78475-df95-e996-f490-5fa510237dbb', 'envs', 'STRING', NULL, NULL, true, 10, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('d4fea866-28b2-4e79-3afe-bf58d244ca1d', '91b78475-df95-e996-f490-5fa510237dbb', 'tables', 'STRING', NULL, NULL, true, 20, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('506f9d05-3d47-a150-d303-752236a81dee', 'cb2677d6-2334-cd9e-5fe8-b2d76a05360f', 'tables', 'STRING', NULL, NULL, true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('9d968844-2887-5db8-df8b-4ccc61f76d83', 'cb2677d6-2334-cd9e-5fe8-b2d76a05360f', 'ddl_contains', 'STRING', NULL, 'ddl_contains', true, 20, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('c39a4ca9-7842-eed2-245d-587a4de8f316', 'ab69c504-e716-5bd6-f67e-11b186f98c49', 'envs', 'STRING', NULL, NULL, true, 10, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('649fb33e-4f64-d732-bbb5-121e5a2b365d', 'ab69c504-e716-5bd6-f67e-11b186f98c49', 'logins', 'STRING', NULL, NULL, true, 20, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('4fcf1957-3970-e137-1625-867f11488a5d', 'ab69c504-e716-5bd6-f67e-11b186f98c49', 'tables', 'STRING', NULL, NULL, true, 30, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

