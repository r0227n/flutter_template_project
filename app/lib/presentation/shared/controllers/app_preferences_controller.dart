import 'package:app/application/application.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/core/localization/app_locale_resolver.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_preferences_controller.freezed.dart';
part 'app_preferences_controller.g.dart';

/// Root widget と設定画面が参照する唯一の表示用設定。
@freezed
abstract class AppPreferences with _$AppPreferences {
  /// 保存済みの値から生成する。保存中も直前の成功値を維持する。
  const factory AppPreferences({
    required Locale locale,
    required ThemeMode themeMode,
    @Default(false) bool isSaving,
  }) = _AppPreferences;
}

/// 設定変更を操作順に保存し、成功した値だけを画面へ公開する。
@Riverpod(keepAlive: true)
class AppPreferencesController extends _$AppPreferencesController {
  Future<void> _pendingSave = Future<void>.value();

  @override
  AppPreferences build() {
    final stored = ref.watch(initialAppPreferencesSnapshotProvider);
    return AppPreferences(
      locale: resolveAppLocale(
        stored.locale?.languageCode,
        WidgetsBinding.instance.platformDispatcher.locales,
      ).flutterLocale,
      themeMode: switch (stored.theme) {
        AppThemePreference.system => ThemeMode.system,
        AppThemePreference.light => ThemeMode.light,
        AppThemePreference.dark => ThemeMode.dark,
      },
    );
  }

  /// テーマを保存する。保存失敗は呼び出し元へ返す。
  Future<void> setThemeMode(ThemeMode mode) => _save(
    (useCase) => useCase.saveTheme(switch (mode) {
      ThemeMode.system => AppThemePreference.system,
      ThemeMode.light => AppThemePreference.light,
      ThemeMode.dark => AppThemePreference.dark,
    }),
    (current) => current.copyWith(themeMode: mode),
  );

  /// 言語を保存し、Slang と MaterialApp に同じ言語を公開する。
  Future<void> setLocale(AppLocale locale) => _save(
    (useCase) => useCase.saveLocale(
      LocalePreference(languageCode: locale.languageCode),
    ),
    (current) => current.copyWith(locale: locale.flutterLocale),
    locale: locale,
  );

  Future<void> _save(
    Future<void> Function(AppPreferencesUseCase) persist,
    AppPreferences Function(AppPreferences) update, {
    AppLocale? locale,
  }) {
    final useCase = ref.read(appPreferencesUseCaseProvider);
    state = state.copyWith(isSaving: true);
    final save = _pendingSave.then((_) async {
      if (!ref.mounted) return;
      await persist(useCase);
      if (!ref.mounted) return;
      if (locale != null) await LocaleSettings.setLocale(locale);
      if (!ref.mounted) return;
      state = update(state);
    });
    // 失敗は呼び出し元へ返しつつ、次の保存を止めない。
    final completion = save.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    _pendingSave = completion;
    return save.whenComplete(() {
      if (ref.mounted && identical(_pendingSave, completion)) {
        state = state.copyWith(isSaving: false);
      }
    });
  }
}
