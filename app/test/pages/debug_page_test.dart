import 'package:app/pages/debug_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('DebugPage Widget Tests', () {
    testWidgets('should display debug page title', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const DebugPage(),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('Debug Page'), findsOneWidget);
    });

    testWidgets('should display time setting section', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const DebugPage(),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('Time Setting'), findsOneWidget);
    });

    testWidgets('should have back button functionality', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DebugPage()),
                  ),
                  child: const Text('Go to Debug'),
                ),
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Go to Debug'));
      await tester.pumpAndSettle();

      // Assert - Back button should exist
      expect(find.byType(BackButton), findsOneWidget);
    });

    testWidgets('should display current time when clock package is used', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const DebugPage(),
          ),
        ),
      );

      // Act & Assert
      expect(find.textContaining(':'), findsAtLeastNWidgets(1)); // Time format HH:MM
    });
  });
}