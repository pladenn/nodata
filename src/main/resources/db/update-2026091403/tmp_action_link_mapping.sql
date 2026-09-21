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
-- Name: tmp_action_link_mapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tmp_action_link_mapping (
    id uuid,
    action_link_id uuid,
    parameter_id uuid,
    mapping text,
    default_value character varying
);


ALTER TABLE public.tmp_action_link_mapping OWNER TO postgres;

--
-- Data for Name: tmp_action_link_mapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('65c3240e-317a-126f-1f0f-6170259d31ce', 'dfefffdc-ebde-3d84-d675-a47c5c4f5f5f', '3fb2c82a-129c-4e53-bc65-ddcfea395e91', 'id', NULL);


--
-- PostgreSQL database dump complete
--

