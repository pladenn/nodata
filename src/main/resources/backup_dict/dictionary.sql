create table dictionary
(
    id           uuid                  not null
        primary key,
    parameter_id uuid                  not null
        constraint dictionary_parameter_uk
            unique
        constraint dictionary_parameter_fk
            references parameter
            on delete cascade,
    action_id    uuid                  not null
        constraint dictionary_action_fk
            references action
            on delete cascade,
    name_column  text,
    value_column text,
    editable     boolean,
    null_value   boolean default false not null
);

alter table dictionary
    owner to postgres;

INSERT INTO public.dictionary (id, parameter_id, action_id, name_column, value_column, editable, null_value) VALUES ('773a7609-ce29-64c4-be0d-435c2c871e65', 'a5b997db-c1b9-5e87-2083-cb3e98fa40e3', '4b1d6290-beb8-f38a-dc57-a8801cff31cb', null, null, true, false);
INSERT INTO public.dictionary (id, parameter_id, action_id, name_column, value_column, editable, null_value) VALUES ('a8970074-67a1-c446-25e5-6e636cc5a5f5', 'd8f69853-f7a0-8714-b452-361638d5c1dc', '8d9f7add-2f20-0e56-7d53-5ea78c2ea052', null, null, null, false);
INSERT INTO public.dictionary (id, parameter_id, action_id, name_column, value_column, editable, null_value) VALUES ('26fe3aa9-d962-7c25-9e74-463b48de0145', '98a3d843-60fa-cf4a-750e-d73724b539aa', '9a327110-5e26-4d2a-8bc1-8eabeb2da397', 'title', 'id', null, false);
INSERT INTO public.dictionary (id, parameter_id, action_id, name_column, value_column, editable, null_value) VALUES ('28a7cdf6-5eb9-3eee-2be2-08df1246e70e', '6a470095-73dc-15ea-c076-4e3ce6b4fc0b', '9a327110-5e26-4d2a-8bc1-8eabeb2da397', 'title', 'id', null, false);
INSERT INTO public.dictionary (id, parameter_id, action_id, name_column, value_column, editable, null_value) VALUES ('13881a4d-b36d-ad76-6489-2c9cfb7f8c13', '61b25268-6239-6b63-d7ff-bc9ac4b4252d', '9a327110-5e26-4d2a-8bc1-8eabeb2da397', 'title', 'id', null, false);
INSERT INTO public.dictionary (id, parameter_id, action_id, name_column, value_column, editable, null_value) VALUES ('47cb4190-23ed-c579-6e97-3d250c25bee0', 'e8b48da7-177b-3a38-3051-cdbc61e6b57b', '8d9f7add-2f20-0e56-7d53-5ea78c2ea052', null, null, null, false);
INSERT INTO public.dictionary (id, parameter_id, action_id, name_column, value_column, editable, null_value) VALUES ('70263629-a3e6-72e1-87ab-d71199c10d81', '47a1a676-2a66-451f-106f-0624eaa15296', '8d9f7add-2f20-0e56-7d53-5ea78c2ea052', null, null, null, false);
INSERT INTO public.dictionary (id, parameter_id, action_id, name_column, value_column, editable, null_value) VALUES ('360ab157-58cd-4872-35d3-362bcae7b872', '26d76ab7-a74d-bede-7fd5-dd503175b2fa', '081f536b-6882-46b1-bbf2-1fd976e4a3f5', 'description', 'id', null, false);
INSERT INTO public.dictionary (id, parameter_id, action_id, name_column, value_column, editable, null_value) VALUES ('1c097706-db1e-26c7-42d2-55333ea6feca', 'de5364f5-47fa-a93f-3b03-4a7f15d0ae9d', '081f536b-6882-46b1-bbf2-1fd976e4a3f5', 'description', 'id', null, false);
INSERT INTO public.dictionary (id, parameter_id, action_id, name_column, value_column, editable, null_value) VALUES ('1359a61a-fa65-9761-5add-ee1b4764e731', '07bc356c-3bad-3352-6781-fdfd3187c53c', '8d9f7add-2f20-0e56-7d53-5ea78c2ea052', null, null, null, false);
INSERT INTO public.dictionary (id, parameter_id, action_id, name_column, value_column, editable, null_value) VALUES ('657b0777-34d4-a860-544c-969b97fcd19b', '1d939070-a377-dc92-2852-76c632e9427f', '8d9f7add-2f20-0e56-7d53-5ea78c2ea052', null, null, null, false);
INSERT INTO public.dictionary (id, parameter_id, action_id, name_column, value_column, editable, null_value) VALUES ('16f3717f-6fee-2f02-129d-72c25c8ec961', '430785d0-f6c9-eb82-ef44-82c17858d243', 'dfe67d96-5391-4534-aa8c-a706d985896c', 'title', 'id', null, false);
