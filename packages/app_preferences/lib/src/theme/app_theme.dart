import 'package:flutter/material.dart';

/// Application theme configuration
class AppTheme {
  /// Creates an instance of [AppTheme]
  const AppTheme();

  /// Gets the light theme configuration
  static ThemeData get lightTheme => const AppTheme().toLightTheme();

  /// Gets the dark theme configuration
  static ThemeData get darkTheme => const AppTheme().toDarkTheme();

  /// Converts to light theme data
  ThemeData toLightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.inversePrimary,
        foregroundColor: colorScheme.onSurface,
      ),
    );
  }

  /// Converts to dark theme data
  ThemeData toDarkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.inversePrimary,
        foregroundColor: colorScheme.onSurface,
      ),
    );
  }
}
