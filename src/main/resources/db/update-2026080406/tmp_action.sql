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
-- Name: tmp_action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tmp_action (
    id uuid,
    code character varying(50),
    connection_id uuid,
    query text,
    content text,
    execution_type character varying(40),
    title text,
    post_process text,
    description text,
    redirect character varying,
    post_request boolean,
    name text
);


ALTER TABLE public.tmp_action OWNER TO postgres;

--
-- Data for Name: tmp_action; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('dad7e0ad-b47a-4e6c-ae10-876bdb4a7cc1', 'system-sub-menu-json', 'b16c7ed6-3beb-495c-b38e-337f9adec0a1', '/content/system/return-request-body/data/short/first', '[
    {
      "name": "System",
      "link": null,
      "items": [
        {
          "name": "Actions",
          "link": null,
          "items": [
            {
              "name": "All",
              "link": "/content/system/system-actions",
              "items": null
            },
            {
              "name": "System actions",
              "link": "/content/system/system-actions?connection_id=d48b9a97-e13c-4961-9eff-d76f39abdffb",
              "items": null
            }
          ]
        },
        {
          "name": "Connections",
          "link": null,
          "items": [
            {
              "name": "All",
              "link": "/content/system/system-connections",
              "items": null
            },
            {
              "name": "System connections",
              "link": "/content/system/system-connections?code=system%25",
              "items": null
            }
          ]
        },
        {
          "name": "Properties",
          "link": null,
          "items": [
            {
              "name": "Environments",
              "link": "/content/system/system-property-groups?category_code=context&title_for_group_column=Environment&description=Environments",
              "items": null
            },
            {
              "name": "All properties",
              "link": "/content/system/system-properties?category_code=context&title_for_group_column=Environment&title_for_property_column=Property+name",
              "items": null
            },
            {
              "name": "Dictionaries",
              "link": "/content/system/system-dictionaries",
              "items": null
            }
          ]
        },
        {
          "name": "Menu",
          "link": "/content/system/system-actions?id=&code=%25-sub-menu&connection_id=&system.action-code=system-actions",
          "items": null
        }
      ]
    }
  ]', 'HTTP_POST', 'System submenu JSON', NULL, NULL, NULL, false, NULL);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('b6512014-7f6c-4440-ab22-363a3bf4a351', 'return-request-body', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select ''{request-parameters.__request_body}'' content', NULL, 'HTTP_GET', 'return-request-body', NULL, NULL, NULL, false, NULL);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('570aeb3f-d237-2c20-154b-8d8415c87792', 'system-welcome', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select '''' as "-" where 1 = 2', NULL, 'SQL', 'Welcome! NoData for you.', NULL, 'Welcome! NoData for you.', NULL, false, 'Welcome! NoData for you.');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('2ec6e7bc-125d-19b8-4138-468bf5e6f994', 'system-sub-menu', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select
    (content::jsonb ->> ''content'')::jsonb menu
from http_get(''http://localhost:9944/content/system/system-sub-menu-json/data/short'')', NULL, 'SQL', 'System submenu', NULL, 'System submenu', NULL, false, 'System submenu');


--
-- PostgreSQL database dump complete
--

