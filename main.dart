import 'dart:async';

import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'dart:io' as io;

const String apiKey = Platform.environment['API_TELEGRAM_KEY'] ?? '';

Future<void> main() async {
	final username = (await Telegram(apiKey).getMe().username);
	final teledart = TeleDart(apiKey, Event(username!));

	teledart.start();

	teledart.onCommand('start').listen((message) {
		final testButton = KeyboardButton(text: 'Test medium');
		final anotherButton = KeyboardButton(text: 'Another Button');

		final twoButtonList = [testButton, anotherButton];

		final markup = ReplyKeyboardMarkup(
			keyboard: [twoButtonList],
		);

		teledart.telegram.sendMessage(
			message.chat.id,
			'Hello, asshole!',
			reply_markup: markup,
		);
	});
}