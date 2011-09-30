create table OBJECT_ID
(
  inst_id     number not null,
  id          number not null,
  schema_name varchar2(30) not null,
  table_name  varchar2(30) not null,
  seq_name    varchar2(30)
);
