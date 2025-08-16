import 'package:app_logger/src/crashlytics_observer.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'logger_config.dart';

/// Application logger wrapper for TalkerFlutter
class AppLogger {
  AppLogger._internal(this._talker);

  static AppLogger? _instance;
  final Talker _talker;

  /// Initialize the logger with configuration
  static void initialize(LoggerConfig config) {
    final talker = TalkerFlutter.init(
      observer: CrashlyticsTalkerObserver(),
      settings: config.settings,
    );

    _instance = AppLogger._internal(talker);
  }

  /// Get the current logger instance
  static AppLogger get instance {
    if (_instance == null) {
      throw StateError(
        'AppLogger has not been initialized. Call AppLogger.initialize() first.',
      );
    }
    return _instance!;
  }

  /// Check if logger is initialized
  static bool get isInitialized => _instance != null;

  /// Get Talker instance for advanced usage
  Talker get talker => _talker;

  // Convenience methods for logging
  void debug(String message, [Object? extra]) =>
      _logWithFullData(LogLevel.debug, message, extra);
  void info(String message, [Object? extra]) =>
      _logWithFullData(LogLevel.info, message, extra);
  void warning(String message, [Object? extra]) =>
      _logWithFullData(LogLevel.warning, message, extra);
  void error(String message, [Object? exception, StackTrace? stackTrace]) =>
      _logWithFullData(LogLevel.error, message, exception, stackTrace);
  void critical(String message, [Object? exception, StackTrace? stackTrace]) =>
      _logWithFullData(LogLevel.critical, message, exception, stackTrace);

  /// Log with full data display, preventing truncation
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
        break;
      case LogLevel.info:
        _talker.info(formattedMessage);
        break;
      case LogLevel.warning:
        _talker.warning(formattedMessage);
        break;
      case LogLevel.error:
        _talker.error(formattedMessage, extra, stackTrace);
        break;
      case LogLevel.critical:
        _talker.critical(formattedMessage, extra, stackTrace);
        break;
      default:
        _talker.log(formattedMessage);
    }
  }

  /// Format log message with full data display
  String _formatLogMessage(String message, Object? extra) {
    if (extra == null) return message;

    final extraStr = _formatExtra(extra);
    return '$message $extraStr';
  }

  /// Format extra data to prevent truncation
  String _formatExtra(Object? extra) {
    if (extra == null) return '';

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
  void logUserAction(String action, [Map<String, dynamic>? metadata]) {
    info('User Action: $action', metadata);
  }

  void logApiCall(String endpoint, [Map<String, dynamic>? metadata]) {
    debug('API Call: $endpoint', metadata);
  }

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

  /// Full log output (no truncation)
  void logFull(String message, [Object? data]) {
    if (data != null) {
      _talker.info('$message\n${_formatExtra(data)}');
    } else {
      _talker.info(message);
    }
  }

  /// Full debug log output
  void debugFull(String message, [Object? data]) {
    if (data != null) {
      _talker.debug('$message\n${_formatExtra(data)}');
    } else {
      _talker.debug(message);
    }
  }
}
