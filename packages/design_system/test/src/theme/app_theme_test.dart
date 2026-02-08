import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    test('lightTheme returns a valid ThemeData', () {
      final theme = AppTheme.lightTheme;

      expect(theme, isA<ThemeData>());
      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.brightness, Brightness.light);
    });

    test('darkTheme returns a valid ThemeData', () {
      final theme = AppTheme.darkTheme;

      expect(theme, isA<ThemeData>());
      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.brightness, Brightness.dark);
    });

    test('lightTheme has custom AppBar theme', () {
      final theme = AppTheme.lightTheme;

      expect(theme.appBarTheme.backgroundColor, isNotNull);
      expect(theme.appBarTheme.foregroundColor, isNotNull);
    });

    test('darkTheme has custom AppBar theme', () {
      final theme = AppTheme.darkTheme;

      expect(theme.appBarTheme.backgroundColor, isNotNull);
      expect(theme.appBarTheme.foregroundColor, isNotNull);
    });
  });
}
