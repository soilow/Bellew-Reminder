import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';

final Map<int, String> waithingForPassword = {};

void handleRegistration(TeleDart bot, Message message) {
	final userId = message.chat.id;
	final username = message.from?.username ?? 'Unknown user';

	bot.sendMessage(userId, "Добро пожаловать! Введи пароль, который будет использоваться для аккаунта @$username:");

	waithingForPassword[userId] = username;
}

void handlePasswordInput(TeleDart bot, Message message) {
	final userId = message.chat.id;

	if (waithingForPassword.containsKey(userId)) {
		final username = waithingForPassword[userId];
		final password = message.text!;

		bot.sendMessage(userId, "Регистрация успешна! ✅");

		waithingForPassword.remove(userId);
	}
}