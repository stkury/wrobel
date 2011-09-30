prompt start ./plsql/generated/plankton/USERS.sql
prompt Create trigger users_fer
create or replace trigger users_fer
before insert on users
for each row
declare
begin
  insert into object_id( inst_id, id, schema_name, table_name, seq_name ) values( 0, :new.id, 'PLANKTON' ,'USERS', '' );
end;
/
show errors
prompt stop ./plsql/generated/plankton/USERS.sql
