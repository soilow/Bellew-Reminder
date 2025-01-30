import 'package:postgres/postgres.dart';

import 'dart:io';

class Database {
	late Connection connection;

	Future<void> connect() async {
		final dbUrl = Platform.environment['DATABASE_URL'] ?? 'postgres://postgres:password@localhost:5432/bot_db';
		final uri = Uri.parse(dbUrl);

		connection = await Connection.open(
			Endpoint(
				host: uri.host,
				port: uri.port,
				database: uri.pathSegments.first,
				username: uri.userInfo.split(':')[0],
				password: uri.userInfo.split(':')[1],
			),
		);

		print("Подключение к постгре норм прошло");
	}

	Future<void> close() async {
		await connection.close();
	}

	Future<void> createTables() async {
		await connection.execute(
			'''
			CREATE TABLE IF NOT EXISTS users (
				if SERIAL PRIMARY KEY,
				telegram_id BIGINT UNIQUE NOT NULL,
				username TEXT,
				password TEXT NOT NULL
			);
			'''
		);

		print("Users создана либо есть");
	}

	Future<void> addUser(int telegramId, String username, String password) async {
		await connection.execute(
			Sql.named(
				"INSERT INTO users (telegramId, username, password) VALUES (@telegram_id, @username, @password) "
				"ON CONFLICT (telegram_id) DO NOTHING",
			),
			parameters: {
				'telegram_id': telegramId,
				'username': username,
				'password': password,
			},
		);

		print("Пользователь добавлен!");
	}
}