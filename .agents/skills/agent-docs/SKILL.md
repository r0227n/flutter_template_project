---
name: agent-docs
description: このテンプレートのAGENTS.md・project skill・開発手順を整備する。Agent向け指示やスキルの作成・整理を依頼されたときに使う。
---

# Agent 向け文書の整備

[管理方針](../../../docs/agent-skills.md) と対象文書を読む。
共通の設計規約は `AGENTS.md` と `docs/ARCHITECTURE.md`、手順は各 skill、
SDK・依存・コマンドは `.mise.toml` と `pubspec.yaml` を正にし、同じ規則を複製しない。

skill は実際の依頼例から用途を決め、description で発動条件、本文で必要な判断と完了条件を示す。
一般論や未導入サービスの手順を増やさず、実在するファイル・コマンドに接続する。
長い条件別の資料だけ references へ分け、短い skill には空の補助ディレクトリを作らない。
本文を分ける場合は参照する条件とリンクを残す。

ユーザーの依頼範囲と既存の許可を保ち、skill を書く依頼をその workflow の実行許可と解釈しない。
例示した外部操作・並列作業・承認手順を全タスクの必須工程へ広げない。
CLI 管理の上流 skill は独自 skill と区別し、上流の本文・manifest を手編集しない。

name と directory、frontmatter、必要な参照先、UI metadata、Markdown/YAML の整形を確認する。
コマンドや script を変えた場合は実行し、実行できなかったものを報告する。
実装を変更しない文書整備のためにアプリや外部サービスを起動しない。
