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

INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('a0ab454f-82bf-4e63-a49d-1cf7f304aa7f', '325e7262-43f7-4a57-b053-d17cb6852977', 'id', 'UUID', NULL, 'Exact id (used by the view-any-object drill-down)', true, 1, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('c81fd342-b881-4940-9a17-e26d85f8ac40', '325e7262-43f7-4a57-b053-d17cb6852977', 'name', 'STRING', NULL, 'Name contains (fuzzy)', true, 2, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('9b2deb14-62c0-4418-a5e9-8a7a099f99a7', '325e7262-43f7-4a57-b053-d17cb6852977', 'data', 'STRING', NULL, 'Data contains (fuzzy)', true, 3, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('55cb3479-40b7-4aa2-ad6e-c25ae9323f79', '002d3444-b227-47f7-a059-adee55f1f78d', 'id', 'INTEGER', NULL, 'Connection id (connections.id)', false, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('e053744c-8ff9-4a61-a491-e5d61d066642', 'dec16dae-0b50-48f0-9252-8d130fc93a01', 'name', 'STRING', NULL, 'Name', true, 1, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('a4f96e2b-dbc1-456d-bb55-504f65be319d', 'dec16dae-0b50-48f0-9252-8d130fc93a01', 'data', 'TEXT', NULL, 'Data', true, 2, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('13a123c8-304b-403b-b851-55e7e79c00b4', '9ae4808e-d6bd-47ed-a4b4-b76e40f46884', 'id', 'UUID', NULL, 'Id', true, 1, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('89cebe88-12c6-42b8-a344-bb443169618f', '9ae4808e-d6bd-47ed-a4b4-b76e40f46884', 'name', 'STRING', NULL, 'Name', true, 2, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('3d10589d-e938-4211-9af6-0d86df7a15bc', '9ae4808e-d6bd-47ed-a4b4-b76e40f46884', 'data', 'TEXT', NULL, 'Data', true, 3, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('bbe27d61-18c4-4917-8f2f-cbd94e331c51', '1ca07cd8-9aa0-47f1-a7be-5747fd4a64df', 'id', 'UUID', NULL, 'Id', true, 1, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

