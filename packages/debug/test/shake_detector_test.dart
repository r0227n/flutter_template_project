import 'package:debug/debug.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for ShakeDetectorService following F.I.R.S.T. principles
void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  tearDownAll(ShakeDetectorService.dispose);

  group('ShakeDetectorService', () {
    test('should initialize on supported platforms', () {
      // Given: Shake detector service
      // When: Initializing on supported platform
      // Then: Should complete without errors
      // (may fail silently on unsupported platforms)
      expect(ShakeDetectorService.initialize, returnsNormally);
    });

    test('should detect platform support correctly', () {
      // Given: Platform detection capability
      // When: Checking platform support
      final isSupported = ShakeDetectorService.isPlatformSupported;
      
      // Then: Should return boolean value
      expect(isSupported, isA<bool>());
    });

    test('should handle shake events', () {
      // Given: Shake detection capability
      // When: Simulating shake event
      // Then: Should not throw exceptions
      expect(ShakeDetectorService.simulateShake, returnsNormally);
    });
  });
}
