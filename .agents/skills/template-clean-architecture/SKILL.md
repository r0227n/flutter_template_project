---
name: template-clean-architecture
description: Flutter Template の依存方向・公開 API・状態所有に沿って機能追加、リファクタリング、境界レビューを行う。app/lib と packages の責務や DI を変更するときに使う。
---

# テンプレートの設計と実装

[AGENTS.md](../../../AGENTS.md) と [設計の正](../../../docs/ARCHITECTURE.md)、対象コード・テストを読む。
命名のためだけに層を増やさず、変更する責務、依存方向、状態の所有者を先に特定する。
コードと文書が異なる場合は現行挙動を確認し、ユーザーが求めた変更と同時に整合させる。

## 変更の置き場所

- 業務上の不変条件は domain。業務要件のない初期状態にはダミー entity を作らない。
- 外部能力の契約とユーザー目的の手順は application。端末 API と保存形式は infrastructure。
- UI の状態と操作は feature。共有化は実際の利用者が複数になった時点で判断する。
- 具象 adapter の選択は `app/lib/app/dependency_graph.dart`、必須 token は
  `app/lib/presentation/dependencies/`。未注入時に本番実装へ fallback させない。
- 色・余白・角丸は design_system、文言は Slang JSON。画面 Widget は feature に置く。

新しい外部能力では port と利用側の最小契約を決め、constructor injection できる adapter、
use case、token、composition root の順に結線する。設定・権限が必要なサービスは利用先の要件に応じて導入する。
公開 API の追加・削除は呼び出し元と barrel export まで更新する。公開例外は専用ファイルから import する。

## 設定・非同期・生存期間

`AppPreferencesSnapshot` は保存境界の純 Dart データ、`AppPreferences` は表示状態。
現在の所有者は `AppPreferencesController`。同じ値を別 Provider や controller に保持しない。
保存は操作順に処理し、保存成功後に公開する。失敗後の後続処理、破棄後の完了、未開始操作も検討する。
画面の feedback と ErrorReporter の責務を分け、同じ例外を二重に報告しない。
router は app が生成・破棄し、定義と typed route は presentation/navigation に置く。

## 検証と文書

境界変更は `app/test/architecture/`、処理変更は対応レイヤーのテストで確認する。
非同期の変更では成功だけでなく順序・失敗・破棄を検証し、UI の変更では
狭い幅・文字拡大・テーマ・日本語/英語・遷移を確認する。
生成・翻訳・全体検証は [README の検証](../../../README.md#検証) に従う。
設計境界を意図的に変える場合は architecture test と設計書を同期し、長期判断なら ADR を追加する。
完了時は配置理由、検証結果、残る制約を報告する。
