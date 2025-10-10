alter table action_link
    add mapping varchar;

alter table action
    alter column query drop not null;