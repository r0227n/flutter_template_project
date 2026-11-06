# Flutter Template

`oshiki` の命名と設計境界を、新規アプリのための最小構成にした Flutter テンプレートです。
ホーム、テーマと言語の設定、永続化、翻訳、エラー報告を一通り動かせます。
Firebase・Sentry などのアカウントや設定ファイルは不要です。

## セットアップ

SDK とツールの版数は `.mise.toml`、依存とコマンドはルート `pubspec.yaml` を正とします。
Flutter 3.44.6 / Dart 3.12 系の Pub workspace に、`app` と `packages/design_system` を配置しています。

```sh
mise install
mise run setup
cp app/.dart_define/sample.json app/.dart_define/development.json
cd app
flutter run --dart-define-from-file=.dart_define/development.json
```

Melos は Oshiki と同じ `8.9.0` に固定し、常に `dart run melos` で実行します。グローバルへのインストールは不要です。
VS Code の development / staging / production 起動設定では、対応する `.dart_define/*.json` を用意してください。
実プロジェクト用 JSON は Git 管理から除外され、`sample.json` だけを管理します。

## 新規アプリへの変更手順

1. テンプレートを複製し、新しいリポジトリを作成します。
2. `pubspec.yaml` の Melos 名と `app/pubspec.yaml` の説明・バージョンを更新します。
   Dart package 名 `app` を変える場合は、すべての `package:app/` import とアーキテクチャテストも変更します。
3. `.dart_define/*.json` の `APP_ID`・`APP_ID_SUFFIX`・`APP_NAME` を設定します。
   Android の application ID とランチャー名、iOS の bundle ID と表示名に反映されます。
   Web の表示名は `app/web/manifest.json` と `index.html`、デスクトップの識別子は各 runner を変更します。
4. `app/assets/i18n/*.i18n.json` の `appName` と画面文言を変更します。
   `packages/design_system/lib/src/tokens/colors.dart` の seed が配色の起点です。
5. `presentation/features/home` をアプリの最初の機能に置き換え、typed route を追加します。
6. 必要になった外部サービス、権限、端末固有の設定を追加し、署名と配布設定を用意します。

## 構成

```text
app/lib/
├── app/                         # bootstrap、依存の結線、root widget
├── domain/                      # アプリ固有の純粋な業務ルールの追加先
├── application/                 # 設定モデル、use case、port、公開エラー
├── infrastructure/              # port の具象 adapter、保存キー
├── presentation/
│   ├── dependencies/            # 必ず注入する application / observability token
│   ├── features/                # home / settings の screens と widgets
│   ├── navigation/              # typed route と router の組み立て
│   └── shared/controllers/      # root と画面が共有する設定状態
└── core/                        # 翻訳生成物、locale 解決、logger
packages/design_system/          # テーマとトークンのみ
```

`AppPreferencesSnapshot` は純 Dart の保存データ、`AppPreferences` は Flutter の表示状態です。
具象 adapter は `app/dependency_graph.dart` だけで選択し、画面へは use case を注入します。
業務機能のない初期状態では、domain にダミーの entity や Todo サンプルを追加しません。

詳細は [アーキテクチャ](docs/ARCHITECTURE.md)、[画面仕様](docs/specs/SPECS_INDEX_SPEC.md)、
[採用した設計判断](docs/specs/ADR-0001-template-architecture.md) を参照してください。

## Agent 向けの作業手順

`.agents/skills/` に、設計・レビュー・不具合調査・ドメイン設計・画面 QA・PR 作成・Agent 文書整備の
project skill を配置しています。Oshiki の手順を参考に、このテンプレートの構成と利用可能な機能に合わせて作成しています。
用途と管理方針は [Agent skills](docs/agent-skills.md)、共通規約は [AGENTS.md](AGENTS.md) を参照してください。

## 設定とエラー

テーマは端末設定・ライト・ダークから、言語は日本語・English から選べます。
未設定の言語は起動時の端末の優先言語順で解決し、非対応なら日本語を使用します。
設定変更は操作順に保存し、成功した値だけを画面に反映します。
保存に失敗すると直前の設定を維持し、再試行を促すメッセージと Talker のログに記録します。
起動時の初期化に失敗した場合も、再試行画面を表示します。

## 依存の方針

既存の Riverpod generated Notifier、Freezed、GoRouter typed routes、Slang、SharedPreferences、Talker を使います。
GoRouter builder は現在の生成 API と合わせて 4.3 系に制限しています。
画像処理・カメラ・広告・認証・DB・Marionette・Patrol は、利用先アプリで必要になったときに追加します。
開発依存の `analyzer` は条件付き import を含む依存境界テスト、
`shared_preferences_platform_interface` は保存拒否と端末例外を再現する fake に使用します。
ログの外部送信は設定していません。

## 検証

ルートから実行します。生成物は入力から更新し、手編集しません。

```sh
dart run melos run gen
dart run melos run gen:slang
mise run quality
cd app
flutter build web --dart-define-from-file=.dart_define/sample.json
```

`quality` は全 workspace の format check・静的解析・翻訳解析・テスト・dprint を実行します。
CI でも同じ検証と生成物の同期チェック、Web ビルドを実行します。
テストは `app/test/` に実装と同じレイヤー構成で配置します。
モバイルの署名付き配布と各 OS の実機検証は、新しいアプリの識別子・権限設定で行ってください。
