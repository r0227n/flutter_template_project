# Flutter Template

Oshiki の責務分割を基にした Flutter アプリのテンプレートです。
Firebase、Crashlytics、Sentry のアカウントや設定ファイルなしで起動できます。

## 起動

このディレクトリを独立したプロジェクトルートとして使用します。
Flutter のバージョンは `.mise.toml` の 3.44.6、Dart は ^3.12.0 です。

```sh
mise install
flutter pub get
dart run melos run gen
cd app
flutter run
```

ホームから設定画面へ移動し、テーマと日本語・英語を切り替えられます。
設定は端末へ保存され、次回起動時に復元されます。
保存に失敗すると元の設定を維持して画面にエラーを表示し、Talker に記録します。

## 構成

- `app/lib/app`: 起動、DI の結線、ルーターの生存期間、root widget。
- `app/lib/domain`: 純粋な業務モデルの追加先。初期状態では業務ルールを定義しません。
- `app/lib/application`: Flutter に依存しない設定モデル、use case、永続化 port。
- `app/lib/infrastructure`: SharedPreferences adapter。保存キーと読み書きの実装を所有します。
- `app/lib/presentation`: feature ごとの画面、設定 controller、必須 DI token、typed routes。
- `app/lib/core`: Slang 生成物と Talker の連携。
- `packages/design_system`: テーマとデザイントークン。

以前の未使用 `core` パッケージの設定・ログの責務は `app` 内へ移しました。
未接続の Todo / DuckDB サンプルは取り除き、特定の業務モデルや DB を選ばない構成です。
詳しい依存規則は [アーキテクチャ](docs/ARCHITECTURE.md) を参照してください。

## 依存パッケージの範囲

Riverpod、Freezed、GoRouter、Slang、SharedPreferences、Talker と関連 generator を使用します。
GoRouter builder は 4.4 以降の生成 API 変更を避けるため、4.3 系に制限しています。
Oshiki の汎用依存である intl、Lucide、package_info_plus、path_provider、permission_handler、url_launcher、
Marionette、Patrol も `app/pubspec.yaml` に用意しています。
Marionette のランタイム接続と Patrol の端末別設定は、利用先アプリに合わせて追加してください。

カメラ、画像選択・保存、画像処理・編集・補正、編集用の絵文字・色選択は含みません。
Firebase Analytics / Core / Crashlytics と Sentry は依存・初期化ともに含みません。
Talker は Flutter の例外、未処理の非同期例外、Riverpod のイベントを記録します。
ログの外部送信は設定していません。

## 検証

プロジェクトルートで実行します。

```sh
dart run melos run gen
dart run melos run gen:slang
dart run melos run analyze:slang
dart run melos run analyze
dart run melos run test
dart run melos run ci:format
mise run check:dprint
```

アプリを配布する際は `app` 配下の各プラットフォームのアプリ名、bundle ID、
署名設定を利用先の値に変更してください。
