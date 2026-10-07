---
name: template-pr
description: Prepare or update a pull request for this template when the user requests one, with verified scope, actual test results, and the repository PR template.
---

# PR 作成

現在の branch、GitHub default branch、差分、未コミット変更、同じ head の既存 PR を確認します。
依頼外の差分を保持し、依頼された変更だけをコミット・push してください。
既存 PR があればその PR を使います。新規 PR は Draft を初期値にします。
merge や release は別の明示的な依頼が必要です。

[品質確認](../template-quality/SKILL.md) を実行し、
`.github/pull_request_template.md` の見出しと順序で本文を作成します。
概要、変更内容、実際の検証、未実施と理由、残る制約を記載します。
関連 Issue がない場合は「該当なし」とし、仮番号を残しません。
設定のみの変更では端末確認やスクリーンショットは「対象外」と記載できます。
UI 変更の証跡は利用可能な検証手段で取得し、個人情報や秘密値を公開しません。
他の private repo を参考にした場合は汎用化した設計だけを取り込み、private 原本や内部証跡を貼りません。

作成後に URL、Draft 状態、base / head、公開本文を再確認します。
CI は最終 head SHA に対応する結果を確認し、古いコミットの結果を流用しません。
保留や失敗がある場合も正確に報告してください。
