# Linear連携ステータス確認コマンド

Linear MCPの接続状況と設定を確認します。

## 確認項目
1. Linear MCP接続状況
2. 認証状態
3. アクセス可能なワークスペース
4. 設定されているチーム
5. 権限レベル
6. APIレート制限状況

## 出力例
```
🔗 Linear連携ステータス:
✅ MCP接続: 正常
✅ 認証: 有効
✅ ワークスペース: Example Company
✅ アクセス可能チーム: 3個
   - Frontend Team (FRONT)
   - Backend Team (BACK)  
   - QA Team (QA)
✅ 権限: 読み取り・書き込み・Issue作成

📊 統計情報:
- アサイン済みIssue: 5個
- 今日作成されたIssue: 2個
- 今週完了したIssue: 8個
- APIコール制限: 95/1000 (残り905回)

🔧 設定状況:
- ENABLE_BACKGROUND_TASKS: ✅ 有効
- AUTO_CONFIRM_WITH_ARGS: ✅ 有効
- FLUTTER_VERSION_MANAGEMENT: ✅ fvm
- PR_LANGUAGE: ✅ Japanese
```

## トラブルシューティング
問題が検出された場合、以下の解決方法を提案します：

### 接続エラーの場合
```
❌ Linear連携ステータス:
❌ MCP接続: 失敗
💡 解決方法:
1. MCP設定ファイルを確認してください
2. Linear APIキーが正しく設定されているか確認
3. Claude Code を再起動してみてください
```

### 認証エラーの場合
```
❌ 認証: 無効
💡 解決方法:
1. Linear APIキーの有効期限を確認
2. 新しいAPIキーを生成してください
3. MCP設定を更新してください
```

### 権限エラーの場合
```
⚠️ 権限: 読み取りのみ
💡 解決方法:
1. Linear管理者に書き込み権限を依頼
2. Issue作成権限の付与を依頼
3. チームメンバーシップを確認
```

## 詳細診断
追加情報が必要な場合：
```bash
# 詳細な接続診断
/linear-status --verbose

# 特定チームの詳細確認
/linear-status --team frontend

# API制限の詳細確認
/linear-status --api-limits
```

## 自動修復
一部の問題は自動修復を試行します：
- MCP接続の再試行
- 認証トークンの更新確認
- 設定ファイルの検証
- 環境変数の確認

問題解決後、/linear コマンドが正常に動作することを確認してください。