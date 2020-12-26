create table if not exists cybersportsmen (
	id serial not null primary key,
	name varchar(40) not null,
	nickname varchar(30) not null,
	country varchar(30) not null,
	team varchar(30) references teams(team_name) not null,
	prize_amount varchar(30) not null,
	rating int check (rating > 0 and rating < 1000)
);
--copy cybersportsmen from 'C:\Users\Roket\Desktop\Programming\5_semestr\Data_Base\lab_01\cybersportsmen.csv' delimiter ';' csv;
--copy cybersportsmen from '/home/ef1t/Рабочий стол/Programming/5_semestr/Data_Base/lab_01/cybersportsmen.csv' delimiter ';' csv;

create table if not exists contracts(
	brand_name varchar(30) references brands(brand_name) not null,
	player_id int references cybersportsmen(id) not null,
	contracts_amount varchar(30) not null
);
--copy contracts from 'C:\Users\Roket\Desktop\Programming\5_semestr\Data_Base\lab_01\contracts.csv' delimiter ';' csv;
--copy contracts from '/home/ef1t/Рабочий стол/Programming/5_semestr/Data_Base/lab_01/contracts.csv' delimiter ';' csv;

create table if not exists brands(
	brand_name varchar(30) not null primary key,
	brand_ambassador varchar(30),
	brand_email varchar(30),
	brand_profit varchar(30)
);
--copy brands from 'C:\Users\Roket\Desktop\Programming\5_semestr\Data_Base\lab_01\brands.csv' delimiter ';' csv;
--copy brands from '/home/ef1t/Рабочий стол/Programming/5_semestr/Data_Base/lab_01/brands.csv' delimiter ';' csv;

create table if not exists teams(
	team_name varchar(30) not null primary key,
	founded int not null,
	prize_amount varchar(30)
)

--copy teams from 'C:\Users\Roket\Desktop\Programming\5_semestr\Data_Base\lab_01\teams.csv' delimiter ';' csv;
--copy teams from '/home/ef1t/Рабочий стол/Programming/5_semestr/Data_Base/lab_01/teams.csv' delimiter ';' csv;
