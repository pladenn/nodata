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

INSERT INTO public.tmp_property_category (id, code, name) VALUES ('f011a155-fa7a-8451-ddf5-d3a360405f19', 'dictionaries', 'dictionaries');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('b2dcb7f7-0daa-4718-b7e8-2b411d6e6f4e', '97775d1b-b328-4667-93b7-8a16fb054bcd', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('cfa3c748-ca89-403c-88e5-98f6b8e5ae28', 'c3532f35-be82-043c-7a80-700d5dc87d6f', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('758d15ac-6242-4599-9f5c-af6aa2a78ff1', '92cb9478-8f04-4e67-92b5-72c9c6063044', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('31d0005f-b7c5-49df-bec2-e5d85c8c0200', '4cdb1b7c-3913-4b60-a100-9fb659a06679', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('889769c6-6776-4f04-a051-01dc8c1f389f', 'b44a0e2b-ca69-44d0-9f02-7ae31e7d6103', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('8b66cb43-f7ea-4e67-8e1f-05cd245f48e2', '37ff260c-4cab-486c-9abc-0ef7c0f90198', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('e21a9886-ea63-48ee-bc1a-55a4b8d367c2', '2f8b4ebf-d425-4e6c-ae74-24b8d3ff6c2c', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('95bdfa1c-3328-4cbd-8cff-a5f2415889f5', '86e487cc-027c-4c09-9df2-6eed0f0fd1db', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('b2e8a2d1-d0de-480b-b735-8283f4b1f26a', 'f46d9d65-acbf-4282-97d9-fb5f99540554', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('4685dbba-f213-4cda-a28e-ebcb5e421ad9', '7e0fe3e1-4c70-44d3-8c85-c52e0d7b10ac', 'action properties');


--
-- PostgreSQL database dump complete
--

