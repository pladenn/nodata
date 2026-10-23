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

INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('a9609d87-9e48-48e5-8814-16d8dd454cd1', '6ab256a9-2004-4913-a0a6-22604e7a8715', '506f9d05-3d47-a150-d303-752236a81dee', '__object.table.full_table_name', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('d1594603-21a2-45eb-ab4d-f7e1aea5c2d6', '1464d1f7-7b1d-4a90-8843-582fcea86d18', '4fcf1957-3970-e137-1625-867f11488a5d', 'table', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('921723c3-0846-4613-be1f-00986962a6fd', 'e346f013-4653-49cf-9aa3-cc85c0b16b3b', '649fb33e-4f64-d732-bbb5-121e5a2b365d', '__object.login', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('abe9b49d-acba-3f46-35f2-5bb4b7d3e6e6', 'e346f013-4653-49cf-9aa3-cc85c0b16b3b', 'c39a4ca9-7842-eed2-245d-587a4de8f316', '__object.environment', NULL);


--
-- PostgreSQL database dump complete
--

