import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_locale_preference.dart';
import '../models/app_theme_preference.dart';

part 'app_preferences_repository.g.dart';

@riverpod
AppPreferencesRepository appPreferencesRepository(AppPreferencesRepositoryRef ref) {
  return AppPreferencesRepository();
}

class AppPreferencesRepository {
  static const String _localeKey = 'app_locale';
  static const String _themeKey = 'app_theme';

  // Locale management
  Future<AppLocalePreference?> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeJson = prefs.getString(_localeKey);
    
    if (localeJson == null) return null;
    
    try {
      final json = jsonDecode(localeJson) as Map<String, dynamic>;
      return AppLocalePreference.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<void> setLocale(AppLocalePreference locale) async {
    final prefs = await SharedPreferences.getInstance();
    final localeJson = jsonEncode(locale.toJson());
    await prefs.setString(_localeKey, localeJson);
  }

  Future<void> clearLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeKey);
  }

  // Theme management
  Future<AppThemePreference?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeJson = prefs.getString(_themeKey);
    
    if (themeJson == null) return null;
    
    try {
      final json = jsonDecode(themeJson) as Map<String, dynamic>;
      return AppThemePreference.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<void> setTheme(AppThemePreference theme) async {
    final prefs = await SharedPreferences.getInstance();
    final themeJson = jsonEncode(theme.toJson());
    await prefs.setString(_themeKey, themeJson);
  }

  Future<void> clearTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_themeKey);
  }
}