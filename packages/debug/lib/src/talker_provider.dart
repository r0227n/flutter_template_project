import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';
import 'debug_config.dart';

final talkerProvider = Provider<Talker>((ref) {
  if (!DebugConfig.shouldEnableTalker) {
    return Talker(settings: TalkerSettings(enabled: false));
  }

  return TalkerFlutter.init(
    settings: TalkerSettings(
      enabled: true,
      useConsoleLogs: true,
      useHistory: true,
      maxHistoryItems: 100,
    ),
  );
});

class TalkerRiverpodObserver extends ProviderObserver with TalkerRiverpodLoggerMixin {
  TalkerRiverpodObserver({Talker? talker}) : _talker = talker;

  final Talker? _talker;

  @override
  Talker get talker => _talker ?? TalkerFlutter.instance;
}