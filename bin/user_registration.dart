import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';

import 'database.dart';

final Map<int, String> waithingForPassword = {};

void handleRegistration(TeleDart bot, CallbackQuery callback) {
	final userId = callback.from.id;
	final username = callback.from.username ?? 'Unknown user';

	bot.sendMessage(userId, "Добро пожаловать! Введи пароль, который будет использоваться для аккаунта @$username:");

	waithingForPassword[userId] = username;
}

void handlePasswordInput(TeleDart bot, Message message, Database db) async {
	final userId = message.chat.id;

	if (waithingForPassword.containsKey(userId)) {
		final username = waithingForPassword[userId];
		final password = message.text!;

		await db.addUser(userId, username!, password);

		bot.sendMessage(userId, "Регистрация успешна! ✅");

		waithingForPassword.remove(userId);
	}
}