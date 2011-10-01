
create table uczestnicy(
  id       number constraint ucz_pk primary key,
  atr_id   number not null constraint atr_atr_fk references atrakcje,
  userid   number not null constraint ucz_usr_fk references users,
  aktywny  varchar2(1)
);


create table lista_obecnosci(
  id       number constraint lu_pk primary key,
  term_id  number not null constraint term_ucz_fk references terminarze,
  ucz_id   number not null constraint lu_ucz_fk references uczestnicy,
  status   varchar2(1) -- (B)rak (C)hce (N)ie chcê (Z)astanowie siê jeszcze
);
