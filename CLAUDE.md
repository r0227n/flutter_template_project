# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

このプロジェクトはFlutterを使用したモバイルアプリケーション開発プロジェクトです。Claude Codeを使用して、Linear Issue管理システムと連携した自動化開発ワークフローを実現します。

### 技術スタック

- **フレームワーク**: Flutter (Workspace/Monorepo構造)
- **バージョン管理**: fvm (Flutter Version Management)
- **タスク管理**: Linear (MCP連携済み)
- **並列開発**: git worktree
- **自動化**: Claude Code with background tasks
- **State Management**: Riverpod (hooks_riverpod, riverpod_annotation)
- **Navigation**: go_router (declarative routing)
- **Internationalization**: slang (type-safe translations)
- **Build Tools**: build_runner, freezed
- **Monorepo Management**: Melos + pub workspace

## プロジェクト構造

```
flutter_template_project/
├── app/                         # メインFlutterアプリケーション
│   ├── lib/
│   │   ├── main.dart           # エントリーポイント
│   │   ├── pages/              # UIページ (home_page.dart, settings_page.dart)
│   │   ├── router/             # go_router設定と型安全ルート定義
│   │   └── i18n/               # slang生成の多言語ファイル
│   ├── assets/i18n/            # JSON翻訳ファイル (ja.i18n.json, en.i18n.json)
│   └── test/                   # ウィジェットテスト
├── packages/
│   └── app_preferences/        # 共有preferences管理パッケージ
│       ├── lib/
│       │   ├── src/
│       │   │   ├── providers/  # Riverpodプロバイダー
│       │   │   ├── repositories/
│       │   │   └── theme/
│       │   └── widgets/        # 再利用可能なウィジェット
│       └── assets/i18n/        # パッケージ固有の翻訳
├── pubspec.yaml                # Workspace設定
└── melos.yaml                  # (pubspec.yaml内に統合)
```

## 環境設定

### 必須要件

- Flutter SDK (fvmで管理)
- Git worktree対応
- Linear MCP設定完了
- Claude Code ENABLE_BACKGROUND_TASKS有効化
- Node.js (commitlint, prettier用)

## 開発コマンド

### Melosコマンド (推奨)

```bash
# コード生成 (freezed, riverpod, go_router, slang)
melos run gen

# 依存関係取得
melos run get

# 静的解析
melos run analyze

# slang翻訳チェック
melos run analyze:slang

# コードフォーマット
melos run format

# テスト実行
melos run test

# CI用フォーマットチェック
melos run ci:format
```

### Flutter直接コマンド (fvm使用)

```bash
# アプリケーション実行
cd app && fvm flutter run

# テスト実行（単一ファイル）
cd app && fvm flutter test test/widget_test.dart

# ビルド
cd app && fvm flutter build apk
cd app && fvm flutter build ios --no-codesign
```

### Node.js関連コマンド

```bash
# YAML/Markdownリント
npm run lint

# YAML/Markdownフォーマット
npm run format
```

### 環境変数

```bash
export ENABLE_BACKGROUND_TASKS=true
export FLUTTER_VERSION_MANAGEMENT=fvm
export TASK_MANAGEMENT_SYSTEM=linear
export PARALLEL_DEVELOPMENT=git_worktree
export PR_LANGUAGE=japanese
export COMPLETION_NOTIFICATION=alarm
export INTERACTIVE_MODE=true
export ISSUE_SELECTION_UI=enabled
export AUTO_CONFIRM_WITH_ARGS=true      # 引数ありの場合は確認をスキップ
export SILENT_MODE_WITH_ARGS=false      # 進捗表示は継続
export ERROR_ONLY_OUTPUT=false          # エラー以外も表示
export CLAUDE_ISOLATION_MODE=true       # 並列実行時の作業分離
export CLAUDE_WORKSPACE_DIR=".claude-workspaces" # プロジェクト内作業ディレクトリ
export CLAUDE_MEMORY_ISOLATION=true     # メモリ・コンテキスト分離
export GITHUB_ACTIONS_CHECK=true        # GitHub Actions完了チェック有効
export CHECK_PR_WORKFLOW="check-pr.yml" # 監視対象ワークフローファイル
```

## アーキテクチャ設計

### State Management: Riverpod

- **Providers**: `app_preferences/lib/src/providers/`に配置
- **コード生成**: `@riverpod`アノテーションを使用し、`melos run gen`で生成
- **AsyncValue**: 非同期操作の状態管理に使用
- **Provider Types**:
  - `StateNotifierProvider`: 状態変更を伴うロジック
  - `FutureProvider`: 非同期データの取得
  - `StreamProvider`: リアルタイムデータストリーム

### Navigation: go_router

- **ルート定義**: `app/lib/router/app_routes.dart`
- **型安全ルーティング**: `@TypedGoRoute`アノテーションで型安全を実現
- **遷移例**: `HomePageRoute().go(context)`

### Internationalization: slang

- **翻訳ファイル**: `app/assets/i18n/`に`ja.i18n.json`と`en.i18n.json`を配置
- **型安全アクセス**: `context.i18n.someKey`で翻訳文字列にアクセス
- **動的切り替え**: LocaleSettingsを使用して実行時に言語切り替え可能

### Theme Management

- **テーマプロバイダー**: `app_preferences`パッケージで管理
- **永続化**: SharedPreferencesで選択テーマを保存
- **システムテーマ**: Material You (Android 12+)対応

## カスタムスラッシュコマンド設定

### 利用可能なコマンド

- `/linear` - Linear Issue処理（対話式・自動実行）
- `/linear-list` - 利用可能Issue一覧表示
- `/linear-status` - Linear連携状況確認

### コマンドファイル配置

```
.claude/
└── commands/
    ├── linear.md          # メインのIssue処理コマンド
    ├── linear-list.md     # Issue一覧表示コマンド
    └── linear-status.md   # 接続状況確認コマンド
```

## ワークフロー定義

### 基本フロー（/linearコマンド使用）

1. **コマンド実行**: `claude` → `/linear` または `/linear <Issue ID>` 実行
2. **Issue選択**: 対話形式でIssue ID選択（引数指定時はスキップ）
3. **ブランチ作成**: 新規作業ブランチをgit worktreeで作成
4. **並列実行**: 非同期でタスクを実行
5. **自動PR作成**: 作業完了時に日本語でPRを作成
6. **完了通知**: アラームで作業完了を通知

### 詳細ワークフロー

#### Phase 1: タスク初期化

```
INPUT:
- 対話形式: `/linear` → Issue ID選択プロンプト
- 自動実行: `/linear ABC-123` → 確認なしで即座に開始
↓
1. Issue ID検証（自動実行時は確認プロンプトなし）
2. Linear APIでIssue詳細を取得
3. Issue内容を解析してタスク要件を理解
4. 適切なブランチ名を生成 (feature/ISSUE_ID) ※日本語は使用しない
5. 実行開始（自動実行時は確認プロンプトスキップ）
```

#### Phase 2: 環境準備（分離実行）

```
1. Issue IDベースの独立作業ディレクトリ作成（プロジェクト内）
   - .claude-workspaces/ABC-123/ (タスクA専用)
   - .claude-workspaces/XYZ-456/ (タスクB専用)
2. 各ディレクトリでgit worktree add実行
3. 独立したClaude Codeプロセスとメモリ空間
4. fvm use でプロジェクト指定のFlutterバージョンを設定
5. 依存関係のインストール (flutter pub get)
6. セッション識別子の作成（.claude-session）
```

#### Phase 3: 非同期実行

```
ENABLE_BACKGROUND_TASKS = true で以下を並列実行:
- コード実装
- テスト作成・実行
- ドキュメント更新
- コード品質チェック
```

#### Phase 4: 完了処理

```
1. 全ての作業が完了次第
2. 変更をコミット
3. PRを作成（説明文は日本語）
4. GitHub Actions実行: .github/workflows/check-pr.yml の全チェック正常終了を確認
5. Linear IssueをIn Reviewステータスに更新
6. アラーム通知で完了を報告
```

## コマンド実行例

### 対話形式での実行（推奨）

```bash
# Claude Code対話モードを開始
claude

# /linearコマンドで対話形式実行
/linear

# 実行例:
# 📋 利用可能なIssue:
# 1) ABC-123: ユーザー認証機能の実装 (High, To Do)
# 2) XYZ-456: バグ修正: ログイン時のエラー処理 (Urgent, In Progress)
# 3) FEAT-789: 新機能: プッシュ通知 (Normal, To Do)
#
# ? 処理するIssueを選択してください [1-3, または複数選択]: 1,3
# ? 選択したIssue: ABC-123, FEAT-789 で実行しますか？ [Y/n]: y
#
# 🚀 並列実行を開始しています...
```

### 直接指定での実行（自動実行）

```bash
# Claude Code対話モード
claude

# Issue IDを直接指定（確認なしで自動実行）
/linear ABC-123
# ✅ Issue検証完了 → 🚀 自動実行開始

# 複数Issue IDを指定（確認なしで自動実行）
/linear ABC-123 XYZ-456 FEAT-789
# ✅ 3件のIssue検証完了 → 🚀 並列自動実行開始

# 実行例（自動モード）:
# /linear ABC-123
# ✅ Issue ID検証: ABC-123
# ✅ Linear API確認: Issue存在確認済み
# ✅ 権限確認: 処理可能
# ✅ git worktree作成: feature/ABC-123
# ✅ Flutter環境設定: fvm 3.24.0 適用済み
# 🚀 バックグラウンド実行開始...
# 📝 実装中: ユーザー認証機能
# ⏰ 完了時にアラーム通知予定
```

### 補助コマンド

```bash
# Issue一覧確認
/linear-list

# Linear連携状況確認
/linear-status
```

## 並列実行時の作業分離設定

### 問題: タスクAとタスクBの内容混在

Claude Codeを複数並列実行した際に、異なるIssueの作業内容が混在してしまう問題の対策

### 分離戦略

#### 1. 物理的ディレクトリ分離

```bash
# プロジェクト構造例（プロジェクト内分離）
project-root/
├── CLAUDE.md                    # マスター設定
├── .claude/commands/           # 共通コマンド
├── .claude-workspaces/         # 並列作業領域（gitignore対象）
│   ├── ABC-123/               # タスクA専用ディレクトリ
│   │   ├── .claude-session    # セッション識別子
│   │   └── [git worktree]     # feature/ABC-123ブランチ
│   └── XYZ-456/               # タスクB専用ディレクトリ
│       ├── .claude-session    # セッション識別子
│       └── [git worktree]     # feature/XYZ-456ブランチ
├── src/                       # 元のソースコード
├── pubspec.yaml              # Flutter設定
└── .gitignore                # .claude-workspaces/ を除外
```

#### 2. Claude Codeプロセス分離

```bash
# 各タスクを別ターミナル・別プロセスで実行
# ターミナル1: タスクA（プロジェクトルートから）
claude
/linear ABC-123
# → .claude-workspaces/ABC-123/ で実行

# ターミナル2: タスクB（プロジェクトルートから）
claude
/linear XYZ-456
# → .claude-workspaces/XYZ-456/ で実行
```

#### 3. メモリ・コンテキスト分離

```bash
# 各Claude Codeインスタンスで独立したメモリ空間
export CLAUDE_MEMORY_ISOLATION=true
export CLAUDE_SESSION_ID="ABC-123"  # タスクA
export CLAUDE_SESSION_ID="XYZ-456"  # タスクB
```

### 自動分離実装

#### 作業ディレクトリ自動作成

```bash
# /linearコマンド実行時の自動分離処理（プロジェクト内）
function create_isolated_workspace() {
    ISSUE_ID=$1
    PROJECT_ROOT=$(pwd)
    WORKSPACE_DIR=".claude-workspaces/${ISSUE_ID}"

    # 1. プロジェクト内に独立作業ディレクトリ作成
    mkdir -p "${WORKSPACE_DIR}"

    # 2. git worktreeセットアップ (ブランチ名はISSUE_IDのみ、日本語不可)
    git worktree add "${WORKSPACE_DIR}" -b "feature/${ISSUE_ID}"

    # 3. セッション識別子作成
    echo "SESSION_${ISSUE_ID}" > "${WORKSPACE_DIR}/.claude-session"
    echo "CREATED_AT=$(date)" >> "${WORKSPACE_DIR}/.claude-session"

    # 4. Flutter環境セットアップ（プロジェクト設定を継承）
    cd "${WORKSPACE_DIR}"
    fvm use $(cat "${PROJECT_ROOT}/.fvmrc" 2>/dev/null || echo "stable")
    flutter pub get

    # 5. 作業ディレクトリ情報
    echo "作業ディレクトリ: ${PROJECT_ROOT}/${WORKSPACE_DIR}"
    echo "git worktree: feature/${ISSUE_ID}"
    echo "セッションID: SESSION_${ISSUE_ID}"

    # 6. プロジェクトルートに戻る（Claude Codeはルートから実行）
    cd "${PROJECT_ROOT}"
}
```

#### 分離実行ログ

```bash
# タスクA実行ログ例
🚀 Issue ABC-123 処理開始
📁 作業ディレクトリ: .claude-workspaces/ABC-123
🔗 git worktree: feature/ABC-123
💾 Claude メモリ分離: SESSION_ABC-123
✅ 環境分離完了

# タスクB実行ログ例
🚀 Issue XYZ-456 処理開始
📁 作業ディレクトリ: .claude-workspaces/XYZ-456
🔗 git worktree: feature/XYZ-456
💾 Claude メモリ分離: SESSION_XYZ-456
✅ 環境分離完了
```

### 分離確認・管理

#### 進行中タスク確認

```bash
# 並列実行中のタスク一覧
/linear-running
📊 実行中のタスク:
┌──────────┬─────────────────────┬──────────┬──────────────────────┐
│ Issue ID │ 作業ディレクトリ     │ 進捗     │ 開始時刻              │
├──────────┼─────────────────────┼──────────┼──────────────────────┤
│ ABC-123  │ .claude-workspaces/ABC-123│ 実装中   │ 2025-06-22 10:30:00  │
│ XYZ-456  │ .claude-workspaces/XYZ-456│ テスト中 │ 2025-06-22 10:45:00  │
└──────────┴─────────────────────┴──────────┴──────────────────────┘
```

#### 作業領域クリーンアップ

```bash
# 完了タスクの作業領域削除
/linear-cleanup
? クリーンアップ対象を選択:
  [x] .claude-workspaces/ABC-123 (完了済み)
  [ ] .claude-workspaces/XYZ-456 (実行中)
  [x] .claude-workspaces/OLD-789 (7日前完了)

✅ 2個の作業領域をクリーンアップしました
```

#### .gitignore設定

```bash
# .gitignoreに追加
.claude-workspaces/
*.lock
.claude-session
```

### 競合回避ルール

1. **同一Issue IDの重複実行禁止**: 既に実行中のIssueは再実行不可
2. **ファイルロック**: 作業ディレクトリに.lock ファイル作成
3. **リソース監視**: CPU/メモリ使用率が80%超過時は新規実行を待機
4. **依存関係チェック**: 関連Issueの実行状況を確認

### 対話フローの設定

```bash
# デフォルト設定で対話モード有効
export INTERACTIVE_MODE=true
export PROMPT_STYLE="enhanced"  # enhanced, simple, minimal
export AUTO_COMPLETION=true     # Issue ID補完機能
export ISSUE_PREVIEW=true       # Issue内容プレビュー表示
```

### 入力検証とエラーハンドリング

```
対話時の検証項目:
1. Issue ID形式チェック (例: ABC-123)
2. Linear APIでの存在確認
3. Issue状態確認（クローズ済みの場合は警告）
4. 権限確認（アサインされていない場合は確認）
5. 依存関係チェック（ブロッカーIssueの存在）
```

### 対話UIのカスタマイズ

```bash
# 対話モード（引数なし）- 詳細確認あり
/linear
> 📋 利用可能なIssue:
> 1) ABC-123: ユーザー認証機能の実装
>    ステータス: To Do | 優先度: High | 担当者: あなた
>    📝 説明: OAuth2.0を使用したログイン機能の実装
>
> ? 処理するIssueを選択してください: 1
> ? このIssueを処理しますか？ [Y/n]: y

# 自動実行モード（引数あり）- 確認なし
/linear ABC-123
> ✅ Issue ID検証: ABC-123
> ✅ Linear API確認: 存在確認済み
> ✅ 処理権限: OK
> 🚀 自動実行開始...
> 📝 実装中: ユーザー認証機能の実装
> ⏰ 完了時にアラーム通知予定

# エラー発生時のみ停止
/linear INVALID-123
> ❌ エラー: Issue ID 'INVALID-123' が見つかりません
> 💡 /linear-list で利用可能なIssueを確認してください
```

## 自動化ルール

### PR作成ルール

- **タイトル**: `[ABC-123] Issue タイトルをそのまま使用`
- **説明文**: 日本語で以下の内容を含む

  ```markdown
  ## 変更内容

  - 実装した機能の詳細
  - 修正したバグの内容

  ## 関連Issue

  - Closes #{Linear Issue URL}

  ## テスト

  - 実行したテストの概要
  - テスト結果

  ## チェックリスト

  - [ ] コードレビュー準備完了
  - [ ] テスト実行済み
  - [ ] ドキュメント更新済み
  ```

### 並列実行ルール

- 各git worktreeは独立したFlutter環境を持つ
- 同時に複数のIssueを処理可能
- リソース競合を避けるため、重要度に応じて優先度を調整

### 完了通知ルール

- システムアラーム音で通知
- 通知内容: "Issue ABC-123の作業が完了しました。PRが作成されています。"
- **完了条件**: `.github/workflows/check-pr.yml`の全チェックが正常終了すること

### ワークフロー完了条件

以下の条件を全て満たした場合にタスク完了とみなします：

1. **コード実装完了**: Issue要件に基づく機能実装
2. **テスト実行成功**: 自動テスト・手動テストの成功
3. **コード品質チェック**: dart analyze、dart format通過
4. **PR作成**: 日本語説明文付きでPR作成済み
5. **GitHub Actions成功**: `.github/workflows/check-pr.yml`の全チェック正常終了
6. **Linear更新**: IssueステータスをIn Reviewに更新

### GitHub Actions連携

```bash
# PR作成後の自動チェック監視
1. PR作成時に.github/workflows/check-pr.ymlが自動実行
2. Claude Codeが以下のチェック結果を監視:
   - Build success
   - Test suite pass
   - Code quality checks
   - Security scans
   - Lint checks
3. 全チェック正常終了を確認後、完了通知
4. いずれかのチェック失敗時は自動修正を試行
```

### 失敗時の自動対応

```bash
# GitHub Actionsチェック失敗時
❌ GitHub Actions失敗検出
📋 失敗内容を解析
🔧 自動修正を試行:
   - テスト失敗 → テストコード修正
   - Lint エラー → dart format実行
   - Build エラー → 依存関係確認・修正
📤 修正コミット・プッシュ
🔄 再チェック実行
✅ 全チェック正常終了後に完了通知
```

## トラブルシューティング

### よくある問題と解決方法

#### 1. Linear API接続エラー

```bash
# Linear連携状況確認
/linear-status

# MCP設定の再確認が必要な場合
/config
```

#### 2. fvmバージョン競合

```bash
# Flutterバージョンを再設定
fvm use [project_flutter_version]
flutter clean
flutter pub get
```

#### 3. git worktree作成失敗

```bash
# 既存のworktreeを確認・削除
git worktree list
git worktree remove [worktree_path]
```

#### 4. バックグラウンドタスクが動作しない

```bash
# 環境変数を確認
echo $ENABLE_BACKGROUND_TASKS
export ENABLE_BACKGROUND_TASKS=true
```

## 設定カスタマイズ

### 通知設定

- アラーム音の変更: システム設定で調整
- 通知タイミング: PR作成完了時

### 品質管理

- 自動テスト実行: 全てのコミット前に実行
- コード静的解析: dart analyze自動実行
- フォーマット: dart format自動適用

### パフォーマンス最適化

- 並列実行数制限: CPU使用率に応じて調整
- メモリ使用量監視: 大量のworktree作成時の制御

## セキュリティ考慮事項

- Linear APIキーの安全な管理
- git認証情報の適切な設定
- 機密情報を含むコードの取り扱い注意

---

**注意**: このファイルはClaude Codeの動作を制御する重要な設定ファイルです。変更時は十分にテストを行ってください。

## 開発上の注意事項

### コード生成

- 新しいモデルクラスやプロバイダーを追加した後は必ず`melos run gen`を実行
- 生成ファイル(`*.g.dart`, `*.freezed.dart`)は直接編集しない

### テスト

- 新機能追加時は対応するウィジェットテストを`app/test/`に追加
- `melos run test`で全パッケージのテストを実行

### Git Workflow

- コミットメッセージは[Conventional Commits](https://www.conventionalcommits.org/)形式を使用
- **ブランチ名**: `feature/ISSUE_ID` 形式のみ使用（日本語・英語説明文は含めない）
- PRチェックは`.github/workflows/check-pr.yml`で自動実行
- 分析、フォーマット、テスト、i18n検証が含まれる

### パッケージ管理

- 新しい依存関係は該当するパッケージの`pubspec.yaml`に追加
- Workspace resolutionにより、全パッケージで同じバージョンが使用される
- `melos run get`で全パッケージの依存関係を一括更新
