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
-- Name: tmp_action_link_mapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tmp_action_link_mapping (
    id uuid,
    action_link_id uuid,
    parameter_id uuid,
    mapping text,
    default_value character varying
);


ALTER TABLE public.tmp_action_link_mapping OWNER TO postgres;

--
-- Data for Name: tmp_action_link_mapping; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('d5a60112-6d17-2487-cd1a-d6d6542cc804', '72ad5238-5cb5-8db0-9181-00c47bfb88aa', 'cb93fbd4-0444-2f00-419c-7b1a7eeaaeff', '__object.description', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('fd8ba6e1-7fda-b1ab-efbc-ad2add7103c6', '72ad5238-5cb5-8db0-9181-00c47bfb88aa', 'c7aa9ef0-db43-5c34-d0bb-bd89a13977c9', '__object.type', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('06d9d33a-c72c-e7a0-274b-a3bd5f91b3cb', '9d3eabc1-6ca6-eb86-e724-7b47fe6a23d9', 'c5a226f0-4c04-4aa4-b33c-2a6da8278b5d', 'environment', '___');
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('92c625d1-d5d7-4005-bd76-2f7c18a1238f', '164cf393-5246-4f8f-82ba-6ab33df3c6ce', '1d0ffa69-d5be-41f4-b672-64a38ffafd1f', '__object.id', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('1122963b-9eba-4683-b432-cf44c3c6cdcd', '164cf393-5246-4f8f-82ba-6ab33df3c6ce', '2a4c002f-5bbb-42fd-8ba4-1b144aa158a9', '__object.service_name', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('1e5039eb-a72b-4b88-8890-40b7dc8158e6', '164cf393-5246-4f8f-82ba-6ab33df3c6ce', '73351be7-3e7b-4c4b-8697-bef1f4c9b2f6', '__object.environment', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('15ec7919-df32-421d-9b18-8f9f65989700', '164cf393-5246-4f8f-82ba-6ab33df3c6ce', '4bbef206-22dc-4fc0-aa19-0624bc7a1a15', '__object.url', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('3b60cd00-aaf5-4fa0-a261-96fb8ad818b4', '164cf393-5246-4f8f-82ba-6ab33df3c6ce', '7eeb113f-ac67-4734-9ad0-bba88a9c11b8', '__object.login', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('26061ef4-ba7a-4f8f-a7ae-a9a53977db8e', '164cf393-5246-4f8f-82ba-6ab33df3c6ce', 'dc09758b-4367-41e1-9f2c-83d4d0db38ab', '__object.password', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('5578469e-ae13-4d50-9f1e-576a82eb84cd', '164cf393-5246-4f8f-82ba-6ab33df3c6ce', '46385928-339a-4a04-81a1-aea8323c2be4', '__object.active', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('04d28d2e-325d-436d-88dd-ff7af8e196a7', '07ce8145-db77-4240-917d-8f17de5e71ff', '75a6b33c-b4bb-4e89-8b41-c82b96ab64ef', '__object.id', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('0e7968da-757e-57c8-a387-da4d95b15c5a', '94995f06-8371-04fe-7e73-21fef4d20485', '42db8f25-e852-6c01-85f0-5be09a6dd2a4', '__object.description', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('efa35064-bd63-d4d7-e79b-5f0685974162', '94995f06-8371-04fe-7e73-21fef4d20485', '47a1a676-2a66-451f-106f-0624eaa15296', '__object.type', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('3b6f5dc6-9327-f243-0773-5329e3246024', '94995f06-8371-04fe-7e73-21fef4d20485', '097f49f4-7233-1fa8-2bc2-b5ec7f2628fc', '__object.login', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('db1d3451-1b19-e72a-f22d-b27d922e2761', '94995f06-8371-04fe-7e73-21fef4d20485', '966b738e-052c-4dc7-8e5d-ac201789d936', '__object.url', NULL);
INSERT INTO public.tmp_action_link_mapping (id, action_link_id, parameter_id, mapping, default_value) VALUES ('9392de48-4f19-41e8-1035-ecaa6f3631cb', '9d3eabc1-6ca6-eb86-e724-7b47fe6a23d9', '55337ffa-b990-444c-8a99-27a895008b39', 'login', '___');


--
-- PostgreSQL database dump complete
--

