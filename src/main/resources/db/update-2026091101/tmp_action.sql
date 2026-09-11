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

INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('081f536b-6882-46b1-bbf2-1fd976e4a3f5', 'system-connections', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'select 
  con.description "Name",
  con.url "URL",
  con.login "Login",
  con.type "Type",
to_jsonb(con) __object
from connection con
where (con.id = :id or :id::uuid is null)
and (con.code like :code or :code::varchar is null)', NULL, 'SQL', 'Connections', NULL, 'Connections', NULL, false, 'Connections');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('f0a9485a-550a-4c5c-aa1f-c3d686cd1323', 'update-connection', '280508e7-9ad9-0607-bf04-eee56d322ab7', '
-- Update one row in the "Database structure" catalog connections table, by connections.id.
-- Row action mounted on catalog-connections (via_parameters=true, pre-filled from the row).

UPDATE connections
SET service_name = :service_name,
    environment  = :environment,
    url          = :url,
    login        = :login,
    password     = :password,
    active       = :active
WHERE id = :id::integer
', NULL, 'SQL_DML', NULL, NULL, 'Update one Database-structure catalog connection row, by connections.id. Row action mounted on catalog-connections.', '{request-parameters._original_url}', true, 'Update connection');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('3c8229ce-6f04-47e3-9b4f-888c0e355eb1', 'delete-connection', '280508e7-9ad9-0607-bf04-eee56d322ab7', '
-- Delete one row from the "Database structure" catalog connections table, by connections.id.
-- Row action mounted on catalog-connections (via_parameters=true).
-- Cascades to that connections privileges rows (privileges.connection_id ON DELETE CASCADE).

DELETE FROM connections
WHERE id = :id::integer
', NULL, 'SQL_DML', NULL, NULL, 'Delete one Database-structure catalog connection row, by connections.id (cascades to its privileges rows). Row action mounted on catalog-connections.', '{request-parameters._original_url}', true, 'Delete connection');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('6ae6cff9-d041-4ba8-83ba-3fc7bae39aac', 'create-connection', '280508e7-9ad9-0607-bf04-eee56d322ab7', '
-- Insert one row into the "Database structure" catalog connections table
-- (a service login to the shared PostgreSQL DB, one row per login x environment).
--
-- All of service_name/environment/url/login/password are required; active defaults to
-- false (matches the column default) if omitted -- pass active=true so the next manual
-- Tables.java catalog refresh picks this login up and records its table privileges/DDL.

INSERT INTO connections (service_name, environment, url, login, password, active)
VALUES (:service_name, :environment, :url, :login, :password, coalesce(:active::boolean, false))
', NULL, 'SQL_DML', NULL, NULL, 'Insert one service-login row into the Database-structure catalog''s connections table (service_name, environment, url, login, password, active).', '{request-parameters._original_url}', true, 'Create connection');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('9cc55a3e-b522-409b-a221-9aa163453ef5', 'call-any-select-sql', '20a9693e-d032-f7f1-d197-6f11ffab6ba7', '{request-parameters.__request_body}', NULL, 'SQL', NULL, NULL, NULL, NULL, true, 'Call any "select" SQL');
INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('2b9c7e2d-c035-4416-a0c4-8e2b3d8c069d', 'catalog-connections', '280508e7-9ad9-0607-bf04-eee56d322ab7', '-- Query behind the "database-catalog connections" endpoint.
--
-- Lists the service logins registered in the "Database structure" catalog: one row per
-- (service login x environment). This is the `connections` side of the catalog -- the privilege
-- matrix is `user-table-privileges` / `find-login-for-tables`, table structure is `table-ddl`.
--
-- Only connections with active = true are refreshed by the catalog loader, so an inactive row
-- may hold stale privileges; the flag is in __object.
--
-- Catalog table:
--   connections(id, service_name, environment, url, login, password, active)
--
-- Named parameters (ALL OPTIONAL -- omitted / blank / all-spaces disables that filter; multiple
-- filters combine with AND):
--   :logins  comma-separated MASKS, matched case-insensitively against BOTH `login` AND
--            `service_name`. A row matches if ANY mask hits EITHER column, so `woofer` finds
--            service_name `woofer` and login `woofer_app` alike. A mask with no `%` is a
--            SUBSTRING (wrapped as ILIKE ''%mask%''); a mask that CONTAINS a `%` is used as the
--            ILIKE pattern verbatim, so it can be anchored -- `chat%` = starts with,
--            `%_app` = ends with. Same mask rules as :tables in `table-ddl`.
--            (In a GET query string a literal `%` must be sent as `%25`.)
--   :envs    comma-separated MASKS, matched case-insensitively against `environment` (e.g.
--            `qa`, `stage`, `prod`). Same mask rules as :logins -- fuzzy substring unless the
--            mask itself contains `%`, ANY-of-masks. E.g. `envs=qa,prod` returns qa and prod
--            rows; `envs=sta` matches `stage` via substring.
--
-- Returns service_name, login, environment + the full catalog row in __object -- which also
-- carries id, url, the `active` refresh flag, and the connection''s PASSWORD.

SELECT c.service_name,
       c.login,
       c.environment,
       c.active,
       to_jsonb(c) AS __object
FROM connections c
WHERE (
    nullif(trim(:logins::varchar), '''') IS NULL
    OR EXISTS (SELECT 1
               FROM (SELECT CASE WHEN strpos(m, ''%'') > 0 THEN m ELSE ''%'' || m || ''%'' END AS pat
                     FROM (SELECT trim(x) AS m
                           FROM unnest(string_to_array(:logins::varchar, '','')) AS x) tok
                     WHERE m <> '''') p
               WHERE c.login ILIKE p.pat
                  OR c.service_name ILIKE p.pat)
  )
  AND (
    nullif(trim(:envs::varchar), '''') IS NULL
    OR EXISTS (SELECT 1
               FROM (SELECT CASE WHEN strpos(m, ''%'') > 0 THEN m ELSE ''%'' || m || ''%'' END AS pat
                     FROM (SELECT trim(x) AS m
                           FROM unnest(string_to_array(:envs::varchar, '','')) AS x) tok
                     WHERE m <> '''') p
               WHERE c.environment ILIKE p.pat)
  )
ORDER BY c.service_name NULLS LAST, c.login, c.environment
', NULL, 'SQL', 'Catalog connections', NULL, 'Service DB logins registered in the Database structure catalog; fuzzy mask search over login + service name and/or environment.', NULL, false, 'Catalog connections');


--
-- PostgreSQL database dump complete
--

