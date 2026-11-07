---
name: code-review
description: Flutter Template の差分・PRをレビューし、再現条件と影響を示す。レビューや設計評価を依頼されたときに使い、指摘の投稿や修正は依頼範囲に従う。
---

# 差分のレビュー

対象ブランチ・比較先・未コミット変更を確認する。PR の base は通常 `develop`。
[設計書](../../../docs/ARCHITECTURE.md)、変更元・変更先、呼び出し元とテストを読み、
差分に起因する問題と既存問題を区別する。

## このテンプレートで確認すること

- application の Flutter/plugin 依存、feature 間・shared から feature・他 package の src への依存。
- 具象 adapter の選択場所、必須 token の未注入、router と Provider の生存期間。
- 設定保存の直列化、成功前の公開、失敗時のキャッシュ復元、破棄後の state/ref/context 利用。
- UI feedback と ErrorReporter、元の例外・stack trace、Slang と MaterialApp の言語同期。
- typed route、保存値の互換性、狭い画面・大きな文字・テーマ・翻訳。
- 生成元と生成物、Pub lockfile、仕様・ADR・テストが同じ契約を表しているか。

必要な検証を実行し、既存テストが成功していても対象の失敗条件を扱っているか確認する。
新しい依存や共通化は実際の利用者と目的から評価し、好みだけの書き換えを指摘にしない。

## 報告

修正が必要な項目を影響の大きい順に、対象ファイル・行、起きる条件、利用者への影響、
根拠とともに示す。未確認の推測は確定した不具合と分ける。
指摘がなければその旨と検証範囲・未確認事項を記す。
レビュー依頼だけではコード変更、Issue 作成、PR コメント投稿を行わない。
