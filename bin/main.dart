import 'dart:io';
import 'dart:async';

import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

import 'user_registration.dart';
import 'database.dart';

final String apiKey = Platform.environment['API_TELEGRAM_KEY'] ?? '';
final Database db = Database();

Future<void> main() async {
	await db.connect();
	await db.createTables();

	final username = (await Telegram(apiKey).getMe()).username;
	final bot = TeleDart(apiKey, Event(username!));

	bot.start();

	bot.onCommand('start').listen((message) {
		bot.sendMessage(
			message.chat.id,
			'Привет! Выбери действие:',
			replyMarkup: InlineKeyboardMarkup(inlineKeyboard: [
				[
					InlineKeyboardButton(text: '🔹 Регистрация', callbackData: 'register'),
					InlineKeyboardButton(text: '🔑 Авторизация', callbackData: 'login'),
				]
			]));
		});

	bot.onCallbackQuery().listen((callback) {
		if (callback.data == 'register') {
			handleRegistration(bot, callback);
		} else if (callback.data == 'login') {
			bot.sendMessage(callback.message!.chat.id, 'Авторизация');
		}

		bot.answerCallbackQuery(callback.id);
		});

	bot.onMessage().listen((message) {
		handlePasswordInput(bot, message, db);
		});


}