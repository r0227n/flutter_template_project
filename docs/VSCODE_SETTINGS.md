# VS Code Settings Configuration

プロジェクトの`.vscode/settings.json`設定ファイルの詳細解説ドキュメント

## Table of Contents

- [Overview](#overview)
- [Configuration Details](#configuration-details)
- [Development Workflow Impact](#development-workflow-impact)
- [Customization Guide](#customization-guide)
- [Troubleshooting](#troubleshooting)
- [References](#references)

## Overview

Flutter開発環境に最適化されたVS Code設定を提供し、開発効率とコード品質を向上させます。

### Key Features

| 機能                     | 説明                                 | 効果                         |
| ------------------------ | ------------------------------------ | ---------------------------- |
| **自動フォーマット**     | 保存時の自動コードフォーマット       | スタイル統一・コード品質向上 |
| **生成ファイル除外**     | build_runner等の生成ファイルを非表示 | 関連ファイルへの集中         |
| **ファイルネスティング** | 関連ファイルのグループ化表示         | プロジェクト構造の理解促進   |
| **言語固有設定**         | Dart/YAML/Markdown専用設定           | 最適化された開発体験         |

## Configuration Details

### Flutter & Dart Configuration

| 設定項目                                    | 値                     | 目的                                     | 効果                                      |
| ------------------------------------------- | ---------------------- | ---------------------------------------- | ----------------------------------------- |
| `dart.flutterSdkPath`                       | `mise where flutter`   | miseで管理されているFlutter SDKパスを指定 | プロジェクト固有のFlutterバージョンを使用 |
| `dart.previewFlutterUiGuides`               | `true`                 | Flutter UIガイドラインの表示             | ウィジェット構造の視覚的な理解が向上      |
| `dart.previewFlutterUiGuidesCustomTracking` | `true`                 | カスタムウィジェットでのUIガイド表示     | 自作ウィジェットでも構造が見やすくなる    |

### File Management

| 設定項目        | 対象ファイル   | 目的                            | 効果                       |
| --------------- | -------------- | ------------------------------- | -------------------------- |
| `files.exclude` | `**/.git`      | Gitディレクトリを非表示         | エクスプローラーがスッキリ |
|                 | `**/.svn`      | SVNディレクトリを非表示         | 古いVCS対応                |
|                 | `**/.hg`       | Mercurialディレクトリを非表示   | 古いVCS対応                |
|                 | `**/.DS_Store` | macOSシステムファイルを非表示   | 不要ファイルの除外         |
|                 | `**/Thumbs.db` | Windowsシステムファイルを非表示 | 不要ファイルの除外         |

### Search Configuration

| 設定項目                            | 値/対象                  | 目的                                           | 効果                     |
| ----------------------------------- | ------------------------ | ---------------------------------------------- | ------------------------ |
| `search.exclude`                    | `**/*.g.dart`            | build_runnerで生成されたファイルを検索から除外 | 検索結果の精度向上       |
|                                     | `**/*.freezed.dart`      | freezedパッケージで生成されたファイルを除外    | 関連性の高い検索結果     |
|                                     | `**/*.config.dart`       | 設定ファイルを除外                             | 手動編集ファイルに集中   |
|                                     | `**/*.gr.dart`           | go_routerで生成されたファイルを除外            | ルート定義ファイルに集中 |
|                                     | `**/translations.g.dart` | slangで生成された翻訳ファイルを除外            | 翻訳ソースに集中         |
| `search.useReplacePreview`          | `true`                   | 置換前にプレビューを表示                       | 意図しない置換を防止     |
| `search.searchOnType`               | `true`                   | 入力と同時に検索実行                           | リアルタイム検索         |
| `search.searchOnTypeDebouncePeriod` | `300`                    | 検索実行の遅延時間（ms）                       | パフォーマンス向上       |

### Explorer File Nesting

| 設定項目                       | 値      | 目的                             | 効果                   |
| ------------------------------ | ------- | -------------------------------- | ---------------------- |
| `explorer.fileNesting.enabled` | `true`  | ファイルネスティング機能を有効化 | エクスプローラーの整理 |
| `explorer.fileNesting.expand`  | `false` | ネストを折りたたみ状態で表示     | 初期表示をスッキリ     |

#### File Nesting Patterns

| 親ファイル     | 子ファイル                      | 説明                             |
| -------------- | ------------------------------- | -------------------------------- |
| `*.dart`       | `${capture}.g.dart`             | build_runnerで生成されたファイル |
|                | `${capture}.freezed.dart`       | freezedで生成されたファイル      |
|                | `${capture}.config.dart`        | 設定ファイル                     |
|                | `${capture}.gr.dart`            | go_routerで生成されたファイル    |
| `pubspec.yaml` | `pubspec.lock`                  | 依存関係ロックファイル           |
|                | `.flutter-plugins`              | Flutterプラグイン情報            |
|                | `.flutter-plugins-dependencies` | プラグイン依存関係               |
|                | `.packages`                     | パッケージ情報                   |
|                | `.metadata`                     | メタデータファイル               |
| `.gitignore`   | `.gitattributes`                | Git属性設定                      |
|                | `.gitmodules`                   | Gitサブモジュール                |
|                | `.gitmessage`                   | コミットメッセージテンプレート   |
|                | `.mailmap`                      | 作者情報マッピング               |
|                | `.git-blame*`                   | Git blame設定                    |

### General Editor Configuration

| 設定項目                                 | 値                       | 目的                           | 効果                     |
| ---------------------------------------- | ------------------------ | ------------------------------ | ------------------------ |
| `editor.defaultFormatter`                | `esbenp.prettier-vscode` | デフォルトフォーマッターを設定 | 統一されたコードスタイル |
| `editor.formatOnSave`                    | `true`                   | 保存時に自動フォーマット       | コード品質の向上         |
| `editor.codeActionsOnSave.source.fixAll` | `explicit`               | 保存時に自動修正を実行         | リントエラーの自動修正   |

### Language-Specific Settings

#### Dart Configuration

| 設定項目                                                 | 値                    | 目的                       | 効果                   |
| -------------------------------------------------------- | --------------------- | -------------------------- | ---------------------- |
| `[dart].editor.defaultFormatter`                         | `Dart-Code.dart-code` | Dart専用フォーマッター使用 | Dartスタイルガイド準拠 |
| `[dart].editor.formatOnSave`                             | `true`                | 保存時にdart format実行    | 自動コードフォーマット |
| `[dart].editor.codeActionsOnSave.source.fixAll`          | `explicit`            | Dartコードの自動修正       | リントルール違反の修正 |
| `[dart].editor.codeActionsOnSave.dart.addConstModifier`  | `explicit`            | const修飾子の自動追加      | パフォーマンス向上     |
| `[dart].editor.codeActionsOnSave.source.organizeImports` | `explicit`            | import文の自動整理         | 可読性向上             |

#### YAML Configuration

| 設定項目                         | 対象ファイル | 値                       | 目的                   | 効果                   |
| -------------------------------- | ------------ | ------------------------ | ---------------------- | ---------------------- |
| `[yaml].editor.defaultFormatter` | `.yaml`      | `esbenp.prettier-vscode` | Prettierでフォーマット | 統一されたYAMLスタイル |
| `[yml].editor.defaultFormatter`  | `.yml`       | `esbenp.prettier-vscode` | Prettierでフォーマット | 統一されたYMLスタイル  |
| `[yaml].editor.formatOnSave`     | `.yaml`      | `true`                   | 保存時フォーマット     | pubspec.yamlの整理     |
| `[yml].editor.formatOnSave`      | `.yml`       | `true`                   | 保存時フォーマット     | 設定ファイルの整理     |

#### Markdown Configuration

| 設定項目                             | 値                       | 目的                             | 効果                           |
| ------------------------------------ | ------------------------ | -------------------------------- | ------------------------------ |
| `[markdown].editor.defaultFormatter` | `esbenp.prettier-vscode` | MarkdownをPrettierでフォーマット | 統一されたドキュメントスタイル |
| `[markdown].editor.formatOnSave`     | `true`                   | 保存時にフォーマット             | ドキュメント品質向上           |
| `[markdown].editor.wordWrap`         | `on`                     | 長い行の自動折り返し             | 可読性向上                     |

## Development Workflow Impact

| カテゴリ                   | 改善点                 | 具体的な効果                         |
| -------------------------- | ---------------------- | ------------------------------------ |
| **Code Quality**           | 自動フォーマット・修正 | スタイル統一、エラー削減、可読性向上 |
| **Development Efficiency** | ファイル管理最適化     | 関連ファイルへの集中、構造理解促進   |
| **Team Collaboration**     | 環境統一               | SDKバージョン統一、設定共有          |
| **Search Performance**     | 生成ファイル除外       | 検索精度向上、結果の関連性向上       |
| **Project Navigation**     | ファイルネスティング   | 階層構造の理解、ナビゲーション効率化 |

## Customization Guide

### Adding New Generated File Types

生成ファイルタイプを追加する場合の設定例：

```json
{
  "search.exclude": {
    "**/*.your_extension.dart": true,
    "**/*.generated.dart": true
  },
  "explorer.fileNesting.patterns": {
    "*.dart": "${capture}.g.dart, ${capture}.freezed.dart, ${capture}.your_extension.dart"
  }
}
```

### Language-Specific Configuration

新しい言語サポートを追加する場合：

```json
{
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.formatOnSave": true,
    "editor.tabSize": 2
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.codeActionsOnSave": {
      "source.organizeImports": "explicit"
    }
  }
}
```

### Custom File Nesting Patterns

プロジェクト固有のファイルネスティングパターン：

```json
{
  "explorer.fileNesting.patterns": {
    "*.component.ts": "${capture}.component.html, ${capture}.component.scss, ${capture}.component.spec.ts",
    "*.service.ts": "${capture}.service.spec.ts",
    "package.json": "package-lock.json, yarn.lock, pnpm-lock.yaml"
  }
}
```

## Troubleshooting

### Formatter Not Working

**Problem**: コードが保存時にフォーマットされない

**Solutions**:

1. **Extension Check**:

   ```bash
   # VS Code Extensions確認
   code --list-extensions | grep -E "(dart-code|prettier)"
   ```

2. **Settings Verification**:

   - `editor.formatOnSave`: `true`になっているか
   - 言語固有設定が正しく記述されているか
   - デフォルトフォーマッターが適切に設定されているか

3. **Configuration Reload**:
   - VS Code再起動
   - 設定ファイルの再読み込み

### File Nesting Issues

**Problem**: ファイルネスティングが表示されない

**Solutions**:

1. **Setting Check**:

   ```json
   {
     "explorer.fileNesting.enabled": true,
     "explorer.fileNesting.expand": false
   }
   ```

2. **Pattern Validation**:

   - パターン構文の確認
   - ファイル名の一致確認
   - 正規表現の妥当性

3. **Workspace Reload**:
   - ワークスペースの再読み込み
   - VS Code完全再起動

### Search Exclusion Problems

**Problem**: 生成ファイルが検索結果に表示される

**Solutions**:

1. **Exclude Pattern Check**:

   ```json
   {
     "search.exclude": {
       "**/*.g.dart": true,
       "**/*.freezed.dart": true
     }
   }
   ```

2. **Global vs Workspace Settings**:
   - ワークスペース設定の優先確認
   - グローバル設定との競合チェック

## References

| Resource                | Description              | URL                                                                                            |
| ----------------------- | ------------------------ | ---------------------------------------------------------------------------------------------- |
| **VS Code Settings**    | 公式設定リファレンス     | [Settings Reference](https://code.visualstudio.com/docs/getstarted/settings)                   |
| **Dart-Code Extension** | Dart/Flutter開発拡張機能 | [Dart-Code](https://dartcode.org/)                                                             |
| **Prettier Extension**  | コードフォーマッター     | [Prettier VS Code](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) |
| **Flutter VS Code**     | Flutter開発ガイド        | [Flutter Development](https://docs.flutter.dev/development/tools/vs-code)                      |
| **File Nesting**        | ファイルネスティング設定 | [File Nesting](https://code.visualstudio.com/updates/v1_67#_explorer-file-nesting)             |
