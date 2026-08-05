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

INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('b6512014-7f6c-4440-ab22-363a3bf4a351', 'return-request-body', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select :__request_body content', NULL, 'HTTP_GET', 'return-request-body', NULL, NULL, NULL, false, NULL);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('30bb03df-85fe-4c5d-bcaf-43c8b99044ba', 'custom-sub-menu-json', 'b16c7ed6-3beb-495c-b38e-337f9adec0a1', '/content/system/return-request-body/data/short/first', '        [
          {
            "name": "Examples",
            "items": [
              {
                "name": "Example",
                "link": "http://localhost:{properties.system.localhost-port}/content/system/system-welcome"
              }
            ]
          }
        ]
', 'HTTP_POST', 'Custom submenu JSON', NULL, NULL, NULL, false, NULL);
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('8096367c-cc1a-473e-a9d0-33041aa92d61', 'system-create-action', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'DO $$declare
    id uuid;
    title varchar;
    code varchar;
    connection_id uuid;
    query varchar;
    content varchar;
    execution_type varchar;
    post_process varchar;
    description varchar;
    redirect varchar;
BEGIN
    select string_value into title from sql_block_parameters where name = ''title'';
    select string_value into code from sql_block_parameters where name = ''code'';
    select uuid_value::uuid into connection_id from sql_block_parameters where name = ''connection_id'';
    select string_value into query from sql_block_parameters where name = ''query'';
    select string_value into content from sql_block_parameters where name = ''content'';
    select string_value into execution_type from sql_block_parameters where name = ''execution_type'';
    select string_value into post_process from sql_block_parameters where name = ''post_process'';

    id = gen_random_uuid();

    INSERT INTO public.action
    VALUES (id,
            code,
            connection_id, query, content, execution_type,
            case when coalesce(trim(title), '''') = '''' then code else title end,
            post_process,
            description,
            redirect);

    insert into parameter(id,action_id,name,type,"order")
    with param as (
    select
        distinct
        lower(m[1]) as parameter_name,
        nullif(m[2], '''') as parameter_type
    from (
             select regexp_matches(
                        query,
                        '':([a-zA-Z_]\w*)(?:::(?![:])([a-zA-Z_]\w*))?'',
                        ''g''
             ) as m
   ) sub)

    select
        gen_random_uuid(),
        id action_id,
        r.*,
        (ROW_NUMBER() OVER ())*10 AS row_num        
    from
    (select
        distinct
        p.parameter_name,
        coalesce(
        case upper(pt.parameter_type)
            when ''INT'' then ''INTEGER''
            when ''VARCHAR'' then ''STRING''
            else upper(pt.parameter_type)
        end, ''_INSERTED'') parameter_type
    from param p
    left join param pt on p.parameter_name = pt.parameter_name and pt.parameter_type is not null) r
;

    insert into property_category values(gen_random_uuid(), id, ''action properties'');

END $$', NULL, 'SQL_BLOCK', 'Create action', NULL, 'Create action', '/content/system/system-actions?code={request-parameters.code}', true, 'Create action');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('2ec6e7bc-125d-19b8-4138-468bf5e6f994', 'system-sub-menu', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select
    (content::jsonb ->> ''content'')::jsonb menu
from http_get(''{properties.system.localhost-http-url}/content/system/system-sub-menu-json/data/short'')', NULL, 'SQL', 'System submenu', NULL, 'System submenu', NULL, false, 'System submenu');


--
-- PostgreSQL database dump complete
--

