# VS Code Settings Configuration

このドキュメントでは、プロジェクトの`.vscode/settings.json`で設定されている各項目について詳しく解説します。

## 概要

Flutter開発に最適化されたVS Code設定で、以下の機能を提供します：

- 自動フォーマット（保存時）
- 生成ファイルの非表示化
- ファイルネスティング
- 言語固有の設定

## 設定項目の詳細

### Flutter & Dart Configuration

| 設定項目                                    | 値                     | 目的                                     | 効果                                      |
| ------------------------------------------- | ---------------------- | ---------------------------------------- | ----------------------------------------- |
| `dart.flutterSdkPath`                       | `.fvm/versions/3.32.2` | fvmで管理されているFlutter SDKパスを指定 | プロジェクト固有のFlutterバージョンを使用 |
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

## 開発ワークフローへの影響

### 1. コード品質の向上

- 自動フォーマットによるスタイル統一
- 保存時の自動修正によるエラー削減
- import文の自動整理による可読性向上

### 2. 開発効率の向上

- 生成ファイルの非表示化により、関連ファイルに集中
- ファイルネスティングによるプロジェクト構造の理解
- リアルタイム検索による素早いファイル発見

### 3. チーム開発の効率化

- Flutter SDKバージョンの統一
- コードスタイルの自動統一
- 設定ファイルの共有による環境統一

## カスタマイズ方法

### 新しい生成ファイルタイプの追加

```json
"search.exclude": {
  "**/*.your_extension.dart": true
},
"explorer.fileNesting.patterns": {
  "*.dart": "${capture}.g.dart, ${capture}.your_extension.dart"
}
```

### 言語固有設定の追加

```json
"[json]": {
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true
}
```

## トラブルシューティング

### フォーマッターが動作しない場合

1. 拡張機能のインストール確認:

   - Dart-Code.dart-code
   - esbenp.prettier-vscode

2. 設定の確認:
   - `editor.formatOnSave`が`true`になっているか
   - 言語固有設定が正しく記述されているか

### ファイルネスティングが表示されない場合

1. `explorer.fileNesting.enabled`が`true`になっているか確認
2. パターンが正しく記述されているか確認
3. VS Codeの再起動を試行

## 参考資料

- [VS Code Settings Reference](https://code.visualstudio.com/docs/getstarted/settings)
- [Dart-Code Extension](https://dartcode.org/)
- [Prettier VS Code Extension](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)
- [Flutter Development on VS Code](https://docs.flutter.dev/development/tools/vs-code)
