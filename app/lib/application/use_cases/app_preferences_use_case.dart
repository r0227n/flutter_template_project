import 'package:app/application/models/app_preferences.dart';
import 'package:app/application/ports/app_preferences_repository.dart';

final class AppPreferencesUseCase {
  const AppPreferencesUseCase(this._repository);
  final AppPreferencesRepository _repository;
  AppPreferences load() => _repository.load();
  Future<void> saveTheme(AppThemePreference theme) =>
      _repository.saveTheme(theme);
  Future<void> saveLanguage(String code) {
    if (code != 'ja' && code != 'en') throw ArgumentError.value(code, 'code');
    return _repository.saveLanguage(code);
  }
}
