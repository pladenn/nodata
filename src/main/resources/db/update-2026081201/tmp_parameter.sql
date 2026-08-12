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

INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('7d17722b-8f3b-4b57-9dbb-aa480fbb629a', 'cccdac53-ba4b-4df8-96c1-b2c0c4ecbfd5', 'tables', 'STRING', NULL, 'Table names', true, 1, NULL, NULL, NULL, NULL, NULL, 'Comma-separated list of table names. Strict, case-insensitive exact match on either the bare name (action) or the qualified name (public.action). Omitted => all tables.');
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('f2e95f51-538f-4917-b2bf-4a2152fa825b', 'cccdac53-ba4b-4df8-96c1-b2c0c4ecbfd5', 'ddl_contains', 'STRING', NULL, 'DDL contains', true, 2, NULL, NULL, NULL, NULL, NULL, 'Comma-separated list of fuzzy masks matched against the generated DDL (case-insensitive, ANY match). A mask with no % is wrapped to %mask%; a mask containing % is used verbatim so it can be anchored. Omitted => no DDL filter.');
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('55337ffa-b990-444c-8a99-27a895008b39', '2b9c7e2d-c035-4416-a0c4-8e2b3d8c069d', 'logins', 'STRING', NULL, 'Login / service name masks', true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('4d77ca02-997c-49b8-b9ab-e9c6c1ba6090', '130ade7a-359d-4b02-a5fe-0858f5702e67', 'action_code', 'STRING', NULL, 'Action code', true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('0c892e1d-d0ed-4b87-9458-94a603e0d4a0', '130ade7a-359d-4b02-a5fe-0858f5702e67', 'field', 'STRING', NULL, 'Field to update', true, 10, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('2662ca84-8461-40b2-9b32-9ffbb77509fb', '130ade7a-359d-4b02-a5fe-0858f5702e67', '__request_body', 'TEXT', NULL, 'New value (request body)', true, 20, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('363f3a4d-8f3a-45ed-886f-0f79a2c410d4', '6e9e9e46-e340-430e-849e-2d8485a8dc5e', 'id', 'UUID', NULL, 'Action id (optional; enables renaming code)', true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('541b6ea5-602e-4ded-9353-593c7e1f5040', '6e9e9e46-e340-430e-849e-2d8485a8dc5e', 'code', 'STRING', NULL, 'Action code', true, 10, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('9450845f-2b93-45ca-a2c6-f6a18be6433b', '6e9e9e46-e340-430e-849e-2d8485a8dc5e', 'connection_id', 'UUID', NULL, 'Connection id', true, 20, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('ae74311c-62f7-467b-b655-8be0bee6da9f', '6e9e9e46-e340-430e-849e-2d8485a8dc5e', 'execution_type', 'STRING', NULL, 'Execution type', true, 30, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('223480e1-b46a-4958-b90f-d9526d2089d6', '6e9e9e46-e340-430e-849e-2d8485a8dc5e', 'title', 'STRING', NULL, 'Title', true, 40, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('0f895d2f-a91c-4413-bb53-07050b7c44de', '6e9e9e46-e340-430e-849e-2d8485a8dc5e', 'description', 'TEXT', NULL, 'Description', true, 50, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('7be32a68-2446-47fb-a623-32893a61debc', '6e9e9e46-e340-430e-849e-2d8485a8dc5e', 'query', 'TEXT', NULL, 'Query', true, 60, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('096f668b-8a0b-4793-9b74-32aea36a16f7', '6e9e9e46-e340-430e-849e-2d8485a8dc5e', 'content', 'TEXT', NULL, 'Content', true, 70, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('e4d045d6-dfee-46de-abd7-ecbed1b877ce', '6e9e9e46-e340-430e-849e-2d8485a8dc5e', 'post_process', 'TEXT', NULL, 'Post process', true, 80, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('42d4cc00-fce6-4f0a-8c7f-23c28199bde1', '6e9e9e46-e340-430e-849e-2d8485a8dc5e', 'redirect', 'STRING', NULL, 'Redirect', true, 90, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('bdd8a1ad-7a86-4938-baf2-da0098bd43e5', '6e9e9e46-e340-430e-849e-2d8485a8dc5e', 'post_request', 'BOOLEAN', NULL, 'Post request', true, 100, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('67f63a84-8e86-46cd-a42e-95617effee01', '6e9e9e46-e340-430e-849e-2d8485a8dc5e', 'action_parameters', 'TEXT', NULL, 'Parameters to upsert (JSON array)', true, 110, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('e789c7ca-d6ff-4304-8120-50d82e8f0143', '6e9e9e46-e340-430e-849e-2d8485a8dc5e', 'delete_parameters', 'TEXT', NULL, 'Parameter names to delete (JSON array)', true, 120, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

