create table lokalizacje(
  id       number constraint lok_pk primary key,
  userid   number not null constraint lok_usr_fk references users,
  nazwa    varchar2(50),
  opis     varchar(4000)
  KRAJ                    VARCHAR2(4000),  
  REGION                  VARCHAR2(4000),  
  MIASTO                  VARCHAR2(4000),  
  DZIELNICA               VARCHAR2(4000),  
  ULICA                   VARCHAR2(4000),  
  NUMER_DOMU              VARCHAR2(4000)  
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
  pkt_id   number constraint atr_pkt_fk references punkty,
  nazwa    varchar2(50),
  opis     varchar(4000)
);

create table rozklady_jazdy(
  id       number constraint rozk_jazdy_pk primary key,
  userid   number not null constraint rozk_jazdy_usr_fk references users,
  atr_id   number not null constraint rozk_jazdy_atr_fk references atrakcje,
  seq      number not null, -- w ramach atrakcji
  rodzaj   varchar2(1) not null constraint rozk_jazdy_rodzaj_chk check( rodzaj in ('D','T','M') ),
  active   varchar2(1) default 'Y',
  godz_od  date not null,
  godz_do  date not null,
  d_co_ile number default '1',
  t_dni    varchar2(7),
  t_co_ile number  default '1',
  m_w      number, -- z minusem znaczy od koñca; 0=ostatni, liczba 1-7 dla jednostki dzien 1-31 dla jednostki miesiac
  m_j      number, -- jednostka 0=dzieñ, 1, 2, .. ,7 dzieñ tygodnia
  m_co_ile number default '1',
  constraint rj_seq_uk unique( atr_id, seq ),
  constraint rozk_jazdy_d_chk check( rodzaj<>'D' or (d_co_ile is not null and d_co_ile between 1 and 1000) ),
  constraint rozk_jazdy_t_chk check( rodzaj<>'T' or (t_co_ile is not null and t_dni is not null and t_co_ile between 1 and 10) ),
  constraint rozk_jazdy_m_chk check( rodzaj<>'M' or (m_co_ile is not null and m_j is not null and m_w is not null and m_co_ile between 1 and 30 and m_j between 0 and 7 and m_w between -31 and 31) )
);

create table terminarze(
  id       number constraint term_pk primary key,
  userid   number not null constraint term_usr_fk references users,
  atr_id   number not null constraint term_atr_fk references atrakcje,
  rj_id    number not null constraint term_rj_fk references rozklady_jazdy,
  godz_od  date not null,
  godz_do  date not null
);
