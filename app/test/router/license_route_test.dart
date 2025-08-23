import 'package:app/i18n/translations.g.dart' as app_translations;
import 'package:app/pages/license/license_page.dart';
import 'package:app/router/routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  setUpAll(() {
    // Initialize AppLogger for all tests
    if (!AppLogger.isInitialized) {
      AppLogger.initialize(LoggerConfig.development());
    }
  });

  group('LicenseRoute TDD Tests', () {
    testWidgets('LicenseRoute should exist and be navigable from settings', (
      tester,
    ) async {
      // RED phase: This test should FAIL initially
      // We expect LicenseRoute to exist but it doesn't yet

      final router = GoRouter(
        routes: $appRoutes,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: app_translations.TranslationProvider(
            child: MaterialApp.router(
              routerConfig: router,
            ),
          ),
        ),
      );

      // Navigate to settings
      router.go('/settings');
      await tester.pumpAndSettle();

      // Verify settings page loads
      expect(find.text('設定'), findsOneWidget);

      // Try to navigate to license route - this should work after 
      // implementation
      router.go('/settings/license');
      await tester.pumpAndSettle();

      // This should find a license page (will fail initially)
      expect(find.byType(CustomLicensePage), findsOneWidget);
    });

    testWidgets('LicenseRoute should be accessible via LicenseRoute().go()', (
      tester,
    ) async {
      // RED phase: Test type-safe navigation

      final router = GoRouter(
        routes: $appRoutes,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: app_translations.TranslationProvider(
            child: MaterialApp.router(
              routerConfig: router,
            ),
          ),
        ),
      );

      // This should work after implementation
      const LicenseRoute().go(
        router.routerDelegate.navigatorKey.currentContext!,
      );
      await tester.pumpAndSettle();

      // Verify license page is displayed
      expect(find.byType(CustomLicensePage), findsOneWidget);
      expect(find.text('ライセンス'), findsOneWidget); // Japanese for "License"
    });

    testWidgets(
      'Settings page should use LicenseRoute navigation instead of '
      'showLicensePage',
      (tester) async {
        // RED phase: Verify navigation method change

        final router = GoRouter(
          routes: $appRoutes,
        );

        await tester.pumpWidget(
          ProviderScope(
            child: app_translations.TranslationProvider(
              child: MaterialApp.router(
                routerConfig: router,
              ),
            ),
          ),
        );

        // Navigate to settings
        router.go('/settings');
        await tester.pumpAndSettle();

        // Find and tap the license list tile
        final licenseTile = find.text('ライセンス');
        expect(licenseTile, findsOneWidget);

        await tester.tap(licenseTile);
        await tester.pumpAndSettle();

        // Should navigate to license route, not show dialog
        expect(find.byType(CustomLicensePage), findsOneWidget);

        // Should be able to navigate back
        router.pop();
        await tester.pumpAndSettle();
        expect(find.text('設定'), findsOneWidget);
      },
    );
  });
}
