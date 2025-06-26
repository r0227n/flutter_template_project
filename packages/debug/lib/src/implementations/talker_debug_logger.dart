import 'package:talker_flutter/talker_flutter.dart';
import '../interfaces/debug_logger.dart';
import '../services/log_filter_service.dart';
import '../services/platform_detection_service.dart';

/// Talker implementation of DebugLogger (Dependency Inversion Principle)
class TalkerDebugLogger implements DebugLogger {
  final Talker _talker;
  final LogFilterService _filterService;

  TalkerDebugLogger({
    Talker? talker,
    LogFilterService? filterService,
  })  : _talker = talker ?? _createDefaultTalker(),
        _filterService = filterService ?? LogFilterService();

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
    if (PlatformDetectionService.isReleaseMode) return;
    
    final filtered = _filterService.filter(message);
    _talker.log(filtered);
  }

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (PlatformDetectionService.isReleaseMode) return;
    
    final filtered = _filterService.filter(message);
    _talker.error(filtered, error, stackTrace);
  }

  @override
  void warning(String message) {
    if (PlatformDetectionService.isReleaseMode) return;
    
    final filtered = _filterService.filter(message);
    _talker.warning(filtered);
  }

  @override
  void info(String message) {
    if (PlatformDetectionService.isReleaseMode) return;
    
    final filtered = _filterService.filter(message);
    _talker.info(filtered);
  }
}