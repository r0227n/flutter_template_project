# Linear Issue一覧表示コマンド

現在利用可能なLinear Issueの一覧を表示します。

## 機能

Linear APIを使用して以下の情報を取得・表示：

- 自分にアサインされたIssue
- ステータス（To Do, In Progress, In Review等）
- 優先度（Urgent, High, Normal, Low）
- 作成日・更新日
- 推定工数

## 表示形式

```
📋 利用可能なIssue:
┌──────────┬─────────────────────────────────┬──────────┬────────┬──────────┐
│ Issue ID │ タイトル                        │ ステータス │ 優先度  │ 更新日    │
├──────────┼─────────────────────────────────┼──────────┼────────┼──────────┤
│ ABC-123  │ ユーザー認証機能の実装           │ To Do    │ High   │ 2日前    │
│ XYZ-456  │ バグ修正: ログイン時のエラー処理  │ In Progress │ Urgent │ 1日前    │
│ FEAT-789 │ 新機能: プッシュ通知            │ To Do    │ Normal │ 3時間前  │
└──────────┴─────────────────────────────────┴──────────┴────────┴──────────┘

💡 /linear <Issue ID> で直接処理を開始できます
💡 /linear で対話形式の選択も可能です
```

## フィルタリングオプション

```bash
# 全てのIssue表示
/linear-list

# 高優先度のみ
/linear-list --priority high,urgent

# 特定ステータスのみ
/linear-list --status "to do","in progress"

# 今週更新されたもののみ
/linear-list --updated-within 7d

# 特定チームのIssue
/linear-list --team frontend
```

## 出力情報

各Issueについて以下の情報を表示：

- **Issue ID**: Linear上のユニークID
- **タイトル**: Issue名
- **説明**: Issue概要（短縮版）
- **ステータス**: 現在の処理状況
- **優先度**: Urgent/High/Normal/Low
- **担当者**: アサイン状況
- **更新日**: 最終更新日時
- **推定工数**: 設定されている場合
- **依存関係**: ブロッカーがある場合は表示

## 連携機能

- 表示後、そのまま /linear コマンドで処理開始可能
- Issue ID をコピーして直接実行可能
- フィルタ結果から選択実行可能

実行後、/linear コマンドで直接処理を開始できます。
