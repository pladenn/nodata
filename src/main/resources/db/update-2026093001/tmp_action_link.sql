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
-- Name: tmp_action_link; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tmp_action_link (
    id uuid,
    parent_action_id uuid,
    child_action_id uuid,
    title text,
    is_action_target boolean,
    via_parameters boolean,
    "order" integer,
    mounted_to_row boolean,
    category character varying,
    variable character varying,
    mapping character varying
);


ALTER TABLE public.tmp_action_link OWNER TO postgres;

--
-- Data for Name: tmp_action_link; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tmp_action_link (id, parent_action_id, child_action_id, title, is_action_target, via_parameters, "order", mounted_to_row, category, variable, mapping) VALUES ('55dfe752-4cef-4d61-9bce-721dd4e52cd2', '325e7262-43f7-4a57-b053-d17cb6852977', '97775d1b-b328-4667-93b7-8a16fb054bcd', 'Prettify JSON', false, false, 30, false, 'MOUNTED_TO_ROW', NULL, NULL);
INSERT INTO public.tmp_action_link (id, parent_action_id, child_action_id, title, is_action_target, via_parameters, "order", mounted_to_row, category, variable, mapping) VALUES ('ec6e817f-2150-484a-94ce-89e983b2efd3', '2b9c7e2d-c035-4416-a0c4-8e2b3d8c069d', '86e487cc-027c-4c09-9df2-6eed0f0fd1db', 'Add connection', false, true, 0, false, 'MOUNTED_TO_ACTION', NULL, NULL);
INSERT INTO public.tmp_action_link (id, parent_action_id, child_action_id, title, is_action_target, via_parameters, "order", mounted_to_row, category, variable, mapping) VALUES ('cb6f6494-8230-4fdf-8092-c022a6ae03ac', '325e7262-43f7-4a57-b053-d17cb6852977', 'f46d9d65-acbf-4282-97d9-fb5f99540554', 'Copy', false, true, 40, false, 'MOUNTED_TO_ROW', NULL, NULL);
INSERT INTO public.tmp_action_link (id, parent_action_id, child_action_id, title, is_action_target, via_parameters, "order", mounted_to_row, category, variable, mapping) VALUES ('4b1dd225-e333-40af-ac61-9ce2f9f3cd6d', '9a327110-5e26-4d2a-8bc1-8eabeb2da397', '7e0fe3e1-4c70-44d3-8c85-c52e0d7b10ac', 'Description', false, false, 0, false, 'MOUNTED_TO_ROW', NULL, NULL);


--
-- PostgreSQL database dump complete
--

