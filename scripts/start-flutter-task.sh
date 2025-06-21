#!/bin/bash

# start-flutter-task.sh - Flutter Template Project 特化タスク起動スクリプト

# set -e removed to prevent premature exits

# パラメータ解析
TICKET_ID=""
WORKFLOW="flutter-feature"
BACKGROUND=true
PLATFORM="all"
DEVICE=""

# プロジェクト設定
PROJECT_NAME="Flutter Template Project"
FLUTTER_APP_DIR="apps"

while [[ $# -gt 0 ]]; do
    case $1 in
        --ticket=*)
            TICKET_ID="${1#*=}"
            shift
            ;;
        --workflow=*)
            WORKFLOW="${1#*=}"
            shift
            ;;
        --platform=*)
            PLATFORM="${1#*=}"
            shift
            ;;
        --device=*)
            DEVICE="${1#*=}"
            shift
            ;;
        --foreground)
            BACKGROUND=false
            shift
            ;;
        *)
            if [ -z "$TICKET_ID" ]; then
                TICKET_ID="$1"
            fi
            shift
            ;;
    esac
done

if [ -z "$TICKET_ID" ]; then
    echo "Usage: $0 --ticket=<TICKET_ID> [--workflow=<WORKFLOW>] [--platform=<PLATFORM>] [--foreground]"
    echo "Example: $0 --ticket=ABC-123 --workflow=flutter-feature --platform=android"
    echo ""
    echo "Available workflows:"
    echo "  flutter-feature     - New feature development"
    echo "  flutter-ui          - UI/UX improvements"
    echo "  flutter-bugfix      - Bug fixes"
    echo "  flutter-performance - Performance optimization"
    echo "  flutter-widget      - Widget development"
    echo ""
    echo "Available platforms: ios, android, web, all"
    exit 1
fi

# 設定
WORKTREES_DIR="./worktrees"
LOGS_DIR="./logs"
PIDS_DIR="./pids"
CLAUDE_DIR=".claude"

# 必要なディレクトリを作成
mkdir -p "$WORKTREES_DIR" "$LOGS_DIR" "$PIDS_DIR" "$CLAUDE_DIR/workflows" "$CLAUDE_DIR/prompts"

echo "🚀 Starting Flutter task for ticket: $TICKET_ID"
echo "📋 Workflow: $WORKFLOW"
echo "📱 Platform: $PLATFORM"

# Flutter環境確認
echo "🔍 Checking Flutter environment..."
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    exit 1
fi

# appsディレクトリの存在確認
if [ ! -d "$FLUTTER_APP_DIR" ]; then
    echo "❌ Flutter app directory not found: $FLUTTER_APP_DIR"
    exit 1
fi

FLUTTER_VERSION=$(flutter --version | head -n 1)
echo "✅ $FLUTTER_VERSION"

# Flutter Doctor確認（警告は無視）
echo "🔧 Running flutter doctor..."
flutter doctor > /dev/null 2>&1 || echo "⚠️  Flutter doctor has some issues, but continuing..."

# ブランチ名とディレクトリ名を生成
BRANCH_PREFIX="feature"
case $WORKFLOW in
    flutter-ui)
        BRANCH_PREFIX="ui"
        ;;
    flutter-bugfix)
        BRANCH_PREFIX="bugfix"
        ;;
    flutter-performance)
        BRANCH_PREFIX="perf"
        ;;
    flutter-widget)
        BRANCH_PREFIX="widget"
        ;;
esac

BRANCH_NAME="${BRANCH_PREFIX}-${TICKET_ID}"
WORKTREE_DIR="${WORKTREES_DIR}/${BRANCH_NAME}"

# 既存のworktreeをチェック
if [ -d "$WORKTREE_DIR" ]; then
    echo "⚠️  Worktree already exists at $WORKTREE_DIR"
    echo "✅ Continuing with existing worktree..."
else
    # 新しいworktreeを作成
    echo "📁 Creating worktree: $WORKTREE_DIR"
    git worktree add -b "$BRANCH_NAME" "$WORKTREE_DIR" main
fi

# Flutter固有の設定ファイルを作成
cat > "$WORKTREE_DIR/.claude_config.json" << EOF
{
  "project_name": "$PROJECT_NAME",
  "flutter_app_dir": "$FLUTTER_APP_DIR",
  "ticket_id": "$TICKET_ID",
  "workflow": "$WORKFLOW",
  "branch_name": "$BRANCH_NAME",
  "worktree_path": "$WORKTREE_DIR",
  "platform": "$PLATFORM",
  "device": "$DEVICE",
  "flutter_version": "$(flutter --version | head -n 1 | cut -d' ' -f2)",
  "created_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "project_root": "$(pwd)",
  "state_management": "riverpod",
  "i18n_system": "slang",
  "navigation": "go_router"
}
EOF

# ワークフロー固有のCLAUDE.mdをworktreeにコピー
if [ -f "$CLAUDE_DIR/workflows/${WORKFLOW}.md" ]; then
    cp "$CLAUDE_DIR/workflows/${WORKFLOW}.md" "$WORKTREE_DIR/CLAUDE.md"
    echo "📄 Copied workflow: $WORKFLOW.md → CLAUDE.md"
else
    echo "⚠️  Workflow file not found: $CLAUDE_DIR/workflows/${WORKFLOW}.md"
    echo "📄 Using default CLAUDE.md"
    cp "CLAUDE.md" "$WORKTREE_DIR/CLAUDE.md" 2>/dev/null || echo "❌ No default CLAUDE.md found"
fi

# Flutter固有コンテキストを追加
if [ -f "$CLAUDE_DIR/prompts/context.md" ]; then
    echo "" >> "$WORKTREE_DIR/CLAUDE.md"
    echo "---" >> "$WORKTREE_DIR/CLAUDE.md"
    echo "" >> "$WORKTREE_DIR/CLAUDE.md"
    cat "$CLAUDE_DIR/prompts/context.md" >> "$WORKTREE_DIR/CLAUDE.md"
    echo "📄 Added Flutter context from: $CLAUDE_DIR/prompts/context.md"
fi

# プラットフォーム固有の情報を追加
echo "" >> "$WORKTREE_DIR/CLAUDE.md"
echo "## 現在のタスク情報" >> "$WORKTREE_DIR/CLAUDE.md"
echo "" >> "$WORKTREE_DIR/CLAUDE.md"
echo "- **チケットID**: $TICKET_ID" >> "$WORKTREE_DIR/CLAUDE.md"
echo "- **ワークフロー**: $WORKFLOW" >> "$WORKTREE_DIR/CLAUDE.md"
echo "- **対象プラットフォーム**: $PLATFORM" >> "$WORKTREE_DIR/CLAUDE.md"
if [ ! -z "$DEVICE" ]; then
    echo "- **対象デバイス**: $DEVICE" >> "$WORKTREE_DIR/CLAUDE.md"
fi
echo "- **作業ブランチ**: $BRANCH_NAME" >> "$WORKTREE_DIR/CLAUDE.md"
echo "- **Flutter Version**: $(flutter --version | head -n 1)" >> "$WORKTREE_DIR/CLAUDE.md"

echo "🔍 Debug: Attempting to cd to: $WORKTREE_DIR"
ls -la "$WORKTREE_DIR" && echo "✅ Directory exists" || echo "❌ Directory not found"
if ! cd "$WORKTREE_DIR"; then
    echo "❌ Failed to change directory to $WORKTREE_DIR"
    echo "Current directory: $(pwd)"
    echo "Target directory: $WORKTREE_DIR"
    ls -la "$WORKTREES_DIR" 2>/dev/null || echo "Worktrees directory doesn't exist"
    echo "⚠️  Continuing without changing directory..."
fi

# 初期Flutter環境セットアップ
echo "📦 Setting up Flutter environment..."
if ! cd "$FLUTTER_APP_DIR"; then
    echo "❌ Failed to change directory to $FLUTTER_APP_DIR"
    echo "⚠️  Skipping Flutter setup..."
else
echo "📦 Running flutter pub get..."
if ! flutter pub get; then
    echo "❌ Flutter pub get failed, but continuing..."
fi

# コード生成の実行
echo "🔧 Running code generation..."
echo "🔧 Running build_runner..."
if ! flutter pub run build_runner build --delete-conflicting-outputs; then
    echo "⚠️  Code generation skipped (no generated files yet)"
fi

# 国際化ファイル生成
echo "🌐 Generating i18n files..."
echo "🌐 Running slang build..."
if ! dart run slang build; then
    echo "⚠️  i18n generation skipped"
fi
fi

if ! cd "$WORKTREE_DIR"; then
    echo "❌ Failed to change directory to $WORKTREE_DIR"
    echo "⚠️  Continuing from current directory..."
fi

# プラットフォーム固有の準備
case $PLATFORM in
    ios)
        echo "🍎 Preparing iOS environment..."
        if [ -d "$FLUTTER_APP_DIR/ios" ]; then
            echo "🍎 Installing iOS pods..."
            cd "$FLUTTER_APP_DIR/ios" && pod install && cd "$WORKTREE_DIR" || echo "⚠️  Pod install failed"
        fi
        ;;
    android)
        echo "🤖 Preparing Android environment..."
        # Android固有の準備があれば追加
        ;;
    web)
        echo "🌐 Preparing Web environment..."
        echo "🌐 Enabling web support..."
        flutter config --enable-web || echo "⚠️  Web config failed"
        ;;
    all)
        echo "📱 Preparing all platforms..."
        if [ -d "$FLUTTER_APP_DIR/ios" ]; then
            echo "🍎 Installing iOS pods..."
            cd "$FLUTTER_APP_DIR/ios" && pod install && cd "$WORKTREE_DIR" || echo "⚠️  Pod install failed"
        fi
        echo "🌐 Enabling web support..."
        flutter config --enable-web || echo "⚠️  Web config failed"
        ;;
esac

# Claude Code起動コマンドを構築
CLAUDE_CMD="claude-code --ticket=$TICKET_ID"

# プラットフォーム固有パラメータ追加
if [ "$PLATFORM" != "all" ]; then
    CLAUDE_CMD="$CLAUDE_CMD --platform=$PLATFORM"
fi

if [ ! -z "$DEVICE" ]; then
    CLAUDE_CMD="$CLAUDE_CMD --device=$DEVICE"
fi

# 設定ファイルから追加パラメータを読み込み
CONFIG_FILE="$CLAUDE_DIR/config.json"
if [ -f "$CONFIG_FILE" ]; then
    echo "⚙️  Loading Flutter project config: $CONFIG_FILE"
    if command -v jq &> /dev/null; then
        MAX_TIME=$(jq -r '.execution.maxExecutionTime // 300' "$CONFIG_FILE")
        if [ "$MAX_TIME" != "null" ] && [ "$MAX_TIME" != "300" ]; then
            CLAUDE_CMD="$CLAUDE_CMD --max-time=$MAX_TIME"
        fi
    fi
fi

echo "🤖 Starting Claude Code for Flutter development..."
echo "📂 Working directory: $WORKTREE_DIR"
echo "🔧 Command: $CLAUDE_CMD"

if [ "$BACKGROUND" = true ]; then
    # バックグラウンドで実行
    nohup $CLAUDE_CMD > "../logs/claude-flutter-${TICKET_ID}.log" 2>&1 &
    CLAUDE_PID=$!
    
    echo "✅ Claude Code started in background"
    echo "🆔 PID: $CLAUDE_PID"
    echo "📄 Log: ../logs/claude-flutter-${TICKET_ID}.log"
    
    # PIDを保存
    echo "$CLAUDE_PID" > "../pids/claude-flutter-${TICKET_ID}.pid"
    
    echo ""
    echo "Monitor progress:"
    echo "  tail -f logs/claude-flutter-${TICKET_ID}.log"
    echo ""
    echo "Flutter specific monitoring:"
    echo "  flutter logs (if device connected)"
    echo "  flutter analyze"
    echo "  flutter test"
    echo ""
    echo "Manage task:"
    echo "  ./scripts/manage-flutter-tasks.sh status $TICKET_ID"
    echo "  ./scripts/manage-flutter-tasks.sh stop $TICKET_ID"
    echo "  ./scripts/manage-flutter-tasks.sh screenshot $TICKET_ID"
else
    # フォアグラウンドで実行
    echo "🎯 Running in foreground mode..."
    echo "💡 Tip: Use 'flutter logs' in another terminal to monitor device logs"
    echo "▶️  Executing: $CLAUDE_CMD"
    $CLAUDE_CMD
fi

echo ""
echo "🎉 Flutter task setup completed for ticket: $TICKET_ID"
echo "🔥 Happy Flutter development! 🚀"