Сайт "Web база данных".

База данных должна быть заранее создана.

Тип базы данных, имя пользователя и пароль от базы
указывать в файле /lib/Webdb.pm в переменные $user_name и $password.

Имя базы данных, имя таблицы и значение ключевого поля задаются в URL-е,
тип операции в бд определяется по типу запроса,
параметры для запроса передаются в параметрах HTTP запроса.
Результат возвращается в виде json-а

Метод GET:

	GET http://localhost:5000/mydb/mytable/100500

		||
		\/

	SELECT * from mytable where id = 100500;

	Возвращает запись со всеми полями

Метод PUT:

	PUT http://localhost:5000/mydb/mytable/100500?field1=abc

		||
		\/

	UPDATE mytable SET field1 = "abc" WHERE id = 100500;

	Возвращает сообщение - удалось выполнить операцию или нет.

Метод POST:

	POST http://localhost:5000/mydb/mytable/?field1=abc&field2=123

	||
	\/

	INSERT INTO mytable (field1, field2) VALUES ("abc", 123);

	Возвращает id новой записи

Метод DELETE:

	DELETE http://localhost:5000/mydb/mytable/100500

		||
		\/

	DELETE from mytable where id = 100500;

	Возвращает сообщение - удалось выполнить операцию или нет.