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

INSERT INTO public.tmp_action_link (id, parent_action_id, child_action_id, title, is_action_target, via_parameters, "order", mounted_to_row, category, variable, mapping) VALUES ('1464d1f7-7b1d-4a90-8843-582fcea86d18', 'cb2677d6-2334-cd9e-5fe8-b2d76a05360f', 'ab69c504-e716-5bd6-f67e-11b186f98c49', 'Privileges', false, false, 1, false, 'MOUNTED_TO_ROW', NULL, NULL);
INSERT INTO public.tmp_action_link (id, parent_action_id, child_action_id, title, is_action_target, via_parameters, "order", mounted_to_row, category, variable, mapping) VALUES ('e346f013-4653-49cf-9aa3-cc85c0b16b3b', '2b9c7e2d-c035-4416-a0c4-8e2b3d8c069d', 'ab69c504-e716-5bd6-f67e-11b186f98c49', 'Privileges', false, false, 3, false, 'MOUNTED_TO_ROW', NULL, NULL);
INSERT INTO public.tmp_action_link (id, parent_action_id, child_action_id, title, is_action_target, via_parameters, "order", mounted_to_row, category, variable, mapping) VALUES ('6ab256a9-2004-4913-a0a6-22604e7a8715', 'ab69c504-e716-5bd6-f67e-11b186f98c49', 'cb2677d6-2334-cd9e-5fe8-b2d76a05360f', 'Table DDL', false, false, 0, false, 'MOUNTED_TO_ROW', NULL, NULL);


--
-- PostgreSQL database dump complete
--

