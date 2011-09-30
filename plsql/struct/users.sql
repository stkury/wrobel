create sequence objseq;

create table users(
  id       number constraint users_pk primary key,
  username varchar2(30),
  haslo    varchar2(50),
  constraint users_username_uk unique (username)
);
