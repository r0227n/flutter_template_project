#!/bin/bash

# manage-flutter-tasks.sh - Flutter特化プロセス管理スクリプト

WORKTREES_DIR="./worktrees"
LOGS_DIR="./logs"
PIDS_DIR="./pids"
SCREENSHOTS_DIR="./screenshots"

# 必要なディレクトリを作成
mkdir -p "$LOGS_DIR" "$PIDS_DIR" "$SCREENSHOTS_DIR"

case "$1" in
    "list")
        echo "🚀 Active Flutter Claude Code processes:"
        echo "========================================"
        for pidfile in "$PIDS_DIR"/claude-flutter-*.pid; do
            if [ -f "$pidfile" ]; then
                ticket_id=$(basename "$pidfile" .pid | sed 's/claude-flutter-//')
                pid=$(cat "$pidfile")
                config_file="$WORKTREES_DIR/feature-$ticket_id/.claude_config.json"
                
                if kill -0 "$pid" 2>/dev/null; then
                    status="🟢 Running"
                    cpu_usage=$(ps -p "$pid" -o pcpu= | tr -d ' ')
                    mem_usage=$(ps -p "$pid" -o pmem= | tr -d ' ')
                else
                    status="🔴 Stopped"
                    cpu_usage="N/A"
                    mem_usage="N/A"
                fi
                
                # 設定情報を読み込み
                workflow="unknown"
                platform="unknown"
                if [ -f "$config_file" ] && command -v jq &> /dev/null; then
                    workflow=$(jq -r '.workflow // "unknown"' "$config_file")
                    platform=$(jq -r '.platform // "unknown"' "$config_file")
                fi
                
                echo "📋 Ticket: $ticket_id | 🔧 Workflow: $workflow | 📱 Platform: $platform"
                echo "   PID: $pid | Status: $status | CPU: ${cpu_usage}% | MEM: ${mem_usage}%"
                echo ""
            fi
        done
        ;;
    
    "stop")
        ticket_id="$2"
        if [ -z "$ticket_id" ]; then
            echo "Usage: $0 stop <TICKET_ID>"
            exit 1
        fi
        
        pidfile="$PIDS_DIR/claude-flutter-${ticket_id}.pid"
        if [ -f "$pidfile" ]; then
            pid=$(cat "$pidfile")
            echo "🛑 Stopping Flutter Claude Code for ticket $ticket_id (PID: $pid)..."
            kill "$pid" 2>/dev/null && echo "✅ Process stopped" || echo "⚠️  Process was not running"
            rm -f "$pidfile"
        else
            echo "❌ No process found for ticket $ticket_id"
        fi
        ;;
    
    "logs")
        ticket_id="$2"
        if [ -z "$ticket_id" ]; then
            echo "Usage: $0 logs <TICKET_ID>"
            exit 1
        fi
        
        logfile="$LOGS_DIR/claude-flutter-${ticket_id}.log"
        if [ -f "$logfile" ]; then
            echo "📄 Showing logs for Flutter ticket $ticket_id..."
            echo "   Press Ctrl+C to exit"
            tail -f "$logfile"
        else
            echo "❌ No log file found for ticket $ticket_id"
        fi
        ;;
    
    "status")
        ticket_id="$2"
        if [ -z "$ticket_id" ]; then
            echo "Usage: $0 status <TICKET_ID>"
            exit 1
        fi
        
        pidfile="$PIDS_DIR/claude-flutter-${ticket_id}.pid"
        worktree_dir="$WORKTREES_DIR/feature-${ticket_id}"
        config_file="$worktree_dir/.claude_config.json"
        
        echo "📊 Flutter Development Status for ticket $ticket_id:"
        echo "=================================================="
        
        # プロセス状況
        if [ -f "$pidfile" ]; then
            pid=$(cat "$pidfile")
            if kill -0 "$pid" 2>/dev/null; then
                echo "🟢 Process: Running (PID: $pid)"
            else
                echo "🔴 Process: Stopped (PID file exists but process is dead)"
            fi
        else
            echo "⚪ Process: Not started"
        fi
        
        # 設定情報
        if [ -f "$config_file" ] && command -v jq &> /dev/null; then
            echo "⚙️  Configuration:"
            echo "   Workflow: $(jq -r '.workflow' "$config_file")"
            echo "   Platform: $(jq -r '.platform' "$config_file")"
            echo "   Flutter Version: $(jq -r '.flutter_version' "$config_file")"
            echo "   Created: $(jq -r '.created_at' "$config_file")"
        fi
        
        # Git状況
        if [ -d "$worktree_dir" ]; then
            cd "$worktree_dir"
            echo "🌿 Git Status:"
            echo "   Branch: $(git branch --show-current)"
            echo "   Commits: $(git rev-list --count HEAD ^main)"
            echo "   Changes: $(git status --porcelain | wc -l) files modified"
            echo "   Last activity: $(git log -1 --format=%cd --date=relative)"
            
            # Flutter固有の状況
            echo "📱 Flutter Status:"
            if [ -f "pubspec.yaml" ]; then
                echo "   Project: $(grep '^name:' pubspec.yaml | cut -d' ' -f2)"
                echo "   SDK Version: $(grep 'flutter:' pubspec.yaml -A 1 | grep 'sdk:' | cut -d'"' -f2 || echo 'Not specified')"
                
                # 依存関係チェック
                if flutter pub deps > /dev/null 2>&1; then
                    echo "   Dependencies: ✅ Resolved"
                else
                    echo "   Dependencies: ❌ Issues found"
                fi
                
                # 分析結果
                analysis_result=$(flutter analyze --no-pub 2>/dev/null | tail -n 1)
                if echo "$analysis_result" | grep -q "No issues found"; then
                    echo "   Analysis: ✅ No issues"
                else
                    issue_count=$(echo "$analysis_result" | grep -o '[0-9]\+ issue' | head -n 1 | cut -d' ' -f1)
                    echo "   Analysis: ⚠️  $issue_count issues found"
                fi
                
                # テスト状況
                if [ -d "test" ]; then
                    test_count=$(find test -name "*.dart" | wc -l)
                    echo "   Tests: $test_count test files"
                else
                    echo "   Tests: No test directory"
                fi
            fi
        else
            echo "❌ Worktree: Not found"
        fi
        ;;
    
    "test")
        ticket_id="$2"
        if [ -z "$ticket_id" ]; then
            echo "Usage: $0 test <TICKET_ID>"
            exit 1
        fi
        
        worktree_dir="$WORKTREES_DIR/feature-${ticket_id}"
        if [ -d "$worktree_dir" ]; then
            cd "$worktree_dir"
            echo "🧪 Running Flutter tests for ticket $ticket_id..."
            echo "=============================================="
            
            # 分析実行
            echo "📊 Running Flutter analyze..."
            flutter analyze
            
            echo ""
            echo "🧪 Running unit tests..."
            flutter test --reporter=compact
            
            echo ""
            echo "📱 Test summary completed for ticket $ticket_id"
        else
            echo "❌ Worktree not found for ticket $ticket_id"
        fi
        ;;
    
    "build")
        ticket_id="$2"
        platform="$3"
        if [ -z "$ticket_id" ]; then
            echo "Usage: $0 build <TICKET_ID> [platform]"
            echo "Platforms: android, ios, web, all"
            exit 1
        fi
        
        worktree_dir="$WORKTREES_DIR/feature-${ticket_id}"
        if [ -d "$worktree_dir" ]; then
            cd "$worktree_dir"
            echo "🔨 Building Flutter app for ticket $ticket_id..."
            
            case "${platform:-all}" in
                android)
                    echo "🤖 Building Android APK..."
                    flutter build apk --debug
                    ;;
                ios)
                    echo "🍎 Building iOS app..."
                    flutter build ios --debug --no-codesign
                    ;;
                web)
                    echo "🌐 Building Web app..."
                    flutter build web
                    ;;
                all)
                    echo "📱 Building for all platforms..."
                    flutter build apk --debug
                    flutter build ios --debug --no-codesign
                    flutter build web
                    ;;
                *)
                    echo "❌ Unknown platform: $platform"
                    echo "Available platforms: android, ios, web, all"
                    exit 1
                    ;;
            esac
            
            echo "✅ Build completed for ticket $ticket_id"
        else
            echo "❌ Worktree not found for ticket $ticket_id"
        fi
        ;;
    
    "screenshot")
        ticket_id="$2"
        if [ -z "$ticket_id" ]; then
            echo "Usage: $0 screenshot <TICKET_ID>"
            exit 1
        fi
        
        worktree_dir="$WORKTREES_DIR/feature-${ticket_id}"
        screenshot_dir="$SCREENSHOTS_DIR/$ticket_id"
        mkdir -p "$screenshot_dir"
        
        if [ -d "$worktree_dir" ]; then
            cd "$worktree_dir"
            echo "📸 Taking screenshots for ticket $ticket_id..."
            
            # 統合テストでスクリーンショット撮影
            if [ -f "integration_test/screenshot_test.dart" ]; then
                flutter test integration_test/screenshot_test.dart
                echo "✅ Screenshots captured via integration test"
            else
                echo "⚠️  No screenshot test found. Creating basic screenshot test..."
                mkdir -p integration_test
                cat > integration_test/screenshot_test.dart << 'EOF'
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:myapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Screenshot Test', () {
    testWidgets('capture main screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      await tester.binding.convertFlutterSurfaceToImage();
      await tester.binding.takeScreenshot('main-screen');
    });
  });
}
EOF
                echo "📄 Created basic screenshot test"
                flutter test integration_test/screenshot_test.dart || echo "⚠️  Screenshot test failed"
            fi
            
            # スクリーンショットファイルを移動
            if [ -d "screenshots" ]; then
                cp -r screenshots/* "$screenshot_dir/" 2>/dev/null || true
                echo "📁 Screenshots copied to: $screenshot_dir"
            fi
            
        else
            echo "❌ Worktree not found for ticket $ticket_id"
        fi
        ;;
    
    "cleanup")
        echo "🧹 Cleaning up stopped Flutter processes..."
        for pidfile in "$PIDS_DIR"/claude-flutter-*.pid; do
            if [ -f "$pidfile" ]; then
                pid=$(cat "$pidfile")
                if ! kill -0 "$pid" 2>/dev/null; then
                    ticket_id=$(basename "$pidfile" .pid | sed 's/claude-flutter-//')
                    echo "🗑️  Removing dead process for ticket $ticket_id"
                    rm -f "$pidfile"
                fi
            fi
        done
        
        # 古いスクリーンショットのクリーンアップ（7日以上古い）
        find "$SCREENSHOTS_DIR" -type d -mtime +7 -exec rm -rf {} + 2>/dev/null || true
        
        echo "✅ Cleanup completed"
        ;;
    
    "restart")
        ticket_id="$2"
        if [ -z "$ticket_id" ]; then
            echo "Usage: $0 restart <TICKET_ID>"
            exit 1
        fi
        
        # 停止
        $0 stop "$ticket_id"
        sleep 2
        
        # 再起動
        worktree_dir="$WORKTREES_DIR/feature-${ticket_id}"
        if [ -d "$worktree_dir" ]; then
            cd "$worktree_dir"
            config_file=".claude_config.json"
            
            # 設定ファイルから情報を読み込み
            if [ -f "$config_file" ] && command -v jq &> /dev/null; then
                workflow=$(jq -r '.workflow' "$config_file")
                platform=$(jq -r '.platform' "$config_file")
                device=$(jq -r '.device // empty' "$config_file")
                
                echo "🔄 Restarting Flutter Claude Code for ticket $ticket_id..."
                echo "   Workflow: $workflow"
                echo "   Platform: $platform"
                
                # Claude Code再起動コマンド構築
                restart_cmd="claude-code --ticket=$ticket_id"
                if [ "$platform" != "null" ] && [ "$platform" != "all" ]; then
                    restart_cmd="$restart_cmd --platform=$platform"
                fi
                if [ ! -z "$device" ] && [ "$device" != "null" ]; then
                    restart_cmd="$restart_cmd --device=$device"
                fi
                
                # Flutter環境再確認
                flutter pub get > /dev/null 2>&1
                
                nohup $restart_cmd > "../logs/claude-flutter-${ticket_id}.log" 2>&1 &
                echo "$!" > "../pids/claude-flutter-${ticket_id}.pid"
                echo "✅ Restarted with PID: $!"
            else
                echo "❌ Cannot read configuration file"
            fi
        else
            echo "❌ Worktree not found for ticket $ticket_id"
        fi
        ;;
    
    "devices")
        echo "📱 Available Flutter devices:"
        echo "============================"
        flutter devices
        echo ""
        echo "💡 Use --device=<device-id> when starting tasks to target specific devices"
        ;;
    
    "doctor")
        echo "🏥 Flutter Doctor Status:"
        echo "========================"
        flutter doctor -v
        ;;
        
    *)
        echo "Flutter Task Manager"
        echo "==================="
        echo "Usage: $0 {command} [options]"
        echo ""
        echo "Commands:"
        echo "  list                    - Show all active Flutter Claude Code processes"
        echo "  stop <TICKET_ID>        - Stop Claude Code for specific ticket"
        echo "  logs <TICKET_ID>        - Show logs for specific ticket"
        echo "  status <TICKET_ID>      - Show detailed status for specific ticket"
        echo "  test <TICKET_ID>        - Run Flutter tests for specific ticket"
        echo "  build <TICKET_ID> [platform] - Build Flutter app (android/ios/web/all)"
        echo "  screenshot <TICKET_ID>  - Take screenshots for specific ticket"
        echo "  cleanup                 - Remove dead process files and old screenshots"
        echo "  restart <TICKET_ID>     - Restart Claude Code for specific ticket"
        echo "  devices                 - Show available Flutter devices"
        echo "  doctor                  - Run flutter doctor for environment check"
        echo ""
        echo "Examples:"
        echo "  $0 list"
        echo "  $0 status ABC-123"
        echo "  $0 test ABC-123"
        echo "  $0 build ABC-123 android"
        echo "  $0 screenshot ABC-123"
        exit 1
        ;;
esac