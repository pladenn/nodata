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

INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('72810b2a-84c9-26ff-38be-e0dbb0706d89', 'd89d6127-2e92-5ea3-d9b7-fb485b2250a0', 'action_id', 'UUID', NULL, 'Action', true, 10, 'e99f0139-e852-c50c-0b54-e71bce37b2e5', '__object.action.title', '__object.action.id', NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('ab9c00ee-7de5-8cdb-c1fc-29da3d24fadf', 'a01761a0-988e-3f81-ccb9-6b92c2ccf1df', 'description', 'TEXT', NULL, 'Description', true, 2, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('919af12e-1ec2-41f8-8c81-74acc55e02fe', 'c6b6dafc-5a7c-4dcd-819c-888cd72396cb', 'title', 'STRING', NULL, 'Title', true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('46158ba0-eae8-42d9-98a7-e1d6929ecfa0', 'c6b6dafc-5a7c-4dcd-819c-888cd72396cb', 'parent_action_id', 'UUID', NULL, 'Parent action id (ignored when global=true)', true, 1, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('2447600f-619f-4c93-9ecd-1e43127c9fec', 'c6b6dafc-5a7c-4dcd-819c-888cd72396cb', 'child_action_id', 'UUID', NULL, 'Child action id', true, 2, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('33b90909-051b-4f93-98f1-0131e5f9c3f3', 'c6b6dafc-5a7c-4dcd-819c-888cd72396cb', 'group', 'STRING', NULL, 'MOUNTED_TO_ACTION or MOUNTED_TO_ROW', true, 3, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('54282e71-1035-48ed-90a3-691f445a207e', 'c6b6dafc-5a7c-4dcd-819c-888cd72396cb', 'via_parameters', 'BOOLEAN', 'false', 'Open parameters tab', true, 4, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('6c2dab5a-00d7-40f3-9951-be7a7c8597fb', 'c6b6dafc-5a7c-4dcd-819c-888cd72396cb', 'order', 'INTEGER', '0', 'Order', true, 5, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('44a310fa-721c-4f80-b0cd-386e03b8a79e', 'c6b6dafc-5a7c-4dcd-819c-888cd72396cb', 'global', 'BOOLEAN', 'false', 'Global action', true, 6, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('f7dcbc40-5529-4350-9579-899a11f4f85a', 'c6b6dafc-5a7c-4dcd-819c-888cd72396cb', 'mapping', 'TEXT', NULL, 'JSON array of {path, parameter_name} pairs', true, 7, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('6a470095-73dc-15ea-c076-4e3ce6b4fc0b', '9ac0f8b6-01a7-d1f4-2b23-b891bf39012f', 'parent_action_id', 'UUID', NULL, 'Parent action', true, 1, '23a4af42-a2cd-0b1e-2c15-28633bdd857c', '__object.action.name', '__object.action.id', NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('98a3d843-60fa-cf4a-750e-d73724b539aa', '9ac0f8b6-01a7-d1f4-2b23-b891bf39012f', 'child_action_id', 'UUID', NULL, 'Child action', true, 2, '23a4af42-a2cd-0b1e-2c15-28633bdd857c', '__object.action.name', '__object.action.id', NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

