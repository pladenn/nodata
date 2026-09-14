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



--
-- PostgreSQL database dump complete
--

