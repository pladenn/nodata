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

INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('7d8eff79-4c5a-4b1f-8238-691c16f3561d', '97775d1b-b328-4667-93b7-8a16fb054bcd', 'id', 'UUID', NULL, 'Entry id', true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('3418f2d6-4ead-38c7-7a84-527168a1bad2', 'a01761a0-988e-3f81-ccb9-6b92c2ccf1df', 'content', 'TEXT', NULL, 'Content/body', true, 60, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('41626c13-4d7d-4478-afc0-bc33694fc93d', 'a01761a0-988e-3f81-ccb9-6b92c2ccf1df', 'name', 'STRING', NULL, 'Name', true, 10, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('ab9c00ee-7de5-8cdb-c1fc-29da3d24fadf', 'a01761a0-988e-3f81-ccb9-6b92c2ccf1df', 'description', 'TEXT', NULL, 'Description', true, 25, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('1ec554d6-90ab-f695-8a16-0e5be052ae70', 'a01761a0-988e-3f81-ccb9-6b92c2ccf1df', 'query', 'TEXT', NULL, 'Query', true, 20, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('84d0fe59-afe3-471d-8479-19b6a51e4b68', 'eeaece13-e0bb-40e1-b093-c6e05658be57', 'url', 'STRING', NULL, 'URL', true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('5a386182-1168-4b50-bbfa-769e632d3336', 'eeaece13-e0bb-40e1-b093-c6e05658be57', 'body', 'TEXT', NULL, 'Request body', true, 10, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('7746c0d8-b55e-4ab3-8ec9-a745242ddfe4', 'f46d9d65-acbf-4282-97d9-fb5f99540554', 'id', 'UUID', NULL, 'Entry id', true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('4a276328-ac93-4c41-845f-ab1483965429', 'f46d9d65-acbf-4282-97d9-fb5f99540554', 'name', 'STRING', NULL, 'New entry name (blank = original name + timestamp)', true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('d83bce9f-430b-4e62-b292-ac8d48e5ca60', '4cdb1b7c-3913-4b60-a100-9fb659a06679', 'timestamp_value', 'STRING', NULL, 'Epoch timestamp (seconds or milliseconds)', true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('9a86cc3c-1864-48a8-8f1f-5d5938e20898', 'b44a0e2b-ca69-44d0-9f02-7ae31e7d6103', 'datetime_value', 'STRING', NULL, 'Datetime (e.g. 2026-09-28 14:30:00)', true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('cd043e4b-4f97-4289-b4de-502f0847b925', '37ff260c-4cab-486c-9abc-0ef7c0f90198', 'base64_value', 'TEXT', NULL, 'Base64-encoded value', true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('8d01c191-304e-4f3e-8072-ec75bfb5d269', '2f8b4ebf-d425-4e6c-ae74-24b8d3ff6c2c', 'text_value', 'TEXT', NULL, 'Text to encode', true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('05012b5a-22ef-9823-0324-a33cc48c5d92', 'a01761a0-988e-3f81-ccb9-6b92c2ccf1df', 'post_process', 'TEXT', NULL, 'Post process script', true, 70, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('3204d61b-b0f2-2953-e54d-0b1d63bd8129', 'a01761a0-988e-3f81-ccb9-6b92c2ccf1df', 'code', 'STRING', NULL, 'Code', true, 5, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('1ebc9e1d-f6fd-bf29-45f9-b7d6fbd20c10', 'a01761a0-988e-3f81-ccb9-6b92c2ccf1df', 'title', 'STRING', NULL, 'Title', true, 100, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('955e2915-50ef-6237-53c3-ec56720c954a', 'a01761a0-988e-3f81-ccb9-6b92c2ccf1df', 'redirect', 'STRING', NULL, 'Redirect to', true, 15, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('5bc814c5-ced6-454b-892d-2b44916dce54', '7e0fe3e1-4c70-44d3-8c85-c52e0d7b10ac', 'action_code', 'STRING', NULL, 'Action code(s)', true, 0, NULL, NULL, NULL, NULL, NULL, 'Comma-separated list of codes/fragments, matched with ILIKE %term%. All matches are aggregated into one description.');
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('542e5164-bc5f-48ef-9b66-39e84d97c292', '7e0fe3e1-4c70-44d3-8c85-c52e0d7b10ac', 'description_search', 'STRING', NULL, 'Description search terms', true, 0, NULL, NULL, NULL, NULL, NULL, 'Comma-separated list of terms, fuzzy-matched (ILIKE %term%) against the action''s raw description column only -- generated parameters/links tables are not searched.');
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('d8f69853-f7a0-8714-b452-361638d5c1dc', 'a01761a0-988e-3f81-ccb9-6b92c2ccf1df', 'execution_type', 'STRING', NULL, 'Execution provider', true, 40, '49f10ecf-1283-4102-aa3a-3a4aeea02cbd', '__object.value', '__object.key', NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('85f4bafa-0063-486a-805d-0984c8748e95', '86e487cc-027c-4c09-9df2-6eed0f0fd1db', 'service_name', 'STRING', NULL, 'Service name', true, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('7c56be01-93ba-4412-b3ea-c48ccfa267be', '86e487cc-027c-4c09-9df2-6eed0f0fd1db', 'environment', 'STRING', NULL, 'Environment (qa/stage/prod)', true, 1, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('197ee1a2-0feb-4d5f-bf42-89be159b9401', '86e487cc-027c-4c09-9df2-6eed0f0fd1db', 'url', 'STRING', NULL, 'JDBC URL (a leading jdbc:aws-wrapper: is stripped automatically)', true, 2, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('41a1c58f-de57-4bf2-adfb-2100f931688e', '86e487cc-027c-4c09-9df2-6eed0f0fd1db', 'login', 'STRING', NULL, 'Login', true, 3, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('f4886a4f-1cdc-4d26-9d95-a2fab4ba7bd8', '86e487cc-027c-4c09-9df2-6eed0f0fd1db', 'password', 'STRING', NULL, 'Password', true, 4, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('792e64f9-1309-4410-be45-85006c05c849', '86e487cc-027c-4c09-9df2-6eed0f0fd1db', 'active', 'BOOLEAN', 'false', 'Active (include in next catalog refresh)', true, 5, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('de5364f5-47fa-a93f-3b03-4a7f15d0ae9d', 'a01761a0-988e-3f81-ccb9-6b92c2ccf1df', 'connection_id', 'UUID', NULL, 'Connection ID', true, 30, 'bea93896-df65-c91f-6473-5a255de071e2', '__object.description', '__object.id', NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('bbe27d61-18c4-4917-8f2f-cbd94e331c51', '1ca07cd8-9aa0-47f1-a7be-5747fd4a64df', 'id', 'UUID', NULL, 'Id', false, 1, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('e7954447-a1ab-4778-8efd-947654f36fe6', '9a327110-5e26-4d2a-8bc1-8eabeb2da397', 'search_words', 'STRING', NULL, 'Search words', true, 3, NULL, NULL, NULL, NULL, NULL, 'Comma-separated list of words; fuzzy-matches action description or code (ILIKE)');


--
-- PostgreSQL database dump complete
--

