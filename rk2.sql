Тюрин Олег ИУ7-51Б
Вариант № 3

create table if not exists prepods (
id serial not null primary key,
fio varchar(40) not null,
graduate varchar(40) not null,
faculty varchar(30) not null
);

create table if not exists theme (
id serial not null primary key,
teacher_id int references prepods(id) not null,
theme varchar(30) not null
);

create table if not exists students (
id serial not null primary key, 
teacher_id int references prepods(id) not null,
fio varchar(40) not null,
faculty varchar(30) not null,
group_name varchar(30) not null,
gradebook_id int unique not null references marks(gradebook_id)
);

create table if not exists marks (
id serial not null primary key,
gradebook_id int unique not null,
gos_mark int not null,
diplom_mark int not null
);

INSERT INTO prepods(fio, graduate, faculty)
VALUES ('Znajkin Vsenasvetevich', 'Proffessor', 'Vseznanie'),
('Nevseznaikin Rogozin', 'Docent', 'Cosmos'),
('Ilon Muskovich', 'Proffessor', 'Cosmos'),
('Okay Miprostoigraevich', 'Doctor', 'Zhizn'),
('Vseznaika Puvin', 'Kandidat', 'History');

INSERT INTO theme(teacher_id, theme)
VALUES (2, 'Comets'),
1, 'Celebreties'),
(3, 'Tesla cars'),
(5, 'Grade Wars'),
(4, 'Popular songs');

INSERT INTO students(teacher_id, fio, faculty, group, gradebook_id)
VALUES (2, 'Lolikov Lol', 'IU', '61b', 3),
(1, 'Popikov Pop', 'SM', '42b', 1),
(4, 'Kekikov Kek', 'RK', '63b', 2),
(5, 'Studentov Student', 'SM', '14b', 4),
(3, 'Bestovich Uchenik', 'BMT', '63b', 5);

INSERT INTO marks(gradebook_id, gos_mark, diplom_mark)
VALUES (1, 4, 4),
(3, 4, 5),
(2, 3, 3),
(4, 5, 4),
(5, 5, 5);

select * from prepods
where faculty < ALL
(select faculty from prepods
where graduate = 'Doctor');

select count(faculty) from student
group by faculty

select * into temp_table_student from
(select id, fio, faculty from student
) temp;

select * from temp_table_student;

create or replace procedure search_func(inout quantity int = 0) as
$$
declare
obj record;
cmd text:=$cmd$ select routine_name as title from 
information_schema.routines
where routine_type = 'FUNCTION' and specific_schema='public'$cmd$; 
ind int;
begin
	quantity = 0;
	for obj in execute cmd
	loop
	ind := position('ufn' in obj.title);
	if ind = 1 then quantity := quantity + 1;
	end if;
	end loop;
end;
$$ language plpgsql;

call search_func();

