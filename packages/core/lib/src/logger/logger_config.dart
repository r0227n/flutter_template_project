import 'package:talker_flutter/talker_flutter.dart';

/// Logger configuration for the application.
class LoggerConfig {
  /// Creates a logger configuration.
  LoggerConfig({
    this.logLevel = LogLevel.debug,
    this.enableConsoleOutput = true,
    this.enableFileOutput = false,
    TalkerSettings? settings,
  }) : settings = settings ?? TalkerSettings(maxHistoryItems: 3000);

  /// Create a production-ready configuration
  factory LoggerConfig.production() {
    return LoggerConfig(
      logLevel: LogLevel.warning,
      enableConsoleOutput: false,
      enableFileOutput: true,
      settings: TalkerSettings(useConsoleLogs: false, maxHistoryItems: 100),
    );
  }

  /// Create a development configuration
  factory LoggerConfig.development() {
    return LoggerConfig(
      settings: TalkerSettings(
        maxHistoryItems: 6000,
      ),
    );
  }

  /// Minimum log level to record.
  final LogLevel logLevel;

  /// Whether to output logs to console.
  final bool enableConsoleOutput;

  /// Whether to output logs to file.
  final bool enableFileOutput;

  /// Talker settings.
  final TalkerSettings settings;

  /// Creates a copy of this configuration with the given fields replaced.
  LoggerConfig copyWith({
    LogLevel? logLevel,
    bool? enableConsoleOutput,
    bool? enableFileOutput,
    TalkerSettings? settings,
  }) {
    return LoggerConfig(
      logLevel: logLevel ?? this.logLevel,
      enableConsoleOutput: enableConsoleOutput ?? this.enableConsoleOutput,
      enableFileOutput: enableFileOutput ?? this.enableFileOutput,
      settings: settings ?? this.settings,
    );
  }
}
