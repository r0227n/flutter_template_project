# Flutter Template Agent Instructions

このリポジトリは新規 Flutter アプリの出発点です。
Oshiki の命名と設計境界を採用しますが、業務機能や外部サービスは利用先で必要になったときに追加します。
既存の未コミット変更を保持し、実装・生成・検証・文書の同期まで進めてください。

## 情報の正

- セットアップと利用方法: [README.md](README.md)。SDK と task: `.mise.toml`。
- workspace・依存・Melos scripts: ルート `pubspec.yaml`。
- 責務配置・公開 API・依存注入・状態所有: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)。
- 画面仕様: [docs/specs/SPECS_INDEX_SPEC.md](docs/specs/SPECS_INDEX_SPEC.md)。
- 長期的な設計判断: `docs/specs/ADR-*.md`。
- 作業別の project skill: [.agents/skills](.agents/skills)。用途と管理方針は [docs/agent-skills.md](docs/agent-skills.md)。
- 文書とコードに不一致があれば現行挙動を確認し、明示的な依頼を優先して同じ変更で整合させます。

## 設計境界

- `domain`: UI と端末から独立した業務領域ごとの純粋なルール。
- `application`: `models`・`ports`・`use_cases`・`errors`。domain 以外の app layer に依存しません。
- `infrastructure`: constructor injection 可能な具象 adapter。Riverpod と presentation に依存しません。
- `presentation`: feature ごとの画面・状態・Widget。app と具象 adapter を参照しません。
- `app`: bootstrap・composition root・router の生存期間・root widget。
- `core`: 翻訳、locale 解決、観測など外側の共通実装。
- `packages/design_system`: テーマとトークンのみ。アプリ固有 Widget を置きません。

外側は application の公開入口を使い、公開例外だけは `application/errors/*.dart` を直接 import します。
他 package の `src/`、feature 間、shared から feature への直接依存は禁止します。
具象 adapter の選択は `app/dependency_graph.dart`、必須 token は `presentation/dependencies/` に置きます。

## 実装規約

- 型は PascalCase、メンバーは camelCase、ファイルは snake_case とし、責務を表す名前にします。
- 既存の Riverpod generated Notifier、Freezed state、GoRouter typed route を使います。
  標準 Widget の局所的な状態は StatefulWidget などで管理します。
- 同じ状態を複数の controller や Provider へコピーしません。
- await 後の state / ref / context 利用前に mounted を確認します。失敗を握りつぶしません。
- 設定の変更は保存成功後に公開し、UI feedback と ErrorReporter を接続します。
- Widget は小さく分割し、画面だけの部品は対象 feature に置きます。
- 配色・余白・角丸は design_system、表示文言は Slang の JSON を正とします。
- 公開 API は `///` で契約を記載し、理由が必要な箇所だけに実装コメントを書きます。
- 新規依存は既存手段で足りない理由を示し、pub コマンドで lockfile も更新します。
- 生成物は手編集せず、互換 re-export や未使用の汎用層は追加しません。

## 生成と検証

Melos はルート `pubspec.yaml` の固定版を使い、ルートから `dart run melos` で実行します。
利用可能なら Dart の format / fix / analyze / test ツールを使い、なければ CLI を使います。

```sh
dart run melos run gen
dart run melos run gen:slang
mise run quality
git diff --check
```

テストは `app/test/` の同じレイヤーに配置し、fake を優先します。
依存境界の変更では architecture test、非同期処理では順序・失敗・破棄を検証します。
UI の変更では狭い画面・文字拡大・テーマ・翻訳・遷移を確認します。
対象 platform のビルドや実行結果と未検証事項をPRに記録します。
PR のベースブランチは `develop` です。
