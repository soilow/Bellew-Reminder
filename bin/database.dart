import 'package:postgres/postgres.dart';

import 'dart:io';

import 'log_service.dart';

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
			settings: ConnectionSettings(sslMode: SslMode.disable),
		);

		LogService.info("Successful connection to the database");
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

		LogService.info("Table `users` created or already existed");
	}

	Future<void> addUser(int telegramId, String username, String password) async {
		await connection.execute(
			Sql.named(
				"INSERT INTO users (telegram_id, username, password) VALUES (@telegram_id, @username, @password) "
				"ON CONFLICT (telegram_id) DO NOTHING",
			),
			parameters: {
				'telegram_id': telegramId,
				'username': username,
				'password': password,
			},
		);

		LogService.info("User $username with id $telegramId added to database");
	}
}