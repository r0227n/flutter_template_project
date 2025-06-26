import 'package:debug/src/debug_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Minimal debug provider implementation
final debugServiceProvider = Provider<void>((ref) {
  DebugService.initialize();
});
