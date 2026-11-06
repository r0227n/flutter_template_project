/// UI とログで共有する安定した失敗分類。
enum AppErrorCode {
  /// 設定の永続化に失敗した。
  settingsWrite('settings.write'),

  /// 分類されていない不具合。
  unexpected('unexpected');

  const AppErrorCode(this.value);

  /// enum の名前や順序に依存しない公開コード。
  final String value;
}
