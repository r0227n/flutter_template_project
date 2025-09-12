import 'package:clock/clock.dart';

/// Service responsible for debug-related time operations
/// Follows Single Responsibility Principle
abstract class DebugTimeService {
  /// Gets the current time safely
  DateTime getCurrentTime();
  
  /// Validates if a time value is acceptable for debug operations
  bool isValidTime(DateTime time);
  
  /// Formats time for display in debug interface
  String formatTime(DateTime time);
}

/// Default implementation of DebugTimeService
/// Follows Dependency Inversion Principle - depends on Clock abstraction
class DefaultDebugTimeService implements DebugTimeService {
  const DefaultDebugTimeService();
  
  // Cache for validation boundaries to avoid repeated calculations
  static DateTime? _minTimeCache;
  static DateTime? _maxTimeCache;
  static DateTime? _lastCacheUpdate;
  
  @override
  DateTime getCurrentTime() {
    try {
      return clock.now();
    } catch (e) {
      // Fallback to system clock if custom clock fails
      return DateTime.now();
    }
  }
  
  @override
  bool isValidTime(DateTime time) {
    // Performance: Use cached validation boundaries when possible
    final now = DateTime.now();
    
    // Update cache if it's stale (older than 1 hour)
    if (_lastCacheUpdate == null || 
        now.difference(_lastCacheUpdate!).inHours > 1) {
      _minTimeCache = now.subtract(const Duration(days: 365));
      _maxTimeCache = now.add(const Duration(days: 365));
      _lastCacheUpdate = now;
    }
    
    return time.isAfter(_minTimeCache!) && time.isBefore(_maxTimeCache!);
  }
  
  @override
  String formatTime(DateTime time) {
    try {
      if (!isValidTime(time)) {
        return 'Invalid time';
      }
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      // Handle any formatting errors gracefully
      return 'Format error';
    }
  }
}

/// Time service provider for dependency injection
/// Follows Dependency Injection pattern
const DebugTimeService debugTimeService = DefaultDebugTimeService();