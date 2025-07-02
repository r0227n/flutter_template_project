# パッケージ開発ガイド

**AI支援パッケージ開発によるGitHub Issues統合環境**

このドキュメントは、packagesディレクトリ内の機能特化パッケージ開発に関する人間向けガイドです。プロジェクト全体のセットアップおよびメインアプリケーション開発については、[../README.md](../README.md)を参照してください。

## ドキュメント構造

この`packages/`ディレクトリは、以下のドキュメント体系に従います：

### CLAUDE.md - README.md 1:1対応

- **[CLAUDE.md](CLAUDE.md)**: Claude Code用のパッケージ開発設定とワークフロー
- **[README.md](README.md)**: 人間向けのパッケージ開発説明（本文書）
- **1:1関係**: CLAUDE.mdの各セクションは、このREADME.mdで対応する人間向け説明を持ちます

### 関連ドキュメント

- **[メインプロジェクト設定](../CLAUDE.md)**: Claude Code全体設定
- **[プロジェクト概要](../README.md)**: 人間向けプロジェクトガイド
- **[Claude 4設計原則](../docs/CLAUDE_4_BEST_PRACTICES.md)**: AI開発ベストプラクティス

## パッケージ特化開発

このディレクトリには、メインアプリケーションから抽出された機能特化パッケージが含まれています。各パッケージは以下に従います：

### 設計原則

- **単一責任**: 1パッケージ = 1つの明確な機能
- **独立性**: パッケージ間の依存関係を最小化
- **再利用性**: 複数のアプリケーションでの使用を想定した設計
- **AI Review-First**: メイン設定で詳述されたレビュー手法に従う

## パッケージ開発ワークフロー

### GitHub Issues統合プロセス

```bash
# パッケージ開発 (パッケージ関連Issue IDを使用)
/task PKG-001    # 新規パッケージ作成
/task PKG-002    # 既存パッケージへの機能追加
/task PKG-003    # パッケージリファクタリング/最適化
```

### 現在のパッケージ

- **app_preferences**: アプリケーション設定（言語、テーマ、永続化）

## パッケージ作成ワークフロー

### 手動パッケージ作成（Flutterコマンド使用）

GitHub Issues自動化を使用する前の手動作成の場合：

```bash
# 1. packagesディレクトリに移動
cd packages

# 2. Flutterコマンドで新規パッケージ作成
flutter create --template=package [package_name]

# 3. ワークスペース用にパッケージ設定
cd [package_name]
echo "resolution: workspace" >> pubspec.yaml

# 4. 標準依存関係の追加
flutter pub add flutter_riverpod riverpod_annotation
flutter pub add --dev build_runner riverpod_generator yumemi_lints

# 5. yumemi_lints設定
# リンター互換性用Flutterバージョン取得
FLUTTER_VERSION=$(flutter --version | head -n 1 | grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+")

# analysis_options.yaml作成
cat > analysis_options.yaml << EOF
include: package:yumemi_lints/flutter/\${FLUTTER_VERSION}/recommended.yaml

analyzer:
  errors:
    invalid_annotation_target: ignore
  plugins:
    - custom_lint

formatter:
  trailing_commas: preserve
EOF

# 6. ワークスペースへのパッケージ登録
# ルートpubspec.yamlのworkspaceセクションに追加:
# workspace:
#   - app
#   - packages/app_preferences
#   - packages/[package_name]  # この行を追加

# 7. 依存関係インストールとコード生成
cd ../../
melos run get
melos run gen
```

### GitHub Issues自動パッケージ開発

自動化されたパッケージ開発の場合：

1. **パッケージIssue作成**: パッケージ関連IssuesにはPKG-XXX形式を使用
2. **コマンド実行**: `/task PKG-XXX`で自動パッケージ開発
3. **AIレビュープロセス**: 品質保証のための自動3-4回レビューサイクル
4. **統合**: 自動ワークスペース登録とメインアプリ統合

## パッケージアーキテクチャ

### 標準パッケージ構造

```
lib/
├── [package_name].dart     # パブリックAPI
├── src/
│   ├── providers/          # Riverpod状態管理
│   ├── repositories/       # データアクセス層
│   ├── models/            # データモデル
│   ├── widgets/           # UIコンポーネント
│   └── utils/             # ユーティリティ
├── assets/                # 静的リソース
└── test/                  # テスト
```

## AI Review統合

### 自動品質保証

パッケージ開発には以下が自動的に含まれます：

1. **セキュリティレビュー**: 入力値検証、エラーハンドリング、データサニタイゼーション
2. **アーキテクチャレビュー**: SOLID原則、依存関係管理
3. **パフォーマンスレビュー**: メモリ使用量、非同期処理、状態効率性
4. **最終人間検証**: ビジネス要件と統合テスト

### 品質ゲート

- コードカバレッジ: 最低80%
- 静的解析: 全チェック通過
- ドキュメント: 完全なAPI文書化
- テスト: ユニット、ウィジェット、統合テスト

## パッケージ開発標準

### yumemi_lints設定

一貫したコード品質のため、全パッケージにyumemi_lintsが必須：

```yaml
# 各パッケージのanalysis_options.yamlテンプレート
include: package:yumemi_lints/flutter/[FLUTTER_VERSION]/recommended.yaml

analyzer:
  errors:
    invalid_annotation_target: ignore
  plugins:
    - custom_lint

formatter:
  trailing_commas: preserve
```

### 必須依存関係

全パッケージの標準依存関係：

```yaml
# pubspec.yaml依存関係
dependencies:
  flutter:
    sdk: flutter
  hooks_riverpod: ^2.x.x
  riverpod_annotation: ^2.x.x

dev_dependencies:
  build_runner: ^2.x.x
  riverpod_generator: ^2.x.x
  yumemi_lints: ^1.x.x
  custom_lint: ^0.5.x
```

### 設計原則

- **単一責任**: 1パッケージ = 1つの明確な機能
- **疎結合**: パッケージ間の依存関係を最小化
- **高凝集**: 関連機能のグループ化
- **依存性注入**: クリーンアーキテクチャにRiverpodを使用
- **コード品質**: 全パッケージでyumemi_lints標準を強制

### 良い例・悪い例

✅ **良い例**: `user_authentication` - 認証のみ  
✅ **良い例**: `payment_processing` - 決済処理のみ  
❌ **悪い例**: `common_utils` - 混在機能

## 開発コマンド

### パッケージ開発

```bash
# GitHub Issues経由の自動パッケージ開発
claude
/task PKG-123  # パッケージを自動作成/更新

# 手動コマンド（必要な場合）
cd packages/[package_name]
melos run gen    # コード生成
flutter test     # テスト実行
dart analyze     # 静的解析
```

## パッケージ統合

### 自動統合

`/task PKG-XXX`使用時は統合が自動：

- ルート`pubspec.yaml`でのワークスペース登録
- メインアプリの依存関係設定
- プロバイダーセットアップと初期化
- ドキュメント更新

### 手動統合（必要な場合）

詳細な統合手順については[../README.md](../README.md)を参照してください。

## パッケージ例

### app_preferencesパッケージ

**目的**: アプリケーション設定管理  
**コンポーネント**: ロケール/テーマプロバイダー、設定ダイアログ、設定リポジトリ  
**統合**: ユーザー設定用にメインアプリで使用

詳細な実装については、パッケージソースコードを参照するか、`/task PKG-XXX`を使用して既存パッケージを分析してください。

## パッケージガイドライン

### パッケージを作成すべき場合

- 複数の画面/機能で使用される
- 独立してテスト可能
- 他プロジェクトでの再利用の可能性
- 特定のドメインロジックを含む

### パッケージを作成すべきでない場合

- 単一使用の簡単な機能
- メインアプリロジックと密結合
- 非常に小さなユーティリティ関数
- 1つの画面に特化したUIコンポーネント

## モノレポコマンド

### ワークスペース全体コマンド

```bash
# プロジェクトルートから
melos run gen      # 全パッケージのコード生成
melos run test     # 全パッケージのテスト
melos run analyze  # 全パッケージの静的解析
melos run format   # 全パッケージのフォーマット
melos run get      # 全パッケージの依存関係取得
```

## まとめ

このプロジェクトでのパッケージ開発は：

1. **GitHub Issuesを使用**: パッケージ作業にはPKG-XXX Issuesを作成
2. **自動化を活用**: `/task PKG-XXX`で自動開発
3. **基準に従う**: 単一責任、疎結合、高凝集
4. **プロセスを信頼**: AI Review-Firstが自動的に品質を保証

包括的なプロジェクトセットアップ、メインアプリ開発、詳細ワークフローについては、[../README.md](../README.md)および[../CLAUDE.md](../CLAUDE.md)を参照してください。

---

**パッケージディレクトリにおけるCLAUDE.mdとREADME.mdの1:1対応により、AIと人間の両方に最適化されたパッケージ開発環境を提供します。**
