import 'dart:ui';

import 'package:app_preferences/src/models/app_locale_preference.dart';
import 'package:app_preferences/src/models/app_theme_preference.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLocalePreference', () {
    test('should create from locale', () {
      const locale = Locale('en', 'US');
      final preference = AppLocalePreference.fromLocale(locale);

      expect(preference.languageCode, equals('en'));
      expect(preference.countryCode, equals('US'));
    });

    test('should convert to locale', () {
      final preference = AppLocalePreference(
        languageCode: 'ja',
        countryCode: 'JP',
      );
      final locale = preference.toLocale();

      expect(locale.languageCode, equals('ja'));
      expect(locale.countryCode, equals('JP'));
    });

    test('should handle locale without country code', () {
      const locale = Locale('en');
      final preference = AppLocalePreference.fromLocale(locale);

      expect(preference.languageCode, equals('en'));
      expect(preference.countryCode, isNull);
    });

    test('should serialize to and from JSON', () {
      final preference = AppLocalePreference(
        languageCode: 'en',
        countryCode: 'US',
      );
      
      final json = preference.toJson();
      expect(json['languageCode'], equals('en'));
      expect(json['countryCode'], equals('US'));
      
      final fromJson = AppLocalePreference.fromJson(json);
      expect(fromJson.languageCode, equals('en'));
      expect(fromJson.countryCode, equals('US'));
    });
  });

  group('AppThemePreference', () {
    test('should serialize to and from JSON', () {
      final preference = AppThemePreference(mode: AppThemeMode.dark);
      
      final json = preference.toJson();
      expect(json['mode'], equals('dark'));
      
      final fromJson = AppThemePreference.fromJson(json);
      expect(fromJson.mode, equals(AppThemeMode.dark));
    });

    test('should handle all theme modes', () {
      for (final mode in AppThemeMode.values) {
        final preference = AppThemePreference(mode: mode);
        final json = preference.toJson();
        final fromJson = AppThemePreference.fromJson(json);
        
        expect(fromJson.mode, equals(mode));
      }
    });
  });
}