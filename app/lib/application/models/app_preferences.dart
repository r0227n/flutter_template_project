enum AppThemePreference { system, light, dark }

final class AppPreferences {
  const AppPreferences({
    this.theme = AppThemePreference.system,
    this.languageCode = 'ja',
  });
  final AppThemePreference theme;
  final String languageCode;
}
