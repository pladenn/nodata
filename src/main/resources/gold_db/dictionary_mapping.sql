create table dictionary_mapping
(
    id                      uuid not null
        primary key,
    action_parameter_id     uuid
        constraint dictionary_mapping_action_parameter_id_fk
            references parameter
            on delete cascade,
    dictionary_parameter_id uuid not null
        constraint dictionary_mapping_dictionary_parameter_id_fk
            references parameter
            on delete cascade,
    default_value           text,
    dictionary_id           uuid not null
        constraint dictionary_mapping_dictionary_id_fk
            references dictionary
            on delete cascade,
    constraint dictionary_mapping_u_dictionary_id_dictionary_parameter_id
        unique (dictionary_id, dictionary_parameter_id)
);

alter table dictionary_mapping
    owner to postgres;

INSERT INTO public.dictionary_mapping (id, action_parameter_id, dictionary_parameter_id, default_value, dictionary_id) VALUES ('3ea884cb-fe63-a99d-77f3-705d62d5d527', 'b6546e70-c556-b8b8-e2dd-839ad123e2eb', '1800c3cc-421d-9945-59c2-232920de29a9', null, '773a7609-ce29-64c4-be0d-435c2c871e65');
INSERT INTO public.dictionary_mapping (id, action_parameter_id, dictionary_parameter_id, default_value, dictionary_id) VALUES ('2a4ec2d8-8e7d-13e5-0de7-d2029ff5083d', null, '3a5b846b-61bf-3214-ffcc-53356ebd62f2', 'action_execution_type', '6fe052cd-9213-5a27-cdc0-86d97ceb6482');
INSERT INTO public.dictionary_mapping (id, action_parameter_id, dictionary_parameter_id, default_value, dictionary_id) VALUES ('a06c4249-3b59-befb-e5a0-f37f650b8cd8', null, '2deb2a5a-a28d-702e-c596-441453bc34f1', 'dictionaries', '6fe052cd-9213-5a27-cdc0-86d97ceb6482');
INSERT INTO public.dictionary_mapping (id, action_parameter_id, dictionary_parameter_id, default_value, dictionary_id) VALUES ('45bd20fb-73ae-b2c9-cd4d-e9783e8cc89d', null, '2deb2a5a-a28d-702e-c596-441453bc34f1', 'dictionaries', 'a8970074-67a1-c446-25e5-6e636cc5a5f5');
INSERT INTO public.dictionary_mapping (id, action_parameter_id, dictionary_parameter_id, default_value, dictionary_id) VALUES ('800856d7-9dba-a728-8b41-759125c35c9a', null, '3a5b846b-61bf-3214-ffcc-53356ebd62f2', 'action_execution_type', 'a8970074-67a1-c446-25e5-6e636cc5a5f5');
INSERT INTO public.dictionary_mapping (id, action_parameter_id, dictionary_parameter_id, default_value, dictionary_id) VALUES ('d0eda519-0931-05d0-9438-deb85e9b85c7', null, '2deb2a5a-a28d-702e-c596-441453bc34f1', 'dictionaries', '47cb4190-23ed-c579-6e97-3d250c25bee0');
INSERT INTO public.dictionary_mapping (id, action_parameter_id, dictionary_parameter_id, default_value, dictionary_id) VALUES ('89727b43-8a63-3b61-021b-5861689d623b', null, '3a5b846b-61bf-3214-ffcc-53356ebd62f2', 'connection-type', '47cb4190-23ed-c579-6e97-3d250c25bee0');
INSERT INTO public.dictionary_mapping (id, action_parameter_id, dictionary_parameter_id, default_value, dictionary_id) VALUES ('3b7f9caf-bc5a-e702-0cd6-57a26e0d04d3', null, '2deb2a5a-a28d-702e-c596-441453bc34f1', 'dictionaries', '70263629-a3e6-72e1-87ab-d71199c10d81');
INSERT INTO public.dictionary_mapping (id, action_parameter_id, dictionary_parameter_id, default_value, dictionary_id) VALUES ('cf68454c-b587-e034-2974-5023c6ec7c9b', null, '3a5b846b-61bf-3214-ffcc-53356ebd62f2', 'connection-type', '70263629-a3e6-72e1-87ab-d71199c10d81');
INSERT INTO public.dictionary_mapping (id, action_parameter_id, dictionary_parameter_id, default_value, dictionary_id) VALUES ('8e4ef175-9c1b-e6ff-d012-80acbb3b0fc9', null, '2deb2a5a-a28d-702e-c596-441453bc34f1', 'dictionaries', '1359a61a-fa65-9761-5add-ee1b4764e731');
INSERT INTO public.dictionary_mapping (id, action_parameter_id, dictionary_parameter_id, default_value, dictionary_id) VALUES ('5bb591e7-e21b-23f7-5ee1-05d3d9700bb5', null, '3a5b846b-61bf-3214-ffcc-53356ebd62f2', 'parameter_types', '1359a61a-fa65-9761-5add-ee1b4764e731');
INSERT INTO public.dictionary_mapping (id, action_parameter_id, dictionary_parameter_id, default_value, dictionary_id) VALUES ('9bc1abb4-eeca-f662-03f6-bf3d19e17d33', null, '3a5b846b-61bf-3214-ffcc-53356ebd62f2', 'parameter_types', '657b0777-34d4-a860-544c-969b97fcd19b');
INSERT INTO public.dictionary_mapping (id, action_parameter_id, dictionary_parameter_id, default_value, dictionary_id) VALUES ('c1b6a992-ae0f-d0de-caba-510574c7234f', null, '2deb2a5a-a28d-702e-c596-441453bc34f1', 'dictionaries', '657b0777-34d4-a860-544c-969b97fcd19b');
INSERT INTO public.dictionary_mapping (id, action_parameter_id, dictionary_parameter_id, default_value, dictionary_id) VALUES ('e41cdd22-3ce2-70c6-3c46-e86f12d7de82', '0d8ea4a9-b5b1-6595-c563-0a9f2bae3444', '8b54bd6d-7e4e-1e26-3dda-f781fe3bbfaa', null, '16f3717f-6fee-2f02-129d-72c25c8ec961');
INSERT INTO public.dictionary_mapping (id, action_parameter_id, dictionary_parameter_id, default_value, dictionary_id) VALUES ('0f4ef8ef-721e-9cde-6981-d7ac6715df2d', '4b41e33d-9eec-686c-d310-1087837c5878', 'a5b38ecf-9b44-689b-6a61-90fa20f435e1', null, '773a7609-ce29-64c4-be0d-435c2c871e65');
