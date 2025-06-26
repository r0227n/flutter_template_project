import 'package:debug/src/interfaces/debug_logger.dart';
import 'package:debug/src/services/log_filter_service.dart';
import 'package:debug/src/services/platform_detection_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Talker implementation of DebugLogger (Dependency Inversion Principle)
class TalkerDebugLogger implements DebugLogger {
  TalkerDebugLogger({
    Talker? talker,
    LogFilterService? filterService,
  })  : _talker = talker ?? _createDefaultTalker(),
        _filterService = filterService ?? LogFilterService();

  final Talker _talker;
  final LogFilterService _filterService;

  /// Expose underlying talker for backward compatibility
  Talker get talker => _talker;

  static Talker _createDefaultTalker() {
    if (PlatformDetectionService.isReleaseMode) {
      return Talker(); // Dummy talker for release mode
    }
    
    return TalkerFlutter.init(
      settings: TalkerSettings(
        enabled: PlatformDetectionService.isDebugModeEnabled,
      ),
    );
  }

  @override
  void log(String message) {
    if (PlatformDetectionService.isReleaseMode) {
      return;
    }
    
    final filtered = _filterService.filter(message);
    _talker.log(filtered);
  }

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (PlatformDetectionService.isReleaseMode) {
      return;
    }
    
    final filtered = _filterService.filter(message);
    _talker.error(filtered, error, stackTrace);
  }

  @override
  void warning(String message) {
    if (PlatformDetectionService.isReleaseMode) {
      return;
    }
    
    final filtered = _filterService.filter(message);
    _talker.warning(filtered);
  }

  @override
  void info(String message) {
    if (PlatformDetectionService.isReleaseMode) {
      return;
    }
    
    final filtered = _filterService.filter(message);
    _talker.info(filtered);
  }
}
