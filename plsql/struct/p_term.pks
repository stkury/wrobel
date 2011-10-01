create or replace package p_term
as

function genTerm( p_atr_id number, p_ile number, p_id out number ) return varchar2;

end;
/
show err
