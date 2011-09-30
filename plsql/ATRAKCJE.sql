prompt start ./plsql/generated/plankton/ATRAKCJE.sql
prompt Create trigger atrakcje_fer
create or replace trigger atrakcje_fer
before insert on atrakcje
for each row
declare
begin
  insert into object_id( inst_id, id, schema_name, table_name, seq_name ) values( 0, :new.id, 'PLANKTON' ,'ATRAKCJE', '' );
end;
/
show errors
prompt stop ./plsql/generated/plankton/ATRAKCJE.sql
