import 'package:flutter_test/flutter_test.dart';
import 'package:debug/debug.dart';

/// Tests for Debug Navigation following F.I.R.S.T. principles
void main() {
  group('DebugNavigation', () {
    test('should provide route for TalkerScreen', () {
      // Given: Debug navigation configuration
      // When: Getting Talker screen route
      final route = DebugNavigation.talkerRoute;
      
      // Then: Should return valid route path
      expect(route, isA<String>());
      expect(route, isNotEmpty);
    });

    test('should create navigation extension', () {
      // Given: Navigation context capability
      // When: Accessing debug navigation methods
      // Then: Should provide navigation utilities
      expect(DebugNavigation.navigateToTalkerScreen, isNotNull);
    });
  });
}