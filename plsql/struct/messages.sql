create table messages(
  id     number,
  userid number,
  sender number,
  state  varchar2(1),
  sdate  date default sysdate,
  msg    varchar2(4000)
);
