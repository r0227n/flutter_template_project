import 'package:app/application/application.dart';
import 'package:app/application/errors/settings_error.dart';
import 'package:app/infrastructure/persistence/shared_preferences/shared_preferences_keys.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences の保存表現を application の契約へ接続する。
final class LocalAppPreferencesRepository implements AppPreferencesRepository {
  /// 初期化済みの端末ストレージを注入する。
  const LocalAppPreferencesRepository(this._preferences);

  final SharedPreferences _preferences;

  @override
  AppPreferencesSnapshot load() => AppPreferencesSnapshot(
    theme: switch (_preferences.get(SharedPreferencesKey.appTheme.value)) {
      'light' => AppThemePreference.light,
      'dark' => AppThemePreference.dark,
      _ => AppThemePreference.system,
    },
    locale: switch (_preferences.get(SharedPreferencesKey.appLocale.value)) {
      final String code when code == 'ja' || code == 'en' => LocalePreference(
        languageCode: code,
      ),
      _ => null,
    },
  );

  @override
  Future<void> saveTheme(AppThemePreference theme) => _write(
    () =>
        _preferences.setString(SharedPreferencesKey.appTheme.value, theme.name),
  );

  @override
  Future<void> saveLocale(LocalePreference locale) => _write(
    () => _preferences.setString(
      SharedPreferencesKey.appLocale.value,
      locale.languageCode,
    ),
  );

  Future<void> _write(Future<bool> Function() operation) async {
    try {
      if (await operation()) return;
    } on PlatformException catch (error, stackTrace) {
      await _restoreAfterFailure(error, stackTrace);
    }
    await _restoreAfterFailure(
      StateError('SharedPreferences rejected the write'),
      StackTrace.current,
    );
  }

  Future<Never> _restoreAfterFailure(
    Object cause,
    StackTrace stackTrace,
  ) async {
    // SharedPreferences は失敗時も先にキャッシュを更新するため復元する。
    var failure = cause;
    try {
      await _preferences.reload();
    } on PlatformException catch (reloadError) {
      failure = (writeError: cause, reloadError: reloadError);
    }
    Error.throwWithStackTrace(
      SettingsWriteException(cause: failure, causeStackTrace: stackTrace),
      stackTrace,
    );
  }
}
