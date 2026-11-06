import 'package:app/application/application.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'application_providers.g.dart';

/// Presentation が利用する入力境界。具象値は composition root が注入する。
@Riverpod(keepAlive: true)
AppPreferencesUseCase appPreferencesUseCase(Ref ref) =>
    throw UnimplementedError('AppPreferencesUseCase must be injected.');

/// 起動時に一度だけ取得した設定。必ず root scope へ注入する。
@Riverpod(keepAlive: true)
AppPreferencesSnapshot initialAppPreferencesSnapshot(Ref ref) =>
    throw UnimplementedError('AppPreferencesSnapshot must be injected.');
