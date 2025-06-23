# セットアップガイド - Flutter Template Project

## 前提条件

### 必須ツール

| ツール      | バージョン    | インストール方法                  | 確認コマンド        |
| ----------- | ------------- | --------------------------------- | ------------------- |
| **Flutter** | Latest Stable | FVM管理を推奨                     | `flutter --version` |
| **Dart**    | Flutter付属   | Flutterと一緒にインストール       | `dart --version`    |
| **FVM**     | 3.0+          | `dart pub global activate fvm`    | `fvm --version`     |
| **Node.js** | 18+           | [nodejs.org](https://nodejs.org/) | `node --version`    |
| **Git**     | 2.23+         | システムパッケージマネージャー    | `git --version`     |

### オプションツール

| ツール         | 用途         | インストール方法                             |
| -------------- | ------------ | -------------------------------------------- |
| **Melos**      | モノレポ管理 | `dart pub global activate melos`             |
| **VS Code**    | 推奨IDE      | [公式サイト](https://code.visualstudio.com/) |
| **GitHub CLI** | PR操作       | [gh-cli](https://cli.github.com/)            |

## 初回セットアップ

### 1. プロジェクトクローン

```bash
# HTTPSでクローン
git clone https://github.com/your-org/flutter_template_project.git
cd flutter_template_project

# または SSH
git clone git@github.com:your-org/flutter_template_project.git
cd flutter_template_project
```

### 2. Flutter環境構築

```bash
# FVMでFlutterバージョン管理
fvm install    # .fvmrc のバージョンをインストール
fvm use        # プロジェクト用Flutterバージョンを設定

# グローバル設定（任意）
fvm global stable  # または fvm global $(cat .fvmrc)
```

### 3. 依存関係インストール

```bash
# Node.js 依存関係（commitlint, prettier等）
npm install

# Dart/Flutter 依存関係（全パッケージ）
melos bootstrap

# または手動で各パッケージ
fvm flutter pub get  # ルートディレクトリ
cd app && fvm flutter pub get  # メインアプリ
```

### 4. コード生成実行

```bash
# 全パッケージのコード生成
melos run gen

# または個別実行
cd app && fvm flutter packages pub run build_runner build
```

### 5. 動作確認

```bash
# 静的解析
melos run analyze

# テスト実行
melos run test

# アプリ起動（デバイス/エミュレータが必要）
cd app && fvm flutter run
```

## 開発環境設定

### VS Code 拡張機能

必須拡張機能を`.vscode/extensions.json`で管理：

```json
{
  "recommendations": [
    "dart-code.dart-code",
    "dart-code.flutter",
    "ms-vscode.vscode-json",
    "redhat.vscode-yaml",
    "github.copilot"
  ]
}
```

### Git設定

```bash
# Conventional Commits用フック設定
npm run prepare

# Git設定確認
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### IDE設定

VS Code設定（`.vscode/settings.json`）:

```json
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk",
  "search.exclude": {
    "**/.fvm": true
  },
  "files.watcherExclude": {
    "**/.fvm": true
  }
}
```

## Claude Code設定（AI支援開発）

### 1. Claude Code インストール

```bash
# Claude Code CLI インストール
curl -fsSL https://claude.ai/install.sh | sh

# または npm
npm install -g @anthropic/claude-code
```

### 2. Linear統合設定

```bash
# Claude設定ディレクトリ
claude config

# Linear APIキー設定（Linear設定画面から取得）
claude config set LINEAR_API_KEY your_api_key_here
```

### 3. 環境変数設定

```bash
# .env ファイル作成（.env.example をコピー）
cp .env.example .env

# 必要な環境変数を設定
export ENABLE_BACKGROUND_TASKS=true
export FLUTTER_VERSION_MANAGEMENT=fvm
export TASK_MANAGEMENT_SYSTEM=linear
export PARALLEL_DEVELOPMENT=git_worktree
```

### 4. 動作確認

```bash
# Claude Code起動
claude

# テストコマンド実行
/linear --help
```

## トラブルシューティング

### Flutter環境関連

#### FVMが動作しない

```bash
# PATH設定確認
echo $PATH | grep -o '[^:]*fvm[^:]*'

# PATHに追加（bash/zsh）
echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> ~/.bashrc
source ~/.bashrc
```

#### Flutter依存関係エラー

```bash
# キャッシュクリア
fvm flutter clean
fvm flutter pub get

# 全パッケージクリア
melos clean
melos bootstrap
```

### コード生成エラー

#### build_runner実行失敗

```bash
# 生成済みファイル削除後再実行
find . -name "*.g.dart" -delete
find . -name "*.freezed.dart" -delete
melos run gen
```

#### slang生成エラー

```bash
# 翻訳ファイル構文チェック
cd app/assets/i18n
cat ja.i18n.json | jq .  # JSON構文確認
```

### Git Worktree問題

#### Worktree作成失敗

```bash
# 既存worktree確認・削除
git worktree list
git worktree remove path/to/worktree

# ブランチ削除
git branch -D branch-name
```

### Claude Code接続問題

#### Linear API接続エラー

```bash
# API key確認
claude config get LINEAR_API_KEY

# 手動API接続テスト
curl -H "Authorization: Bearer $LINEAR_API_KEY" \
     https://api.linear.app/graphql
```

## 開発フロー確認

すべてのセットアップが完了したら、以下で開発フローを確認：

```bash
# 1. 新機能開発開始
claude
/linear ABC-123  # 実際のIssue IDを指定

# 2. 並行開発テスト
/linear ABC-123 XYZ-456  # 複数Issue同時実行

# 3. 手動開発フロー
git worktree add feature/manual-test -b feature/manual-test
cd feature/manual-test
# 開発・テスト・コミット
git push -u origin feature/manual-test
```

## セットアップ完了チェックリスト

- [ ] Flutter環境（FVM管理）
- [ ] 依存関係インストール（Node.js + Dart）
- [ ] コード生成実行（エラーなし）
- [ ] VS Code拡張機能インストール
- [ ] Git hooks設定（commitlint）
- [ ] Claude Code & Linear統合
- [ ] 環境変数設定
- [ ] テストアプリ起動成功
- [ ] 全品質チェック通過（analyze, test, format）

すべてチェックが完了したら、開発開始の準備完了です！
