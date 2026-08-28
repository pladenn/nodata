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

INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('d9fde150-0d0f-463d-b202-8e0594b2c9ff', 'properties', '5ef53d7b598b2a01b28d5afb9260bf22');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('613e3a30-baa6-46e4-808b-11f7ff0d747d', 'property', '751bcdd98918255b5a0bcb8cb5deadc7');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('c80d7dbe-eb25-d138-a5be-27d81ebcf681', 'action_link', '6a7804eaa9688ed54cb6e87be773466f');


--
-- PostgreSQL database dump complete
--

