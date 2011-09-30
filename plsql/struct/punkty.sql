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
