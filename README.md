# Flutter Template Project

このリポジトリは、Flutterプロジェクトを初期化するためのGitHubテンプレートとして機能します。このテンプレートからプロジェクトを作成した後、初期セットアップとして「initialization」という名前のGitHub Actionを一度実行してください。

## 特徴

このテンプレートは以下の機能を提供します：

- **FVM（Flutter Version Management）** を使用した最新のFlutterバージョン管理
- **マルチプラットフォーム対応** - iOS、Android、Web、macOS、Linux、Windowsをサポート
- **整理されたプロジェクト構造** - `apps`ディレクトリにFlutterプロジェクト、`docs`ディレクトリにドキュメントを配置
- **主要パッケージのプリインストール**:
  - [hooks_riverpod](https://pub.dev/packages/hooks_riverpod) - 状態管理
  - [flutter_hooks](https://pub.dev/packages/flutter_hooks) - ステートフルロジックの再利用
  - [riverpod_annotation](https://pub.dev/packages/riverpod_annotation) - コード生成のためのRiverpodアノテーション
  - [go_router](https://pub.dev/packages/go_router) - 宣言的ルーティング
- **開発依存関係**:
  - [riverpod_generator](https://pub.dev/packages/riverpod_generator) - Riverpodプロバイダーのコード生成
  - [build_runner](https://pub.dev/packages/build_runner) - コード生成ツール
  - [custom_lint](https://pub.dev/packages/custom_lint) - カスタムlintルール
  - [riverpod_lint](https://pub.dev/packages/riverpod_lint) - Riverpod特有のlintルール
  - [go_router_builder](https://pub.dev/packages/go_router_builder) - GoRouterのコード生成
- **コミットメッセージの標準化** - commitlintによる一貫したコミットメッセージ形式の強制

## 使用方法

### 新しいプロジェクトの作成

1. GitHubで「Use this template」ボタンをクリックして、このテンプレートから新しいリポジトリを作成します。
2. リポジトリが作成されると、「initialization」ワークフローが自動的に実行されます（リポジトリ名が「flutter-mobile-project-template」でない場合）。
3. ワークフローが完了すると、Flutterプロジェクトが設定され、必要なパッケージがすべてインストールされます。

### プロジェクト構造

初期化後、プロジェクトは以下の構造になります：

```
your-project/
├── .github/
│   └── workflows/
│       └── initialization.yml
├── apps/
│   ├── lib/
│   ├── test/
│   ├── android/
│   ├── ios/
│   ├── web/
│   ├── macos/
│   ├── linux/
│   ├── windows/
│   ├── pubspec.yaml
│   └── analysis_options.yaml
├── docs/
├── .gitignore
├── .gitattributes
├── commitlint.config.js
└── README.md
```

### 開発

プロジェクトでは、FVMを使用してFlutterバージョンを管理しています。以下のコマンドを使用してください：

```bash
# Flutterコマンドの実行
fvm flutter run

# パッケージの追加
fvm flutter pub add package_name

# ビルドランナーの実行
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### コミットメッセージの形式

このプロジェクトでは、[Conventional Commits](https://www.conventionalcommits.org/)形式を使用しています。コミットメッセージは以下の形式に従う必要があります：

```
<type>: <description>

[optional body]

[optional footer]
```

使用可能なタイプ：
- `build`: ビルドシステムまたは外部依存関係に影響する変更
- `chore`: その他の変更（ソースやテストの変更を含まない）
- `ci`: CI設定ファイルとスクリプトの変更
- `docs`: ドキュメントのみの変更
- `feat`: 新機能
- `fix`: バグ修正
- `perf`: パフォーマンスを向上させるコード変更
- `refactor`: バグを修正せず、機能も追加しないコード変更
- `revert`: 以前のコミットを元に戻す
- `style`: コードの意味に影響しない変更（空白、フォーマット、セミコロンの欠落など）
- `test`: 不足しているテストの追加または既存のテストの修正

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。詳細については、[LICENSE](LICENSE)ファイルを参照してください。
