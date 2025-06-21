import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shake/shake.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'debug_config.dart';
import 'talker_provider.dart';

class ShakeDetectorWidget extends ConsumerStatefulWidget {
  const ShakeDetectorWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<ShakeDetectorWidget> createState() => _ShakeDetectorWidgetState();
}

class _ShakeDetectorWidgetState extends ConsumerState<ShakeDetectorWidget> {
  ShakeDetector? _shakeDetector;

  @override
  void initState() {
    super.initState();
    
    if (DebugConfig.shouldEnableShakeDetector) {
      _shakeDetector = ShakeDetector.autoStart(
        onPhoneShake: () {
          final talker = ref.read(talkerProvider);
          talker.info('Shake detected! Opening Talker screen...');
          
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TalkerScreen(
                talker: talker,
                theme: TalkerScreenTheme(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  cardColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  textColor: Theme.of(context).colorScheme.onSurface,
                  logColors: {
                    TalkerLogType.info: Colors.cyan,
                    TalkerLogType.debug: Colors.grey,
                    TalkerLogType.warning: Colors.orange,
                    TalkerLogType.error: Colors.red,
                    TalkerLogType.critical: Colors.red.shade900,
                  },
                ),
                appBarTitle: 'Debug Logs',
                appBarLeading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          );
        },
        minimumShakeCount: 2,
        shakeSlopTimeMS: 500,
        shakeCountResetTime: 3000,
        shakeThresholdGravity: 2.7,
      );
    }
  }

  @override
  void dispose() {
    _shakeDetector?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}