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
-- Name: tmp_property; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tmp_property (
    id uuid,
    "group" character varying(50),
    property text,
    value text,
    category_id uuid
);


ALTER TABLE public.tmp_property OWNER TO postgres;

--
-- Data for Name: tmp_property; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- PostgreSQL database dump complete
--

