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
-- Name: tmp_properties; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tmp_properties (
    id uuid,
    parent_id uuid,
    key character varying,
    value text
);


ALTER TABLE public.tmp_properties OWNER TO postgres;

--
-- Data for Name: tmp_properties; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('387b57d2-3fcd-485c-9777-913d51b8610c', NULL, 'storage', 'Storage');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('9a35de98-c28f-45c5-bb72-73548b6ab5d2', '387b57d2-3fcd-485c-9777-913d51b8610c', 'system-sub-menu-json', '[
    {
        "link": null,
        "name": "System",
        "items": [
            {
                "link": null,
                "name": "Actions",
                "items": [
                    {
                        "link": "/content/system/system-actions",
                        "name": "All",
                        "items": null
                    },
                    {
                        "link": "/content/system/system-actions?connection_id=d48b9a97-e13c-4961-9eff-d76f39abdffb",
                        "name": "System actions",
                        "items": null
                    }
                ]
            },
            {
                "link": null,
                "name": "Connections",
                "items": [
                    {
                        "link": "/content/system/system-connections",
                        "name": "All",
                        "items": null
                    },
                    {
                        "link": "/content/system/system-connections?code=system%25",
                        "name": "System connections",
                        "items": null
                    }
                ]
            },
            {
                "link": null,
                "name": "Properties",
                "items": [
                    {
                        "link": "/content/system/system-property-groups?category_code=context&title_for_group_column=Environment&description=Environments",
                        "name": "Environments",
                        "items": null
                    },
                    {
                        "link": "/content/system/system-properties?category_code=context&title_for_group_column=Environment&title_for_property_column=Property+name",
                        "name": "All properties",
                        "items": null
                    },
                    {
                        "link": "/content/system/system-dictionaries",
                        "name": "Dictionaries",
                        "items": null
                    }
                ]
            },
            {
                "link": "/content/system/system-actions?id=&code=%25-sub-menu&connection_id=&system.action-code=system-actions",
                "name": "Menu",
                "items": null
            },
            {
                "name": "Database catalog",
                "items": [
                    {
                        "code": "user-table-privileges",
                        "parameters": true
                    },
                    {
                        "code": "find-login-for-tables",
                        "parameters": true
                    },
                    {
                        "code": "table-ddl",
                        "parameters": true
                    },
                    {
                        "code": "catalog-connections",
                        "name": "Service connections",
                        "parameters": true
                    }
                ]
            },
            {
                "code": "system-tables-ddl",
                "name": "System DB tables"
            },
            {
                "code": "storage-entries",
                "name": "Storage"
            }
        ]
    }
]');
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('f011a155-fa7a-8451-ddf5-d3a360405f19', NULL, 'dictionaries', NULL);
INSERT INTO public.tmp_properties (id, parent_id, key, value) VALUES ('f74da10c-19be-4ac6-b03d-e50b3bba9bfa', '387b57d2-3fcd-485c-9777-913d51b8610c', 'custom-sub-menu-json', '[
    {
        "name": "Examples",
        "items": [
            {
                "link": "http://localhost:{properties.system.localhost-port}/content/system/system-welcome",
                "name": "Example"
            }
        ]
    }
]');


--
-- PostgreSQL database dump complete
--

