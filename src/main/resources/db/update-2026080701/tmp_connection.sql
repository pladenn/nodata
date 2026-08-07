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
-- Name: tmp_connection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tmp_connection (
    id uuid,
    description text,
    type character varying(50),
    url text,
    login character varying(250),
    password character varying(250),
    code character varying
);


ALTER TABLE public.tmp_connection OWNER TO postgres;

--
-- Data for Name: tmp_connection; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tmp_connection (id, description, type, url, login, password, code) VALUES ('280508e7-9ad9-0607-bf04-eee56d322ab7', 'Knowlege base', 'SQL', '{properties.system.kb-db-url}', '{properties.system.kb-db-user}', '{properties.system.kb-db-password}', 'knowlege-base');


--
-- PostgreSQL database dump complete
--

