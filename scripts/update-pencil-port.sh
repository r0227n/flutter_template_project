#!/bin/bash
# Pencil MCP サーバーのポート番号を検出して .mcp.json を更新

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
MCP_JSON="$PROJECT_ROOT/.mcp.json"

# Pencil アプリのメインプロセスを検索
PENCIL_PID=$(pgrep -f "Pencil.app/Contents/MacOS/Pencil" 2>/dev/null | head -1)

if [[ -z "$PENCIL_PID" ]]; then
    echo "[pencil-port] Pencil app is not running, skipping update" >&2
    exit 0
fi

# Pencil アプリがリッスンしている TCP ポートを取得
PORT=$(lsof -Pan -p "$PENCIL_PID" -iTCP -sTCP:LISTEN 2>/dev/null | awk 'NR>1 {print $9}' | grep -oE '[0-9]+$' | head -1)

if [[ -z "$PORT" ]]; then
    echo "[pencil-port] Could not detect Pencil listening port" >&2
    exit 0
fi

# .mcp.json が存在しない場合はスキップ
if [[ ! -f "$MCP_JSON" ]]; then
    echo "[pencil-port] .mcp.json not found, skipping update" >&2
    exit 0
fi

# 現在の設定を確認
CURRENT_PORT=$(jq -r '.mcpServers.pencil.args[1] // empty' "$MCP_JSON" 2>/dev/null)

if [[ "$CURRENT_PORT" == "$PORT" ]]; then
    echo "[pencil-port] Port already up to date: $PORT"
    exit 0
fi

# .mcp.json を更新
jq --arg port "$PORT" '.mcpServers.pencil.args[1] = $port' "$MCP_JSON" > "$MCP_JSON.tmp" && mv "$MCP_JSON.tmp" "$MCP_JSON"

echo "[pencil-port] Updated .mcp.json with port: $PORT"
