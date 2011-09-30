create or replace package body p_term
as

function genTerm( p_atr_id number, p_od date, p_id out number ) return varchar2
is
  last_term terminarze %rowtype;
  v_godz_od date := p_od + 1000;
  v_godz_do date;
  v_rj_id number;
  v date;
begin
  for rj in ( select *
                from rozklady_jazdy where atr_id = p_atr_id
               order by seq )
  loop
    last_term := null;
    for l4rj in ( select *
                    from ( select *
                             from terminarze
                            where atr_id = p_atr_id and rj_id = rj.id and godz_do < p_od
                            order by godz_do desc )
                   where rownum = 1 )
    loop
      last_term := l4rj;
    end loop;

    if last_term.godz_od is null then
      last_term.godz_od := rj.godz_od;
      last_term.godz_do := rj.godz_do;
    end if;

    v := last_term.godz_od;

    while v < last_term.godz_do
    loop
      case rj.rodzaj
        when 'D' then
          v := v + rj.d_co_ile;
        when 'T' then
          null;
        when 'M' then
          null;
      end case;
    end loop;

    if v < v_godz_od then
      v_rj_id := rj.id;
      v_godz_od := v;
      v_godz_do := v + (rj.godz_do - rj.godz_od);
    end if;
  end loop;

  if v_rj_id is null then
    return 'Nie uda³o siê :(';
  end if;

  insert into terminarze(id,userid,atr_id,rj_id,godz_od,godz_do) values( objseq.nextval, OE.sess.userid, p_atr_id, v_rj_id, v_godz_od, v_godz_do )
  return id into p_id;

  return '';
end;

end;
/
show err
