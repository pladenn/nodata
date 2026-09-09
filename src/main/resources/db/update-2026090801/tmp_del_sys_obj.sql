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

INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('01d482ce-b25e-4cd5-bbbe-cd2149df60ed', 'property_category', '42e5678d9c437f4dbd41903d04eb9e09');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('507b6ed7-c91f-4589-97a5-38d25f812842', 'property_category', '8cedbbc68f4b811e520dfc0e6e823824');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('dad7e0ad-b47a-4e6c-ae10-876bdb4a7cc1', 'action', '0e33fa0b989821e6d558227090888285');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('30bb03df-85fe-4c5d-bcaf-43c8b99044ba', 'action', 'e2d196fc5064b444841f3a3115f427f4');


--
-- PostgreSQL database dump complete
--

