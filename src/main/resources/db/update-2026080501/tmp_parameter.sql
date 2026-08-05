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

INSERT INTO public.tmp_parameter (id, action_id, name, type, default_value, title, editable, "order", dictionary_id, name_column, value_column, editable_dictionary, dict_null_value, description) VALUES ('bc7813db-e71f-474f-aba3-e2896c22df4e', 'b6512014-7f6c-4440-ab22-363a3bf4a351', '__request_body', 'TEXT', NULL, NULL, true, 0, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- PostgreSQL database dump complete
--

