prompt start ./plsql/generated/plankton/MESSAGES.sql
prompt Create trigger messages_fer
create or replace trigger messages_fer
before insert on messages
for each row
declare
begin
  insert into object_id( inst_id, id, schema_name, table_name, seq_name ) values( 0, :new.id, 'PLANKTON' ,'MESSAGES', '' );
end;
/
show errors
prompt stop ./plsql/generated/plankton/MESSAGES.sql
