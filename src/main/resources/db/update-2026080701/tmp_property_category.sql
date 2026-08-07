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
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('e67c58e3-6a18-f888-d7b8-3e79a340d851', '91b78475-df95-e996-f490-5fa510237dbb', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('cbe47a64-7232-4d03-efd2-4268fb9d2e24', 'ab69c504-e716-5bd6-f67e-11b186f98c49', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('3cea25cc-75b8-6aa1-eaaa-16c4bb21da10', 'cb2677d6-2334-cd9e-5fe8-b2d76a05360f', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('dc01e5cd-6ff2-b8ac-4f23-fc77fa6837ca', '280508e7-9ad9-0607-bf04-eee56d322ab7', 'connection properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('77749c5c-bb16-422b-97d2-87b0247613c6', 'f52aef46-d5be-4653-88b4-c74e23c9004e', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('f12e50a6-0653-4096-aff1-faa070dec34d', 'ed2ec51a-53c6-4b6d-b643-ca8dd9ccfe49', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('acb57bf3-efcd-4e7c-88d9-f823d7b994cf', '8226da50-68c5-4b39-98c0-d87a5870371e', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('7448ce28-28d0-4f35-924c-b26f37e427de', 'f777a55e-e019-44b3-bfdc-2df687195867', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('85ad1320-9730-47f3-81be-7efdc998d80e', 'f4261fc2-cfff-456d-bfc0-c886a3ef3c70', 'action properties');


--
-- PostgreSQL database dump complete
--

