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
-- Name: tmp_column; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tmp_column (
    id uuid,
    action_id uuid,
    name character varying(50),
    path text,
    "order" integer
);


ALTER TABLE public.tmp_column OWNER TO postgres;

--
-- Data for Name: tmp_column; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('8a35a6f1-e3d9-3de6-c6f5-e2b438f2bd2d', '6265989e-67d2-68ef-9dee-12efe4a4d88d', 'Parent action name', 'parent_action_name', 10);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('e50bc655-5f30-06a7-cd25-0e260c187aba', '691dce23-aae8-e745-2f44-e5afad8996f6', 'Name', 'name', 1);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('ee5dc3c4-076e-9adc-6489-2c7055b7f2cf', '691dce23-aae8-e745-2f44-e5afad8996f6', 'Path', 'path', 2);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('63ac750e-91e2-9f2e-c4e6-a1877c0fc4c5', '691dce23-aae8-e745-2f44-e5afad8996f6', 'Order', 'order', 5);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('cdde6bfe-1996-530f-0aae-a0bb4e4148fa', '6265989e-67d2-68ef-9dee-12efe4a4d88d', 'Parent action code', 'parent_action_code', 20);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('09040d83-4c09-464f-de84-8221f0d78f0b', '6265989e-67d2-68ef-9dee-12efe4a4d88d', 'Child action name', 'child_action_name', 30);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('638b5079-cbb6-cb99-d0c6-564ad2005424', '6265989e-67d2-68ef-9dee-12efe4a4d88d', 'Child action code', 'child_action_code', 40);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('d40a89ae-6496-a7d9-f217-2d60741869bd', '6265989e-67d2-68ef-9dee-12efe4a4d88d', 'Child parmater title', 'title', 50);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('176bded1-a433-e48c-df25-7d3f9daf97a3', '6265989e-67d2-68ef-9dee-12efe4a4d88d', 'Parent action value', 'mapping', 60);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('39889453-09c7-8147-d3af-d1feadc3168c', '6265989e-67d2-68ef-9dee-12efe4a4d88d', 'Default value', 'default_value', 70);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('3477e23c-0b10-1265-da2d-da3ef8cb1669', '6265989e-67d2-68ef-9dee-12efe4a4d88d', 'Child parmater name', 'name', 80);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('7924ac9f-db2f-2b83-f3d3-edac083a70da', '6265989e-67d2-68ef-9dee-12efe4a4d88d', 'Child parmater type', 'type', 90);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('11643c64-df49-7f90-111a-113488f02101', '6265989e-67d2-68ef-9dee-12efe4a4d88d', 'Link title', 'link_title', 0);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('a2d712fe-f7ca-6e5b-3530-66cd2a696295', '924039ab-a63f-2ef3-2578-616eefe35c1b', 'Environment', 'link', 0);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('e9fb2a13-e777-a619-a5bb-34a3ba9669c1', '8d9f7add-2f20-0e56-7d53-5ea78c2ea052', 'Value', 'value', 2);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('92c89f74-fd88-1673-1213-26619383f529', '8d9f7add-2f20-0e56-7d53-5ea78c2ea052', '{title_for_property_column}', 'property', 1);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('00e9c810-8d8c-9ff0-6b8f-f5531e6bd8bc', '8d9f7add-2f20-0e56-7d53-5ea78c2ea052', '{title_for_group_column}', 'group', 0);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('69ab95b2-bcac-51a0-2123-11d093745775', '4b1d6290-beb8-f38a-dc57-a8801cff31cb', '{title_for_group_column}', 'link', 0);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('f584574e-0142-cf82-07c4-02f82ec78652', '081f536b-6882-46b1-bbf2-1fd976e4a3f5', 'Name', 'description', 0);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('c54b71e0-c320-2552-7ff3-1e205f7dc4e8', '081f536b-6882-46b1-bbf2-1fd976e4a3f5', 'URL', 'url', 2);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('ce19ef0b-1657-73ba-179a-bcfbf2c5bad7', '081f536b-6882-46b1-bbf2-1fd976e4a3f5', 'Login', 'login', 3);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('4ee8c90e-3487-0b3b-2009-5b61cd123484', '081f536b-6882-46b1-bbf2-1fd976e4a3f5', 'Type', 'type', 1);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('fee5ccd5-9ec7-8bc1-8529-74a9d86fe0e7', 'fa35b5dd-6e29-6474-3f10-07b684c06a62', 'Title', 'title', 0);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('c989b668-f3bc-603e-d1ed-64a0d58a56c7', 'fa35b5dd-6e29-6474-3f10-07b684c06a62', 'Parent action name', 'parent_action_name', 10);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('8fb33f97-27ce-e1a6-8df1-507cb77ffe3f', 'fa35b5dd-6e29-6474-3f10-07b684c06a62', 'Parent action code', 'parent_action_code', 20);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('73856421-715e-faf5-5b66-69d8a9adc1a6', 'fa35b5dd-6e29-6474-3f10-07b684c06a62', 'Child action name', 'child_action_name', 30);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('e2279a22-78a1-0aa2-9cd3-dee6e73c9a9a', 'fa35b5dd-6e29-6474-3f10-07b684c06a62', 'Child action code', 'child_action_code', 40);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('edbbf0d5-6ea3-19cc-7ca8-a27c8f08fa7a', 'fa35b5dd-6e29-6474-3f10-07b684c06a62', 'Order', 'order', 70);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('70ee0814-a029-62e3-565c-49cba25e27ed', 'fa35b5dd-6e29-6474-3f10-07b684c06a62', 'Open parameters tab', 'via_parameters', 60);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('939d88bc-d2f8-c938-88c0-f0473a0dcee0', 'fa35b5dd-6e29-6474-3f10-07b684c06a62', 'Group', 'group', 50);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('3267edf3-8cdd-56db-4ea1-a680f4ce6766', 'fa35b5dd-6e29-6474-3f10-07b684c06a62', 'Global link', 'global', 80);


--
-- PostgreSQL database dump complete
--

