/// Debug package with Talker integration and shake detector
library;

// Main exports
export 'src/debug_navigation.dart';
export 'src/debug_provider.dart';
export 'src/debug_service.dart';

// Implementations
export 'src/implementations/physical_shake_detector.dart';
export 'src/implementations/talker_debug_logger.dart';

// Interfaces
export 'src/interfaces/debug_logger.dart';
export 'src/interfaces/shake_detector.dart';

// Services
export 'src/services/log_filter_service.dart';
export 'src/services/platform_detection_service.dart';
export 'src/shake_detector_service.dart';
