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

INSERT INTO public.tmp_action_link (id, parent_action_id, child_action_id, title, is_action_target, via_parameters, "order", mounted_to_row, category, variable, mapping) VALUES ('9d3eabc1-6ca6-eb86-e724-7b47fe6a23d9', '9cc55a3e-b522-409b-a221-9aa163453ef5', '2b9c7e2d-c035-4416-a0c4-8e2b3d8c069d', NULL, false, false, 0, false, 'DATA', 'credentials', '0.__object');
INSERT INTO public.tmp_action_link (id, parent_action_id, child_action_id, title, is_action_target, via_parameters, "order", mounted_to_row, category, variable, mapping) VALUES ('164cf393-5246-4f8f-82ba-6ab33df3c6ce', '2b9c7e2d-c035-4416-a0c4-8e2b3d8c069d', 'f0a9485a-550a-4c5c-aa1f-c3d686cd1323', 'Update connection', false, true, 1, false, 'MOUNTED_TO_ROW', NULL, NULL);
INSERT INTO public.tmp_action_link (id, parent_action_id, child_action_id, title, is_action_target, via_parameters, "order", mounted_to_row, category, variable, mapping) VALUES ('07ce8145-db77-4240-917d-8f17de5e71ff', '2b9c7e2d-c035-4416-a0c4-8e2b3d8c069d', '3c8229ce-6f04-47e3-9b4f-888c0e355eb1', 'Delete connection', false, true, 2, false, 'MOUNTED_TO_ROW', NULL, NULL);
INSERT INTO public.tmp_action_link (id, parent_action_id, child_action_id, title, is_action_target, via_parameters, "order", mounted_to_row, category, variable, mapping) VALUES ('2ae120fd-26c2-5a1b-d07b-3839345b3b9f', '8096367c-cc1a-473e-a9d0-33041aa92d61', '081f536b-6882-46b1-bbf2-1fd976e4a3f5', NULL, false, false, 0, false, 'DICTIONARY', NULL, NULL);
INSERT INTO public.tmp_action_link (id, parent_action_id, child_action_id, title, is_action_target, via_parameters, "order", mounted_to_row, category, variable, mapping) VALUES ('bea93896-df65-c91f-6473-5a255de071e2', 'a01761a0-988e-3f81-ccb9-6b92c2ccf1df', '081f536b-6882-46b1-bbf2-1fd976e4a3f5', NULL, false, false, 0, false, 'DICTIONARY', NULL, NULL);


--
-- PostgreSQL database dump complete
--

