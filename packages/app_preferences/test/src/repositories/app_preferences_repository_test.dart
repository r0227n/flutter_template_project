import 'dart:convert';

import 'package:app_preferences/src/repositories/app_preferences_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AppPreferencesRepository', () {
    late AppPreferencesRepository repository;
    late SharedPreferences mockPrefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      mockPrefs = await SharedPreferences.getInstance();
      repository = AppPreferencesRepository(prefs: mockPrefs);
    });

    group('Locale Management', () {
      test('getLocale returns null when no preference is stored', () async {
        final result = await repository.getLocale();
        expect(result, isNull);
      });

      test('setLocale stores locale preference correctly', () async {
        const locale = Locale('en', 'US');

        await repository.setLocale(locale);

        final storedJson = mockPrefs.getString('app_locale');
        expect(storedJson, isNotNull);

        final decoded = jsonDecode(storedJson!) as Map<String, dynamic>;
        expect(decoded['languageCode'], 'en');
        expect(decoded['countryCode'], 'US');
      });

      test('getLocale retrieves stored locale preference', () async {
        const locale = Locale('ja', 'JP');
        await repository.setLocale(locale);

        final result = await repository.getLocale();

        expect(result?.languageCode, 'ja');
        expect(result?.countryCode, 'JP');
      });

      test('getLocale handles locale without country code', () async {
        const locale = Locale('ja');
        await repository.setLocale(locale);

        final result = await repository.getLocale();

        expect(result?.languageCode, 'ja');
        expect(result?.countryCode, isNull);
      });

      test('getLocale returns null when invalid JSON is stored', () async {
        await mockPrefs.setString('app_locale', 'invalid json');

        final result = await repository.getLocale();

        expect(result, isNull);
      });

      test('clearLocale removes stored preference', () async {
        const locale = Locale('en');
        await repository.setLocale(locale);

        await repository.clearLocale();

        final result = await repository.getLocale();
        expect(result, isNull);
      });
    });

    group('Theme Management', () {
      test('getTheme returns null when no preference is stored', () async {
        final result = await repository.getTheme();
        expect(result, isNull);
      });

      test('setTheme stores system theme preference correctly', () async {
        await repository.setTheme(ThemeMode.system);

        final stored = mockPrefs.getString('app_theme');
        expect(stored, 'system');
      });

      test('setTheme stores light theme preference correctly', () async {
        await repository.setTheme(ThemeMode.light);

        final stored = mockPrefs.getString('app_theme');
        expect(stored, 'light');
      });

      test('setTheme stores dark theme preference correctly', () async {
        await repository.setTheme(ThemeMode.dark);

        final stored = mockPrefs.getString('app_theme');
        expect(stored, 'dark');
      });

      test('getTheme retrieves system theme preference', () async {
        await repository.setTheme(ThemeMode.system);

        final result = await repository.getTheme();

        expect(result, ThemeMode.system);
      });

      test('getTheme retrieves light theme preference', () async {
        await repository.setTheme(ThemeMode.light);

        final result = await repository.getTheme();

        expect(result, ThemeMode.light);
      });

      test('getTheme retrieves dark theme preference', () async {
        await repository.setTheme(ThemeMode.dark);

        final result = await repository.getTheme();

        expect(result, ThemeMode.dark);
      });

      test('getTheme returns null for invalid theme string', () async {
        await mockPrefs.setString('app_theme', 'invalid_theme');

        final result = await repository.getTheme();

        expect(result, isNull);
      });

      test('clearTheme removes stored preference', () async {
        await repository.setTheme(ThemeMode.dark);

        await repository.clearTheme();

        final result = await repository.getTheme();
        expect(result, isNull);
      });
    });

    group('Initialization', () {
      test(
        'initializeLocale calls onLocaleFound when preference exists',
        () async {
          const locale = Locale('en', 'US');
          await repository.setLocale(locale);

          String? receivedLanguageCode;
          var deviceLocaleUsed = false;

          await repository.initializeLocale(
            onLocaleFound: (languageCode) async {
              receivedLanguageCode = languageCode;
            },
            onUseDeviceLocale: () async {
              deviceLocaleUsed = true;
            },
          );

          expect(receivedLanguageCode, 'en');
          expect(deviceLocaleUsed, false);
        },
      );

      test(
        'initializeLocale calls onUseDeviceLocale when no preference exists',
        () async {
          String? receivedLanguageCode;
          var deviceLocaleUsed = false;

          await repository.initializeLocale(
            onLocaleFound: (languageCode) async {
              receivedLanguageCode = languageCode;
            },
            onUseDeviceLocale: () async {
              deviceLocaleUsed = true;
            },
          );

          expect(receivedLanguageCode, isNull);
          expect(deviceLocaleUsed, true);
        },
      );

      test(
        'initializeLocale calls onUseDeviceLocale when invalid JSON is stored',
        () async {
          await mockPrefs.setString('app_locale', 'invalid json');

          String? receivedLanguageCode;
          var deviceLocaleUsed = false;

          await repository.initializeLocale(
            onLocaleFound: (languageCode) async {
              receivedLanguageCode = languageCode;
            },
            onUseDeviceLocale: () async {
              deviceLocaleUsed = true;
            },
          );

          expect(receivedLanguageCode, isNull);
          expect(deviceLocaleUsed, true);
        },
      );
    });
  });
}
