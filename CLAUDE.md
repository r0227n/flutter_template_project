# Flutter Template

開発規約と検証手順は [AGENTS.md](AGENTS.md) を参照してください。
現行構成は root の `pubspec.yaml` と [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) が正です。

`app` がアプリ、`packages/design_system` がテーマとデザイントークンを所有します。
Riverpod、GoRouter、Slang、SharedPreferences、Talker を使います。
DuckDB、独立した core / database package、外部サービスの資格情報は初期構成に含みません。

PR を依頼された場合は `.github/pull_request_template.md` を読み、
実施した検証と未実施項目を区別してください。
