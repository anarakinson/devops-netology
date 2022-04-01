\? - help
\c - connect
\conninfo - connect info
\d - tables
\i D:/path/to/file.sql - import table
\! cls - or - \! clear - clear screen

### операторы определения данных (Data Definition Language, DDL):
  CREATE создаёт объект базы данных (саму базу, таблицу, представление, пользователя и так далее),
  ALTER изменяет объект,
  DROP удаляет объект;
### операторы манипуляции данными (Data Manipulation Language, DML):
  SELECT выбирает данные, удовлетворяющие заданным условиям,
  INSERT добавляет новые данные,
  UPDATE изменяет существующие данные,
  DELETE удаляет данные;
### операторы определения доступа к данным (Data Control Language, DCL):
  GRANT предоставляет пользователю (группе) разрешения на определённые операции с объектом,
  REVOKE отзывает ранее выданные разрешения,
  DENY задаёт запрет, имеющий приоритет над разрешением;
### операторы управления транзакциями (Transaction Control Language, TCL):
  COMMIT применяет транзакцию,
  ROLLBACK откатывает все изменения, сделанные в контексте текущей транзакции,
  SAVEPOINT делит транзакцию на более мелкие участки.

create database
drop database
create table
drop table

### CORRECT ENCODING:
python >> print('Les Misérables'.encode('latin1').decode('cp437')) >> Les MisΘrables

### BASIC COMMANDS:

select count(*) from holiday; - show number of rows
select distinct gender from employee; - unique values from column
select distinct birthplace from employee order by birthplace; - all unique values from column "birthplace"
select * from employee offset 10 limit 5; - show rows from 10 till 15
select * from employee offset 10 fetch first 5 row only; - show rows from 10 till 15
select firstname, gender, birthplace from employee where gender = 'Male' and birthplace = 'Honduras' or birthplace = 'Ukraine' order by birthplace, gender, firstname;
select * from employee where birthplace in ('Poland', 'Ukraine', 'Israel');
select * from employee where birthday between '2021-01-01' and '2021-03-01' order by birthday;
select * from employee where email like '%google.%';
select * from employee where birthplace like 'P%';
select * from employee where birthplace ilike 'p%';
select birthplace, count(*) from employee group by birthplace having count(*) > 10 order by count desc;
select id, firstname as name, lastname as surname, gender as sex, email, birthday, birthplace from employee;
select coalesce(email, 'not applicable') from employee;

### CHANGE AND DELETE:

update employee set email = 'ghazeley2@mail.com', gender = 'Male', lastname = 'Hazeley' where id = 3;
delete from employee where email like '%google%' and birthplace = 'China';

### CONFLICTS:

para=# insert into employee (id, firstname, lastname, gender, email, birthday, birthplace)
para-# values (3, 'John', 'Doe', 'Male', 'john.doe@gmail.com', date '2019-05-23', 'Philippines')
para-# on conflict do nothing; OR
para-# on conflict (id) do nothing; OR
para-# on conflict (email) do nothing;

#### new lastname, email, birthday, but old ID:
para=# insert into employee (id, firstname, lastname, gender, email, birthday, birthplace)
para-# values (3, 'John', 'Doe', 'Male', 'john.doe@gmail.com', date '2019-05-23', 'Philippines')
para-# on conflict (id) do update set email = excluded.email, lastname = excluded.lastname, birthday = excluded.birthday;

### SUM-AVG-MAX:

select max(price), min(price), round(avg(price), 2) from holiday;
select destination_country, destination_city, max(price) as max_price from holiday group by destination_country, destination_city order by max_price desc limit 20;
select sum(price) from holiday;
select destination_country, sum(price) from holiday group by destination_country order by sum desc;

### MATH:

select 100 + 2;
select 100 - 2;
select 100 * 2;
select 100 / 2;
select 100 ^ 2;
select 100 % 2;
select 5!;

### DATETIME:

select now();
select now()::time;
select now()::date;
select now() + interval '10 days';
select now() - interval '10 month';
select now() - interval '10 year';
select extract(year from now());
select extract(dow from now()); - day of week now (sunday = 1
select firstname, lastname, gender, birthplace, birthday, age(now()::date, birthday) as age from employee;
###########
SELECT * FROM rnc_rna_precomputed rnc_rna_precomputed
WHERE is_active IS true
AND EXTRACT(year FROM rnc_rna_precomputed.update_date) = 2018
AND EXTRACT(month FROM rnc_rna_precomputed.update_date) = 04
LIMIT 10;
###########

### PRIMARY KEYS:

alter table employee drop constraint employee_pkey; - delete constraint "unique id"/"primary key"
alter table employee add primary key(id); - add constraint
delete from employee where id = 1;

### CONSTRAINTS:

select email, count(*) from employee group by email having count(*) > 1;
alter table employee add constraint unique_email_address unique (email); - only unique values may be in table
#### gender may be only of this types:
alter table employee add constraint gender_constraint check (gender in ('Genderqueer', 'Bigender', 'Genderfluid', 'Polygender', 'Non-binary', 'Agender', 'Male', 'Female'));

### FOREIGN KEYS:

alter table employee add bicycle_id BIGINT references bicycle (id); - add column with pointer to other table
alter table employee add unique(bicycle_id); - make values of "bicycle_id" unique

### JOIN:

select * from employee join bicycle on employee.bicycle_id = bicycle.id; - OR
select * from employee inner join bicycle on employee.bicycle_id = bicycle.id;
select employee.firstname, bicycle.make, bicycle.type from employee join bicycle on employee.bicycle_id = bicycle.id;
select * from employee left join bicycle on bicycle.id = employee.bicycle_id where bicycle_id IS NOT NULL; - orient on first table - who have bicycle
select * from employee left join bicycle on bicycle.id = employee.bicycle_id where bicycle_id IS NULL; - who have no bicycle
select * from employee right join bicycle on bicycle.id = employee.bicycle_id where bicycle_id is not null; - orient on second table

### TO CSV:

\copy (select * from employee left join bicycle on bicycle.id = employee.bicycle_id where bicycle_id is not null) to 'D:/coding/Atom/sql/bicycles.csv' delimiter ',' csv header;

### PG AVAILABLE EXTENSIONS:

select * from pg_available_extensions; - show extensions
create extension if not exists "uuid-ossp"; - install extension


### UUID:

select uuid_generate_v4(); - generate random id like - "29942ac1-efb7-4f30-b10a-b982586f2bd7"
insert into passport (passport_serial, issue_date, expire_date, issue_country) values(uuid_generate_v4(), '2020-01-02', '2021-01-02', 'Ukraine'); - pass generate id into table
para=# select * from passport;
           passport_serial            | issue_date | expire_date | issue_country
--------------------------------------+------------+-------------+---------------
 34196046-39ca-4225-b5e0-1cadf3717830 | 2020-01-02 | 2021-01-02  | Ukraine
 12ac3d24-f7ea-4a95-a371-4728c0fa7ae5 | 2020-01-02 | 2021-01-02  | Ukraine
(2 rows)
