import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'debug_service.dart';

/// Minimal debug provider implementation
final debugServiceProvider = Provider<void>((ref) {
  DebugService.initialize();
});