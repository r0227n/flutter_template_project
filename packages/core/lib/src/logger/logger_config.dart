import 'package:talker_flutter/talker_flutter.dart';

/// Logger configuration for the application
class LoggerConfig {
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

  final LogLevel logLevel;
  final bool enableConsoleOutput;
  final bool enableFileOutput;
  final TalkerSettings settings;

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
