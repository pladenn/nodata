alter table action_link
    add category varchar;

alter table action_link
    add variable varchar;

update action_link al set category =
    case
      when al.is_action_target then 'MOUNTED_TO_ACTION'
      when al.mounted_to_row then 'MOUNTED_TO_ROW'
      when exists(select 1 from parameter p where p.dictionary_id = al.id) then 'DICTIONARY'
    end
;