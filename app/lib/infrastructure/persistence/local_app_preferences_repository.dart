import 'package:app/application/application.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class LocalAppPreferencesRepository implements AppPreferencesRepository {
  const LocalAppPreferencesRepository(this._preferences);
  final SharedPreferences _preferences;
  static const themeKey = 'app.theme';
  static const languageKey = 'app.language';
  @override
  AppPreferences load() {
    final theme = _preferences.get(themeKey);
    final language = _preferences.get(languageKey);
    return AppPreferences(
      theme: AppThemePreference.values.firstWhere(
        (value) => value.name == theme,
        orElse: () => AppThemePreference.system,
      ),
      languageCode: language == 'en' ? 'en' : 'ja',
    );
  }

  @override
  Future<void> saveTheme(AppThemePreference theme) async {
    if (!await _preferences.setString(themeKey, theme.name)) {
      throw StateError('Failed to save theme');
    }
  }

  @override
  Future<void> saveLanguage(String languageCode) async {
    if (!await _preferences.setString(languageKey, languageCode)) {
      throw StateError('Failed to save language');
    }
  }
}
