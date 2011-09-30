create sequence objseq;

create table users(
  id       number primary key users_pk,
  username varchar2(30),
  haslo    varchar2(50),
  constraint users_username_uk unique (username)
);
