import 'package:app_preferences/src/providers/app_preferences_provider.dart';
import 'package:app_preferences/src/repositories/app_preferences_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AppLocaleProvider', () {
    late ProviderContainer container;
    late AppPreferencesRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final mockPrefs = await SharedPreferences.getInstance();
      repository = AppPreferencesRepository(prefs: mockPrefs);

      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          appPreferencesRepositoryProvider.overrideWithValue(repository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test(
      'build returns default Japanese locale when no preference is stored',
      () async {
        final provider = container.read(appLocaleProviderProvider.future);
        final result = await provider;

        expect(result.languageCode, 'ja');
        expect(result.countryCode, isNull);
      },
    );

    test('build returns stored locale preference', () async {
      const locale = Locale('en', 'US');
      await repository.setLocale(locale);

      final provider = container.read(appLocaleProviderProvider.future);
      final result = await provider;

      expect(result.languageCode, 'en');
      expect(result.countryCode, 'US');
    });

    test('setLocale updates the preference and state', () async {
      const newLocale = Locale('fr', 'FR');
      final notifier = container.read(appLocaleProviderProvider.notifier);

      await notifier.setLocale(newLocale);

      final result = await container.read(appLocaleProviderProvider.future);
      expect(result.languageCode, 'fr');
      expect(result.countryCode, 'FR');

      // Verify it was stored in repository
      final storedLocale = await repository.getLocale();
      expect(storedLocale?.languageCode, 'fr');
      expect(storedLocale?.countryCode, 'FR');
    });

    test('clearLocale removes preference and resets to default', () async {
      // First set a locale
      const locale = Locale('en', 'US');
      await repository.setLocale(locale);

      final notifier = container.read(appLocaleProviderProvider.notifier);
      await notifier.clearLocale();

      final result = await container.read(appLocaleProviderProvider.future);
      expect(result.languageCode, 'ja'); // Should reset to default
      expect(result.countryCode, isNull);

      // Verify it was cleared from repository
      final storedLocale = await repository.getLocale();
      expect(storedLocale, isNull);
    });
  });

  group('AppThemeProvider', () {
    late ProviderContainer container;
    late AppPreferencesRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final mockPrefs = await SharedPreferences.getInstance();
      repository = AppPreferencesRepository(prefs: mockPrefs);

      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          appPreferencesRepositoryProvider.overrideWithValue(repository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test(
      'build returns system theme mode when no preference is stored',
      () async {
        final provider = container.read(appThemeProviderProvider.future);
        final result = await provider;

        expect(result, ThemeMode.system);
      },
    );

    test('build returns stored theme mode preference', () async {
      await repository.setTheme(ThemeMode.dark);

      final provider = container.read(appThemeProviderProvider.future);
      final result = await provider;

      expect(result, ThemeMode.dark);
    });

    test('setThemeMode updates the preference and state', () async {
      const newThemeMode = ThemeMode.light;
      final notifier = container.read(appThemeProviderProvider.notifier);

      await notifier.setThemeMode(newThemeMode);

      final result = await container.read(appThemeProviderProvider.future);
      expect(result, ThemeMode.light);

      // Verify it was stored in repository
      final storedTheme = await repository.getTheme();
      expect(storedTheme, ThemeMode.light);
    });

    test('clearTheme removes preference and resets to default', () async {
      // First set a theme
      await repository.setTheme(ThemeMode.dark);

      final notifier = container.read(appThemeProviderProvider.notifier);
      await notifier.clearTheme();

      final result = await container.read(appThemeProviderProvider.future);
      expect(result, ThemeMode.system); // Should reset to default

      // Verify it was cleared from repository
      final storedTheme = await repository.getTheme();
      expect(storedTheme, isNull);
    });

    test('supports all theme modes', () async {
      final notifier = container.read(appThemeProviderProvider.notifier);

      // Test system mode
      await notifier.setThemeMode(ThemeMode.system);
      var result = await container.read(appThemeProviderProvider.future);
      expect(result, ThemeMode.system);

      // Test light mode
      await notifier.setThemeMode(ThemeMode.light);
      result = await container.read(appThemeProviderProvider.future);
      expect(result, ThemeMode.light);

      // Test dark mode
      await notifier.setThemeMode(ThemeMode.dark);
      result = await container.read(appThemeProviderProvider.future);
      expect(result, ThemeMode.dark);
    });
  });

  group('Provider Dependencies', () {
    test(
      'appPreferencesRepositoryProvider creates repository with '
      'SharedPreferences',
      () async {
        SharedPreferences.setMockInitialValues({});
        final mockPrefs = await SharedPreferences.getInstance();

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
          ],
        );

        final repository = container.read(appPreferencesRepositoryProvider);
        expect(repository, isA<AppPreferencesRepository>());

        container.dispose();
      },
    );

    test('sharedPreferencesProvider throws UnimplementedError by default', () {
      final container = ProviderContainer();

      expect(
        () => container.read(sharedPreferencesProvider),
        throwsA(isA<UnimplementedError>()),
      );

      container.dispose();
    });
  });
}
