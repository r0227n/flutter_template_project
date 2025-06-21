import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';
import 'debug_config.dart';

final talkerProvider = Provider<Talker>((ref) {
  if (!DebugConfig.shouldEnableTalker) {
    return Talker(
      settings: TalkerSettings(
        enabled: false,
      ),
    );
  }

  final talker = TalkerFlutter.init(
    settings: TalkerSettings(
      useColors: true,
      useHistory: true,
    ),
    logger: TalkerLogger(
      settings: TalkerLoggerSettings(
        colors: {
          LogLevel.info: AnsiPen()..cyan(),
          LogLevel.debug: AnsiPen()..gray(),
          LogLevel.warning: AnsiPen()..yellow(),
          LogLevel.error: AnsiPen()..red(),
          LogLevel.critical: AnsiPen()..red(bold: true),
        },
        enableColors: true,
      ),
    ),
  );

  // Add Riverpod observer
  ref.onDispose(() {
    talker.good('Talker disposed');
  });

  return talker;
});

class TalkerRiverpodObserver extends ProviderObserver {
  const TalkerRiverpodObserver({
    required this.talker,
    this.settings = const TalkerRiverpodLoggerSettings(),
  });

  final Talker talker;
  final TalkerRiverpodLoggerSettings settings;

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    if (!settings.printProviderAdded) return;
    
    talker.debug(
      'Provider added: ${_getProviderName(provider)}',
      'TalkerRiverpodObserver',
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase provider,
    ProviderContainer container,
  ) {
    if (!settings.printProviderDisposed) return;
    
    talker.debug(
      'Provider disposed: ${_getProviderName(provider)}',
      'TalkerRiverpodObserver',
    );
  }

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (!settings.printProviderUpdated) return;
    
    talker.debug(
      'Provider updated: ${_getProviderName(provider)}',
      'TalkerRiverpodObserver',
    );
  }

  @override
  void providerDidFail(
    ProviderBase provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    if (!settings.printProviderFailed) return;
    
    talker.error(
      'Provider failed: ${_getProviderName(provider)}',
      error,
      stackTrace,
    );
  }

  String _getProviderName(ProviderBase provider) {
    return provider.name ?? provider.runtimeType.toString();
  }
}