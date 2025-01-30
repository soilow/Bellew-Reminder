import 'dart:async';

import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'dart:io';

final String apiKey = Platform.environment['API_TELEGRAM_KEY'] ?? '';

Future<void> main() async {
	final username = (await Telegram(apiKey).getMe()).username;
	final bot = TeleDart(apiKey, Event(username!));

	bot.start();

	bot.onCommand('start').listen((message) {
		bot.sendMessage(
			message.chat.id,
			'Привет! Выбери действие:',
			replyMarkup: InlineKeyboardMarkup(inlineKeyboard: [
				[
					inlineKeyboardButton(text: '🔹 Регистрация', callbackData: 'register'),
					inlineKeyboardButton(text: '🔑 Авторизация', callbackData: 'login'),
				]
			]));
		});

	bot. onCallbackQuery().listen((callback) {
		if (callback.data == 'register') {
			bot.sendMessage(callback.message!.chat.id, 'Регистрация');
		} else if (callback.data == 'login') {
			bot.sendMessage(callback.message!.chat.id, 'Авторизация');
		}

		bot.answerCallbackQuery(callback.id);
		});
}