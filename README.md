# Flutter Template Project

**モダンなアーキテクチャ、自動化された開発ワークフロー、包括的なツールセットを備えたプロダクション対応Flutterテンプレート**

## 概要

モノレポ構造、Claude Code統合による自動開発、包括的な品質保証ツールを特徴とするエンタープライズグレードのFlutterアプリケーションテンプレートです。

### 主要機能

| 機能               | 技術スタック         | メリット                                     |
| ------------------ | -------------------- | -------------------------------------------- |
| **モノレポ管理**   | Melos + FVM          | マルチパッケージ開発、バージョン一貫性       |
| **状態管理**       | Riverpod + Hooks     | リアクティブでテスト可能な状態アーキテクチャ |
| **国際化**         | slang                | 型安全でコード生成による翻訳                 |
| **ナビゲーション** | go_router            | 宣言的で型安全なルーティング                 |
| **コード生成**     | build_runner         | 自動化されたボイラープレート除去             |
| **品質保証**       | Custom lints + CI/CD | 一貫したコード品質、自動テスト               |
| **AI開発**         | Claude Code + Linear | 自動化されたIssue駆動開発                    |

## アーキテクチャ

### プロジェクト構造

```
flutter_template_project/
├── 📱 app/                        # メインFlutterアプリケーション
│   ├── lib/
│   │   ├── main.dart             # アプリケーションエントリーポイント
│   │   ├── pages/                # UI画面 (ホーム、設定)
│   │   ├── router/               # go_router設定
│   │   └── i18n/                 # 生成された翻訳ファイル
│   └── assets/i18n/              # 翻訳ソースファイル
├── 📦 packages/                   # 共有パッケージ
│   └── app_preferences/          # 設定管理パッケージ
├── 🔧 scripts/                   # 自動化スクリプト
├── 📚 docs/                      # 包括的なドキュメント
├── 🤖 .claude/commands/          # Claude Code統合
└── ⚙️  melos.yaml               # モノレポ設定
```

## コード品質ツール

| ツール         | バージョン | 目的                      | 設定ファイル           |
| -------------- | ---------- | ------------------------- | ---------------------- |
| **commitlint** | ^18.0.0    | Conventional Commits検証  | `.commitlintrc.yml`    |
| **prettier**   | 3.5.3      | YAML/Markdownフォーマット | `package.json` scripts |

## はじめに

### 前提条件

| ツール      | バージョン | インストール方法                 |
| ----------- | ---------- | -------------------------------- |
| **FVM**     | Latest     | `dart pub global activate fvm`   |
| **Node.js** | 18+        | [Node.js](https://nodejs.org/)   |
| **Melos**   | 7.0+       | `dart pub global activate melos` |

### クイックセットアップ

```bash
# 1. リポジトリのクローン
git clone https://github.com/your-org/flutter_template_project.git
cd flutter_template_project

# 2. Flutterバージョンのセットアップ
fvm install
fvm use

# 3. 依存関係のインストール
melos bootstrap

# 4. コード生成
melos run gen

# 5. アプリの実行
cd app && fvm flutter run
```

### 開発コマンド

#### Melosコマンド（推奨）

| コマンド                 | 目的                        | 使用範囲              |
| ------------------------ | --------------------------- | --------------------- |
| `melos run get`          | 依存関係のインストール      | 全パッケージ          |
| `melos run gen`          | コード生成                  | build_runner, slang等 |
| `melos run analyze`      | 静的解析                    | Dart analyzer         |
| `melos run format`       | コードフォーマット          | dart format           |
| `melos run test`         | テスト実行                  | 全パッケージ          |
| `melos run clean:branch` | gitブランチのクリーンアップ | 未使用ブランチの削除  |

#### コード品質コマンド

| コマンド             | 目的                   | 対象ファイル         |
| -------------------- | ---------------------- | -------------------- |
| `npm run lint`       | フォーマットチェック   | `**/*.{yml,yaml,md}` |
| `npm run format`     | 自動フォーマット       | `**/*.{yml,yaml,md}` |
| `npm run commitlint` | コミットメッセージ検証 | 現在のコミット       |

### Claude Code統合

Linear統合による自動開発：

```bash
# Claude Codeの起動
claude

# 直接Issue実行
/linear ABC-123
```

詳細なClaude Codeセットアップについては[docs/CLAUDE_CODE.md](docs/CLAUDE_CODE.md)を参照してください。

## 開発ワークフロー

### コード品質基準

#### Conventional Commits

このプロジェクトは**commitlint**によって強制される[Conventional Commits](https://www.conventionalcommits.org/)仕様に従います：

**設定ファイル**: `.commitlintrc.yml`

**サポートされるタイプ**:

| タイプ     | 説明               | 例                                         |
| ---------- | ------------------ | ------------------------------------------ |
| `feat`     | 新機能             | `feat(auth): add OAuth login`              |
| `fix`      | バグ修正           | `fix(router): resolve navigation issue`    |
| `docs`     | ドキュメント変更   | `docs: update README`                      |
| `style`    | コードスタイル変更 | `style: format code`                       |
| `refactor` | リファクタリング   | `refactor(state): simplify provider logic` |
| `test`     | テスト変更         | `test(auth): add unit tests`               |
| `chore`    | メンテナンスタスク | `chore: update dependencies`               |
| `ci`       | CI/CD変更          | `ci: add GitHub Actions`                   |

#### Prettierフォーマット

**対象ファイル**: YAML, Markdown
**設定**: `package.json` scripts

```bash
# フォーマット準拠チェック
npm run lint

# ファイルの自動フォーマット
npm run format
```

**Melosとの統合**:

- `melos run lint` → `npm run lint`
- `melos run format:prettier` → `npm run format`

#### コード生成ワークフロー

```bash
# 1. アノテーション付きクラスに変更を加える
# 2. コード生成を実行
melos run gen

# 3. 生成されたファイルをレビュー
# 4. 変更をテスト
melos run test

# 5. フォーマットと解析
melos run format
melos run analyze
```

### ドキュメント

| ドキュメント                                         | 目的                     | 対象読者           |
| ---------------------------------------------------- | ------------------------ | ------------------ |
| [CLAUDE.md](CLAUDE.md)                               | メイン自動化ワークフロー | 開発者             |
| [docs/VSCODE_SETTINGS.md](docs/VSCODE_SETTINGS.md)   | エディター設定           | 開発者             |
| [docs/COMMITLINT_RULES.md](docs/COMMITLINT_RULES.md) | コミットメッセージ基準   | コントリビューター |
| [packages/CLAUDE.md](packages/CLAUDE.md)             | パッケージ開発           | パッケージ作成者   |

### アーキテクチャパターン

#### Riverpodによる状態管理

```dart
// 1. データモデルの定義
@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    required Locale locale,
    required ThemeMode themeMode,
  }) = _AppSettings;
}

// 2. リポジトリインターフェースの作成
abstract class AppSettingsRepository {
  Future<AppSettings> load();
  Future<void> save(AppSettings settings);
}

// 3. コード生成を使ったプロバイダーの実装
@riverpod
class AppSettingsNotifier extends _$AppSettingsNotifier {
  @override
  Future<AppSettings> build() async {
    final repository = ref.read(appSettingsRepositoryProvider);
    return repository.load();
  }

  Future<void> updateLocale(Locale locale) async {
    final current = await future;
    final updated = current.copyWith(locale: locale);
    state = AsyncData(updated);
    await ref.read(appSettingsRepositoryProvider).save(updated);
  }
}
```

#### slangによる国際化

```dart
// 1. JSONで翻訳を定義
// assets/i18n/en.i18n.json
{
  "welcome": "Welcome to Flutter Template",
  "settings": {
    "title": "Settings",
    "language": "Language",
    "theme": "Theme"
  }
}

// 2. ウィジェットで使用
class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.i18n.welcome),
      ),
      body: Text(context.i18n.settings.title),
    );
  }
}
```

### テスト戦略

| テストタイプ           | カバレッジ                     | ツール                     |
| ---------------------- | ------------------------------ | -------------------------- |
| **ユニットテスト**     | ビジネスロジック、プロバイダー | `flutter_test`, `mocktail` |
| **ウィジェットテスト** | UIコンポーネント               | `flutter_test`             |
| **統合テスト**         | ユーザーワークフロー           | `integration_test`         |
| **ゴールデンテスト**   | UI一貫性                       | `flutter_test`             |

```bash
# 全テストの実行
melos run test

# カバレッジ付きで実行
melos run test --coverage

# 特定のテストファイルを実行
cd app
fvm flutter test test/pages/home_page_test.dart
```

## コントリビューション

1. リポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'feat: add amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。詳細については[LICENSE](LICENSE)ファイルを参照してください。

## サポート

- 📖 [ドキュメント](docs/)
- 🐛 [Issue Tracker](https://github.com/your-org/flutter_template_project/issues)
- 💬 [ディスカッション](https://github.com/your-org/flutter_template_project/discussions)
