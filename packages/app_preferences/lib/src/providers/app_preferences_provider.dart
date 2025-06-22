import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/app_locale_preference.dart';
import '../models/app_theme_preference.dart';
import '../repositories/app_preferences_repository.dart';

part 'app_preferences_provider.g.dart';

// Locale providers
@riverpod
class AppLocalePreference extends _$AppLocalePreference {
  @override
  Future<Locale> build() async {
    final repository = ref.read(appPreferencesRepositoryProvider);
    final localePreference = await repository.getLocale();
    
    if (localePreference != null) {
      return localePreference.toLocale();
    }
    
    // Default to English if no preference is stored
    return const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    final repository = ref.read(appPreferencesRepositoryProvider);
    final localePreference = AppLocalePreference.fromLocale(locale);
    
    await repository.setLocale(localePreference);
    ref.invalidateSelf();
  }

  Future<void> clearLocale() async {
    final repository = ref.read(appPreferencesRepositoryProvider);
    await repository.clearLocale();
    ref.invalidateSelf();
  }
}

// Theme providers
@riverpod
class AppThemePreference extends _$AppThemePreference {
  @override
  Future<ThemeMode> build() async {
    final repository = ref.read(appPreferencesRepositoryProvider);
    final themePreference = await repository.getTheme();
    
    if (themePreference != null) {
      return themePreference.mode;
    }
    
    // Default to system theme mode if no preference is stored
    return ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final repository = ref.read(appPreferencesRepositoryProvider);
    final themePreference = AppThemePreference(mode: mode);
    
    await repository.setTheme(themePreference);
    ref.invalidateSelf();
  }

  Future<void> clearTheme() async {
    final repository = ref.read(appPreferencesRepositoryProvider);
    await repository.clearTheme();
    ref.invalidateSelf();
  }
}