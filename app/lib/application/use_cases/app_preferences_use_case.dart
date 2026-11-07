import 'package:app/application/models/app_preferences.dart';
import 'package:app/application/ports/app_preferences_repository.dart';

/// 起動と設定画面で共有する、アプリ基本設定の入力境界。
final class AppPreferencesUseCase {
  /// 保存先を外部から注入する。
  const AppPreferencesUseCase(this._repository);

  final AppPreferencesRepository _repository;

  /// 保存済み設定を取得する。
  AppPreferencesSnapshot load() => _repository.load();

  /// テーマを保存する。失敗時は repository の例外を伝える。
  Future<void> saveTheme(AppThemePreference theme) =>
      _repository.saveTheme(theme);

  /// 対応する言語を保存する。不正なコードには ArgumentError を返す。
  Future<void> saveLocale(LocalePreference locale) {
    if (locale.languageCode != 'ja' && locale.languageCode != 'en') {
      throw ArgumentError.value(locale.languageCode, 'languageCode');
    }
    return _repository.saveLocale(locale);
  }
}
