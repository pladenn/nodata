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
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('16efc32f-eedc-4f40-8d42-8359c91e3a10', '69130fb8-abcc-43b9-a1dc-e1e9ae046fc1', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('0ca21d1a-2674-4aa9-bcfd-6ab11488ba1e', '2b9c7e2d-c035-4416-a0c4-8e2b3d8c069d', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('4b99e44b-4ecc-458d-b6a8-4ba034b072d2', '130ade7a-359d-4b02-a5fe-0858f5702e67', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('08e34d68-9b9a-4610-ad24-b0d59d7d1d07', '6e9e9e46-e340-430e-849e-2d8485a8dc5e', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('3144e5ed-4bdb-43d7-88dc-9f77365c4615', 'cccdac53-ba4b-4df8-96c1-b2c0c4ecbfd5', 'action properties');


--
-- PostgreSQL database dump complete
--

