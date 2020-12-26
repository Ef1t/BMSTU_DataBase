--lab_03

-- Функции --

-- Скалярная функция

create or replace function scalar_func(team_name varchar(30)) returns int as
$$
	select id
	from cybersportsmen
	where team = team_name
$$
language sql;

select scalar_func('NAVI');

-- Подставляема табличная функция

create or replace function inserted_table_func(team_name varchar(30)) 
returns cybersportsmen as
$$
	select *
	from cybersportsmen
	where team = team_name
$$ language sql;

select *
from inserted_table_func('NAVI'); 

-- Многооператорную табличную функцию

create or replace function multi_table_func(team_name varchar(30)) 
returns table(id int, name varchar(30), nickname varchar(30), country varchar(30)) as
$$
    select id, name, nickname, country
    from cybersportsmen
    where team = team_name
$$ language sql;

select *
from multi_table_func('NAVI');

----------

create or replace function multi_table_func() returns int as
$$
declare
    cs_t int[];
    max_num int;
    temp_p int;
    elem int;
    count int;
begin
    max_num := (
        select max(rating)
        from cybersportsmen
    );
    cs_t := array(
        select id
        from cybersportsmen
    );
    count := 0;
    foreach elem in array cs_t
    loop
        temp_p := (select rating from cybersportsmen where id = elem);
        if temp_p = max_num
            then count := count + 1;
        end if;
    end loop;
    return count;
end;
$$ language plpgsql;

select *
from multi_table_func();
----------


-- Рекурсивную функцию или функцию с рекурсивным ОТВ

create or replace function recursion_func() 
returns table(id int, team varchar(30))
as
$$
    with recursive cte as
    (
        select id as index, team as team_name from cybersportsmen where id = 1
        union 
        select cybersportsmen.id as index, cybersportsmen.team as team_name
        from cte join cybersportsmen on cte.index + 1 = cybersportsmen.id
        where cybersportsmen.id <= 20
    )
    select * from cte;
$$ language sql;

select *
from recursion_func();

-- Процедуры --

-- Хранимую процедуру без параметров или с параметрами

drop table if exists help_table;

select id, name, nickname, team
into help_table from cybersportsmen
limit 20;


create or replace procedure team_between_id(begin_id int, end_id int, new_team varchar(30)) as
$$
begin
    if (begin_id <= end_id)
    then
        update help_table
        set team = new_team
        where id = begin_id;
        call team_between_id(begin_id + 1, end_id, new_team);
    end if;
end;
$$ language plpgsql;

call team_between_id(1, 6, 'Super Team');

select *
from help_table
order by id;

-- Хранимую процедуру с курсором

drop table if exists help_table;

select id, name, nickname, team, rating
into help_table from cybersportsmen
limit 20;


create or replace procedure delete_str(temp_rating int) as
$$
    declare cur cursor 
    for select * 
    from help_table;
    temp record;
    begin
        open cur;
        loop
            fetch cur into temp;
            exit when not found;
            delete from help_table
            where rating = temp_rating;
        end loop;
        close cur;
    end;
$$ language plpgsql;

call delete_str(655);

select *
from help_table
order by id;
	

-- Хранимую процедуру доступа к метаданным

select table_name, pg_relation_size(cast(table_name as varchar)) as size FROM information_schema.tables WHERE table_schema='public';

create or replace procedure table_info() as
$$
    declare my_cursor cursor
	for select table_name, size
	from (
		select table_name,
		pg_relation_size(cast(table_name as varchar)) as size 
		from information_schema.tables
		WHERE table_schema='public'
	) AS temp_table;
	temp record;
begin
	open my_cursor;
	loop
		fetch my_cursor into temp;
		exit when not found;
		raise info 'name - %, size - %', temp.table_name, temp.size;
	end loop;
	close my_cursor;
end
$$ language plpgsql;

call table_info();

-- Триггеры --

-- AFTER

--  trigger after

drop table if exists help_table;

select id, nickname
into help_table
from cybersportsmen
limit 20;

create or replace function insert_func() returns trigger as
$$
   begin
      insert into help_table(id, nickname) values (24, old.nickname);
      RETURN new;
   end;
$$ language plpgsql;

create trigger instead_update_insert
after update on help_table for each row
execute function insert_func();

select * from help_table;
update help_table
set nickname = 'P0pik'
where id = 16;

select * from help_table
order by id;

-- INSTEAD OF сделать работу с нашими данными 
--удаленных игроков ставить команду nan

drop view if exists help_view cascade;
drop table if exists help_table cascade;

create table help_table(id int, num int);
INSERT into help_table(id, num) values (1, 2);
INSERT into help_table(id, num) values (2, 3);
INSERT into help_table(id, num) values (3, 4);

create view help_view as
select *
from help_table;

create or replace function insert_instead_update() returns trigger as
$$
    begin
        insert into help_view(id, num) values (old.id * 4, new.num);
        RETURN new;
    end;
$$ language plpgsql;

create trigger update_trigger
instead of update on help_view for each row 
execute function insert_instead_update();

select * from help_view;
update help_view
set num = 10
where id = 1;

select * from help_view;


------------------------
drop view if exists help_view cascade;
drop table if exists help_table cascade;

select id, nickname, team
into help_table
from cybersportsmen
limit 20;

create view help_view as
select *
from help_table;

create or replace function insert_instead_update() returns trigger as
$$
    begin
        update help_view 
		set team = 'No Team'
		where id = old.id;
		return new;
    end;
$$ language plpgsql;

create trigger update_trigger
instead of delete on help_view for each row 
execute function insert_instead_update();

select * from help_view;
delete from help_view
where id = 1;

select * from help_view;
------------------------