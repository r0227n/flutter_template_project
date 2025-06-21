# CLAUDE.md - Claude Code設定ファイル

## プロジェクト概要

このプロジェクトはFlutterを使用したモバイルアプリケーション開発プロジェクトです。Claude Codeを使用して、Linear Issue管理システムと連携した自動化開発ワークフローを実現します。

### 技術スタック
- **フレームワーク**: Flutter
- **バージョン管理**: fvm (Flutter Version Management)
- **タスク管理**: Linear (MCP連携済み)
- **並列開発**: git worktree
- **自動化**: Claude Code with background tasks

## 環境設定

### 必須要件
- Flutter SDK (fvmで管理)
- Git worktree対応
- Linear MCP設定完了
- Claude Code ENABLE_BACKGROUND_TASKS有効化

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
```

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
4. 適切なブランチ名を生成 (feature/ABC-123-task-description)
5. 実行開始（自動実行時は確認プロンプトスキップ）
```

#### Phase 2: 環境準備
```
1. git worktree add で新しい作業ディレクトリを作成
2. fvm use でプロジェクト指定のFlutterバージョンを設定
3. 依存関係のインストール (flutter pub get)
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
4. Linear IssueをIn Reviewステータスに更新
5. アラーム通知で完了を報告
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
# ✅ git worktree作成: feature/ABC-123-user-auth
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

## 対話式実行の詳細仕様

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