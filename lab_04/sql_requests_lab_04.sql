-- lab_04

-- Определяемая пользователем скалярная функция CLR

create or replace function get_name_by_id(id_ int) returns varchar
as $$
ppl = plpy.execute("select * from cybersportsmen")
for cybersportsmen in ppl:
    if cybersportsmen['id'] == id_:
        return cybersportsmen['name']
return 'None'
$$ language plpython3u;

select * from get_name_by_id(1);

-- Пользовательскую агрегатную функцию CLR
-- сделать полный агрегат
-- create agregate
create or replace function get_n_country_and_team(country varchar(30), team varchar(30)) returns int
as $$
cs = plpy.execute("select * from cybersportsmen")
sum_ = 0
for player in cs:
    if player['country'] == country and player['team'] == team:
        sum_ += 1
return sum_
$$ language plpython3u;

select * from get_n_country_and_team('Russian Federation', 'NAVI');

-- Определяемую пользователем табличную функцию CLR

create or replace function get_players_by_country (country varchar(30)) 
returns table (id int, name varchar, nickname varchar, country varchar, team varchar, prize_amount varchar, rating int)
as $$
ppl = plpy.execute("select * from cybersportsmen")
res = []
for player in ppl:
    if player['country'] == country:
        res.append(player)
return res
$$ language plpython3u;

select * from get_players_by_country('Russian Federation')

-- Хранимую процедуру CLR

create or replace procedure add_player(id int, name varchar, nickname varchar, country varchar, team varchar, prize_amount varchar, rating int) as
$$
plan = plpy.prepare("insert into cybersportsmen(id, name, nickname, country, team, prize_amount, rating) values($1, $2, $3, $4, $5, $6, $7);", 
                    ["int","varchar", "varchar", "varchar", "varchar", "varchar", "int"])
plpy.execute(plan, [id, name, nickname, country, team, prize_amount, rating])
$$ language plpython3u;

call add_player(801, 'Lolikov Lol', 'l0lik', 'Lol Federation', 'NAVI', '$999999999', 999);

select * from cybersportsmen
order by id desc;

-- Триггер CLR

call add_player(801, 'Lolikov Lol', 'l0lik', 'Lol Federation', 'NAVI', '$999999999', 999);

create table if not exists players_back (
    id serial not null primary key,
    name varchar(40) not null,
    nickname varchar(30) not null,
    country varchar(30) not null,
    team varchar(30) references teams(team_name) not null,
    prize_amount varchar(30) not null,
    rating int check (rating > 0 and rating < 1000)
);

create or replace function backup_deleted_player()
returns trigger 
as $$
plan = plpy.prepare("insert into players_back(id, name, nickname, country, team, prize_amount, rating) values($1, $2, $3, $4, $5, $6, $7);", 
                    ["int","varchar", "varchar", "varchar", "varchar", "varchar", "int"])
pi = TD['old']
rv = plpy.execute(plan, [pi["id"], pi["name"], pi["nickname"], pi["country"], pi["team"], pi["prize_amount"], pi["rating"]])
return TD['new']
$$ language  plpython3u;

drop trigger backup_deleted_player on cybersportsmen; 

create trigger backup_deleted_player
before delete on cybersportsmen for each row
execute procedure backup_deleted_player();

delete from cybersportsmen
where name = 'Lolikov Lol';

select * from players_back;

-- Определяемый пользоватедем тип данных CLR

create type stats as (
  id int,
  nickname varchar,
  rating int
);

create or replace function get_stats_by_id(id_ integer) returns stats 
as $$
plan = plpy.prepare("select id, nickname, rating from cybersportsmen where id = $1", ["int"])
cr = plpy.execute(plan, [id_])
return (cr[0]['id'], cr[0]['nickname'], cr[0]['rating'])
$$ language plpython3u;

select * from get_stats_by_id(1);

select *
from cybersportsmen
where id = 1

---------------
create or replace function get_n_country_and_team(id_ int, rating int) returns int
as $$
cs = plpy.execute("select * from cybersportsmen")
sum_ = 0
for player in cs:
    if player['id'] == id_ and player['rating'] == rating:
        sum_ += 1
return sum_
$$ language plpython3u;

create or replace aggregate count_players_and_countries (int) (
    sfunc = get_n_country_and_team,
    stype = integer,
    initcond = 0
);

select * from cybersportsmen;
select count_players_and_countries(1) from cybersportsmen
group by id;
---------------