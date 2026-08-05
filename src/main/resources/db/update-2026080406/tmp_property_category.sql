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
-- Name: tmp_property_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tmp_property_category (
    id uuid,
    code character varying,
    name character varying
);


ALTER TABLE public.tmp_property_category OWNER TO postgres;

--
-- Data for Name: tmp_property_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tmp_property_category (id, code, name) VALUES ('f011a155-fa7a-8451-ddf5-d3a360405f19', 'dictionaries', 'dictionaries');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('01d482ce-b25e-4cd5-bbbe-cd2149df60ed', 'dad7e0ad-b47a-4e6c-ae10-876bdb4a7cc1', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('a2fe3ffd-6f2c-430d-8000-01fda28ab81f', 'b6512014-7f6c-4440-ab22-363a3bf4a351', 'action properties');


--
-- PostgreSQL database dump complete
--

