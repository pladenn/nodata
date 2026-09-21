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

INSERT INTO public.tmp_action_link (id, parent_action_id, child_action_id, title, is_action_target, via_parameters, "order", mounted_to_row, category, variable, mapping) VALUES ('dfefffdc-ebde-3d84-d675-a47c5c4f5f5f', '9ae4808e-d6bd-47ed-a4b4-b76e40f46884', '34c300af-d7db-4a12-af75-9ce08869c950', NULL, false, false, 0, false, 'PARAMETERS', 'PARAMETERS', NULL);


--
-- PostgreSQL database dump complete
--

