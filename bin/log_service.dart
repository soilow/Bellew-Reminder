import 'package:logger/logger.dart';

class LogService {
	static final Logger _logger = Logger(
		printer: PrettyPrinter(
			methodCount: 0,
			lineLength: 100,
			colors: true,
			printTime: true,
		)
	);

	static void info(String message) {
		_logger.i(message);
	}

	static void warning(String message) {
		_logger.w(message);
	}

	static void error(String message) {
		_logger.e(message);
	}
}