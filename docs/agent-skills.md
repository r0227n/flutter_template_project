# Agent skills

このリポジトリの project skill は `.agents/skills/` に置きます。
設計・調査・レビュー・QA・PR の7 skill は Oshiki の進め方を参考に独自に記述し、
Melos 公式 skill は Dart skills CLI で管理します。
スキルの利用は、各 `SKILL.md` の description にある用途とユーザーの依頼範囲で判断します。

## 独自 skill の用途

| Skill                                                               | 使う場面                           | 主な確認内容                               |
| ------------------------------------------------------------------- | ---------------------------------- | ------------------------------------------ |
| [clean-architecture](../.agents/skills/clean-architecture/SKILL.md) | 実装・リファクタリング・境界の検討 | 責務、公開 API、DI、状態所有、検証         |
| [code-review](../.agents/skills/code-review/SKILL.md)               | 差分・PR のレビュー                | 再現条件、影響、境界と非同期処理の欠陥     |
| [diagnosing-bugs](../.agents/skills/diagnosing-bugs/SKILL.md)       | 不具合の調査・修正                 | 最小再現、fake、順序・失敗・破棄、回帰確認 |
| [domain-modeling](../.agents/skills/domain-modeling/SKILL.md)       | 利用先アプリの業務設計             | 用語、不変条件、責務境界、ADR              |
| [dogfood](../.agents/skills/dogfood/SKILL.md)                       | 探索的 QA・画面操作の確認          | ホーム・設定・復元、表示条件、証跡         |
| [pr-create](../.agents/skills/pr-create/SKILL.md)                   | PR の作成・更新                    | develop、既存 PR、検証結果、公開後の確認   |
| [agent-docs](../.agents/skills/agent-docs/SKILL.md)                 | Agent 指示・skill の整備           | 発動条件、情報の正、参照先、整合性         |

共通の設計規約は [AGENTS.md](../AGENTS.md) と [ARCHITECTURE.md](ARCHITECTURE.md)、
起動・検証手順は [README.md](../README.md)、SDK と task は `.mise.toml`、依存と Melos scripts は
ルート `pubspec.yaml` を正にします。skill に版数やコマンド一覧を複製せず、これらへ参照を繋ぎます。
単純な修正のためにすべての skill を読み込む必要はありません。

## Melos 公式 skill

Melos の `skills/` に同梱された以下の skill を、Dart の `package:skills` CLI で取得します。
導入元は `package:melos`、管理先は `.config/dart_skills/skills_config.json` です。
Codex の CLI 引数は `--agent codex`、manifest の agent 名は `.agents/skills/` を共有する `generic` になります。

| Skill                                                                     | 使う場面                        |
| ------------------------------------------------------------------------- | ------------------------------- |
| [melos-workspace-setup](../.agents/skills/melos-workspace-setup/SKILL.md) | workspace・bootstrap・依存設定  |
| [melos-scripts](../.agents/skills/melos-scripts/SKILL.md)                 | Melos scripts の作成と変更      |
| [melos-commands](../.agents/skills/melos-commands/SKILL.md)               | コマンド・package filters・CI   |
| [melos-migration](../.agents/skills/melos-migration/SKILL.md)             | 旧バージョンからの移行          |
| [melos-versioning](../.agents/skills/melos-versioning/SKILL.md)           | package の版数・changelog・公開 |

公式 skill の一般的なコマンド例は、このリポジトリでは `dart run melos` で実行します。
CI は全 workspace を検証し、PR の base は `develop` です。共通の実行規約は `AGENTS.md` を優先します。

ルートから実行します。`mise run skills` は `.mise.toml` で版数を指定した Dart skills CLI に引数を渡します。

```sh
# CLI 管理の skill を表示（独自 skill は対象外）
mise run skills -- list

# 現在の依存で解決された Melos の skill だけを取得・更新
mise run skills -- get --package melos --all --agent codex
```

直接実行する場合は `dart run skills@1.0.4 get --package melos --all --agent codex` です。
初回の CLI 解決には通信が必要です。Melos の版数はルート `pubspec.yaml` と `pubspec.lock` で管理します。
Melos を更新するときは pub コマンドで最新安定版に更新し、続けて上の取得コマンドを実行します。
`--package melos` で対象を絞り、通常の setup・依存取得・CI では skill を自動更新しません。
checkout に公式 skill と manifest が含まれるため、通常の開発で再インストールは不要です。

## Oshiki からの調整

- `oshiki-clean-architecture` の責務・SSOT・DI の考え方を、ホームと設定だけの最小構成に適用。
  設計検討とドメイン設計も現在の設計書・ADR に接続し、ダミーの業務モデルを追加しません。
- レビューと不具合調査は、保存成功後の公開、SharedPreferences の失敗、非同期処理の順序と破棄を重点化。
- dogfood はホーム・テーマ・言語・再起動時の復元に合わせ、利用できるブラウザや端末操作手段を使います。
- PR 手順は既存 PR の更新と `develop` を維持し、画像処理 CLI や動画添付を必須にしません。
- Agent 文書の整備は、正となる文書への参照と用途ごとの短い指示に集約。

画像処理・カメラ、Marionette、Patrol、Sentry、ストア素材の Goldie と専用の動画編集は初期構成に含めません。
それらの skill、optional-skills 設定、on/off スクリプトも持ち込まず、利用先で機能を導入するときに追加します。
一般的な調査・振り返り・要件質問のための独立 skill は初期構成に増やしていません。

## 所有と更新

7つの独自 skill は手動で管理し、変更時は本文と `agents/openai.yaml`、参照文書を一緒に更新します。
独自 skill は dprint の対象です。名称と呼び出し名には `template-` を付けません。
参照先はリポジトリ内の相対リンクとし、元の Oshiki checkout や特定ユーザーの絶対パスへ依存させません。

公式 skill の本文・付属ファイル・manifest は CLI の生成結果をそのままコミットし、手編集しません。
`dprint.json` は `.agents/skills/melos-*/**` を除外して、上流の本文と contentHash の一致を保ちます。
追加の外部 skill を導入する場合も Dart skills CLI を使い、独自 skill と衝突しない名前を選び、
その配置を dprint の除外へ追加します。上流 skill に必要なローカル規約は `AGENTS.md` または独自 skill に置きます。
`skills-lock.json` は使用しません。

## 検証

`SKILL.md` の frontmatter の name と配置ディレクトリ、description の用途、参照先の存在、
独自 skill の UI metadata の skill 名が一致することを確認します。利用できる場合は skill-creator の
`quick_validate.py` で独自 skill を検証します。公式 skill は CLI の一覧と導入元の内容を照合し、
次のコマンドで管理状態と整形を確認します。

```sh
mise run skills -- list
mise run check:dprint
git diff --check
```

script や検証コマンドを変更した場合は実行結果も確認します。
文書の作成だけを目的に、記載した PR 作成・アプリ起動・外部投稿を実行しません。
