import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shake/shake.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'debug_config.dart';
import 'talker_provider.dart';

class ShakeDetectorWidget extends ConsumerStatefulWidget {
  const ShakeDetectorWidget({
    required this.child,
    super.key,
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
      _initializeShakeDetector();
    }
  }

  void _initializeShakeDetector() {
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: () {
        final talker = ref.read(talkerProvider);
        _showTalkerScreen(talker);
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

  void _showTalkerScreen(Talker talker) {
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => TalkerScreen(talker: talker),
        ),
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