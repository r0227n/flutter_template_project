/// 保存キーの型。文字列との相互変換は永続化 adapter 内に閉じ込める。
extension type const SharedPreferencesKey(String value) {
  /// テーマの固定保存キー。
  static const appTheme = SharedPreferencesKey('app.theme');

  /// 言語の固定保存キー。
  static const appLocale = SharedPreferencesKey('app.language');
}
