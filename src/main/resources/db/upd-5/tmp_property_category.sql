create table tmp_property_category
(
    id   uuid,
    code varchar,
    name varchar
);

alter table tmp_property_category
    owner to postgres;

INSERT INTO public.tmp_property_category (id, code, name) VALUES ('f011a155-fa7a-8451-ddf5-d3a360405f19', 'dictionaries', 'dictionaries');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('884504a5-53fe-4ace-a6a8-d7d6a9223a88', 'context', 'context');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('88e566f7-1a23-9cfb-b611-977739327e20', 'b16c7ed6-3beb-495c-b38e-337f9adec0a1', 'connection');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('6aa49c7d-d5cd-c242-4b79-cba5c60d2954', 'd48b9a97-e13c-4961-9eff-d76f39abdffb', 'connection');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('b80aeca5-3f1f-b1d1-1a07-9a8ecde1e926', '4b1d6290-beb8-f38a-dc57-a8801cff31cb', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('697cabea-7525-4045-8938-5af8b395755b', '27a15286-7c9e-fb12-b406-bc42ab29510c', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('d9e3fb6b-ecac-09ed-563a-9e4910573d56', 'a45d744d-339c-08f2-6993-8841e28f78fd', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('b739366f-c9e8-f2a6-a64d-2806fc7a730b', '3d6fcc69-8b4f-c653-e23a-231452862ad7', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('87a7bd4d-2a83-1060-50b9-23726b63597d', 'a01761a0-988e-3f81-ccb9-6b92c2ccf1df', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('d79049ea-2439-baee-4bad-9911f74eef60', 'eb109b97-5fa6-2712-e517-b10d07976ca8', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('a0f3b971-9825-f469-2168-ab8074944c3d', '4941d454-dc50-177f-e125-f5b031134fba', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('4981478f-f089-5b92-4440-97e9a3a05abc', 'e6ea59cd-7b58-6a9f-9ddb-01f03de167f2', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('fd4ebccd-5ec1-0e45-616a-ffa9a99fe3e0', 'b0078e88-3425-ea62-606f-774f538bbcd9', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('a0c17d6e-b28a-15f3-b384-19c07afa7159', '081f536b-6882-46b1-bbf2-1fd976e4a3f5', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('57c5d848-1fb5-f117-8243-1d75c05e466f', '4d45abd8-7edc-5b5b-b08f-1a0c151a722a', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('c5cb2633-2735-3c1f-79f3-c1d17f00ebeb', '4141be2c-75e0-0384-c45f-a619e4fa131c', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('e9875c41-86d4-01d3-6891-92a2c45aa623', '37cac08c-9f8c-3bf5-803c-1303a1129555', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('235d3a29-2d7e-27b7-0029-47cb6138dacd', '3310ffca-f928-e81b-2a9f-b0bd59d89225', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('78a89488-dc5d-af42-ef4a-002e010cfc3f', 'b47c0f1f-5569-083f-ca7a-14d9a6736e4d', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('1ff9e33b-72fc-8d40-209c-58833ad2cb8d', '09a56638-c975-3b7b-2127-818ab535fc63', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('49c8567f-c088-0471-bb83-e1d1482fbc46', '1b4e4d25-adc9-c116-ba99-1463ad51cec6', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('6d0f1247-e398-03b4-aa5e-269ade84af52', 'e587b6a0-ef4c-2f7b-4a69-5c8fc19f22f2', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('0000c424-fa86-5e59-ea6c-bda46c08577c', '691dce23-aae8-e745-2f44-e5afad8996f6', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('81d655fb-cf15-aad1-f358-dbcb6aa40e08', '76b88064-d9ca-28f6-62c5-7f4bfe16fc40', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('b38e69cf-7a07-ee9d-128b-d615887db60c', 'fa35b5dd-6e29-6474-3f10-07b684c06a62', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('fe093ad7-7b0b-9b2c-9200-fde2871fae27', 'ba7829af-09a9-e951-90fa-d04171739f46', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('d6a0d1f6-ec22-c10f-1164-20a08b1c84b0', '924039ab-a63f-2ef3-2578-616eefe35c1b', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('c366e06e-491c-8148-5410-9bdb3d8ef60b', '9a327110-5e26-4d2a-8bc1-8eabeb2da397', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('5b6c1f3b-35e7-c051-4abe-1a564d5af2b3', '5dfc355d-bd88-c1c1-50e8-d67d5ad682d1', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('78259a05-35da-d83e-cd06-a33c164f0530', '9ac0f8b6-01a7-d1f4-2b23-b891bf39012f', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('27170cd7-ebba-6fe2-d400-306d99b0275e', '6265989e-67d2-68ef-9dee-12efe4a4d88d', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('84d66699-0124-bf92-20c0-165495bbf5c6', '8d9f7add-2f20-0e56-7d53-5ea78c2ea052', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('a9dd1f60-61b1-8024-e43c-326de5988d4a', 'dfe67d96-5391-4534-aa8c-a706d985896c', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('e76f957c-7838-4bfc-9210-ae57c447aad7', 'a8cb378b-60e8-d5d3-d1f7-b41730000c1f', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('72ee0417-cc5a-36d5-7f4c-b5ce69b46af8', '812af221-0b4d-25c7-435b-3c4b8f3de0ae', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('eea91854-9484-b7a2-ed97-bafcb493cfda', '570aeb3f-d237-2c20-154b-8d8415c87792', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('224d00be-174d-b9bd-449a-37256fb59c77', 'a9b34d16-9fe4-0d3d-07da-694b9f67cd4d', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('ff550361-5215-924c-0f57-579c27fa6f92', '8096367c-cc1a-473e-a9d0-33041aa92d61', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('b11a907f-ab1a-ea9b-f30c-5874a9c63970', '2ec6e7bc-125d-19b8-4138-468bf5e6f994', 'action');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('fc88d0ea-e64b-b9aa-3638-d630ef05a34e', 'abdaa370-2c7b-dc78-65e1-5724bf54101a', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('c010d9ab-61e4-fee9-4cac-5a5924cd1f3e', '6703218f-54a0-94b7-42b3-ed9e0e4c6685', 'action properties');
INSERT INTO public.tmp_property_category (id, code, name) VALUES ('4acff3fb-4e56-4cc8-5a04-268baba919bd', 'd89d6127-2e92-5ea3-d9b7-fb485b2250a0', 'action properties');
