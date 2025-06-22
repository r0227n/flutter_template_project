import 'package:flutter/material.dart';

/// Utility class for getting display names for settings values
class SettingsDisplayUtils {
  const SettingsDisplayUtils._();

  /// Gets a display name for a locale
  static String getLocaleDisplayName(Locale? locale) {
    if (locale == null) {
      return 'System';
    }
    return switch (locale.languageCode) {
      'ja' => '日本語',
      'en' => 'English',
      _ => locale.languageCode,
    };
  }

  /// Gets a display name for a theme mode
  static String getThemeDisplayName(
    ThemeMode? themeMode, {
    required String systemLabel,
    required String lightLabel,
    required String darkLabel,
  }) {
    if (themeMode == null) {
      return 'System';
    }
    return switch (themeMode) {
      ThemeMode.system => systemLabel,
      ThemeMode.light => lightLabel,
      ThemeMode.dark => darkLabel,
    };
  }
}
