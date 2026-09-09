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

INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('f438ec59-7e2c-45ef-b22a-0d8fc38f1bd5', 'ca0820f3-f92c-4612-9d3b-632bb9d2691b', '13a123c8-304b-403b-b851-55e7e79c00b4', '__object.id', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('782a33cf-8045-43a3-bf08-6de71cc69a1f', 'ca0820f3-f92c-4612-9d3b-632bb9d2691b', '89cebe88-12c6-42b8-a344-bb443169618f', '__object.key', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('46ec4456-111e-4d26-b70e-76d74c379464', 'ca0820f3-f92c-4612-9d3b-632bb9d2691b', '3d10589d-e938-4211-9af6-0d86df7a15bc', '__object.value', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('d530dec2-8781-4b7c-b45d-979e5653ee5f', '34aff2d3-e95e-4473-bf54-c2ce6092089a', 'bbe27d61-18c4-4917-8f2f-cbd94e331c51', '__object.id', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('1675416a-7952-4f89-9bd1-1639c73230ee', '2293c468-153e-446b-8d12-ee7a5283194b', 'be2244cc-aa58-bba6-18d5-797409c13a86', '__object.__view', NULL);


--
-- PostgreSQL database dump complete
--

