import 'package:app/application/models/app_preferences.dart';

/// アプリ基本設定の永続化契約。保存失敗は呼び出し元へ伝える。
abstract interface class AppPreferencesRepository {
  /// 初期化済みの保存先から設定を読み込む。
  AppPreferencesSnapshot load();

  /// 他の設定を変更せずテーマを保存する。
  Future<void> saveTheme(AppThemePreference theme);

  /// 他の設定を変更せず言語を保存する。
  Future<void> saveLocale(LocalePreference locale);
}
