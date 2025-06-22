import 'dart:convert';

import 'package:app_preferences/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_preferences_repository.g.dart';

@riverpod
AppPreferencesRepository appPreferencesRepository(Ref ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return AppPreferencesRepository(prefs: prefs);
}

class AppPreferencesRepository {
  AppPreferencesRepository({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  static const String _localeKey = 'app_locale';
  static const String _themeKey = 'app_theme';

  // Locale management
  Future<Locale?> getLocale() async {
    final localeJson = _prefs.getString(_localeKey);

    if (localeJson == null) return null;

    try {
      final json = jsonDecode(localeJson) as Map<String, dynamic>;
      final languageCode = json['languageCode'] as String;
      final countryCode = json['countryCode'] as String?;
      return Locale(languageCode, countryCode);
    } catch (e) {
      return null;
    }
  }

  Future<void> setLocale(Locale locale) async {
    final localeJson = jsonEncode({
      'languageCode': locale.languageCode,
      'countryCode': locale.countryCode,
    });
    await _prefs.setString(_localeKey, localeJson);
  }

  Future<void> clearLocale() async {
    await _prefs.remove(_localeKey);
  }

  // Theme management
  Future<ThemeMode?> getTheme() async {
    final themeString = _prefs.getString(_themeKey);

    if (themeString == null) return null;

    try {
      switch (themeString) {
        case 'system':
          return ThemeMode.system;
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    String themeString;
    switch (themeMode) {
      case ThemeMode.system:
        themeString = 'system';
        break;
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
    }
    await _prefs.setString(_themeKey, themeString);
  }

  Future<void> clearTheme() async {
    await _prefs.remove(_themeKey);
  }
}
