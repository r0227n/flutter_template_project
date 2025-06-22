# app_preferences

アプリケーションの設定管理（ロケールとテーマ）を行うためのFlutterパッケージです。

## 概要

`app_preferences` パッケージは、Flutterアプリケーションにおけるユーザー設定の永続化と管理を提供します。主にロケール（言語設定）とテーマ（ライト/ダークモード）の設定を、SharedPreferencesを使用して保存・管理します。

## 主な機能

### 🌍 ロケール管理

- ユーザーの言語設定の保存・読み込み
- デバイスのロケール設定への自動フォールバック
- アプリ起動時の自動初期化

### 🎨 テーマ管理

- ライト・ダーク・システムテーマモードの切り替え
- Material 3デザインシステムに対応
- Deep Purpleをベースとした一貫性のあるカラースキーム

### 🔧 UI コンポーネント

- ロケール選択ダイアログ
- テーマ選択ダイアログ
- バージョン情報表示
- ライセンス情報表示

## アーキテクチャ

### 主要コンポーネント

#### Repository層

- `AppPreferencesRepository`: 設定データの永続化を担当
- SharedPreferencesとの直接的なやりとりを抽象化

#### Provider層（Riverpod）

- `AppLocaleProvider`: ロケール状態の管理
- `AppThemeProvider`: テーマ状態の管理
- `sharedPreferencesProvider`: SharedPreferencesインスタンスの提供

#### 初期化

- `AppPreferencesInitializer`: アプリ起動時の設定初期化

#### テーマ設定

- `AppTheme`: ライト・ダークテーマの定義

## 使用方法

### 1. 基本セットアップ

```dart
import 'package:app_preferences/app_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ロケール設定の初期化
  final sharedPrefs = await AppPreferencesInitializer.initializeLocale(
    onLocaleFound: (languageCode) async {
      final appLocale = AppLocale.values.firstWhere(
        (locale) => locale.languageCode == languageCode,
        orElse: () => AppLocale.ja,
      );
      await LocaleSettings.setLocale(appLocale);
    },
    onUseDeviceLocale: () async {
      await LocaleSettings.useDeviceLocale();
    },
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: MyApp(),
    ),
  );
}
```

### 2. ロケール管理

```dart
import 'package:app_preferences/app_preferences.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeAsync = ref.watch(appLocaleProviderProvider);

    return switch (localeAsync) {
      AsyncData(:final value) => Text('現在のロケール: ${value.languageCode}'),
      AsyncError(:final error) => Text('エラー: $error'),
      _ => CircularProgressIndicator(),
    };
  }
}

// ロケールの変更
await ref.read(appLocaleProviderProvider.notifier)
    .setLocale(const Locale('en'));
```

### 3. テーマ管理

```dart
import 'package:app_preferences/app_preferences.dart';

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(appThemeProviderProvider);

    return switch (themeModeAsync) {
      AsyncData(:final value) => MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: value,
        home: HomePage(),
      ),
      AsyncError(:final error) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('エラー: $error')),
        ),
      ),
      _ => MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
    };
  }
}

// テーマモードの変更
await ref.read(appThemeProviderProvider.notifier)
    .setThemeMode(ThemeMode.dark);
```

### 4. 設定ダイアログの使用

```dart
import 'package:app_preferences/widgets.dart';

// ロケール選択ダイアログ
await PreferencesDialogHelpers.showLocaleSelectionDialog(
  context: context,
  title: '言語設定',
);

// テーマ選択ダイアログ
await PreferencesDialogHelpers.showThemeSelectionDialog(
  context: context,
  title: 'テーマ設定',
);

// カスタムロケールオプション付きのダイアログ
await PreferencesDialogHelpers.showLocaleSelectionDialog(
  context: context,
  title: '言語設定',
  availableLocales: [
    LocaleOption(languageCode: 'ja', displayName: '日本語'),
    LocaleOption(languageCode: 'en', displayName: 'English'),
    LocaleOption(languageCode: 'es', displayName: 'Español'),
  ],
  onLocaleChanged: (languageCode) async {
    // アプリ固有の翻訳更新処理
    await updateSlangTranslations(languageCode);
  },
);
```

#### DialogHelpers の機能

`PreferencesDialogHelpers` クラスは、設定ダイアログの表示を簡単にするヘルパーメソッドを提供します：

**テーマ選択ダイアログ**

- システム・ライト・ダークテーマの選択
- カスタムラベルとアイコンの指定可能
- 自動的にテーマ設定が更新される

**ロケール選択ダイアログ**

- 利用可能な言語の選択
- デフォルトで日本語・英語をサポート
- カスタムロケールオプションの追加可能
- ロケール変更時のコールバック処理対応

## 依存関係

### 主要な依存関係

- `flutter`: Flutterフレームワーク
- `shared_preferences`: ローカルストレージ
- `hooks_riverpod`: 状態管理
- `riverpod_annotation`: Riverpodコード生成
- `slang`: 国際化対応
- `package_info_plus`: アプリ情報取得

### 開発依存関係

- `build_runner`: コード生成
- `freezed`: データクラス生成
- `json_serializable`: JSON シリアライゼーション
- `riverpod_generator`: Riverpod プロバイダー生成

## ファイル構成

```text
packages/app_preferences/
├── lib/
│   ├── app_preferences.dart              # メインエクスポート
│   ├── widgets.dart                      # ウィジェットエクスポート
│   ├── i18n/                            # 国際化ファイル
│   └── src/
│       ├── app_preferences_initializer.dart  # 初期化ユーティリティ
│       ├── providers/                   # Riverpod プロバイダー
│       ├── repositories/                # データアクセス層
│       ├── theme/                       # テーマ定義
│       └── widgets/                     # UIコンポーネント
├── assets/
│   └── i18n/                           # 翻訳ファイル
└── pubspec.yaml
```

## 国際化対応

現在サポートされている言語：

- 🇯🇵 日本語 (ja)
- 🇺🇸 英語 (en)

翻訳ファイルは `assets/i18n/` ディレクトリに配置されており、slangパッケージを使用して型安全な翻訳を提供します。

## 開発

### コード生成

```bash
# Riverpod プロバイダーとFreezedクラスの生成
dart run build_runner build

# 翻訳ファイルの生成
dart run slang
```

### テスト実行

```bash
flutter test
```

## ライセンス

このパッケージは内部使用のためのものです（`publish_to: 'none'` により、pub.devには公開されません）。

## 貢献

このパッケージはFlutterテンプレートプロジェクトの一部として開発されています。機能追加や改善の提案は、プロジェクトのIssue管理システムを通じてお願いします。
