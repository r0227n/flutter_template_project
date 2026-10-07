---
name: template-quality
description: Validate changes in this Flutter template with its shared quality checks. Use after source, dependency, translation, or development configuration edits.
---

# 品質確認

root の `pubspec.yaml` と `.mise.toml` を確認し、宣言済み workspace と SDK を使います。
セットアップ済みの環境で root から `mise run quality` を実行してください。
staged / unstaged / untracked と削除・rename の両側を検出します。
Dart 関連の変更は全 workspace の format check、fatal-infos 分析、Slang 分析、test を実行し、
共有 package の利用者も確認します。文書・設定の整形は dprint の設定を使います。
hook / skill / scripts の変更では SDK 不要の tooling fixture も実行します。

全体確認は `mise run ci-check`、計画だけの確認は
`python3 scripts/quality.py --plan` です。
依存を変更した場合、許可されたセットアップ操作として
`flutter pub get --enforce-lockfile` で解決を確認してから検証します。
失敗を回避するために lockfile を書き換えず、依存更新が目的の場合だけ意図した解決をコミットします。

runner と hook は install、pub get、コード生成、ソースの自動修正を行いません。
生成入力を変更した場合は関連 generator を明示的に実行し、生成差分も確認してください。
ツールや依存が不足した場合は未実施として報告し、ユーザーが許可した範囲でセットアップします。
native / UI の検証は変更内容に応じて追加し、実施した操作・端末を記録します。
