---
name: template-diagnosing-bugs
description: Flutter Template のクラッシュ、保存失敗、状態競合、表示不具合を再現し、原因を切り分けて修正する。不具合調査・修正を依頼されたときに使う。
---

# 不具合の調査と修正

期待する動作と観察した動作を分け、commit・platform・起動条件・入力・操作順を記録する。
[画面仕様](../../../docs/specs/SPECS_INDEX_SPEC.md) と対象コードを照合し、
まず最小の再現手順または失敗するテストを作る。調査のみの依頼では修正を混ぜない。

## 原因を絞る

- 起動失敗: bootstrap、外部 instance の初期化、初期 snapshot、再試行画面の順に追う。
- 設定保存: use case → repository → SharedPreferences の応答と reload を追い、
  保存成功値・plugin のメモリキャッシュ・表示値のどこに差が出たか確かめる。
- 連続操作・破棄: Completer と fake で完了順を制御し、後続操作の継続と mounted を確認する。
- 言語・テーマ: 保存値、端末 locale 解決、Slang、MaterialApp、controller の所有関係を確認する。
- 遷移・表示: typed route、Widget の制約、文字倍率・テーマ・翻訳を再現条件に含める。

実ログと stack trace を根拠に仮説を検証する。Talker はローカル観測用で、Sentry や Firebase を前提にしない。
テストでは実サービスより fake を優先し、`app/test/` の対応レイヤーに置く。
エラーを無視したり timeout を伸ばしたりして再現を隠さず、失敗する契約を直す。

## 完了

修正依頼なら同じ条件で成功を確認し、隣接する失敗・順序・破棄のケースを必要に応じて検証する。
[README](../../../README.md#検証) の生成・全体検証まで進める。
再現条件、原因、変更内容、実行結果、未解決事項を報告する。
再現できない場合は仮説を断定せず、確認済みの条件と次に必要な情報を示す。
