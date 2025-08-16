import 'package:talker_flutter/talker_flutter.dart';

/// Logger configuration for the application
class LoggerConfig {
  LoggerConfig({
    this.logLevel = LogLevel.debug,
    this.enableConsoleOutput = true,
    this.enableFileOutput = false,
    TalkerSettings? settings,
  }) : settings =
           settings ??
           TalkerSettings(
             useConsoleLogs: true,
             maxHistoryItems: 3000,
             enabled: true,
             useHistory: true,
           );

  final LogLevel logLevel;
  final bool enableConsoleOutput;
  final bool enableFileOutput;
  final TalkerSettings settings;

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
      logLevel: LogLevel.debug,
      enableConsoleOutput: true,
      enableFileOutput: false,
      settings: TalkerSettings(
        useConsoleLogs: true,
        maxHistoryItems: 6000,
        enabled: true,
        useHistory: true,
      ),
    );
  }

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
