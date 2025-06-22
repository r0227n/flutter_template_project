import 'package:app_preferences/src/repositories/app_preferences_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_preferences_provider.g.dart';

@riverpod
SharedPreferences sharedPreferences(Ref ref) => throw UnimplementedError();

// Locale providers
@riverpod
class AppLocaleProvider extends _$AppLocaleProvider {
  @override
  Future<Locale> build() async {
    final repository = ref.read(appPreferencesRepositoryProvider);
    final locale = await repository.getLocale();

    if (locale != null) {
      return locale;
    }

    // Default to English if no preference is stored
    return const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    final repository = ref.read(appPreferencesRepositoryProvider);

    await repository.setLocale(locale);
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
class AppThemeProvider extends _$AppThemeProvider {
  @override
  Future<ThemeMode> build() async {
    final repository = ref.read(appPreferencesRepositoryProvider);
    final themeMode = await repository.getTheme();

    if (themeMode != null) {
      return themeMode;
    }

    // Default to system theme mode if no preference is stored
    return ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final repository = ref.read(appPreferencesRepositoryProvider);

    await repository.setTheme(mode);
    ref.invalidateSelf();
  }

  Future<void> clearTheme() async {
    final repository = ref.read(appPreferencesRepositoryProvider);
    await repository.clearTheme();
    ref.invalidateSelf();
  }
}
