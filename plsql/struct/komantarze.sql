
create table komentarze(
  id       number constraint kom_pk primary key,
  userid   number not null constraint kom_usr_fk references users,
  obj_id   number not null,
  kom_id   number constraint kom_kom_fk references komentarze,
  czas     date default sysdate,
  text     varchar2(4000)
);
