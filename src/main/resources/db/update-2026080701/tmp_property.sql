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

INSERT INTO public.tmp_property (id, "group", property, value, category_id) VALUES ('603e8daa-9700-12da-c3a1-f07face8734c', 'system', 'kb-db-password', 'postgres', '884504a5-53fe-4ace-a6a8-d7d6a9223a88');
INSERT INTO public.tmp_property (id, "group", property, value, category_id) VALUES ('84554b3c-b1be-3b8b-03a9-f7b9717066a4', 'system', 'kb-db-url', 'jdbc:postgresql://localhost:5432/kb', '884504a5-53fe-4ace-a6a8-d7d6a9223a88');
INSERT INTO public.tmp_property (id, "group", property, value, category_id) VALUES ('960ff040-0438-2501-f2a3-7e754bb70e76', 'system', 'kb-db-user', 'postgres', '884504a5-53fe-4ace-a6a8-d7d6a9223a88');


--
-- PostgreSQL database dump complete
--

