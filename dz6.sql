CREATE TABLE users_old (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);

/*1. Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру,
с помощью которой можно переместить любого (одного) пользователя из таблицы users
в таблицу users_old. (использование транзакции с выбором commit или rollback –
обязательно)*/

DELIMITER //
START TRANSACTION;
	CREATE PROCEDURE rebase_user()
		BEGIN
			INSERT INTO users_old (SELECT * FROM users WHERE users.id = 2);
            DELETE FROM users WHERE users.id = 2;
        END;
    CALL rebase_user();
COMMIT//
DELIMITER ;

/*2. Создайте хранимую функцию hello(), которая будет возвращать приветствие,
в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать
фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".*/


DROP FUNCTION IF EXISTS hello;
DELIMITER //
CREATE FUNCTION hello()
RETURNS VARCHAR(50) READS SQL DATA
	BEGIN
		DECLARE hello_text VARCHAR(50) DEFAULT "";
        DECLARE my_time TIME;
        SET my_time = CURTIME();
		IF (my_time >= '6:00:00' AND my_time < '12:00:00')
        THEN SET hello_text = "Доброе утро";
        ELSEIF (my_time >= '12:00:00' AND my_time < '18:00:00')
        THEN SET hello_text = "Добрый день";
        ELSEIF (my_time >= '18:00:00' AND my_time < '00:00:00')
        THEN SET hello_text = "Добрый вечер";
        ELSEIF (my_time >= '00:00:00' AND my_time < '6:00:00')
        THEN SET hello_text = "Доброй ночи";
        ELSE SET hello_text = "Неизвестное время";
        END IF;
		RETURN hello_text;
    END//
DELIMITER ;
SELECT hello();
