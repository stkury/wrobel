prompt start ./plsql/generated/plankton/TERMINARZE.sql
prompt Create trigger terminarze_fer
create or replace trigger terminarze_fer
before insert on terminarze
for each row
declare
begin
  insert into object_id( inst_id, id, schema_name, table_name, seq_name ) values( 0, :new.id, 'PLANKTON' ,'TERMINARZE', '' );
end;
/
show errors
prompt stop ./plsql/generated/plankton/TERMINARZE.sql
