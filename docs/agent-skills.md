# Agent skills

このリポジトリの project skill は `.agents/skills/` に置きます。
Oshiki の `.agents` にある設計・調査・レビュー・QA・PR の進め方を参考に、
テンプレートの実装と検証手段に合わせて独自に記述しています。
スキルの利用は、各 `SKILL.md` の description にある用途とユーザーの依頼範囲で判断します。

## 用途

| Skill                                                                                 | 使う場面                           | 主な確認内容                               |
| ------------------------------------------------------------------------------------- | ---------------------------------- | ------------------------------------------ |
| [template-clean-architecture](../.agents/skills/template-clean-architecture/SKILL.md) | 実装・リファクタリング・境界の検討 | 責務、公開 API、DI、状態所有、検証         |
| [template-code-review](../.agents/skills/template-code-review/SKILL.md)               | 差分・PR のレビュー                | 再現条件、影響、境界と非同期処理の欠陥     |
| [template-diagnosing-bugs](../.agents/skills/template-diagnosing-bugs/SKILL.md)       | 不具合の調査・修正                 | 最小再現、fake、順序・失敗・破棄、回帰確認 |
| [template-domain-modeling](../.agents/skills/template-domain-modeling/SKILL.md)       | 利用先アプリの業務設計             | 用語、不変条件、責務境界、ADR              |
| [template-dogfood](../.agents/skills/template-dogfood/SKILL.md)                       | 探索的 QA・画面操作の確認          | ホーム・設定・復元、表示条件、証跡         |
| [template-pr-create](../.agents/skills/template-pr-create/SKILL.md)                   | PR の作成・更新                    | develop、既存 PR、検証結果、公開後の確認   |
| [template-agent-docs](../.agents/skills/template-agent-docs/SKILL.md)                 | Agent 指示・skill の整備           | 発動条件、情報の正、参照先、整合性         |

共通の設計規約は [AGENTS.md](../AGENTS.md) と [ARCHITECTURE.md](ARCHITECTURE.md)、
起動・検証手順は [README.md](../README.md)、SDK と task は `.mise.toml`、依存と Melos scripts は
ルート `pubspec.yaml` を正にします。skill に版数やコマンド一覧を複製せず、これらへ参照を繋ぎます。
単純な修正のためにすべての skill を読み込む必要はありません。

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

現在の7 skill はこのリポジトリで管理する独自ファイルです。`skills-lock.json` の管理対象ではなく、
Oshiki にある CLI 管理の上流 skill やその lockfile をコピーしていません。
変更時は本文と `agents/openai.yaml`、参照文書を一緒に更新し、dprint の対象に含めます。
参照先はリポジトリ内の相対リンクとし、元の Oshiki checkout や特定ユーザーの絶対パスへ依存させません。

将来 `npx skills` などで上流 skill を導入する場合は、独自 skill と別名・別ディレクトリで管理し、
導入した CLI で本文と lockfile を更新します。上流の本文・生成された hash を手編集せず、
必要なローカル規約は `AGENTS.md` または独自 skill に置きます。

## 検証

`SKILL.md` の frontmatter の name と配置ディレクトリ、description の用途、参照先の存在、
UI metadata の skill 名が一致することを確認します。利用できる場合は skill-creator の
`quick_validate.py` で各 skill を検証し、次の整形チェックを行います。

```sh
mise exec -- dprint check AGENTS.md README.md docs/agent-skills.md '.agents/skills/**/*.md' '.agents/skills/**/*.yaml'
git diff --check
```

script や検証コマンドを変更した場合は実行結果も確認します。
文書の作成だけを目的に、記載した PR 作成・アプリ起動・外部投稿を実行しません。
