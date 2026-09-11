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

INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('360ab157-58cd-4872-35d3-362bcae7b872', 'action_link', 'd381b648b3660a972528deafe52a0b5f');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('1c097706-db1e-26c7-42d2-55333ea6feca', 'action_link', '6eef02b6ef0be3c46b8ee755e6e48d37');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('f584574e-0142-cf82-07c4-02f82ec78652', 'column', '541cee0c8aa86a302cd96cbb17ec4369');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('c54b71e0-c320-2552-7ff3-1e205f7dc4e8', 'column', 'e047f1ff1bba0556d5a7e5319cc8d384');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('ce19ef0b-1657-73ba-179a-bcfbf2c5bad7', 'column', '8b0aada9927f7718cb95b1a8af52292f');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('4ee8c90e-3487-0b3b-2009-5b61cd123484', 'column', 'b991ca3b1cff529dcac9c0b1745cf515');


--
-- PostgreSQL database dump complete
--

