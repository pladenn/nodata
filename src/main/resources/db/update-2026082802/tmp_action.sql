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

INSERT INTO public.tmp_action (id, code, connection_id, query, content, execution_type, title, post_process, description, redirect, post_request, name) VALUES ('c6b6dafc-5a7c-4dcd-819c-888cd72396cb', 'system-upsert-action-link', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'DO $$
declare
    vals        jsonb;
    parent_eff  uuid;
    link_id     uuid;
    existing_id uuid;
    child_id    uuid;
    grp         varchar;
    jm          jsonb;
    m           jsonb;
    param_id    uuid;
begin
    select coalesce(jsonb_object_agg(sp.name, to_jsonb(sp)), jsonb_build_object())
      into vals
      from sql_block_parameters sp;

    child_id   := (vals -> ''child_action_id'' ->> ''uuid_value'')::uuid;
    grp        := nullif(trim(vals -> ''group'' ->> ''string_value''), '''');
    parent_eff := case when coalesce((vals -> ''global'' ->> ''boolean_value'')::boolean, false)
                       then null
                       else (vals -> ''parent_action_id'' ->> ''uuid_value'')::uuid end;

    if child_id is null then
        raise exception ''child_action_id is required'';
    end if;
    if not exists (select 1 from action where id = child_id) then
        raise exception ''no action with id % (child_action_id)'', child_id;
    end if;
    if grp not in (''MOUNTED_TO_ACTION'', ''MOUNTED_TO_ROW'') then
        raise exception ''group must be MOUNTED_TO_ACTION or MOUNTED_TO_ROW, got %'', grp;
    end if;

    -- upsert the link itself, keyed by (child, title, effective parent)
    select id into existing_id
    from action_link
    where child_action_id = child_id
      and title is not distinct from (vals -> ''title'' ->> ''string_value'')
      and parent_action_id is not distinct from parent_eff;

    if existing_id is null then
        link_id := gen_random_uuid();
        insert into action_link(id, parent_action_id, child_action_id, title, is_action_target,
                                 via_parameters, "order", mounted_to_row, category, variable, mapping)
        values (link_id, parent_eff, child_id, vals -> ''title'' ->> ''string_value'', false,
                coalesce((vals -> ''via_parameters'' ->> ''boolean_value'')::boolean, false),
                coalesce((vals -> ''order'' ->> ''integer_value'')::integer, 0),
                false, grp, null, null);
    else
        link_id := existing_id;
        update action_link set
            via_parameters = coalesce((vals -> ''via_parameters'' ->> ''boolean_value'')::boolean, false),
            "order"        = coalesce((vals -> ''order'' ->> ''integer_value'')::integer, 0),
            category       = grp
        where id = link_id;
    end if;

    -- mapping: JSON array of {"path": "...", "parameter_name": "..."}; replaces existing mappings wholesale
    jm := coalesce(nullif(vals -> ''mapping'' ->> ''string_value'', '''')::jsonb, ''[]''::jsonb);

    if exists (select 1 from jsonb_array_elements(jm) e
               where coalesce(e ->> ''path'', '''') = '''' or coalesce(e ->> ''parameter_name'', '''') = '''') then
        raise exception ''every mapping entry needs both path and parameter_name'';
    end if;

    delete from action_link_mapping where action_link_id = link_id;

    for m in select * from jsonb_array_elements(jm)
    loop
        select id into param_id from parameter
        where action_id = child_id and name = m ->> ''parameter_name'';

        if param_id is null then
            raise exception ''child action has no parameter named %'', m ->> ''parameter_name'';
        end if;

        insert into action_link_mapping(id, action_link_id, parameter_id, mapping, default_value)
        values (gen_random_uuid(), link_id, param_id, m ->> ''path'', null);
    end loop;
end $$;', NULL, 'SQL_BLOCK', NULL, NULL, 'Create-or-update an action_link plus its action_link_mapping rows in one call. group must be MOUNTED_TO_ACTION or MOUNTED_TO_ROW. mapping is a JSON array of {path, parameter_name} pairs. path is evaluated directly against the rows own JSON (same addressing as column.path) -- there is no row. prefix. Reference a top-level row column by its bare name, or drill into the nested full-row payload via __object.<path> (the rows __objekt/__object key), e.g. __object.wld_id or __object.chat.wld_id. Verified 2026-08-28 against coportal-customer-name -> ngage-chats: row.wld_id silently resolved to nothing, __object.wld_id worked. Mappings are replaced wholesale on every call. Upsert key: (child_action_id, title, effective parent_action_id).', '{request-parameters._original_url}', true, 'Upsert action link (with parameter mappings)');


--
-- PostgreSQL database dump complete
--

