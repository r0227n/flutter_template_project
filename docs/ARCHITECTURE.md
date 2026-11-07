# テンプレートのアーキテクチャ

## 目的と参照元

`oshiki` の責務配置、命名、公開入口、依存注入、状態所有の方針を採用します。
画像処理やカメラなどの業務機能と外部サービスは持ち込まず、新規アプリの出発点を提供します。
長期的な判断は [ADR-0001](specs/ADR-0001-template-architecture.md) に記録します。

## 依存方向

```text
presentation → application → domain
infrastructure → application → domain
app → presentation / infrastructure / application / core
presentation / infrastructure → core（外側の共通処理のみ）
```

- `domain` は業務領域ごとの純粋なルールです。初期状態では業務ルールを定義しません。
- `application` は `models`・`ports`・`use_cases`・`errors` に分けます。
  domain 以外の app layer、Flutter、Riverpod、plugin、外部 I/O に依存しません。
- `infrastructure` は port の具象 adapter です。保存キーと plugin の知識を所有し、Riverpod に依存しません。
- `presentation` は画面と表示状態を所有し、`features/<feature>/screens|controllers|models|widgets` の必要な階層だけを作ります。
- `app` は起動と具象依存の選択、root scope、router の生存期間を所有します。
- `core` は翻訳や観測などの外側の実装です。内側のレイヤーからは参照しません。
- `design_system` はテーマとトークンだけを所有し、画面やアプリ固有 Widget を置きません。

feature は別 feature を直接 import しません。遷移には typed route を使います。
`shared` と `dependencies` から feature への依存、presentation から保存・ロギング実装への依存を禁止します。
`app/test/architecture/` が package URI・相対 URI・条件付き import/export を構文解析して検証します。

## 命名と公開入口

| 対象                    | 規約・例                                                     |
| ----------------------- | ------------------------------------------------------------ |
| 保存境界のデータ        | `AppPreferencesSnapshot`、`LocalePreference`                 |
| 表示状態と所有者        | `AppPreferences`、`AppPreferencesController`                 |
| ユーザー目的の手順      | `AppPreferencesUseCase`                                      |
| 外部能力の契約          | `AppPreferencesRepository`                                   |
| ローカル永続化 adapter  | `LocalAppPreferencesRepository`                              |
| 画面と遷移              | `HomeScreen`、`SettingsScreen`、`HomeRoute`、`SettingsRoute` |
| application 公開入口    | `application/application.dart`                               |
| domain 公開入口         | `domain/domain.dart`                                         |
| infrastructure 公開入口 | `infrastructure/infrastructure.dart`                         |
| 公開エラー              | `application/errors/*.dart` を直接 import                    |
| package 公開入口        | `package:design_system/design_system.dart`                   |

Dart の型は PascalCase、メンバーは camelCase、ファイルは snake_case とします。
公開入口以外の application 内部 path、外部 package の `src/` は直接 import しません。
互換 re-export、別名 provider、未使用の共通層は作りません。

## 依存注入と起動

`AppDependencyGraph` が external instance → adapter → use case の順で生成します。
具象 adapter の選択は `app/dependency_graph.dart` に集約し、`attach()` で root scope に注入します。
`application_providers.dart` は use case と初期 snapshot、`observability_providers.dart` は ErrorReporter の必須 token です。
未注入の token は即座に失敗し、暗黙の本番実装へ fallback しません。

bootstrap は SharedPreferences の初期化、初期 snapshot と表示言語の解決、Slang の同期を終えてから起動します。
root widget と controller は同じ snapshot を使うため、最初のフレームに既定値が混ざりません。
router の定義は navigation、生成・破棄は app が所有します。
初期化失敗は Talker に記録し、ProviderScope に依存しない再試行画面を表示します。

## 設定の状態所有

`AppPreferencesController` の immutable な Freezed state が表示用設定の唯一の所有者です。
root widget は locale と themeMode だけを select し、保存中の更新では再構築しません。
永続化用 snapshot は Flutter に依存せず、表示用 Locale / ThemeMode は controller で変換します。

連続する変更は Future のキューで直列化し、直前の保存成功状態へ差分を適用します。
保存中も表示値を維持し、設定 UI の操作を無効にします。失敗は呼び出し元へ返し、後続操作は止めません。
controller が破棄された場合は、完了後の状態更新と未開始の操作を行いません。

設定画面の `saveSettingsWithFeedback` が失敗を一度だけ ErrorReporter へ通知し、翻訳済みのフィードバックを表示します。
画面が破棄されても報告は行い、破棄済み context へはアクセスしません。

## 保存形式と locale

| 保存キー       | 値                          | 未設定・不正値           |
| -------------- | --------------------------- | ------------------------ |
| `app.theme`    | `system` / `light` / `dark` | system                   |
| `app.language` | `ja` / `en`                 | 起動時の端末言語から解決 |

キーは `SharedPreferencesKey` という extension type で定義し、生の文字列を永続化境界内に閉じ込めます。
既存テンプレートのキーと有効な保存値を引き継ぐため、データ移行は不要です。
書き込みの false 応答と PlatformException は `SettingsWriteException` に変換します。
SharedPreferences が保存前に変更したメモリキャッシュは、失敗時に reload します。
reload も失敗した場合は両方の原因を例外へ残し、画面は最後に成功した値を維持します。

明示的な言語設定がなければ起動時の端末優先言語順で日本語か英語を選び、非対応なら日本語へ戻します。
実行中の端末言語変更の自動追従や「端末の言語に戻す」操作は初期サンプルに含めません。
選択した言語は保存成功後に Slang と MaterialApp の両方へ反映します。
翻訳の正は `app/assets/i18n/*.i18n.json` です。
少量の初期翻訳は `lazy: false` で同梱し、初期化失敗時も即座にエラー画面を表示できます。

## エラーと観測

公開エラーは `AppException`、分類は `AppErrorCode`、設定保存失敗は `SettingsWriteException` です。
未知の失敗は最終表示境界だけで `UnexpectedAppException` に変換し、元の原因と stack trace を保持します。
UI には plugin の生メッセージを表示しません。
Talker の生成・Flutter / PlatformDispatcher のエラーハンドラー・Riverpod observer は起動時に接続します。
Firebase や Sentry は初期化せず、外部送信も行いません。

## 拡張と検証

新しい共有外部能力は port → use case → adapter → 必須 token → dependency graph の順で接続します。
画面単独の表示処理は feature に置き、実際に共有されるまで shared へ移しません。
業務ルールは domain、設定は application、UI の一時状態は presentation に置きます。

テストは実装と同じレイヤー構造で配置します。保存・復旧・連続操作は unit test、
DI・遷移・翻訳・テーマ・大きな文字は widget test、依存方向は architecture test で検証します。

```sh
dart run melos run gen
dart run melos run gen:slang
mise run quality
```

生成物は手編集しません。境界の変更は実装・architecture test・本書・ADR を同時に更新します。
