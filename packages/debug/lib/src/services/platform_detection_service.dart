import 'package:flutter/foundation.dart';

/// Service for platform detection (Single Responsibility Principle)
class PlatformDetectionService {
  /// Check if current platform supports shake detection
  static bool get isShakeSupported {
    return (kDebugMode || kProfileMode) &&
           (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);
  }

  /// Check if debug features should be enabled
  static bool get isDebugModeEnabled {
    return kDebugMode || kProfileMode;
  }

  /// Check if running in release mode
  static bool get isReleaseMode {
    return kReleaseMode;
  }
}