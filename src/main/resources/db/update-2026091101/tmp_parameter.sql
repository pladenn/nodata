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

INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('49caeb55-88c9-4644-9416-959fb2bef7de', '9cc55a3e-b522-409b-a221-9aa163453ef5', '__request_body', 'TEXT', 'select 1 num', NULL, true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('f97b7f33-2dda-4219-917c-399921099024', '9cc55a3e-b522-409b-a221-9aa163453ef5', 'environment', 'STRING', NULL, NULL, true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('d218fd2b-4973-4890-b44e-64f24ff64aff', '9cc55a3e-b522-409b-a221-9aa163453ef5', 'login', 'STRING', NULL, NULL, true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('c5a226f0-4c04-4aa4-b33c-2a6da8278b5d', '2b9c7e2d-c035-4416-a0c4-8e2b3d8c069d', 'envs', 'STRING', NULL, 'Environment masks', true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('26d76ab7-a74d-bede-7fd5-dd503175b2fa', '8096367c-cc1a-473e-a9d0-33041aa92d61', 'connection_id', 'UUID', NULL, 'Connection ID', true, 3, '2ae120fd-26c2-5a1b-d07b-3839345b3b9f', '__object.description', '__object.id', NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('de5364f5-47fa-a93f-3b03-4a7f15d0ae9d', 'a01761a0-988e-3f81-ccb9-6b92c2ccf1df', 'connection_id', 'UUID', NULL, 'Connection ID', true, 3, 'bea93896-df65-c91f-6473-5a255de071e2', '__object.description', '__object.id', NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('50313080-b1af-47ff-86ac-b4471018f4c7', '6ae6cff9-d041-4ba8-83ba-3fc7bae39aac', 'service_name', 'STRING', NULL, 'Service name', true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('0e93cc11-3289-41d6-834e-9f8a4dfd07fa', '6ae6cff9-d041-4ba8-83ba-3fc7bae39aac', 'environment', 'STRING', NULL, 'Environment (qa/stage/prod)', true, 1, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('f94e08a9-dd10-4265-8a4e-3ab629e536e5', '6ae6cff9-d041-4ba8-83ba-3fc7bae39aac', 'url', 'STRING', NULL, 'JDBC URL', true, 2, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('2efbad8b-ab6a-4172-a7f7-c4ce9c8dcf0b', '6ae6cff9-d041-4ba8-83ba-3fc7bae39aac', 'login', 'STRING', NULL, 'Login', true, 3, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('5d09e92a-09b2-4a12-abc0-112ddb86fa6f', '6ae6cff9-d041-4ba8-83ba-3fc7bae39aac', 'password', 'STRING', NULL, 'Password', true, 4, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('54c5b0fa-761e-42ec-9a8d-c6d13be049c8', '6ae6cff9-d041-4ba8-83ba-3fc7bae39aac', 'active', 'BOOLEAN', 'false', 'Active (refresh flag)', true, 5, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('1d0ffa69-d5be-41f4-b672-64a38ffafd1f', 'f0a9485a-550a-4c5c-aa1f-c3d686cd1323', 'id', 'INTEGER', NULL, 'Connection id (connections.id)', true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('2a4c002f-5bbb-42fd-8ba4-1b144aa158a9', 'f0a9485a-550a-4c5c-aa1f-c3d686cd1323', 'service_name', 'STRING', NULL, 'Service name', true, 1, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('73351be7-3e7b-4c4b-8697-bef1f4c9b2f6', 'f0a9485a-550a-4c5c-aa1f-c3d686cd1323', 'environment', 'STRING', NULL, 'Environment', true, 2, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('4bbef206-22dc-4fc0-aa19-0624bc7a1a15', 'f0a9485a-550a-4c5c-aa1f-c3d686cd1323', 'url', 'STRING', NULL, 'JDBC URL', true, 3, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('7eeb113f-ac67-4734-9ad0-bba88a9c11b8', 'f0a9485a-550a-4c5c-aa1f-c3d686cd1323', 'login', 'STRING', NULL, 'Login', true, 4, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('dc09758b-4367-41e1-9f2c-83d4d0db38ab', 'f0a9485a-550a-4c5c-aa1f-c3d686cd1323', 'password', 'STRING', NULL, 'Password', true, 5, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('46385928-339a-4a04-81a1-aea8323c2be4', 'f0a9485a-550a-4c5c-aa1f-c3d686cd1323', 'active', 'BOOLEAN', NULL, 'Active (refresh flag)', true, 6, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('75a6b33c-b4bb-4e89-8b41-c82b96ab64ef', '3c8229ce-6f04-47e3-9b4f-888c0e355eb1', 'id', 'INTEGER', NULL, 'Connection id (connections.id)', true, 0, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

