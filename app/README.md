# app

Flutter テンプレートの実行アプリです。初期化の入口は `lib/main.dart`、
起動と依存注入は `lib/app/` にあります。

セットアップ、命名変更、生成・検証は [ルート README](../README.md) を参照してください。
[アーキテクチャ](../docs/ARCHITECTURE.md) と [画面仕様](../docs/specs/SPECS_INDEX_SPEC.md) に従って拡張します。

ルートで `mise run setup` を実行した後、このディレクトリで起動します。

```sh
flutter run --dart-define-from-file=.dart_define/sample.json
```
