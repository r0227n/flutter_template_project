import 'interfaces/debug_logger.dart';
import 'interfaces/shake_detector.dart';
import 'implementations/talker_debug_logger.dart';
import 'implementations/physical_shake_detector.dart';
import 'services/platform_detection_service.dart';
import 'services/log_filter_service.dart';

/// Main debug service coordinating debug functionality (Single Responsibility Principle)
class DebugService {
  static DebugLogger? _logger;
  static ShakeDetectorInterface? _shakeDetector;
  static bool _isInitialized = false;

  /// Initialize debug service with dependency injection (Dependency Inversion Principle)
  static void initialize({
    DebugLogger? logger,
    ShakeDetectorInterface? shakeDetector,
  }) {
    if (!PlatformDetectionService.isDebugModeEnabled) return;

    _logger = logger ?? TalkerDebugLogger();
    _shakeDetector = shakeDetector ?? PhysicalShakeDetector();
    
    _shakeDetector?.initialize();
    _isInitialized = true;
  }

  /// Get current logger instance
  static DebugLogger get logger {
    return _logger ?? TalkerDebugLogger();
  }

  /// Legacy talker access for backward compatibility
  static dynamic get talker {
    final currentLogger = _logger;
    if (currentLogger is TalkerDebugLogger) {
      return currentLogger.talker;
    }
    return TalkerDebugLogger().talker;
  }

  /// Platform-aware shake detector status
  static bool get isShakeDetectorEnabled {
    return _shakeDetector?.isSupported ?? false;
  }

  /// Main logging method
  static void log(String message) {
    logger.log(message);
  }

  /// Error logging
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    logger.error(message, error, stackTrace);
  }

  /// Warning logging
  static void warning(String message) {
    logger.warning(message);
  }

  /// Info logging
  static void info(String message) {
    logger.info(message);
  }

  /// Dispose all resources (Performance optimization)
  static void dispose() {
    _shakeDetector?.dispose();
    _logger = null;
    _shakeDetector = null;
    _isInitialized = false;
    
    // Clean up filter service cache
    LogFilterService.dispose();
  }
}