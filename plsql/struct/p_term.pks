create or replace package p_term
as

function genTerm( p_atr_id number, p_od date, p_id out number ) return varchar2;

end;
/
show err
