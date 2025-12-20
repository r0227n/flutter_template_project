import 'package:core/src/logger/crashlytics_observer.dart';
import 'package:core/src/logger/logger_config.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// A wrapper around the `TalkerFlutter` logger that provides a singleton
/// instance and convenient logging methods.
///
/// This class must be initialized by calling [initialize] before it can be
/// used.
class AppLogger {
  AppLogger._internal(this._talker);

  static AppLogger? _instance;
  final Talker _talker;

  /// Initializes the logger with the given [config].
  static void initialize(LoggerConfig config) {
    final talker = TalkerFlutter.init(
      observer: CrashlyticsTalkerObserver(),
      settings: config.settings,
    );

    _instance = AppLogger._internal(talker);
  }

  /// Returns the singleton instance of the logger.
  ///
  /// Throws a [StateError] if the logger has not been initialized.
  static AppLogger get instance {
    if (_instance == null) {
      throw StateError(
        'AppLogger has not been initialized. Call AppLogger.initialize().',
      );
    }
    return _instance!;
  }

  /// Returns `true` if the logger has been initialized.
  static bool get isInitialized => _instance != null;

  /// Returns the underlying `Talker` instance.
  Talker get talker => _talker;

  // Convenience methods for logging
  /// Logs a debug message.
  void debug(String message, [Object? extra]) =>
      _logWithFullData(LogLevel.debug, message, extra);

  /// Logs an info message.
  void info(String message, [Object? extra]) =>
      _logWithFullData(LogLevel.info, message, extra);

  /// Logs a warning message.
  void warning(String message, [Object? extra]) =>
      _logWithFullData(LogLevel.warning, message, extra);

  /// Logs an error message.
  void error(String message, [Object? exception, StackTrace? stackTrace]) =>
      _logWithFullData(LogLevel.error, message, exception, stackTrace);

  /// Logs a critical message.
  void critical(String message, [Object? exception, StackTrace? stackTrace]) =>
      _logWithFullData(LogLevel.critical, message, exception, stackTrace);

  /// Logs a message with the given [level], [message], and optional [extra]
  /// data and [stackTrace].
  ///
  /// This method formats the message and extra data to prevent truncation.
  void _logWithFullData(
    LogLevel level,
    String message,
    Object? extra, [
    StackTrace? stackTrace,
  ]) {
    final formattedMessage = _formatLogMessage(message, extra);

    switch (level) {
      case LogLevel.debug:
        _talker.debug(formattedMessage);
      case LogLevel.info:
        _talker.info(formattedMessage);
      case LogLevel.warning:
        _talker.warning(formattedMessage);
      case LogLevel.error:
        _talker.error(formattedMessage, extra, stackTrace);
      case LogLevel.critical:
        _talker.critical(formattedMessage, extra, stackTrace);
      case LogLevel.verbose:
        _talker.verbose(formattedMessage);
    }
  }

  /// Formats the log message and extra data.
  String _formatLogMessage(String message, Object? extra) {
    if (extra == null) {
      return message;
    }

    final extraStr = _formatExtra(extra);
    return '$message $extraStr';
  }

  /// Formats the extra data to prevent truncation.
  String _formatExtra(Object? extra) {
    if (extra == null) {
      return '';
    }

    if (extra is Map) {
      final entries = extra.entries.map((e) => '${e.key}: ${e.value}');
      // Format with newlines for readability and prevent truncation
      return '{\n${entries.map((e) => '  $e').join(',\n')}\n}';
    }

    if (extra is List) {
      // Format lists with newlines for better readability
      return '[\n${extra.map((e) => '  $e').join(',\n')}\n]';
    }

    final str = extra.toString();
    // Split long strings with newlines for better readability
    if (str.length > 100) {
      return '\n$str';
    }

    return str;
  }

  // Structured logging methods
  /// Logs a user action.
  void logUserAction(String action, [Map<String, dynamic>? metadata]) {
    info('User Action: $action', metadata);
  }

  /// Logs an API call.
  void logApiCall(String endpoint, [Map<String, dynamic>? metadata]) {
    debug('API Call: $endpoint', metadata);
  }

  /// Logs the performance of an operation.
  void logPerformance(
    String operation,
    Duration duration, [
    Map<String, dynamic>? metadata,
  ]) {
    final data = <String, dynamic>{
      'duration_ms': duration.inMilliseconds,
      ...?metadata,
    };
    info('Performance: $operation took ${duration.inMilliseconds}ms', data);
  }

  /// Logs a message with the full data displayed, preventing truncation.
  void logFull(String message, [Object? data]) {
    if (data != null) {
      _talker.info('$message\n${_formatExtra(data)}');
    } else {
      _talker.info(message);
    }
  }

  /// Logs a debug message with the full data displayed, preventing truncation.
  void debugFull(String message, [Object? data]) {
    if (data != null) {
      _talker.debug('$message\n${_formatExtra(data)}');
    } else {
      _talker.debug(message);
    }
  }
}
