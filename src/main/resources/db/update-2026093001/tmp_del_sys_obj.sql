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

INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('0cdfbf80-b24a-48c6-b01e-b73e4c4594ed', 'properties', '41df75b575c7766be52942a989805ed1');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('16efc32f-eedc-4f40-8d42-8359c91e3a10', 'property_category', '82908b496013f13b475fe6ccdcf5e5ea');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('69130fb8-abcc-43b9-a1dc-e1e9ae046fc1', 'action', 'c4463ee4d31dfc1ce31790fd5b4bad90');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('8a35a6f1-e3d9-3de6-c6f5-e2b438f2bd2d', 'column', 'ffd1304c8e6e0eec6d7e774491802a09');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('cdde6bfe-1996-530f-0aae-a0bb4e4148fa', 'column', 'be2c749d2d561851be50df33d8ad19e4');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('09040d83-4c09-464f-de84-8221f0d78f0b', 'column', '4182cb43a1a22df2d640c40bcaaadae3');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('638b5079-cbb6-cb99-d0c6-564ad2005424', 'column', '3680e41140d43628bf6c3ebb273ed69d');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('d40a89ae-6496-a7d9-f217-2d60741869bd', 'column', 'c2c86dd707510ba5b9478fe84f5a6ee3');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('176bded1-a433-e48c-df25-7d3f9daf97a3', 'column', 'f2236266f25a2e450859b1570b0e7d6a');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('39889453-09c7-8147-d3af-d1feadc3168c', 'column', 'e3eb41d3bed8e5d0d1191af2e8cef173');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('3477e23c-0b10-1265-da2d-da3ef8cb1669', 'column', '0b1d5f9643b36cec3126bfa391868105');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('7924ac9f-db2f-2b83-f3d3-edac083a70da', 'column', '26e36bd440688acbc1a34902735b1390');
INSERT INTO public.tmp_del_sys_obj (id, tbl, hash) VALUES ('11643c64-df49-7f90-111a-113488f02101', 'column', 'e8a0888d4fa85d69265b698807c44a23');


--
-- PostgreSQL database dump complete
--

