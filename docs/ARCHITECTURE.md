# アーキテクチャ

## 依存方向

```text
presentation → application → domain
infrastructure → application → domain
app → presentation / infrastructure / application / core
```

`domain` と `application` は Flutter、Riverpod、plugin に依存しません。
`presentation` は infrastructure や composition root を参照しません。
`infrastructure` は presentation を参照しません。
feature 同士は直接 import せず、共有する責務を application または shared に配置します。
これらの規則を `app/test/architecture/layer_dependencies_test.dart` で検証します。

## 設定と DI

設定は業務上の不変条件ではないため、モデルは application に配置します。
`AppPreferencesUseCase` は永続化 port を利用し、保存先を知りません。
`LocalAppPreferencesRepository` が SharedPreferences と保存表現を所有します。

具象選択は `app/dependency_graph.dart` に集約します。
外部 instance → adapter → use case の順で作成し、presentation の必須 Provider token を override します。
未注入の token は即座に失敗し、暗黙の本番実装に fallback しません。

`AppPreferencesController` の `AsyncValue<AppPreferences>` は表示用設定状態の唯一の所有者です。
保存中は `AsyncLoading` で操作を直列化し、成功後に保存先を読み直して `AsyncData` を更新します。
失敗時は以前の設定値を保持した `AsyncError` と ErrorReporter の両方へ通知します。
非同期完了後は `ref.mounted` を確認します。

永続化キーは adapter の `app.theme` と `app.language` です。
テーマは `system` / `light` / `dark`、言語は `ja` / `en` を保存します。
未設定・不正な保存値はシステムテーマと日本語に戻します。
旧サンプルの保存形式との互換性は持たない、新規アプリ向けの初期スキーマです。

## 画面と翻訳

ルートの正は `presentation/navigation/routes.dart` です。
`/` はホーム、`/settings` は設定画面です。GoRouter の生成物は直接編集しません。
ルーターの生成・破棄は app が所有します。

翻訳の正は `app/assets/i18n/*.i18n.json` です。
Slang の生成物は `app/lib/core/gen` へ出力します。
設定変更に応じて app が Slang と MaterialApp の locale を同期します。
言語名は選択対象自身の表記（日本語 / English）を使用します。

## 観測と起動

Talker の生成と Flutter / PlatformDispatcher のエラーハンドラー登録は bootstrap が所有します。
Riverpod observer は composition root で取り付けます。
presentation は ErrorReporter の契約だけを使い、Talker の具象型を参照しません。
起動に失敗した場合も Talker へ記録し、再試行ボタンを表示します。

Firebase と Sentry は初期化しません。外部サービスなしで開発を開始できます。
将来導入する場合も core の adapter と app の結線に閉じ込めます。
