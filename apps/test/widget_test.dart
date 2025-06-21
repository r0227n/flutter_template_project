import 'package:apps/i18n/translations.g.dart';
import 'package:apps/main.dart';
import 'package:apps/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('Locale Functionality Tests', () {
    // Test the locale settings and persistence
    test('Locale persistence test', () async {
      // Set to Japanese and verify it persists
      await LocaleSettings.setLocale(AppLocale.ja);
      expect(LocaleSettings.currentLocale, AppLocale.ja);

      // Set to English and verify it persists
      await LocaleSettings.setLocale(AppLocale.en);
      expect(LocaleSettings.currentLocale, AppLocale.en);

      // Verify device locale detection works
      final deviceLocale = await LocaleSettings.useDeviceLocale();
      expect(deviceLocale, isA<AppLocale>());
    });

    test('Translation loading test', () async {
      // Test Japanese translations
      await LocaleSettings.setLocale(AppLocale.ja);
      final jaTranslations = LocaleSettings.instance.currentTranslations;
      expect(jaTranslations.hello, equals('こんにちは'));

      // Test English translations
      await LocaleSettings.setLocale(AppLocale.en);
      final enTranslations = LocaleSettings.instance.currentTranslations;
      expect(enTranslations.hello, equals('Hello'));
    });

    test('Supported locales test', () {
      // Verify all expected locales are supported
      expect(AppLocale.values, contains(AppLocale.en));
      expect(AppLocale.values, contains(AppLocale.ja));
      expect(AppLocale.values.length, equals(2));
    });
  });

  group('Widget Tests', () {
    testWidgets('HomePage displays counter correctly', (tester) async {
      // Test just the HomePage widget with Japanese locale
      await LocaleSettings.setLocale(AppLocale.ja);

      await tester.pumpWidget(
        MaterialApp(
          home: TranslationProvider(
            child: const HomePage(title: 'Test App'),
          ),
        ),
      );

      // Verify that our counter starts at 0
      expect(find.text('0'), findsOneWidget);
      expect(find.text('こんにちは'), findsOneWidget);

      // Tap the '+' icon and trigger a frame
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Verify that our counter has incremented
      expect(find.text('1'), findsOneWidget);
      expect(find.text('0'), findsNothing);
    });

    testWidgets('App structure test', (tester) async {
      // Set locale first
      await LocaleSettings.setLocale(AppLocale.ja);

      // Build the app with proper providers
      await tester.pumpWidget(
        ProviderScope(
          child: TranslationProvider(
            child: const MyApp(),
          ),
        ),
      );

      // Wait briefly for routing to settle
      await tester.pump();

      // Verify basic app structure exists
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
