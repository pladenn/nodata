create table tmp_del_sys_obj
(
    id  uuid,
    tbl text
);

alter table tmp_del_sys_obj
    owner to postgres;

INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('1400abd2-12d4-be34-d5a8-ac2adfe3740d', 'action');
INSERT INTO public.tmp_del_sys_obj (id, tbl) VALUES ('1784c5a6-4d59-eeb0-981c-d9a52b775b46', 'property_category');
