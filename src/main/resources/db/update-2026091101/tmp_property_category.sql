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
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('b9032792-e209-81e9-e83c-3f1d145553c8', '20a9693e-d032-f7f1-d197-6f11ffab6ba7', 'connection properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('2fcbf092-de62-4142-8dfe-754ac288fcf0', '9cc55a3e-b522-409b-a221-9aa163453ef5', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('a2efc46a-8b92-4e1b-a51c-68c4740963de', '6ae6cff9-d041-4ba8-83ba-3fc7bae39aac', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('4f5c93c3-486a-4ba2-a8aa-0d9800357e47', 'f0a9485a-550a-4c5c-aa1f-c3d686cd1323', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('915039b7-c038-496b-baff-42724b4744c0', '3c8229ce-6f04-47e3-9b4f-888c0e355eb1', 'action properties');


--
-- PostgreSQL database dump complete
--

