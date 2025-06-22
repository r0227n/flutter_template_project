import 'package:app_preferences/src/repositories/app_preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Utility class for initializing app preferences during app startup
class AppPreferencesInitializer {
  const AppPreferencesInitializer._();

  /// Initializes locale settings from stored preferences
  ///
  /// This method should be called during app startup before running the app.
  /// It reads the stored locale preference and calls the appropriate callback.
  ///
  /// Example usage:
  /// ```dart
  /// final prefs = await SharedPreferences.getInstance();
  /// await AppPreferencesInitializer.initializeLocale(
  ///   prefs: prefs,
  ///   onLocaleFound: (languageCode) async {
  ///     final appLocale = AppLocale.values.firstWhere(
  ///       (locale) => locale.languageCode == languageCode,
  ///       orElse: () => AppLocale.ja,
  ///     );
  ///     await LocaleSettings.setLocale(appLocale);
  ///   },
  ///   onUseDeviceLocale: () async {
  ///     await LocaleSettings.useDeviceLocale();
  ///   },
  /// );
  /// ```
  static Future<void> initializeLocale({
    required SharedPreferences prefs,
    required Future<void> Function(String languageCode) onLocaleFound,
    required Future<void> Function() onUseDeviceLocale,
  }) async {
    final repository = AppPreferencesRepository(prefs: prefs);
    await repository.initializeLocale(
      onLocaleFound: onLocaleFound,
      onUseDeviceLocale: onUseDeviceLocale,
    );
  }
}
