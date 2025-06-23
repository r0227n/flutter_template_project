# /memo Command Implementation

Claude Code スラッシュコマンド: セッション内メモ記録機能

## Overview

セッション内容を日本語で時系列順に記録し、Markdownファイルとして保存する機能。

## Usage

```bash
/memo
```

## Implementation

### Basic Functionality

- セッション内容の自動解析
- 日時ベースのファイル命名
- Markdownファイル生成
- 同一セッション内での追記対応

### File Format

- ファイル名: `YYYY-MM-DD_HH-mm-ss_memo.md`
- 保存場所: `memos/` ディレクトリ
- エンコーディング: UTF-8

### Content Structure

```markdown
# セッション記録 - YYYY/MM/DD HH:mm:ss

## 概要
[セッション内容の要約]

## 主要な決定事項
- 決定1
- 決定2

## 技術的な気づき
- 気づき1
- 気づき2

## 問題解決プロセス
1. 問題の特定
2. 解決方法の検討
3. 実装
4. 検証

## 次のアクション
- TODO1
- TODO2
```

### Security Considerations

- ファイルパス検証
- ディレクトリトラバーサル防止
- 機密情報フィルタリング
- 入力値サニタイゼーション