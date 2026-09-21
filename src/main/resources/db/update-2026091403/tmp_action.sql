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
-- Name: tmp_action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tmp_action (
    id uuid,
    code character varying(50),
    connection_id uuid,
    query text,
    content text,
    execution_type character varying(40),
    title text,
    post_process text,
    description text,
    redirect character varying,
    name text
);


ALTER TABLE public.tmp_action OWNER TO postgres;

--
-- Data for Name: tmp_action; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, name) VALUES ('34c300af-d7db-4a12-af75-9ce08869c950', '__storage-entry-update_parameters', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select p.id, p.key name, p.value data from properties p
where id = :id::uuid', NULL, 'SQL', NULL, NULL, NULL, NULL, '__storage-entry-update_parameters');


--
-- PostgreSQL database dump complete
--

