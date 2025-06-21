import 'package:app_preferences/src/models/app_locale_preference.dart';
import 'package:app_preferences/src/models/app_theme_preference.dart';
import 'package:app_preferences/src/repositories/app_preferences_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AppPreferencesRepository', () {
    late AppPreferencesRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      repository = AppPreferencesRepository(preferences: prefs);
    });

    group('Locale preferences', () {
      test('should save and retrieve locale preference', () async {
        final locale = AppLocalePreference(
          languageCode: 'ja',
          countryCode: 'JP',
        );

        await repository.saveLocale(locale);
        final retrieved = repository.getLocale();

        expect(retrieved, isNotNull);
        expect(retrieved!.languageCode, equals('ja'));
        expect(retrieved.countryCode, equals('JP'));
      });

      test('should return null when no locale is saved', () {
        final locale = repository.getLocale();
        expect(locale, isNull);
      });

      test('should clear locale preference', () async {
        final locale = AppLocalePreference(languageCode: 'en');
        await repository.saveLocale(locale);
        
        expect(repository.getLocale(), isNotNull);
        
        await repository.clearLocale();
        expect(repository.getLocale(), isNull);
      });
    });

    group('Theme preferences', () {
      test('should save and retrieve theme preference', () async {
        final theme = AppThemePreference(mode: AppThemeMode.dark);

        await repository.saveTheme(theme);
        final retrieved = repository.getTheme();

        expect(retrieved, isNotNull);
        expect(retrieved!.mode, equals(AppThemeMode.dark));
      });

      test('should return null when no theme is saved', () {
        final theme = repository.getTheme();
        expect(theme, isNull);
      });

      test('should clear theme preference', () async {
        final theme = AppThemePreference(mode: AppThemeMode.light);
        await repository.saveTheme(theme);
        
        expect(repository.getTheme(), isNotNull);
        
        await repository.clearTheme();
        expect(repository.getTheme(), isNull);
      });
    });

    test('should clear all preferences', () async {
      final locale = AppLocalePreference(languageCode: 'ja');
      final theme = AppThemePreference(mode: AppThemeMode.dark);
      
      await repository.saveLocale(locale);
      await repository.saveTheme(theme);
      
      expect(repository.getLocale(), isNotNull);
      expect(repository.getTheme(), isNotNull);
      
      await repository.clearAll();
      
      expect(repository.getLocale(), isNull);
      expect(repository.getTheme(), isNull);
    });
  });
}