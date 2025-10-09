create table tmp_column
(
    id        uuid,
    action_id uuid,
    name      varchar(50),
    path      text,
    "order"   integer
);

alter table tmp_column
    owner to postgres;

INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('b4c34961-3875-1ba3-b1ca-6b2ab872d8b6', '9a327110-5e26-4d2a-8bc1-8eabeb2da397', 'Connection type', 'connection_type', 4);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('4bb851ce-d12c-009f-65d2-6f97bfcb26ad', '9a327110-5e26-4d2a-8bc1-8eabeb2da397', 'Method', 'execution_type', 5);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('50c63ba4-1425-45ac-a5d4-0cfe9c7b1dcb', '9a327110-5e26-4d2a-8bc1-8eabeb2da397', 'Action code', 'code', 2);
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
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('65ab1991-3857-b36c-9cc2-4a82cac582c5', '9a327110-5e26-4d2a-8bc1-8eabeb2da397', 'Name', 'title', 1);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('c74ba6b4-441c-f8ab-d960-294fd2cdc9ac', '76b88064-d9ca-28f6-62c5-7f4bfe16fc40', 'Parmater title', 'parameter_title', 0);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('19615b37-2bba-46a7-b637-09eb2565c522', 'dfe67d96-5391-4534-aa8c-a706d985896c', 'Name', 'name', 30);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('512a8007-b5a6-b26d-705e-a03e39199a03', 'dfe67d96-5391-4534-aa8c-a706d985896c', 'Data type', 'type', 50);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('6a3206ab-6ee2-218f-aac0-90f62a73ed79', 'dfe67d96-5391-4534-aa8c-a706d985896c', 'Editable', 'editable', 60);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('d4360d57-93b0-3273-8c2a-bbaab0016de8', 'dfe67d96-5391-4534-aa8c-a706d985896c', 'Title', 'title', 20);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('5149579b-3b5b-5a86-b970-80418914b56b', 'dfe67d96-5391-4534-aa8c-a706d985896c', 'Dictionary code', 'dictionary_code', 200);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('8283b156-a692-7ac3-e2b2-a1f45f981116', 'dfe67d96-5391-4534-aa8c-a706d985896c', 'Order', 'order', 300);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('3f1b95b5-022e-9e59-4454-4cf74fba213b', 'dfe67d96-5391-4534-aa8c-a706d985896c', 'Dictionary editable', 'dictionary_editable', 150);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('7eb9f52b-f151-f20e-eb10-f627c75e867c', 'dfe67d96-5391-4534-aa8c-a706d985896c', 'Dictionary action', 'dictionary_name', 80);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('9e1da988-75c9-ce57-cfe1-e6dfc8f7d046', '9a327110-5e26-4d2a-8bc1-8eabeb2da397', 'Connection', 'connection_description', 3);
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
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('38f2009e-2282-46ea-f30b-ea4ee06f2c3c', '76b88064-d9ca-28f6-62c5-7f4bfe16fc40', 'Action name', 'action_name', 20);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('f0699e79-f1ad-1215-337b-97be784f2102', '76b88064-d9ca-28f6-62c5-7f4bfe16fc40', 'Action code', 'action_code', 30);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('c9f68a02-bb4f-6628-514c-54fad7bd4717', '76b88064-d9ca-28f6-62c5-7f4bfe16fc40', 'Dictionary name', 'dictionary_name', 40);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('41865e25-7480-54a4-6c66-00f51fa17be6', '76b88064-d9ca-28f6-62c5-7f4bfe16fc40', 'Dictionary code', 'dictionary_code', 50);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('eee38d0d-f5cf-42c4-5fcb-d89a52e5f1b0', '76b88064-d9ca-28f6-62c5-7f4bfe16fc40', 'Dictionary parameter title', 'dictionary_parameter_title', 60);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('1c43db64-40e3-9aa9-7ca4-aa2fad6ff37d', '76b88064-d9ca-28f6-62c5-7f4bfe16fc40', 'Dictionary parameter name', 'dictionary_parameter_name', 70);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('15285be6-5ff3-2175-6b4a-666c480519f0', '76b88064-d9ca-28f6-62c5-7f4bfe16fc40', 'Action parameter name', 'action_parameter_name', 90);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('1230ddc4-b882-35f9-a86a-6f91a1c535a2', '76b88064-d9ca-28f6-62c5-7f4bfe16fc40', 'Action parameter title', 'action_parameter_title', 80);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('dd6f39a7-58a8-89a8-038c-e516b03e6d96', '76b88064-d9ca-28f6-62c5-7f4bfe16fc40', 'Default value', 'default_value', 100);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('985d6964-c27c-474a-d045-21e4b82443c6', '76b88064-d9ca-28f6-62c5-7f4bfe16fc40', 'Parameter name', 'parmeter_name', 10);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('939d88bc-d2f8-c938-88c0-f0473a0dcee0', 'fa35b5dd-6e29-6474-3f10-07b684c06a62', 'Group', 'group', 50);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('3267edf3-8cdd-56db-4ea1-a680f4ce6766', 'fa35b5dd-6e29-6474-3f10-07b684c06a62', 'Global link', 'global', 80);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('d9fbe207-afdb-7b75-5f91-04fd993ba176', 'dfe67d96-5391-4534-aa8c-a706d985896c', 'Dictionary name column', 'name_column', 90);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('3e5baf28-e9bb-c73f-04df-54475ab242cd', 'dfe67d96-5391-4534-aa8c-a706d985896c', 'Dictionary value column', 'value_column', 100);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('182013b6-8286-f306-4794-fbc550df96b2', 'dfe67d96-5391-4534-aa8c-a706d985896c', 'Default value', 'default_value', 70);
INSERT INTO public.tmp_column (id, action_id, name, path, "order") VALUES ('8f4e8ef4-5c9b-e50a-61db-63e287f33c47', 'dfe67d96-5391-4534-aa8c-a706d985896c', 'Dictionary', 'dictionary_group', 85);
