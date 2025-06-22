import 'dart:convert';

import 'package:app_preferences/src/models/app_locale_preference.dart';
import 'package:app_preferences/src/models/app_theme_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferencesRepository {
  static const _localeKey = 'app_locale_preference';
  static const _themeKey = 'app_theme_preference';

  final SharedPreferences _preferences;

  AppPreferencesRepository({required SharedPreferences preferences})
      : _preferences = preferences;

  // Locale methods
  Future<void> saveLocale(AppLocalePreference locale) async {
    final json = jsonEncode(locale.toJson());
    await _preferences.setString(_localeKey, json);
  }

  AppLocalePreference? getLocale() {
    final jsonString = _preferences.getString(_localeKey);
    if (jsonString == null) return null;
    
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppLocalePreference.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearLocale() async {
    await _preferences.remove(_localeKey);
  }

  // Theme methods
  Future<void> saveTheme(AppThemePreference theme) async {
    final json = jsonEncode(theme.toJson());
    await _preferences.setString(_themeKey, json);
  }

  AppThemePreference? getTheme() {
    final jsonString = _preferences.getString(_themeKey);
    if (jsonString == null) return null;
    
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppThemePreference.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearTheme() async {
    await _preferences.remove(_themeKey);
  }

  Future<void> clearAll() async {
    await clearLocale();
    await clearTheme();
  }
}