import 'package:app/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('DebugRoute Tests', () {
    testWidgets('should navigate to debug page via route', (WidgetTester tester) async {
      // Arrange
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(
              body: ElevatedButton(
                onPressed: () => const DebugRoute().go(context),
                child: const Text('Go to Debug'),
              ),
            ),
          ),
          GoRoute(
            path: '/debug',
            builder: (context, state) => const DebugRoute().build(context, state),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Go to Debug'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Debug Page'), findsOneWidget);
    });

    testWidgets('should create DebugRoute instance successfully', (WidgetTester tester) async {
      // Act
      const route = DebugRoute();
      
      // Assert
      expect(route, isA<DebugRoute>());
      expect(route.location, equals('/debug'));
    });
  });
}