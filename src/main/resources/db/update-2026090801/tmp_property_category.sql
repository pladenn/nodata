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

INSERT INTO public.tmp_property_category (id, code, name) VALUES ('bee2fe12-0c60-4391-8043-6c405d90e9eb', '1ca07cd8-9aa0-47f1-a7be-5747fd4a64df', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('f011a155-fa7a-8451-ddf5-d3a360405f19', 'dictionaries', 'dictionaries');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('8394ef33-f78c-477e-b64b-1649b3591394', '06d9ecd0-41b1-4e99-96b2-a6e13cf513d2', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('c89ba9b9-d279-4df1-ac1f-db0ac2550fcf', '325e7262-43f7-4a57-b053-d17cb6852977', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('c9f020c4-095e-4d18-a6a7-ff3f9b557e82', 'dec16dae-0b50-48f0-9252-8d130fc93a01', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('ed77da1a-8bd7-42f7-9973-8217b3dee803', '9ae4808e-d6bd-47ed-a4b4-b76e40f46884', 'action properties');


--
-- PostgreSQL database dump complete
--

