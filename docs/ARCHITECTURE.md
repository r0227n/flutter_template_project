# アーキテクチャドキュメント

## 概要

Flutter テンプレートプロジェクトのアーキテクチャドキュメント。
**モノレポ構成とパッケージ間依存関係**に焦点を当てる。

---

## プロジェクト概要

- **モノレポ管理**: Melos 7.3+
- **Dart SDK**: ^3.10.0
- **Flutter**: 3.38.5
- **対応プラットフォーム**: iOS, Android, macOS, Linux, Windows, Web

---

## モノレポ構成

```
flutter_template_project/
├── app/                    # メインアプリケーション
├── packages/               # 共有パッケージ群
│   ├── core/              # 基盤パッケージ
│   └── database/          # データ永続化パッケージ
├── docs/                   # ドキュメント
├── scripts/               # 自動化スクリプト
├── .github/               # CI/CD設定
├── pubspec.yaml           # ワークスペース定義
└── .mise.toml             # 開発環境設定
```

---

## ワークスペース設定

### ルート pubspec.yaml

```yaml
name: workspace
publish_to: none

environment:
  sdk: ^3.10.0

dev_dependencies:
  melos: ^7.3.0

workspace:
  - app
  - packages/core
  - packages/database
```

### Melos スクリプト

Melos設定はルートの `pubspec.yaml` に統合されている。

| コマンド                  | 説明                               |
| ------------------------- | ---------------------------------- |
| `melos run get`           | 全パッケージの依存関係取得         |
| `melos run gen`           | コード生成（build_runner）         |
| `melos run gen:slang`     | 翻訳コード生成                     |
| `melos run analyze`       | 静的解析                           |
| `melos run analyze:slang` | Slang翻訳チェック                  |
| `melos run test`          | テスト実行（Flutter/Dart自動検出） |
| `melos run format`        | コードフォーマット                 |

### CI専用コマンド

| コマンド                       | 説明                                   |
| ------------------------------ | -------------------------------------- |
| `melos run ci:test`            | JSONレポート付きテスト実行             |
| `melos run ci:analyze-changed` | 変更パッケージのみ解析                 |
| `melos run ci:test-changed`    | 変更パッケージのみテスト               |
| `melos run ci:format-changed`  | 変更パッケージのみフォーマットチェック |

---

## パッケージ依存関係

### 依存グラフ

```
app
 ├── core
 └── database

※ core と database の間に依存関係なし（独立）
```

### 依存方向の原則

- `app` → `packages/*` への一方向依存
- パッケージ間の循環依存を禁止
- 各パッケージは独立してテスト可能

---

## パッケージ設計パターン

### パッケージ構成テンプレート

```
packages/[name]/
├── lib/
│   ├── [name].dart          # Public API（エクスポート）
│   └── src/                 # Private実装
│       ├── models/          # データモデル
│       ├── repositories/    # データアクセス層
│       └── providers/       # Riverpod Provider
├── test/                    # テストコード
└── pubspec.yaml            # パッケージ依存関係
```

> **Note**: `analysis_options.yaml` はルートで一元管理。サブパッケージには配置しない（Dart analyzer がディレクトリを遡行して自動適用）。

### Public API エクスポートパターン

```dart
// lib/[name].dart
export 'src/models/model_a.dart';
export 'src/repositories/repository_a.dart';
export 'src/providers/provider_a.dart';
```

### resolution: workspace

各パッケージの `pubspec.yaml` に設定:

```yaml
resolution: workspace
```

これにより、ワークスペース内の依存関係解決が統一される。

---

## packages/core パッケージ

### 責務

- ロギング基盤（Talker）
- アプリ設定（SharedPreferences）
- 多言語対応基盤（Slang）

### 構成

```
core/
├── lib/
│   ├── core.dart           # Public API
│   ├── widgets.dart        # Widget exports
│   ├── i18n/               # 翻訳リソース
│   └── src/
│       ├── logger/         # AppLogger, LoggerConfig
│       └── preferences/    # Repository, Providers
└── assets/
    └── i18n/               # 翻訳JSONファイル
```

### 主要依存関係

```yaml
dependencies:
  flutter_riverpod: ^3.0.3
  shared_preferences: ^2.5.3
  talker_flutter: ^5.0.2
  slang: ^4.11.1
  slang_flutter: ^4.11.0
  freezed_annotation: ^3.1.0
  firebase_crashlytics: ^5.0.5
  package_info_plus: ^9.0.0

dev_dependencies:
  build_runner: ^2.7.1
  freezed: ^3.2.3
  riverpod_generator: ^3.0.3
  slang_build_runner: ^4.11.0
  yumemi_lints: ^4.3.0
```

---

## packages/database パッケージ

### 責務

- データベース接続管理（DuckDB）
- データモデル定義
- CRUD操作（Repository）
- データアクセスProvider

### 構成

```
database/
├── lib/
│   ├── database.dart       # Public API
│   └── src/
│       ├── service/        # DatabaseService
│       ├── schema/         # スキーマ定義
│       ├── todo/           # Todo機能
│       │   ├── models/
│       │   ├── repositories/
│       │   └── providers/
│       └── category/       # Category機能
│           ├── models/
│           ├── repositories/
│           └── providers/
```

### 主要依存関係

```yaml
dependencies:
  dart_duckdb: ^1.4.4
  flutter_riverpod: ^3.0.3
  freezed_annotation: ^3.1.0
  path_provider: ^2.1.5
  uuid: ^4.5.1

dev_dependencies:
  build_runner: ^2.7.1
  freezed: ^3.2.3
  riverpod_generator: ^3.0.3
  yumemi_lints: ^4.3.0
```

---

## app ディレクトリ

### 責務

- UI実装（Presentation Layer）
- ルーティング
- パッケージ統合
- エントリーポイント

### 構成

```
app/lib/
├── main.dart               # エントリーポイント
├── router/                 # go_router設定
├── presentation/           # 画面・状態管理
│   ├── pages/             # 画面実装
│   ├── notifiers/         # 状態管理
│   ├── providers/         # 派生Provider
│   └── helpers/           # UI補助
├── core/                   # アプリ固有の共通コード
│   ├── constants/         # 定数
│   ├── widgets/           # 共通Widget
│   ├── extensions/        # 拡張メソッド
│   └── gen/               # 生成コード
├── data/                   # データ層
├── domain/                 # ドメイン層
└── platform/              # プラットフォーム固有コード
```

### パッケージ参照方法

```yaml
# app/pubspec.yaml
dependencies:
  core:
    path: ../packages/core
  database:
    path: ../packages/database
```

### 主要依存関係

```yaml
dependencies:
  # パッケージ参照
  core:
    path: ../packages/core
  database:
    path: ../packages/database

  # UI/UX
  flutter_hooks: ^0.21.3
  hooks_riverpod: ^3.0.3

  # ルーティング
  go_router: ^17.0.1

  # 国際化
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2
  slang: ^4.11.1
  slang_flutter: ^4.11.0

  # ユーティリティ
  freezed_annotation: ^3.1.0
  talker_flutter: ^5.0.2
  talker_riverpod_logger: ^5.0.2
  uuid: ^4.5.1

dev_dependencies:
  go_router_builder: ^4.0.0
  riverpod_generator: ^3.0.3
  slang_build_runner: ^4.11.0
```

---

## 技術スタック

| カテゴリ     | 技術           | 用途                           |
| ------------ | -------------- | ------------------------------ |
| モノレポ管理 | Melos 7.3+     | パッケージ管理・スクリプト実行 |
| 状態管理     | Riverpod 3.x   | DI・リアクティブ状態管理       |
| ルーティング | go_router 17.x | 型安全なナビゲーション         |
| データモデル | Freezed 3.x    | イミュータブルモデル生成       |
| 多言語対応   | Slang 4.x      | 型安全な翻訳                   |
| ロギング     | Talker 5.x     | 構造化ログ                     |
| データベース | DuckDB         | 組み込みOLAPデータベース       |
| リント       | yumemi_lints   | コード品質管理                 |
| 開発環境     | mise           | ツールバージョン管理           |

---

## コード生成

### 使用ジェネレータ

| ジェネレータ       | 用途                 |
| ------------------ | -------------------- |
| freezed            | イミュータブルモデル |
| json_serializable  | JSON変換             |
| riverpod_generator | Provider生成         |
| go_router_builder  | 型安全ルート         |
| slang_build_runner | 翻訳クラス           |

### 生成コマンド

```bash
# 全パッケージでbuild_runner実行
melos run gen

# 翻訳コード生成
melos run gen:slang
```

---

## 新規パッケージ追加手順

1. `packages/[name]/` ディレクトリ作成
   ```bash
   cd packages
   flutter create --template=package [name]
   ```

2. `pubspec.yaml` に `resolution: workspace` 追加
   ```yaml
   resolution: workspace
   ```

3. ルート `pubspec.yaml` の `workspace:` に追加
   ```yaml
   workspace:
     - app
     - packages/core
     - packages/database
     - packages/[name] # 追加
   ```

4. 依存関係解決
   ```bash
   melos run get
   ```

---

## CI/CD

### GitHub Actions

- `.github/workflows/` にワークフロー定義
- 変更パッケージの自動検出と部分実行

### CI コマンド

```bash
# 変更パッケージの解析
melos run ci:analyze-changed

# 変更パッケージのテスト
melos run ci:test-changed

# 変更パッケージのフォーマットチェック
melos run ci:format-changed
```

### Dependabot

- `.github/dependabot.yml` で依存関係の自動更新を設定
- パッケージごとの更新スケジュール管理

---

## 開発環境

### mise による環境管理

`.mise.toml` で以下のツールを管理:

- Flutter バージョン
- Dart バージョン
- その他開発ツール

### セットアップ

```bash
# mise のインストール（初回のみ）
./scripts/install_mise.sh

# 依存関係の取得
melos run get

# コード生成
melos run gen
```

---

## 参照ドキュメント

- [仕様書](spec.md)
- [画面仕様書](pages/)
- [機能仕様書](features/)
- [Flutter開発ガイドライン](FLUTTER_CODING_GUIDELINES.md)
- [TDD開発ガイド](TEST_DRIVEN_DEVELOPMENT.md)
- [コミットルール](COMMITLINT_RULES.md)
