prompt start ./plsql/generated/plankton/LOKALIZACJE.sql
prompt Create trigger lokalizacje_fer
create or replace trigger lokalizacje_fer
before insert on lokalizacje
for each row
declare
begin
  insert into object_id( inst_id, id, schema_name, table_name, seq_name ) values( 0, :new.id, 'PLANKTON' ,'LOKALIZACJE', '' );
end;
/
show errors
prompt stop ./plsql/generated/plankton/LOKALIZACJE.sql
