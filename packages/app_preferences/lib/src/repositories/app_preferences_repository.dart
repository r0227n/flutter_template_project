import 'dart:convert';

import 'package:app_preferences/src/providers/app_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_preferences_repository.g.dart';

/// Provides the app preferences repository
@riverpod
AppPreferencesRepository appPreferencesRepository(Ref ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return AppPreferencesRepository(prefs: prefs);
}

/// Repository for managing application preferences
class AppPreferencesRepository {
  /// Creates an instance of [AppPreferencesRepository]
  AppPreferencesRepository({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  static const _localeKey = 'app_locale';
  static const _themeKey = 'app_theme';

  /// Locale management
  ///
  /// Gets the stored locale preference
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

  /// Sets the locale preference
  Future<void> setLocale(Locale locale) async {
    final localeJson = jsonEncode({
      'languageCode': locale.languageCode,
      'countryCode': locale.countryCode,
    });
    await _prefs.setString(_localeKey, localeJson);
  }

  /// Clears the locale preference
  Future<void> clearLocale() async {
    await _prefs.remove(_localeKey);
  }

  /// Theme management
  ///
  /// Gets the stored theme preference
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

  /// Sets the theme preference
  Future<void> setTheme(ThemeMode themeMode) async {
    final themeString = switch (themeMode) {
      ThemeMode.system => 'system',
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
    };
    await _prefs.setString(_themeKey, themeString);
  }

  /// Clears the theme preference
  Future<void> clearTheme() async {
    await _prefs.remove(_themeKey);
  }
}
