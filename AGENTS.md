# Flutter Template Agent Instructions

このリポジトリは `app` と `packages/design_system` の Dart workspace です。
依頼された差分と既存の挙動を区別し、他の作業・未コミット変更を保持してください。

## 情報の正

- SDK と task: `.mise.toml`。workspace・依存・Melos scripts: `pubspec.yaml`。
- セットアップと起動: [README.md](README.md)。
- レイヤー、DI、状態所有者を変えるとき: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)。
- 画面・ルート: `app/lib/presentation`。翻訳: `app/assets/i18n/*.i18n.json`。

## 実装

- domain と application は Flutter や外部 I/O に依存させません。
  infrastructure は port の実装、presentation は画面と表示状態、app は結線を所有します。
- 既存の Riverpod、typed GoRouter、Freezed、Slang のパターンを使います。
  UI は `design_system` のテーマとトークン、表示文言は翻訳入力を使います。
- package の利用者は公開入口を使い、別 package の `src/` を直接参照しません。
- `*.g.dart`、`*.freezed.dart`、`*.g.theme.dart` は入力から生成し、手編集しません。
  通常は `melos run gen`、翻訳は `melos run gen:slang` です。
- 失敗はユーザーに見える状態と既存の ErrorReporter / Talker へ反映します。
- 新規依存、公開 API、永続化キー、生成入力の変更は影響と関連文書を確認します。
  存在しない module、資格情報、外部サービスを初期必須条件として追加しません。

## 品質と PR

- [template-quality](.agents/skills/template-quality/SKILL.md): 変更後の品質確認。
  セットアップ済み環境で `mise run quality` を実行します。
  `mise run ci-check` は全体確認です。両方ともソースを自動修正しません。
- [template-pr](.agents/skills/template-pr/SKILL.md): PR 作成を依頼されたとき。
  base は GitHub の default branch を確認し、既存 PR と検証結果を確認します。
- Stop hook は品質確認を補助します。失敗後の継続では自動再実行を抑止します。
  hook の未実行・失敗を合格と扱わず、未実施項目と理由を報告してください。
- UI を変更した場合は利用可能な端末で該当操作を確認します。
  設定のみの変更に Simulator、Marionette、画像・動画を必須としません。
- SDK、依存取得、外部送信、push、PR、merge の権限はユーザー依頼と実行環境に従います。
  hook や skill を操作の承認として扱いません。
