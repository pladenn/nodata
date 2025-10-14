alter table connection
alter column login type varchar(250) using login::varchar(250);

alter table connection
alter column password type varchar(250) using password::varchar(250);