# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

Melos モノレポ構成の Flutter テンプレートプロジェクト。Riverpod + go_router + Slang (i18n) + DuckDB をコアスタックとする。

## ワークスペース構成

```
workspace (root pubspec.yaml)
├── app/              # メインFlutterアプリ（エントリーポイント）
├── packages/core/    # ロギング(Talker)、設定(SharedPreferences)、多言語基盤(Slang)
├── packages/database/ # DuckDB データ永続化、Todo/Category CRUD
└── packages/design_system/ # テーマ・デザイントークン
```

依存方向: `app` → `packages/*` の一方向のみ。core と database 間に依存関係なし。
各パッケージは `resolution: workspace` でワークスペース統一解決。

## アーキテクチャ

### app のレイヤー構成
```
app/lib/
├── main.dart           # エントリーポイント、Riverpod ProviderScope 初期化
├── router/             # go_router 設定（go_router_builder でコード生成）
├── presentation/       # 画面(pages)、状態管理(notifiers)、Provider(providers)
├── domain/             # ビジネスロジック
├── data/               # データ層
├── core/               # アプリ固有の共通コード、定数、Widget、拡張メソッド、生成コード(gen/)
└── platform/           # プラットフォーム固有コード
```

## Git Usage

- 「worktree」は `git worktree` を指す
- Worktree 操作には [git gtr](https://github.com/coderabbitai/git-worktree-runner) を使用する
- The `git -C` option is not prohibited, but avoid using it whenever possible
- Instead, operate in the current directory or use `cd` to navigate before running commands

## Subagent Configuration

- When launching subagents via the Task tool, always set `run_in_background: true` to run them in the background by default
- Use TaskOutput to retrieve results when needed

