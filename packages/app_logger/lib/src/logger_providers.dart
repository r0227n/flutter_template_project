import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'app_logger.dart';

part 'logger_providers.g.dart';

/// Provider for the Talker instance for advanced usage
@riverpod
Talker talker(Ref ref) {
  if (!AppLogger.isInitialized) {
    throw StateError(
      'AppLogger has not been initialized. Call AppLogger.initialize() first.',
    );
  }
  return AppLogger.instance.talker;
}

/// Provider for the AppLogger instance
@riverpod
AppLogger appLogger(Ref ref) {
  return AppLogger.instance;
}

/// Mixin for easy logger access in Riverpod-based classes
mixin LoggerMixin {
  AppLogger get logger => AppLogger.instance;

  void logInfo(String message, [Object? extra]) =>
      logger.info(message, _formatLogData(extra));
  void logDebug(String message, [Object? extra]) =>
      logger.debug(message, _formatLogData(extra));
  void logWarning(String message, [Object? extra]) =>
      logger.warning(message, _formatLogData(extra));
  void logError(String message, [Object? exception, StackTrace? stackTrace]) =>
      logger.error(message, _formatLogData(exception), stackTrace);

  void logUserAction(String action, [Map<String, dynamic>? metadata]) =>
      logger.logUserAction(action, metadata);

  /// Full log output (no truncation)
  void logFull(String message, [Object? data]) => logger.logFull(message, data);

  /// Full debug log output
  void logDebugFull(String message, [Object? data]) =>
      logger.debugFull(message, data);

  /// Format log data to prevent truncation in console output
  Object? _formatLogData(Object? data) {
    if (data == null) return null;

    if (data is Map) {
      // Convert Map to a readable multiline string format to prevent truncation
      final entries = data.entries.map((e) => '${e.key}: ${e.value}');
      return '{\n${entries.map((e) => '  $e').join(',\n')}\n}';
    }

    if (data is List) {
      // Format List with multiline for better readability
      return '[\n${data.map((e) => '  $e').join(',\n')}\n]';
    }

    final str = data.toString();
    // For long strings, add newline for better formatting
    if (str.length > 100) {
      return '\n$str';
    }

    return data;
  }
}
