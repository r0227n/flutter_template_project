import 'package:flutter/foundation.dart';

class DebugConfig {
  static bool get isDebugMode => kDebugMode;
  static bool get shouldEnableTalker => isDebugMode;
  static bool get shouldEnableShakeDetector => isDebugMode;
}