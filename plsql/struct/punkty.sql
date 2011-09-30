create table lokalizacje(
  id       number constraint lok_pk primary key,
  userid   number not null constraint lok_usr_fk references users,
  nazwa    varchar2(50),
  opis     varchar(4000)
);

create table punkty(
  id       number constraint punkty_pk primary key,
  userid   number not null constraint pkt_usr_fk references users,
  nazwa    varchar2(50),
  opis     varchar(4000),
  lok_id   number constraint pkt_lok_fk references lokalizacje,
  zdjecie  varchar2(100)
);


create table atrakcje(
  id       number constraint atrakcje_pk primary key,
  userid   number not null constraint atr_usr_fk references users,
  typ_id   number,
  obj_id   number,
  nazwa    varchar2(50),
  opis     varchar(4000)
);

create table rozklady_jazdy(
  id       number constraint rozk_jazdy_pk primary key,
  userid   number not null constraint rozk_jazdy_usr_fk references users,
  atr_id   number not null constraint rozk_jazdy_atr_fk references atrakcje,
  seq      number not null, -- w ramach atrakcji
  rodzaj   varchar2(1) not null, -- D/T/M
  active   varchar2(1) default 'Y',
  godz_od  date not null,
  godz_do  date not null,
  d_co_ile number default '1',
  t_dni    varchar2(7),
  t_co_ile number  default '1',
  m_w      number, -- liczba 1-7 dla jednostki dzien 1-30 dla jednostki miesiac
  m_j      number, -- jednostka (D)zieñ, 1, 2, .. ,7
  m_co_ile number default '1',
  constraint rj_seq_uk unique( atr_id, seq )
);

create table terminarze(
  id       number constraint term_pk primary key,
  userid   number not null constraint term_usr_fk references users,
  atr_id   number not null constraint term_atr_fk references atrakcje,
  rj_id    number not null constraint term_rj_fk references rozklady_jazdy,
  godz_od  date not null,
  godz_do  date not null
);
