drop table tbl1;
drop table tbl2;

create table tbl1 as
select uuid_in(md5(random()::text || random()::text)::cstring) id, 'code-1' code , 'qwe' title
union all select uuid_in(md5(random()::text || random()::text)::cstring), 'system-code-1', '111'
union all select uuid_in(md5(random()::text || random()::text)::cstring), 'system-code-2', '222'
;

create table tbl2 as
select '4ef1b0a3-5882-1e01-a1e1-9de6f826a961'::uuid id, 'system-code-2' code , '333' title
union all select uuid_in(md5(random()::text || random()::text)::cstring), 'system-code-3', 'vvv'
;


MERGE INTO tbl1 t1
    USING tbl2 t2
    ON t1.id = t2.id and t1.code like 'system-%'
    WHEN NOT MATCHED THEN
        INSERT VALUES(t2.id, t2.code, t2.title)
    WHEN MATCHED THEN
        UPDATE SET code = t2.code, title = t2.title
;

delete from tbl1 where
    id in (select t1.id
           from tbl1 t1
                    left join tbl2 t2 on t1.id = t2.id
           where t1.code like 'system-%'
             and t2.id is null)
;
