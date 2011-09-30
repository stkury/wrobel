prompt start ./plsql/generated/plankton/ROZKLADY_JAZDY.sql
prompt Create trigger rozklady_jazdy_fer
create or replace trigger rozklady_jazdy_fer
before insert on rozklady_jazdy
for each row
declare
begin
  insert into object_id( inst_id, id, schema_name, table_name, seq_name ) values( 0, :new.id, 'PLANKTON' ,'ROZKLADY_JAZDY', '' );
end;
/
show errors
prompt stop ./plsql/generated/plankton/ROZKLADY_JAZDY.sql
