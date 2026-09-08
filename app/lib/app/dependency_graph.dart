import 'package:app/application/application.dart';
import 'package:app/core/logger/talker_integration.dart';
import 'package:app/infrastructure/infrastructure.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

final class AppDependencyGraph {
  AppDependencyGraph(SharedPreferences preferences, this.talker)
    : preferencesUseCase = AppPreferencesUseCase(
        LocalAppPreferencesRepository(preferences),
      );
  final Talker talker;
  final AppPreferencesUseCase preferencesUseCase;
  Widget attach({required Widget child}) => ProviderScope(
    overrides: [
      appPreferencesUseCaseProvider.overrideWithValue(preferencesUseCase),
      errorReporterProvider.overrideWithValue(TalkerErrorReporter(talker)),
    ],
    observers: [TalkerRiverpodObserver(talker: talker)],
    child: child,
  );
}
