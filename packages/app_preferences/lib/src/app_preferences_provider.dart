import 'dart:ui';

import 'package:app_preferences/src/models/app_locale_preference.dart';
import 'package:app_preferences/src/models/app_theme_preference.dart';
import 'package:app_preferences/src/repositories/app_preferences_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_preferences_provider.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return await SharedPreferences.getInstance();
}

@Riverpod(keepAlive: true)
AppPreferencesRepository appPreferencesRepository(
    AppPreferencesRepositoryRef ref) {
  final prefs = ref.watch(sharedPreferencesProvider).requireValue;
  return AppPreferencesRepository(preferences: prefs);
}

@riverpod
class AppLocale extends _$AppLocale {
  @override
  Locale? build() {
    final repository = ref.watch(appPreferencesRepositoryProvider);
    final savedLocale = repository.getLocale();
    return savedLocale?.toLocale();
  }

  Future<void> setLocale(Locale locale) async {
    final repository = ref.read(appPreferencesRepositoryProvider);
    final preference = AppLocalePreference.fromLocale(locale);
    await repository.saveLocale(preference);
    state = locale;
  }

  Future<void> clearLocale() async {
    final repository = ref.read(appPreferencesRepositoryProvider);
    await repository.clearLocale();
    state = null;
  }
}

@riverpod
class AppTheme extends _$AppTheme {
  @override
  ThemeMode build() {
    final repository = ref.watch(appPreferencesRepositoryProvider);
    final savedTheme = repository.getTheme();
    
    switch (savedTheme?.mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
      case null:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final repository = ref.read(appPreferencesRepositoryProvider);
    
    final appThemeMode = switch (mode) {
      ThemeMode.light => AppThemeMode.light,
      ThemeMode.dark => AppThemeMode.dark,
      ThemeMode.system => AppThemeMode.system,
    };
    
    final preference = AppThemePreference(mode: appThemeMode);
    await repository.saveTheme(preference);
    state = mode;
  }

  Future<void> clearTheme() async {
    final repository = ref.read(appPreferencesRepositoryProvider);
    await repository.clearTheme();
    state = ThemeMode.system;
  }
}