import 'package:pretty_logger/pretty_logger.dart';

abstract final class AppLogger {
  AppLogger._();

  static void debug(String message) => PLog.info(message);
  static void info(String message) => PLog.success(message);
  static void warning(String message) => PLog.warning(message);
  static void error(String message) => PLog.error(message);
}
