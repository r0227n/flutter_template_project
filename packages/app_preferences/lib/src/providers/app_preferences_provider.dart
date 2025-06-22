import 'package:app_preferences/src/repositories/app_preferences_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_preferences_provider.g.dart';

/// Provides access to SharedPreferences instance
///
/// This provider should be overridden in main.dart with the actual
/// SharedPreferences instance during app initialization.
///
/// Example usage:
/// ```dart
/// ProviderScope(
///   overrides: [
///     sharedPreferencesProvider.overrideWithValue(sharedPrefsInstance),
///   ],
///   child: MyApp(),
/// )
/// ```
@riverpod
SharedPreferences sharedPreferences(Ref ref) => throw UnimplementedError();

/// Manages locale preferences and state
///
/// This provider handles the application's locale settings, including:
/// - Loading stored locale preferences from SharedPreferences
/// - Setting new locale preferences
/// - Providing default locale fallback
/// - Invalidating state when preferences change
///
/// The default locale is Japanese ('ja') to match the main application default.
@riverpod
class AppLocaleProvider extends _$AppLocaleProvider {
  /// Builds the initial locale state
  ///
  /// Loads the stored locale preference from the repository, or returns
  /// the default Japanese locale if no preference is stored.
  ///
  /// Returns:
  /// A [Future<Locale>] representing the current locale preference
  @override
  Future<Locale> build() async {
    final repository = ref.read(appPreferencesRepositoryProvider);
    final locale = await repository.getLocale();

    if (locale != null) {
      return locale;
    }

    // Default to Japanese if no preference is stored
    // (matching main.dart default)
    return const Locale('ja');
  }

  /// Sets the locale preference and updates the state
  ///
  /// Stores the new locale preference in SharedPreferences and invalidates
  /// the provider state to trigger UI updates.
  ///
  /// Parameters:
  /// - [locale]: The new locale to set as preference
  ///
  /// Example:
  /// ```dart
  /// await ref.read(appLocaleProviderProvider.notifier)
  ///     .setLocale(const Locale('en'));
  /// ```
  Future<void> setLocale(Locale locale) async {
    final repository = ref.read(appPreferencesRepositoryProvider);

    await repository.setLocale(locale);
    ref.invalidateSelf();
  }

  /// Clears the stored locale preference and resets to default
  ///
  /// Removes the locale preference from SharedPreferences and invalidates
  /// the provider state, causing it to fall back to the default locale.
  Future<void> clearLocale() async {
    final repository = ref.read(appPreferencesRepositoryProvider);
    await repository.clearLocale();
    ref.invalidateSelf();
  }
}

/// Manages theme mode preferences and state
///
/// This provider handles the application's theme settings, including:
/// - Loading stored theme mode preferences from SharedPreferences
/// - Setting new theme mode preferences (system, light, dark)
/// - Providing default theme mode fallback
/// - Invalidating state when preferences change
///
/// The default theme mode is system to respect user's device preferences.
@riverpod
class AppThemeProvider extends _$AppThemeProvider {
  /// Builds the initial theme mode state
  ///
  /// Loads the stored theme mode preference from the repository, or returns
  /// the default system theme mode if no preference is stored.
  ///
  /// Returns:
  /// A [Future<ThemeMode>] representing the current theme mode preference
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

  /// Sets the theme mode preference and updates the state
  ///
  /// Stores the new theme mode preference in SharedPreferences and
  /// invalidates the provider state to trigger UI updates.
  ///
  /// Parameters:
  /// - [mode]: The new theme mode to set (system, light, or dark)
  ///
  /// Example:
  /// ```dart
  /// await ref.read(appThemeProviderProvider.notifier)
  ///     .setThemeMode(ThemeMode.dark);
  /// ```
  Future<void> setThemeMode(ThemeMode mode) async {
    final repository = ref.read(appPreferencesRepositoryProvider);

    await repository.setTheme(mode);
    ref.invalidateSelf();
  }

  /// Clears the stored theme mode preference and resets to default
  ///
  /// Removes the theme mode preference from SharedPreferences and
  /// invalidates the provider state, causing it to fall back to
  /// the default system theme mode.
  Future<void> clearTheme() async {
    final repository = ref.read(appPreferencesRepositoryProvider);
    await repository.clearTheme();
    ref.invalidateSelf();
  }
}
