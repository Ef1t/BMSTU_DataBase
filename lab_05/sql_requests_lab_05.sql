-- lab_05

-- 1. Из таблиц базы данных, созданной в первой лабораторной работе, извлечь
-- данные в XML (MSSQL) или JSON(Oracle, Postgres). Для выгрузки в XML
-- проверить все режимы конструкции FOR XML

\copy (select ROW_TO_JSON(cybersportsmen) from cybersportsmen) 
to '/home/ef1t/Desktop/Programming/5_semestr/Data_Base/lab_05/src/cybersportsmen.json';

-- 2. Выполнить загрузку и сохранение XML или JSON файла в таблицу.
-- Созданная таблица после всех манипуляций должна соответствовать таблице
-- базы данных, созданной в первой лабораторной работе.

CREATE TEMP TABLE cybersportsmen_copy_help(doc JSON);
COPY cybersportsmen_copy_help FROM '/home/ef1t/Desktop/Programming/5_semestr/Data_Base/lab_05/src/cybersportsmen.json';

CREATE TABLE IF NOT EXISTS cybersportsmen_copy(LIKE cybersportsmen INCLUDING ALL);
INSERT INTO cybersportsmen_copy
SELECT p.*
FROM cybersportsmen_copy_help, json_populate_record(null::cybersportsmen, doc) AS p;

(
	SELECT * FROM cybersportsmen_copy
	EXCEPT
	SELECT * FROM cybersportsmen
)
UNION
(
	SELECT * FROM cybersportsmen
	EXCEPT
	SELECT * FROM cybersportsmen_copy
)

-- 3. Создать таблицу, в которой будет атрибут(-ы) с типом XML или JSON, или
-- добавить атрибут с типом XML или JSON к уже существующей таблице.
-- Заполнить атрибут правдоподобными данными с помощью команд INSERT
-- или UPDATE.

DROP TABLE cybersportsmen_copy;

CREATE TABLE cybersportsmen_copy (LIKE cybersportsmen INCLUDING ALL);

INSERT INTO cybersportsmen_copy
SELECT *
FROM cybersportsmen;

ALTER TABLE cybersportsmen_copy ADD COLUMN data_json JSON;

DROP TABLE cybersportsmen_json;

CREATE TEMP TABLE cybersportsmen_json(id SERIAL, doc JSON);
COPY cybersportsmen_json(doc) FROM '/home/ef1t/Desktop/Programming/5_semestr/Data_Base/lab_05/src/cybersportsmen.json';

UPDATE cybersportsmen_copy
SET data_json = (SELECT doc FROM cybersportsmen_json WHERE cybersportsmen_copy.id = cybersportsmen_json.id);

select * from cybersportsmen_copy;

-- 4. Выполнить следующие действия:

	-- 1. Извлечь XML/JSON фрагмент из XML/JSON документа

SELECT *
FROM json_extract_path('{"name": "Aleksandr", "Nickname": "S1mple", "Characteristics": {"Rating": "1000", "Age": "23", "Skill": "Maximum skill"}}', 
					   'Characteristics', 'Skill');

	-- 2. Извлечь значения конкретных узлов или атрибутов XML/JSON
--документа

SELECT DISTINCT name, (data_json->>'nickname') AS nickname, (data_json->>'rating') AS rating
FROM cybersportsmen_copy
WHERE data_json->>'rating' LIKE '7%';

	-- 3. Выполнить проверку существования узла или атрибута

SELECT name, nickname, (data_json->>'team') AS team
FROM cybersportsmen_copy
WHERE data_json::jsonb ? 'team';

	-- 4. Изменить XML/JSON документ

UPDATE cybersportsmen_copy
SET data_json = data_json::jsonb - 'country';

select * from cybersportsmen_copy;

	--5. Разделить XML/JSON документ на несколько строк по узлам

SELECT *
FROM json_each_text('{"name": "Aleksandr", "Nickname": "S1mple", "Rating": "1000"}');