import 'package:flutter/foundation.dart';
import 'package:shake_detector/shake_detector.dart';

/// Security-enhanced shake detector service implementation
class ShakeDetectorService {
  static ShakeDetector? _detector;
  static bool _isInitialized = false;

  /// Initialize shake detector with platform and security checks
  static void initialize() {
    // Security: Only initialize in debug/profile mode on supported platforms
    if ((kDebugMode || kProfileMode) && isPlatformSupported) {
      try {
        _detector = ShakeDetector.autoStart(
          onShake: () {
            // Security: Only execute in debug mode
            if (kDebugMode || kProfileMode) {
              _handleShakeEvent();
            }
          },
        );
        _isInitialized = true;
      } catch (e) {
        // Security: Fail silently to prevent information disclosure
        if (kDebugMode) {
          debugPrint('Shake detector initialization failed: $e');
        }
      }
    }
  }

  /// Platform support check with security validation
  static bool get isPlatformSupported {
    // Security: Only support mobile platforms in debug/profile mode
    return (kDebugMode || kProfileMode) &&
           (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);
  }

  /// Simulate shake for testing purposes
  static void simulateShake() {
    // Security: Only allow simulation in debug mode
    if (kDebugMode && _isInitialized) {
      _handleShakeEvent();
    }
  }

  /// Handle shake events securely
  static void _handleShakeEvent() {
    // Security: Additional validation before navigation
    if (kReleaseMode) return;
    
    // TODO: Navigate to Talker screen with proper authorization
    debugPrint('Shake detected - navigating to debug screen');
  }

  /// Dispose resources
  static void dispose() {
    _detector?.stopListening();
    _detector = null;
    _isInitialized = false;
  }
}