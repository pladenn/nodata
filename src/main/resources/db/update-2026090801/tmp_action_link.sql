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
-- Name: tmp_action_link; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tmp_action_link (
    id uuid,
    parent_action_id uuid,
    child_action_id uuid,
    title text,
    is_action_target boolean,
    via_parameters boolean,
    "order" integer,
    mounted_to_row boolean,
    category character varying,
    variable character varying,
    mapping character varying
);


ALTER TABLE public.tmp_action_link OWNER TO postgres;

--
-- Data for Name: tmp_action_link; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tmp_action_link (id, parent_action_id, child_action_id, title, is_action_target, via_parameters, "order", mounted_to_row, category, variable, mapping) VALUES ('5a9981a4-a1a2-425c-a198-2d0b07bd29f3', '325e7262-43f7-4a57-b053-d17cb6852977', 'dec16dae-0b50-48f0-9252-8d130fc93a01', 'New entry', false, true, 1, false, 'MOUNTED_TO_ACTION', NULL, NULL);
INSERT INTO public.tmp_action_link (id, parent_action_id, child_action_id, title, is_action_target, via_parameters, "order", mounted_to_row, category, variable, mapping) VALUES ('ca0820f3-f92c-4612-9d3b-632bb9d2691b', '325e7262-43f7-4a57-b053-d17cb6852977', '9ae4808e-d6bd-47ed-a4b4-b76e40f46884', 'Edit', false, true, 2, false, 'MOUNTED_TO_ROW', NULL, NULL);
INSERT INTO public.tmp_action_link (id, parent_action_id, child_action_id, title, is_action_target, via_parameters, "order", mounted_to_row, category, variable, mapping) VALUES ('34aff2d3-e95e-4473-bf54-c2ce6092089a', '325e7262-43f7-4a57-b053-d17cb6852977', '1ca07cd8-9aa0-47f1-a7be-5747fd4a64df', 'Delete', false, true, 3, false, 'MOUNTED_TO_ROW', NULL, NULL);
INSERT INTO public.tmp_action_link (id, parent_action_id, child_action_id, title, is_action_target, via_parameters, "order", mounted_to_row, category, variable, mapping) VALUES ('2293c468-153e-446b-8d12-ee7a5283194b', '325e7262-43f7-4a57-b053-d17cb6852977', '84f7269c-68a3-b278-f5fc-d807a5f4b1e8', 'View', false, false, 0, false, 'MOUNTED_TO_ROW', NULL, NULL);


--
-- PostgreSQL database dump complete
--

