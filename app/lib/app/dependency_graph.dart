import 'package:app/application/application.dart';
import 'package:app/core/logger/error_reporter.dart';
import 'package:app/core/logger/talker_integration.dart';
import 'package:app/infrastructure/infrastructure.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/dependencies/observability_providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

/// 外部 instance、adapter、use case を結線する唯一の場所。
final class AppDependencyGraph {
  /// 初期化済みの外部 instance から依存と起動時設定を組み立てる。
  factory AppDependencyGraph({
    required SharedPreferences sharedPreferences,
    required Talker talker,
  }) {
    final appPreferences = AppPreferencesUseCase(
      LocalAppPreferencesRepository(sharedPreferences),
    );
    return AppDependencyGraph._(
      appPreferences: appPreferences,
      initialAppPreferences: appPreferences.load(),
      errorReporter: TalkerErrorReporter(talker),
    );
  }

  const AppDependencyGraph._({
    required this.appPreferences,
    required this.initialAppPreferences,
    required this.errorReporter,
  });

  /// 設定画面が利用する入力境界。
  final AppPreferencesUseCase appPreferences;

  /// 最初のフレームと controller で共有する起動時設定。
  final AppPreferencesSnapshot initialAppPreferences;

  /// ロギングの具象実装を隠す報告契約。
  final ErrorReporter errorReporter;

  /// 必須 token を root scope へ一度だけ注入する。
  ProviderScope attach({
    required Widget child,
    List<ProviderObserver> observers = const [],
  }) => ProviderScope(
    observers: observers,
    overrides: [
      appPreferencesUseCaseProvider.overrideWithValue(appPreferences),
      initialAppPreferencesSnapshotProvider.overrideWithValue(
        initialAppPreferences,
      ),
      errorReporterProvider.overrideWithValue(errorReporter),
    ],
    child: child,
  );
}
