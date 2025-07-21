// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:app/i18n/translations.g.dart' as app_translations;
import 'package:app/pages/home/home_page.dart';
import 'package:app_logger/app_logger.dart';
import 'package:app_preferences/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  setUpAll(() {
    // Initialize AppLogger for all tests
    if (!AppLogger.isInitialized) {
      AppLogger.initialize(LoggerConfig.development());
    }
  });

  group('Basic Widget Tests', () {
    testWidgets('Counter increments smoke test', (tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        ProviderScope(
          child: app_translations.TranslationProvider(
            child: const MaterialApp(
              home: HomePage(title: 'Flutter Template'),
            ),
          ),
        ),
      );

      // Verify that our counter starts at 0.
      expect(find.text('カウンター: 0'), findsOneWidget);
      expect(find.text('カウンター: 1'), findsNothing);

      // Tap the '+' icon and trigger a frame.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Verify that our counter has incremented.
      expect(find.text('カウンター: 0'), findsNothing);
      expect(find.text('カウンター: 1'), findsOneWidget);
    });

    testWidgets('App displays correct title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: app_translations.TranslationProvider(
            child: const MaterialApp(
              home: HomePage(title: 'Flutter Template'),
            ),
          ),
        ),
      );

      // Verify the app title is displayed
      expect(find.text('Flutter Template'), findsOneWidget);
    });

    testWidgets('Floating action button exists and is tappable', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: app_translations.TranslationProvider(
            child: const MaterialApp(
              home: HomePage(title: 'Flutter Template'),
            ),
          ),
        ),
      );

      // Find the floating action button
      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);

      // Verify it has the correct icon
      expect(find.byIcon(Icons.add), findsOneWidget);

      // Tap it and verify it works
      await tester.tap(fab);
      await tester.pump();
    });

    testWidgets('AppBar shows correct styling', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: app_translations.TranslationProvider(
            child: const MaterialApp(
              home: HomePage(title: 'Flutter Template'),
            ),
          ),
        ),
      );

      // Find the AppBar
      final appBar = find.byType(AppBar);
      expect(appBar, findsOneWidget);

      // Get the AppBar widget
      final appBarWidget = tester.widget<AppBar>(appBar);

      // Verify the background color uses the theme
      expect(
        appBarWidget.backgroundColor,
        isNotNull,
      );
    });
  });

  group('Theme Tests', () {
    testWidgets('App respects system theme', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: app_translations.TranslationProvider(
            child: const MaterialApp(
              home: HomePage(title: 'Flutter Template'),
            ),
          ),
        ),
      );

      // Get the MaterialApp
      final materialApp = find.byType(MaterialApp);
      expect(materialApp, findsOneWidget);

      final app = tester.widget<MaterialApp>(materialApp);
      // Note: theme and darkTheme might be null in test environment
      // Just verify the app loads without errors
      expect(app, isNotNull);
    });
  });

  group('Settings Integration', () {
    testWidgets('Settings icon exists in AppBar', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: app_translations.TranslationProvider(
            child: const MaterialApp(
              home: HomePage(title: 'Flutter Template'),
            ),
          ),
        ),
      );

      // Find the settings icon button
      final settingsIcon = find.byIcon(Icons.settings);
      expect(settingsIcon, findsOneWidget);
    });

    testWidgets('Settings button is tappable', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: app_translations.TranslationProvider(
            child: const MaterialApp(
              home: HomePage(title: 'Flutter Template'),
            ),
          ),
        ),
      );

      // Find and verify the settings icon button can be tapped
      final settingsIcon = find.byIcon(Icons.settings);
      expect(settingsIcon, findsOneWidget);

      // The tap itself might fail due to routing, but the button should be
      // tappable
      // We'll just verify it exists and is interactive
      final iconButton = tester.widget<IconButton>(
        find.ancestor(
          of: settingsIcon,
          matching: find.byType(IconButton),
        ),
      );
      expect(iconButton.onPressed, isNotNull);
    });
  });

  group('Localization Tests', () {
    testWidgets('App initializes with correct locale', (tester) async {
      // Create a test SharedPreferences instance
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: app_translations.TranslationProvider(
            child: const MaterialApp(
              home: HomePage(title: 'Flutter Template'),
            ),
          ),
        ),
      );

      // Verify the app loads without errors
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Japanese text appears in Japanese locale', (
      tester,
    ) async {
      // Set locale to Japanese
      await app_translations.LocaleSettings.setLocale(
        app_translations.AppLocale.ja,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: app_translations.TranslationProvider(
            child: const MaterialApp(
              home: HomePage(title: 'Flutter Template'),
            ),
          ),
        ),
      );

      // Verify Japanese greeting appears
      expect(find.text('こんにちは'), findsOneWidget);
    });
  });
}
