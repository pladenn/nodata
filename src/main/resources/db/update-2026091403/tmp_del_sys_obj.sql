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
-- Name: tmp_del_sys_obj; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tmp_del_sys_obj (
    id uuid,
    tbl text,
    hash text
);


ALTER TABLE public.tmp_del_sys_obj OWNER TO postgres;

--
-- Data for Name: tmp_del_sys_obj; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('782a33cf-8045-43a3-bf08-6de71cc69a1f', 'action_link_mapping', 'bc248b62393067439a6ad1f9eba8effe');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('46ec4456-111e-4d26-b70e-76d74c379464', 'action_link_mapping', '5f0f061af5bcaf46402c2e9451bb57ba');


--
-- PostgreSQL database dump complete
--

