create table messages(
  id     number primary key messages_pk,
  userid number,
  sender number,
  state  varchar2(1),
  sdate  date default sysdate,
  msg    varchar2(4000)
);
