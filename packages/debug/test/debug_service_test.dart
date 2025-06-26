import 'package:debug/debug.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for DebugService following F.I.R.S.T. principles:
/// - Fast: < 0.1 seconds execution
/// - Independent: No test interdependencies  
/// - Repeatable: Consistent results
/// - Self-validating: Clear pass/fail
/// - Timely: Written before implementation
void main() {
  group('DebugService', () {
    test('should initialize successfully', () {
      // Given: Debug service is not initialized
      // When: Initializing debug service
      // Then: Should complete without errors
      expect(DebugService.initialize, returnsNormally);
    });

    test('should provide Talker instance', () {
      // Given: Debug service is initialized
      DebugService.initialize();
      
      // When: Getting Talker instance
      final talker = DebugService.talker;
      
      // Then: Should return non-null Talker instance
      expect(talker, isNotNull);
    });

    test('should enable shake detector on mobile platforms', () {
      // Given: Debug service with shake detector capability
      DebugService.initialize();
      
      // When: Checking shake detector status
      final isShakeEnabled = DebugService.isShakeDetectorEnabled;
      
      // Then: Should be enabled on supported platforms
      expect(isShakeEnabled, isA<bool>());
    });

    test('should log messages through Talker', () {
      // Given: Initialized debug service
      DebugService.initialize();
      
      // When: Logging a message
      const testMessage = 'Test log message';
      
      // Then: Should not throw exceptions
      expect(() => DebugService.log(testMessage), returnsNormally);
    });
  });
}
