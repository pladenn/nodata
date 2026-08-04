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
-- Name: tmp_connection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tmp_connection (
    id uuid,
    description text,
    type character varying(50),
    url text,
    login character varying(250),
    password character varying(250),
    code character varying
);


ALTER TABLE public.tmp_connection OWNER TO postgres;

--
-- Data for Name: tmp_connection; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tmp_connection (id, description, type, url, login, password, code) VALUES ('d48b9a97-e13c-4961-9eff-d76f39abdffb', 'System SQL', 'SQL', '{properties.system.data-base-url}', '{properties.system.data-base-username}', '{properties.system.data-base-password}', 'system-sql');
INSERT INTO public.tmp_connection (id, description, type, url, login, password, code) VALUES ('6fdfb5ed-816e-77a1-3e13-d84bbb452939', 'Any HTTP', 'HTTP', '{parameters.url}', NULL, NULL, 'system-any-http-request');
INSERT INTO public.tmp_connection (id, description, type, url, login, password, code) VALUES ('b16c7ed6-3beb-495c-b38e-337f9adec0a1', 'Sytem HTTP', 'HTTP', '{properties.system.localhost-http-url}', NULL, NULL, 'system-http');


--
-- PostgreSQL database dump complete
--

