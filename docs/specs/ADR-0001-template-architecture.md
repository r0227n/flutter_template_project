# ADR-0001: Oshiki の設計境界を持つ最小テンプレート

- 状態: Accepted
- 日付: 2026-11-07

## 背景

新しいアプリへ流用するコードでは、ディレクトリだけでなく依存注入、状態所有、エラー、
生成と検証の手順まで一貫した例が必要です。旧テンプレートには保存中の変更を破棄する処理、
保存失敗時の SharedPreferences キャッシュとの不整合、未使用の plugin、グローバル Melos への依存がありました。

## 決定

Oshiki の `app / application / domain / infrastructure / presentation / core` と公開入口を採用します。
`AppPreferencesSnapshot` と表示用の `AppPreferences` を区別し、use case、port、adapter、
必須 Provider token、composition root の命名と役割を揃えます。
既存の Riverpod generated Notifier、Freezed、typed route、Slang、テーマ拡張の生成手順を使います。

保存は controller が直列化し、失敗を UI へ返して後続操作を継続します。
adapter は既知の保存失敗を公開例外へ変換し、失敗時のキャッシュを再読み込みします。
設定画面がユーザー向け表示と一度だけの報告を担当します。
純 Dart の内側レイヤー、feature 間の依存禁止、design_system の公開境界は構文解析するテストで検証します。

業務機能や外部サービスのサンプルは追加しません。design_system はテーマとトークンだけに限定します。
既存の保存キーと値は維持します。言語未設定時は Oshiki と同じく起動時の端末優先言語を使います。
全 workspace の生成・解析・テスト・整形と Web ビルドを CI で実行します。

## 代替案と結果

- Oshiki 全体の複製は、画像処理・外部サービス・権限設定まで新規アプリへ持ち込むため採用しません。
- 標準 ChangeNotifier への変更は、今回求められた既存プロジェクトとの規約共有を失うため採用しません。
- application モデルを UI state と兼用すると Flutter が内側へ漏れるため、保存用 snapshot を分離します。
- 使用予定だけの repository や DB は追加しません。必要になった機能の境界として導入します。

以前の `saveLanguage` / `setTheme` などの Dart API は置き換え、互換 shim は残しません。
新規アプリ向けの作り直しとして、呼び出し元・テスト・文書を同時に更新します。
