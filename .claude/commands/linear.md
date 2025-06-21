# Linear Issue処理コマンド

Linear Issueを処理するためのカスタムコマンドです。

## 実行モード

### 対話モード（引数なし）
引数が指定されていない場合、対話形式で実行します：

1. Linear APIから自分にアサインされたIssueを取得
2. Issue一覧を表示（タイトル、優先度、ステータス付き）
3. 処理するIssue IDを選択（複数選択可能）
4. 選択確認後、並列実行を開始

### 自動実行モード（引数あり）
引数が指定されている場合（例: /linear ABC-123 XYZ-456）：
- **確認プロンプトなし**: 全ての確認をスキップして即座に実行
- 指定されたIssue IDを直接処理
- Linear APIで存在確認後、自動で実行開始
- エラーがない限り、全て自動実行

## 自動実行の動作
引数でIssue IDが指定された場合：
```bash
/linear ABC-123 XYZ-456
# ↓ 以下が自動実行される（確認なし）
# ✅ Issue ID検証: ABC-123, XYZ-456
# ✅ Linear API存在確認: 完了
# ✅ git worktree作成: feature/ABC-123 (origin/main), feature/XYZ-456 (origin/main)
# ✅ Flutter環境設定: 完了
# 🚀 並列実行開始: バックグラウンドで処理中...
# ⏰ 完了時にアラーム通知予定
```

エラーが発生した場合のみ、詳細を表示して停止します。

## 処理内容
- fvmでFlutterバージョン設定
- git worktreeで専用ブランチ作成
- Issue内容に基づいた実装・テスト・ドキュメント作成
- 日本語でのPR作成
- Linear IssueのIn Reviewステータス更新
- 完了アラーム通知

## 設定
```bash
# 自動実行時の動作設定
AUTO_CONFIRM_WITH_ARGS=true    # 引数ありの場合は確認をスキップ
SILENT_MODE_WITH_ARGS=false    # 進捗表示は継続
ERROR_ONLY_OUTPUT=false        # エラー以外も表示
```

## 実行例

### 対話形式
```bash
/linear
📋 利用可能なIssue:
1) ABC-123: ユーザー認証機能の実装 (High, To Do)
2) XYZ-456: バグ修正: ログイン時のエラー処理 (Urgent, In Progress)
3) FEAT-789: 新機能: プッシュ通知 (Normal, To Do)

? 処理するIssueを選択してください [1-3, または複数選択]: 1,3
? 選択したIssue: ABC-123, FEAT-789 で実行しますか？ [Y/n]: y

🚀 並列実行を開始しています...
```

### 自動実行
```bash
/linear ABC-123
✅ Issue ID検証: ABC-123
✅ Linear API確認: Issue存在確認済み
✅ 権限確認: 処理可能
✅ git worktree作成: feature/ABC-123-user-auth (origin/main)
✅ Flutter環境設定: fvm 3.24.0 適用済み
🚀 バックグラウンド実行開始...
📝 実装中: ユーザー認証機能
⏰ 完了時にアラーム通知予定
```

### エラーハンドリング
```bash
/linear INVALID-123
❌ エラー: Issue ID 'INVALID-123' が見つかりません
💡 /linear-list で利用可能なIssueを確認してください
```