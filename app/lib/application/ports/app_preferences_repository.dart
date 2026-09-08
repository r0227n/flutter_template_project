import 'package:app/application/models/app_preferences.dart';

abstract interface class AppPreferencesRepository {
  AppPreferences load();
  Future<void> saveTheme(AppThemePreference theme);
  Future<void> saveLanguage(String languageCode);
}
