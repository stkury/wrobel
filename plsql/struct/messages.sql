create table messages(
  id     number constraint messages_pk primary key,
  userid number not null  constraint mess_usr_fk references users,
  sender number  not null constraint mess_sender_fk references users,
  state  varchar2(1),
  sdate  date default sysdate,
  msg    varchar2(4000)
);
