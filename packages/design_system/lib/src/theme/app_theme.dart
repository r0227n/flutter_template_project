import 'package:flutter/material.dart';

/// Application theme configuration and management
///
/// This class provides a centralized way to define and manage the application's
/// theme configuration for both light and dark modes. It uses Material 3 design
/// principles and provides consistent theming across the application.
///
/// The theme is built using a seed color (deep purple) that generates a
/// cohesive color scheme for both light and dark variants.
///
/// Example usage:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.lightTheme,
///   darkTheme: AppTheme.darkTheme,
///   themeMode: ThemeMode.system,
/// )
/// ```
class AppTheme {
  /// Creates an instance of [AppTheme]
  ///
  /// This constructor is const to allow for efficient instantiation
  /// and static access to theme configurations.
  const AppTheme();

  /// Gets the light theme configuration
  ///
  /// Returns a pre-configured [ThemeData] for light mode using Material 3
  /// design principles. The theme is generated from a deep purple seed color.
  ///
  /// Returns:
  /// A [ThemeData] configured for light mode
  static ThemeData get lightTheme => const AppTheme().toLightTheme();

  /// Gets the dark theme configuration
  ///
  /// Returns a pre-configured [ThemeData] for dark mode using Material 3
  /// design principles. The theme is generated from a deep purple seed color
  /// with dark brightness.
  ///
  /// Returns:
  /// A [ThemeData] configured for dark mode
  static ThemeData get darkTheme => const AppTheme().toDarkTheme();

  /// Converts the theme configuration to light theme data
  ///
  /// Creates a complete [ThemeData] configuration for light mode with:
  /// - Material 3 design system enabled
  /// - Color scheme generated from deep purple seed color
  /// - Custom AppBar theme with inverse primary background
  /// - Consistent foreground colors
  ///
  /// Returns:
  /// A fully configured [ThemeData] for light mode
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

  /// Converts the theme configuration to dark theme data
  ///
  /// Creates a complete [ThemeData] configuration for dark mode with:
  /// - Material 3 design system enabled
  /// - Color scheme generated from deep purple seed color with dark brightness
  /// - Custom AppBar theme with inverse primary background
  /// - Consistent foreground colors optimized for dark mode
  ///
  /// Returns:
  /// A fully configured [ThemeData] for dark mode
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
