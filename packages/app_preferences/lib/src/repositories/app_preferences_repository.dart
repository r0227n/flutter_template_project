import 'dart:convert';

import 'package:app_preferences/src/providers/app_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_preferences_repository.g.dart';

/// Provides the app preferences repository instance
///
/// This provider creates and configures an [AppPreferencesRepository] instance
/// with the SharedPreferences dependency injected from
/// [sharedPreferencesProvider].
///
/// Returns:
/// A configured [AppPreferencesRepository] instance
@riverpod
AppPreferencesRepository appPreferencesRepository(Ref ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return AppPreferencesRepository(prefs: prefs);
}

/// Repository for managing application preferences storage
///
/// This class provides a high-level interface for storing and retrieving
/// user preferences such as locale and theme settings. It handles JSON
/// serialization/deserialization and provides type-safe access to stored
/// preferences.
///
/// All preferences are stored using SharedPreferences with predefined keys
/// to ensure consistency across the application.
class AppPreferencesRepository {
  /// Creates an instance of [AppPreferencesRepository]
  ///
  /// Parameters:
  /// - [prefs]: The SharedPreferences instance used for storage
  AppPreferencesRepository({required SharedPreferences prefs}) : _prefs = prefs;

  /// The underlying SharedPreferences instance
  final SharedPreferences _prefs;

  /// Key used for storing locale preferences in SharedPreferences
  static const _localeKey = 'app_locale';

  /// Key used for storing theme preferences in SharedPreferences
  static const _themeKey = 'app_theme';

  // === Locale Management ===

  /// Retrieves the stored locale preference
  ///
  /// Reads the locale preference from SharedPreferences and deserializes
  /// it from JSON format. Returns null if no preference is stored or if
  /// an error occurs during deserialization.
  ///
  /// Returns:
  /// A [Future<Locale?>] representing the stored locale, or null if not found
  ///
  /// Example:
  /// ```dart
  /// final locale = await repository.getLocale();
  /// if (locale != null) {
  ///   print('Stored locale: ${locale.languageCode}');
  /// }
  /// ```
  Future<Locale?> getLocale() async {
    final localeJson = _prefs.getString(_localeKey);

    if (localeJson == null) {
      return null;
    }

    try {
      final json = jsonDecode(localeJson) as Map<String, dynamic>;
      final languageCode = json['languageCode'] as String;
      final countryCode = json['countryCode'] as String?;
      return Locale(languageCode, countryCode);
    } on Exception {
      return null;
    }
  }

  /// Stores the locale preference
  ///
  /// Serializes the locale to JSON format and stores it in SharedPreferences.
  /// The locale is stored with both language code and optional country code.
  ///
  /// Parameters:
  /// - [locale]: The locale to store as preference
  ///
  /// Example:
  /// ```dart
  /// await repository.setLocale(const Locale('en', 'US'));
  /// ```
  Future<void> setLocale(Locale locale) async {
    final localeJson = jsonEncode({
      'languageCode': locale.languageCode,
      'countryCode': locale.countryCode,
    });
    await _prefs.setString(_localeKey, localeJson);
  }

  /// Removes the stored locale preference
  ///
  /// Deletes the locale preference from SharedPreferences, causing the
  /// application to fall back to default locale behavior.
  Future<void> clearLocale() async {
    await _prefs.remove(_localeKey);
  }

  // === Theme Management ===

  /// Retrieves the stored theme mode preference
  ///
  /// Reads the theme mode preference from SharedPreferences and converts
  /// it from string format to [ThemeMode] enum. Returns null if no
  /// preference is stored or if an invalid value is found.
  ///
  /// Returns:
  /// A [Future<ThemeMode?>] representing the stored theme mode, or null
  /// if not found
  ///
  /// Example:
  /// ```dart
  /// final themeMode = await repository.getTheme();
  /// if (themeMode != null) {
  ///   print('Stored theme: ${themeMode.name}');
  /// }
  /// ```
  Future<ThemeMode?> getTheme() async {
    final themeString = _prefs.getString(_themeKey);

    if (themeString == null) {
      return null;
    }

    try {
      return switch (themeString) {
        'system' => ThemeMode.system,
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => null,
      };
    } on Exception {
      return null;
    }
  }

  /// Stores the theme mode preference
  ///
  /// Converts the theme mode to string format and stores it in
  /// SharedPreferences. Supports system, light, and dark theme modes.
  ///
  /// Parameters:
  /// - [themeMode]: The theme mode to store as preference
  ///
  /// Example:
  /// ```dart
  /// await repository.setTheme(ThemeMode.dark);
  /// ```
  Future<void> setTheme(ThemeMode themeMode) async {
    final themeString = switch (themeMode) {
      ThemeMode.system => 'system',
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
    };
    await _prefs.setString(_themeKey, themeString);
  }

  /// Removes the stored theme mode preference
  ///
  /// Deletes the theme mode preference from SharedPreferences, causing the
  /// application to fall back to default theme mode behavior.
  Future<void> clearTheme() async {
    await _prefs.remove(_themeKey);
  }

  // === Initialization ===

  /// Initializes locale settings from stored preferences during app startup
  ///
  /// This method should be called during app initialization to set up the
  /// initial locale state. It reads the stored locale preference and calls
  /// the appropriate callback function based on whether a preference exists.
  ///
  /// Parameters:
  /// - [onLocaleFound]: Callback invoked when a stored locale is found.
  ///   Receives the language code as parameter.
  /// - [onUseDeviceLocale]: Callback invoked when no stored locale is found
  ///   or when an error occurs reading the stored locale.
  ///
  /// Example:
  /// ```dart
  /// await repository.initializeLocale(
  ///   onLocaleFound: (languageCode) async {
  ///     await LocaleSettings.setLocaleFromLanguageCode(languageCode);
  ///   },
  ///   onUseDeviceLocale: () async {
  ///     await LocaleSettings.useDeviceLocale();
  ///   },
  /// );
  /// ```
  Future<void> initializeLocale({
    required Future<void> Function(String languageCode) onLocaleFound,
    required Future<void> Function() onUseDeviceLocale,
  }) async {
    final localeJson = _prefs.getString(_localeKey);

    if (localeJson != null) {
      try {
        final json = jsonDecode(localeJson) as Map<String, dynamic>;
        final languageCode = json['languageCode'] as String;
        await onLocaleFound(languageCode);
      } on Exception {
        // If there's an error reading stored locale, use device locale
        await onUseDeviceLocale();
      }
    } else {
      // No stored locale, use device locale
      await onUseDeviceLocale();
    }
  }
}
