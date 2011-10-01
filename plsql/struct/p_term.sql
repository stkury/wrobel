create or replace package body p_term
as

function genTerm( p_atr_id number, p_ile number, p_id out number ) return varchar2
is
  p_godz_od date;
  last_term terminarze %rowtype;
  v_godz_od date;
  v_godz_do date;
  v_rj_id number;
  v date;
  x number;
  day_name  varchar2(15);
begin
  for r in ( select 1 from rozklady_jazdy where atr_id = p_atr_id and rownum = 1 )
  loop
    x := 1;
  end loop;
  if x is null then
    return 'Dzidek mistrzu! Zdefiniuj najpierw rodk³ad jazdy!';
  end if;

  -- startujemy po napozniejszym terminarzu
  for l4rj in ( select id, godz_do
                  from ( select id, godz_do
                           from terminarze
                          where atr_id = p_atr_id
                          union
                         select id, godz_do
                           from rozklady_jazdy
                          where atr_id = p_atr_id
                          order by 1 desc )
                 where rownum = 1 )
  loop
    p_godz_od := l4rj.godz_do;
    bkt$utils.trc( 'p_godz_do id='||l4rj.id||' '||p_godz_od );
  end loop;

  for rj in ( select *
                from rozklady_jazdy where atr_id = p_atr_id
               order by seq )
  loop
    -- na last_term wyiczamy ostatni terminarz z rodzaju konczacy siê przed p_godz_od
    last_term := null;
    for l4rj in ( select *
                    from ( select *
                             from terminarze
                            where atr_id = p_atr_id and rj_id = rj.id and godz_do <= p_godz_od
                            order by godz_do desc )
                   where rownum = 1 )
    loop
      last_term := l4rj;
      bkt$utils.trc( 'last_term id='||last_term.id||' '||last_term.godz_od||'-'||last_term.godz_do );
    end loop;

    if last_term.godz_od is null then
      -- nie bylo terminarza przed przed p_godz_od, wiêc startujemy od godziny z rozkladu jazdy
      last_term.godz_od := rj.godz_od;
      last_term.godz_do := rj.godz_do;
      bkt$utils.trc( 'last_term from rj '||last_term.id||' '||last_term.godz_od||'-'||last_term.godz_do );
    end if;

    v := last_term.godz_od;

    -- sprawdzamy kolejne dla rozkladu daty, czy ju¿ s± dostatecznie pó¼no
    while v < greatest( last_term.godz_do, p_godz_od )
    loop
      case rj.rodzaj
        when 'D' then
          v := v + rj.d_co_ile;
        when 'T' then
          declare
            dt varchar2(1); ndt varchar2(1);
          begin
            dt := to_char(v,'Dfm');
            for i in to_number(dt)+1 .. 7 loop -- czy jest jakis pozniejszy dzien tygodnia
              if ndt is null and instr( rj.t_dni, to_char(i) ) > 0 then
                ndt := to_char(i);
              end if;
            end loop;
            if ndt is not null then
              v := v + (ndt-dt);
            else
              ndt := substr(rj.t_dni,1,1); -- wskakujemy w nastepy tydzien (z uwzglednieniem co ile tygodni), pierwszy dzien z listy
              v := v + (rj.t_co_ile*7+ndt-dt);
            end if;
          end;
        when 'M' then
          bkt$utils.trc( 'adding '||(rj.m_co_ile)||' months to '||v );
          v := trunc( add_months( v, rj.m_co_ile ), 'MONTH' ); -- poczatek odpowiedniego miesiaca
          if rj.m_j = 0 then -- co ktorys dzien miesiaca
            if rj.m_w = 0 then
              v := last_day( v ); -- ostatni dzien miesiaca
            elsif rj.m_w > 0 then
              v := v + (rj.m_w-1); -- dzien miesiaca
            else
              v := last_day( v ) + rj.m_w; -- dzien miesiaca od konca
            end if;
          else -- co ktory dzien tygodnia w miesiacu
            day_name := case rj.m_j
              when 1 then 'Poniedzia³ek'
              when 2 then 'Wtorek'
              when 3 then '¦roda'
              when 4 then 'Czwartek'
              when 5 then 'Pi±tek'
              when 6 then 'Sobota'
              when 7 then 'Niedziela'
            end;
            if rj.m_w > 0 then
              v := v-1;
              bkt$utils.trc( ' before next_day '||v );
              for i in 1..rj.m_w loop
                v := next_day( v, day_name );
              end loop;
            else
              raise_application_error( -20001, 'w miesiacu dzien tygodnia od konca - TODO' );
            end if;
          end if;
          bkt$utils.trc( v );
          v := v + (rj.godz_od-trunc(rj.godz_od));
      end case;
    end loop;

    if v < v_godz_od or v_godz_od is null then -- czy to lepszy wyniki niz poprzednie
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

  insert into lista_obecnosci( id, term_id, ucz_id, status )
  select objseq.nextval, p_id, id, 'B'
    from uczestnicy where atr_id = p_atr_id;

  return '';
end;

end;
/
show err
