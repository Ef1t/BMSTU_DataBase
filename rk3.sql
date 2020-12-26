# рк 3 фамилия номер группы 
#вариант в теле письма

# вариант 1

# Задание 1 

create table if not exists employee (
	id serial not null primary key,
	name varchar(50) not null,
	birthdate date,
	departament varchar(15)
);

insert into employee(name, birthdate, departament) 
values('Иванов Иван Иванович', '25-09-1990', 'ИТ'),
('Петров Петр Петрович', '12-11-1987', 'Бухгалетрия')

create table if not exists record (
	id_employee int references employee(id) not null,
	rdate date,
	weekday varchar(15),
	rtime time,
	rtype int
); 

insert into record(id_employee, rdate, weekday, rtime, rtype) 
values(1, '14-12-2018', 'Суббота', '9:00', 1),
(1, '14-12-2018', 'Суббота', '9:20', 2),
(1, '14-12-2018', 'Суббота', '9:25', 1),
(2, '14-12-2018', 'Суббота', '9:05', 1),
(1, '14-12-2018', 'Суббота', '9:30', 2),
(1, '14-12-2018', 'Суббота', '9:35', 1),
(1, '14-12-2018', 'Суббота', '9:40', 2),
(1, '14-12-2018', 'Суббота', '9:45', 1),
(1, '14-12-2018', 'Суббота', '9:50', 2),
(1, '14-12-2018', 'Суббота', '9:55', 1)

Написать скалярную функцию, возвращающую количество сотрудников в возрасте от 18 до
40, выходивших более 3х раз.

select count(*) from (
    select e.id from record as r join employee as e on r.id_employee = e.id
    where extract(year from current_date) - extract (year from e.birthdate) between 18 and 40
    and r.rtype = 2
    group by e.id
    having count(*) >= 3
  ) as s1


# Задание 2

import psycopg2

connect = psycopg2.connect(dbname='race', user='postgres', 
                                        password='admin', host='localhost')

cursor = connect.cursor()

1. Найти все отделы, в которых работает более 10 сотрудников

def more_10(cursor, connect):
	cursor.execute('''
	SELECT departament, count from (
	select departament, count(*)
	from employee
	group by (departament)) as help
	where count > 10	
		''')
	return cursor.fetchall()

2. Найти сотрудников, которые не выходят с рабочего места в течение всего рабочего дня

def no_enter(cursor, connect):
	cursor.execute('''
	SELECT id_employee, rdate, count(*)
	from (
		select id_employee, rdate, rtype
		from record
		where rtype = 2
	)as help group by (id_employee, rdate) 
	having count(*) = 1;	
		''')
	return cursor.fetchall()

3. Найти все отделы, в которых есть сотрудники, опоздавшие в определенную дату. Дату
передавать с клавиатуры

def no_enter(cursor, connect):
	date = input()

	cursor.execute('''with res as (
	select id_employee, min_time from
	(select id_employee, min(rtime) as min_time from 
		(select id_employee, rdate, rtime
			from record
			where rdate = {date} and rtype = 1
		) as help 
		group by id_employee
	) as help_2
	where min_time > '9:00'
	)
	select distinct department from res join employee e on e.id = res.id_employee;'''.format(date = date))
	
	return cursor.fetchall()