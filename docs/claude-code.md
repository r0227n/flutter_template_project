# Claude Code タスク実行ガイド - Flutter Template Project

## 概要

このドキュメントでは、Claude CodeとLinearを連携したFlutterテンプレートプロジェクトの並行開発システムの使用方法について説明します。Git worktreeを活用して複数のタスクを同時に開発し、Claude Codeが各タスクを自律的に実行する仕組みです。

## プロジェクト情報

- **アプリ名**: apps
- **プロジェクトタイプ**: Flutter Template Project
- **状態管理**: Riverpod + Hooks
- **国際化**: Slang（英語・日本語対応）
- **ナビゲーション**: GoRouter
- **対応プラットフォーム**: iOS, Android, Web, macOS, Linux, Windows

## 目次

1. [システム構成](#システム構成)
2. [事前準備](#事前準備)
3. [プロジェクト初期セットアップ](#プロジェクト初期セットアップ)
4. [タスクの開始方法](#タスクの開始方法)
5. [タスクの監視と管理](#タスクの監視と管理)
6. [ワークフローの種類](#ワークフローの種類)
7. [トラブルシューティング](#トラブルシューティング)
8. [ベストプラクティス](#ベストプラクティス)

## システム構成

### アーキテクチャ概要

```bash
flutter_template_project/
├── CLAUDE.md                    # メインワークフロー定義
├── apps/                        # Flutterアプリケーション
│   ├── lib/
│   │   ├── main.dart           # アプリエントリーポイント
│   │   └── i18n/               # 国際化ファイル
│   │       ├── en.i18n.json    # 英語
│   │       └── ja.i18n.json    # 日本語
│   ├── test/                   # ユニットテスト
│   ├── pubspec.yaml            # 依存関係設定
│   └── analysis_options.yaml   # Lint設定
├── .claude/
│   ├── workflows/              # タスクタイプ別ワークフロー
│   ├── prompts/               # 共通プロンプト・コンテキスト
│   └── config.json            # プロジェクト設定
├── worktrees/                 # Git worktree（並行開発用）
├── logs/                      # Claude Code実行ログ
├── pids/                      # プロセス管理用PIDファイル
├── screenshots/               # UIスクリーンショット
└── scripts/                   # 自動化スクリプト
    ├── start-flutter-task.sh  # タスク開始スクリプト
    └── manage-flutter-tasks.sh # タスク管理スクリプト
```

### 主要コンポーネント

- **Claude Code**: AI駆動の自動開発エージェント
- **Linear**: タスク・チケット管理システム
- **Git Worktree**: 並行開発のための独立作業ディレクトリ
- **MCP (Model Context Protocol)**: LinearとClaude Codeの連携インターフェース

## 事前準備

### 必要な環境

#### Flutter開発環境

```bash
# Flutter SDKの確認
flutter --version
# 推奨: Flutter 3.8.1以上

# プロジェクトディレクトリに移動
cd apps

# 依存関係のインストール
flutter pub get

# 開発環境の健全性確認
flutter doctor -v

# コード生成
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 必要なツール

- **Git**: バージョン管理
- **jq**: JSON処理（設定ファイル読み込み用）
- **Linear API Key**: チケット情報取得用
- **Claude Code**: AIエージェント

#### MCPサーバーのセットアップ

```bash
# Linear MCPサーバーのインストール
npm install @modelcontextprotocol/server-linear

# 環境変数の設定
export LINEAR_API_KEY="your_linear_api_key_here"

# MCP設定ファイルの作成
cat > .mcprc << EOF
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-linear"],
      "env": {
        "LINEAR_API_KEY": "${LINEAR_API_KEY}"
      }
    }
  }
}
EOF
```

## プロジェクト初期セットアップ

### 1. ディレクトリ構造の作成

```bash
# 必要なディレクトリを作成
mkdir -p .claude/{workflows,prompts}
mkdir -p {worktrees,logs,pids,screenshots,scripts}

# スクリプトファイルの配置と権限設定
chmod +x scripts/start-flutter-task.sh
chmod +x scripts/manage-flutter-tasks.sh
```

### 2. 設定ファイルの配置

#### `.claude/config.json`

```json
{
  "project": {
    "name": "YourFlutterApp",
    "type": "flutter",
    "platforms": ["ios", "android", "web"]
  },
  "workflows": {
    "default": "flutter-feature",
    "available": [
      "flutter-feature",
      "flutter-ui",
      "flutter-bugfix",
      "flutter-performance"
    ]
  },
  "execution": {
    "maxExecutionTime": 300,
    "progressReportInterval": 30,
    "autoCreatePR": true,
    "screenshotOnProgress": true
  },
  "flutter": {
    "sdkVersion": "3.16.0",
    "targetPlatforms": ["ios", "android", "web"],
    "testCommand": "flutter test",
    "analyzeCommand": "flutter analyze"
  },
  "quality": {
    "requiredCoverage": 80,
    "performanceTarget": 60,
    "accessibilityRequired": true
  }
}
```

### 3. ワークフローファイルの配置

- `CLAUDE.md`: メインワークフロー定義
- `.claude/workflows/flutter-feature.md`: 機能開発用ワークフロー
- `.claude/workflows/flutter-ui.md`: UI改善用ワークフロー
- `.claude/workflows/flutter-bugfix.md`: バグ修正用ワークフロー
- `.claude/prompts/context.md`: Flutter共通コンテキスト

## タスクの開始方法

### 基本的な使用方法

#### 新機能開発の開始

```bash
# 基本形式
./scripts/start-flutter-task.sh --ticket=FEAT-123

# Android向け機能開発
./scripts/start-flutter-task.sh --ticket=FEAT-123 --platform=android

# 特定のワークフローを指定
./scripts/start-flutter-task.sh --ticket=FEAT-123 --workflow=flutter-feature

# 特定デバイスを指定
./scripts/start-flutter-task.sh --ticket=FEAT-123 --device="iPhone 15 Pro"
```

#### コマンドオプション

| オプション     | 説明                       | 例                      |
| -------------- | -------------------------- | ----------------------- |
| `--ticket`     | Linearチケット番号（必須） | `--ticket=FEAT-123`     |
| `--workflow`   | 使用するワークフロー       | `--workflow=flutter-ui` |
| `--platform`   | 対象プラットフォーム       | `--platform=android`    |
| `--device`     | 対象デバイス               | `--device="Pixel 7"`    |
| `--foreground` | フォアグラウンド実行       | `--foreground`          |

### 実行例

#### UI改善タスク

```bash
./scripts/start-flutter-task.sh \
  --ticket=UI-456 \
  --workflow=flutter-ui \
  --platform=all
```

#### バグ修正タスク

```bash
./scripts/start-flutter-task.sh \
  --ticket=BUG-789 \
  --workflow=flutter-bugfix \
  --platform=android
```

#### パフォーマンス改善

```bash
./scripts/start-flutter-task.sh \
  --ticket=PERF-101 \
  --workflow=flutter-performance \
  --device="iPhone 15 Pro"
```

### 実行後の確認

タスク開始後、以下の情報が表示されます：

```
🚀 Starting Flutter task for ticket: FEAT-123
📋 Workflow: flutter-feature
📱 Platform: android
✅ Claude Code started in background
🆔 PID: 12345
📄 Log: logs/claude-flutter-FEAT-123.log

Monitor progress:
  tail -f logs/claude-flutter-FEAT-123.log

Manage task:
  ./scripts/manage-flutter-tasks.sh status FEAT-123
```

## タスクの監視と管理

### 進行中タスクの確認

#### 全タスクの一覧表示

```bash
./scripts/manage-flutter-tasks.sh list
```

出力例：

```
🚀 Active Flutter Claude Code processes:
========================================
📋 Ticket: FEAT-123 | 🔧 Workflow: flutter-feature | 📱 Platform: android
   PID: 12345 | Status: 🟢 Running | CPU: 15.2% | MEM: 8.1%

📋 Ticket: UI-456 | 🔧 Workflow: flutter-ui | 📱 Platform: all
   PID: 12346 | Status: 🟢 Running | CPU: 8.7% | MEM: 5.3%
```

#### 特定タスクの詳細状況

```bash
./scripts/manage-flutter-tasks.sh status FEAT-123
```

出力例：

```
📊 Flutter Development Status for ticket FEAT-123:
==================================================
🟢 Process: Running (PID: 12345)
⚙️  Configuration:
   Workflow: flutter-feature
   Platform: android
   Flutter Version: 3.16.0
   Created: 2025-06-21T10:30:00Z
🌿 Git Status:
   Branch: feature-FEAT-123
   Commits: 3
   Changes: 5 files modified
   Last activity: 2 minutes ago
📱 Flutter Status:
   Project: my_flutter_app
   Dependencies: ✅ Resolved
   Analysis: ✅ No issues
   Tests: 12 test files
```

### ログの監視

#### リアルタイムログ監視

```bash
./scripts/manage-flutter-tasks.sh logs FEAT-123
```

#### ログファイルの直接確認

```bash
tail -f logs/claude-flutter-FEAT-123.log
```

### テストとビルド

#### テスト実行

```bash
# 特定チケットのテスト実行
./scripts/manage-flutter-tasks.sh test FEAT-123
```

#### ビルド実行

```bash
# Android APKビルド
./scripts/manage-flutter-tasks.sh build FEAT-123 android

# iOS アプリビルド
./scripts/manage-flutter-tasks.sh build FEAT-123 ios

# 全プラットフォームビルド
./scripts/manage-flutter-tasks.sh build FEAT-123 all
```

#### スクリーンショット撮影

```bash
./scripts/manage-flutter-tasks.sh screenshot FEAT-123
```

### タスクの制御

#### タスクの停止

```bash
./scripts/manage-flutter-tasks.sh stop FEAT-123
```

#### タスクの再起動

```bash
./scripts/manage-flutter-tasks.sh restart FEAT-123
```

#### 環境確認

```bash
# Flutter環境の確認
./scripts/manage-flutter-tasks.sh doctor

# 利用可能デバイスの確認
./scripts/manage-flutter-tasks.sh devices
```

#### クリーンアップ

```bash
# 停止済みプロセスと古いファイルの削除
./scripts/manage-flutter-tasks.sh cleanup
```

## ワークフローの種類

### 1. flutter-feature（機能開発）

新機能の実装を行うワークフローです。

**適用ケース:**

- 新しい画面・機能の追加
- 新しいWidgetの実装
- API連携の実装

**実行フロー:**

1. 環境確認（5分）
2. チケット情報収集（10分）
3. コードベース調査（15分）
4. 実装計画立案（15分）
5. 実装実行（90-150分）
6. 品質確認（25分）
7. PR作成（20分）

### 2. flutter-ui（UI改善）

既存UIの改善・調整を行うワークフローです。

**適用ケース:**

- デザインの更新
- レスポンシブ対応
- アクセシビリティ改善
- アニメーション追加

### 3. flutter-bugfix（バグ修正）

バグの特定と修正を行うワークフローです。

**適用ケース:**

- 機能不具合の修正
- UIの表示問題
- パフォーマンス問題
- クラッシュの修正

### 4. flutter-performance（パフォーマンス最適化）

アプリのパフォーマンス改善を行うワークフローです。

**適用ケース:**

- 60fps維持の最適化
- メモリ使用量削減
- 起動時間短縮
- Widget再構築最適化

## トラブルシューティング

### よくある問題と解決方法

#### 1. Flutter環境の問題

**問題:** `flutter doctor`でエラーが表示される

```bash
# 解決方法
flutter doctor -v  # 詳細エラーを確認
flutter clean      # キャッシュクリア
flutter pub get    # 依存関係再取得
```

#### 2. Git Worktreeの競合

**問題:** ブランチやworktreeで競合が発生

```bash
# 解決方法
git fetch origin main
cd worktrees/feature-FEAT-123
git rebase main
```

#### 3. Claude Codeプロセスの停止

**問題:** タスクが予期せず停止している

```bash
# 状況確認
./scripts/manage-flutter-tasks.sh status FEAT-123

# ログ確認
./scripts/manage-flutter-tasks.sh logs FEAT-123

# 再起動
./scripts/manage-flutter-tasks.sh restart FEAT-123
```

#### 4. 依存関係の問題

**問題:** `flutter pub get`が失敗する

```bash
# 解決方法
cd worktrees/feature-FEAT-123
flutter clean
rm -rf .dart_tool/
flutter pub get
```

#### 5. ビルドエラー

**問題:** プラットフォーム固有のビルドが失敗する

**Android:**

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter build apk --debug
```

**iOS:**

```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter build ios --debug --no-codesign
```

### デバッグ方法

#### 詳細ログの確認

```bash
# Claude Codeの実行ログ
tail -f logs/claude-flutter-FEAT-123.log

# Flutter固有のログ
cd worktrees/feature-FEAT-123
flutter logs
```

#### 手動でのステップ実行

```bash
# フォアグラウンドでの実行（デバッグ用）
./scripts/start-flutter-task.sh --ticket=FEAT-123 --foreground
```

#### 環境の再確認

```bash
# Flutter環境の詳細確認
./scripts/manage-flutter-tasks.sh doctor

# 利用可能デバイスの確認
./scripts/manage-flutter-tasks.sh devices
```

## ベストプラクティス

### 1. タスク管理

#### チケット命名規則

- **機能開発**: `FEAT-XXX`
- **UI改善**: `UI-XXX`
- **バグ修正**: `BUG-XXX`
- **パフォーマンス**: `PERF-XXX`

#### 並行実行の制限

```bash
# 同時実行数の確認
./scripts/manage-flutter-tasks.sh list | grep "Running" | wc -l

# 推奨：CPUコア数以下の並行実行
```

### 2. 品質管理

#### 定期的な確認

```bash
# 1時間ごとの進捗確認
./scripts/manage-flutter-tasks.sh list

# テスト状況の確認
./scripts/manage-flutter-tasks.sh test FEAT-123
```

#### コード品質の維持

- 自動テストの実行確認
- Flutter Analyzeの通過確認
- スクリーンショットでのUI確認

### 3. リソース管理

#### メモリとCPU使用量の監視

```bash
# システムリソースの確認
top -p $(cat pids/claude-flutter-*.pid | tr '\n' ',' | sed 's/,$//')
```

#### ディスク容量の管理

```bash
# 定期的なクリーンアップ
./scripts/manage-flutter-tasks.sh cleanup

# 古いworktreeの削除
git worktree prune
```

### 4. セキュリティ

#### 機密情報の管理

- API Keyは環境変数で管理
- `.gitignore`に機密ファイルを追加
- ログファイルの機密情報フィルタリング

#### アクセス制御

- Linear API Keyの適切な権限設定
- GitHub Access Tokenの最小権限付与

### 5. チーム協業

#### コミュニケーション

- 進捗はLinearで自動報告
- 問題発生時はSlack通知設定
- PR作成時のレビュー依頼自動化

#### ドキュメント管理

- ワークフローの定期的な更新
- 設定ファイルの変更履歴管理
- トラブルシューティング情報の蓄積

---

## 付録

### A. コマンドリファレンス

#### タスク開始コマンド

```bash
./scripts/start-flutter-task.sh [OPTIONS] TICKET_ID
```

#### タスク管理コマンド

```bash
./scripts/manage-flutter-tasks.sh {list|stop|logs|status|test|build|screenshot|cleanup|restart|devices|doctor} [TICKET_ID] [PLATFORM]
```

### B. 設定ファイル例

完全な設定ファイルの例は、`.claude/config.json`を参照してください。

### C. トラブルシューティングチェックリスト

- [ ] Flutter SDKのバージョン確認
- [ ] 依存関係の解決状況確認
- [ ] Git状態の確認
- [ ] プロセス実行状況の確認
- [ ] ログファイルのエラー確認
- [ ] ディスク容量の確認
- [ ] ネットワーク接続の確認

このガイドを参考に、効率的なFlutter並行開発環境を構築・運用してください。
