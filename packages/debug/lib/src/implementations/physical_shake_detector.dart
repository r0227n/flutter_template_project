import 'package:debug/src/interfaces/shake_detector.dart';
import 'package:debug/src/services/platform_detection_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shake_detector/shake_detector.dart';

/// Physical shake detector implementation (Dependency Inversion Principle)
class PhysicalShakeDetector implements ShakeDetectorInterface {
  PhysicalShakeDetector({void Function()? onShake}) : _onShake = onShake;

  ShakeDetector? _detector;
  bool _isInitialized = false;
  final void Function()? _onShake;

  @override
  void initialize() {
    if (!isSupported) {
      return;
    }

    try {
      _detector = ShakeDetector.autoStart(
        onShake: () {
          if (PlatformDetectionService.isDebugModeEnabled) {
            _handleShakeEvent();
          }
        },
      );
      _isInitialized = true;
    } on Object catch (e) {
      // Fail silently to prevent information disclosure
      if (kDebugMode) {
        debugPrint('Shake detector initialization failed: $e');
      }
    }
  }

  @override
  bool get isSupported => PlatformDetectionService.isShakeSupported;

  @override
  void simulateShake() {
    if (kDebugMode && _isInitialized) {
      _handleShakeEvent();
    }
  }

  @override
  void dispose() {
    _detector?.stopListening();
    _detector = null;
    _isInitialized = false;
  }

  void _handleShakeEvent() {
    if (PlatformDetectionService.isReleaseMode) {
      return;
    }
    
    _onShake?.call();
    debugPrint('Shake detected - navigating to debug screen');
  }
}
