import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App Preferences', () {
    test('AppPreferences exports all required components', () {
      // Basic test to ensure the package exports are working
      expect(AppTheme.lightTheme, isNotNull);
      expect(AppTheme.darkTheme, isNotNull);
    });
  });
}
