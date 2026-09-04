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

INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('98528720-db41-4104-9816-4426a596e4e3', '97da339c-6517-44fa-8ae8-12c22ef90bba', 'be2244cc-aa58-bba6-18d5-797409c13a86', '__object.__view', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('002863f7-8e4b-46bd-9362-62955be6bfd7', '28d82364-db14-4de6-b234-a1c672ec1aa6', '55cb3479-40b7-4aa2-ad6e-c25ae9323f79', '__object.id', NULL);


--
-- PostgreSQL database dump complete
--

