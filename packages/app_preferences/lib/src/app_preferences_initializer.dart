import 'package:app_preferences/src/repositories/app_preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Utility class for initializing app preferences during app startup
///
/// This class provides static methods to initialize application preferences
/// and settings before the main app widget is created. It handles the setup
/// of locale, theme, and other user preferences from stored values.
class AppPreferencesInitializer {
  const AppPreferencesInitializer._();

  /// Initializes locale settings from stored preferences and returns
  /// SharedPreferences instance
  ///
  /// This method should be called during app startup in main() before running
  /// the app. It reads the stored locale preference from SharedPreferences and
  /// calls the appropriate callback to set up the initial locale state.
  ///
  /// The method returns the SharedPreferences instance for use in provider
  /// overrides.
  ///
  /// Parameters:
  /// - [onLocaleFound]: Called when a stored locale preference is found
  /// - [onUseDeviceLocale]: Called when no stored preference exists
  ///   (fallback to device locale)
  /// - [prefs]: Optional SharedPreferences instance (will create new if not
  ///   provided)
  ///
  /// Returns:
  /// SharedPreferences instance that can be used for provider initialization
  ///
  /// Example usage in main.dart:
  /// ```dart
  /// Future<void> main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///
  ///   final sharedPrefs = await prefs.AppPreferencesInitializer
  ///       .initializeLocale(
  ///     onLocaleFound: (languageCode) async {
  ///       final appLocale = AppLocale.values.firstWhere(
  ///         (locale) => locale.languageCode == languageCode,
  ///         orElse: () => AppLocale.ja,
  ///       );
  ///       await LocaleSettings.setLocale(appLocale);
  ///     },
  ///     onUseDeviceLocale: () async {
  ///       await LocaleSettings.useDeviceLocale();
  ///     },
  ///   );
  ///
  ///   runApp(
  ///     ProviderScope(
  ///       overrides: [
  ///         prefs.sharedPreferencesProvider.overrideWithValue(sharedPrefs),
  ///       ],
  ///       child: MyApp(),
  ///     ),
  ///   );
  /// }
  /// ```
  static Future<SharedPreferences> initializeLocale({
    required Future<void> Function(String languageCode) onLocaleFound,
    required Future<void> Function() onUseDeviceLocale,
    SharedPreferences? prefs,
  }) async {
    final sharedPrefs = prefs ?? await SharedPreferences.getInstance();
    final repository = AppPreferencesRepository(prefs: sharedPrefs);
    await repository.initializeLocale(
      onLocaleFound: onLocaleFound,
      onUseDeviceLocale: onUseDeviceLocale,
    );

    return sharedPrefs;
  }
}
