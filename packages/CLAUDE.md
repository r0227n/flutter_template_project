# パッケージ開発ガイド

このドキュメントは、Flutter Template Projectのpackagesディレクトリでの開発方法を説明します。

## 概要

packagesディレクトリには、メインアプリケーションから切り出された機能別パッケージが配置されています。各パッケージは特定の責任を持つ独立したコンポーネントとして設計されており、再利用性とテスト性を重視しています。

## パッケージ一覧

### app_preferences

アプリケーションの設定管理を担当するパッケージです。

**主な機能：**

- 言語設定（日本語/英語）の管理
- テーマ設定（システム/ライト/ダーク）の管理
- SharedPreferencesを使用した設定の永続化
- 設定変更用のダイアログとUI表示コンポーネント

**技術仕様：**

- Riverpod による状態管理
- slang による型安全な多言語対応
- Material 3 デザインシステム対応

## 新規パッケージの作成方法

### 1. パッケージの作成

```bash
# packages ディレクトリに移動
cd packages

# Flutter の公式パッケージテンプレートを使用
flutter create --template=package [パッケージ名]
cd [パッケージ名]
```

### 2. プロジェクト設定の追加

```bash
# ワークスペース対応
echo "resolution: workspace" >> pubspec.yaml

# 基本的な依存関係を追加
flutter pub add hooks_riverpod riverpod_annotation
flutter pub add --dev build_runner riverpod_generator yumemi_lints
```

### 3. 静的解析設定

analysis_options.yaml を作成し、プロジェクト全体で統一されたコード品質を保ちます：

```bash
# Flutter バージョンを取得
FLUTTER_VERSION=$(flutter --version | head -n 1 | grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+")

# analysis_options.yaml を作成
cat > analysis_options.yaml << EOF
include: package:yumemi_lints/flutter/${FLUTTER_VERSION}/recommended.yaml

analyzer:
  errors:
    invalid_annotation_target: ignore
  plugins:
    - custom_lint

formatter:
  trailing_commas: preserve
EOF
```

### 4. ワークスペースに登録

ルートの `pubspec.yaml` に新しいパッケージを追加：

```yaml
workspace:
  - apps
  - packages/app_preferences
  - packages/[新しいパッケージ名] # この行を追加
```

依存関係を解決：

```bash
cd ../../
melos run get
```

## パッケージ開発のベストプラクティス

### アーキテクチャ設計

各パッケージは以下の層構造で構成することを推奨します：

```
lib/
├── [package_name].dart          # パブリック API
├── src/
│   ├── providers/              # 状態管理（Riverpod）
│   ├── repositories/           # データアクセス層
│   ├── models/                 # データモデル
│   ├── widgets/                # UI コンポーネント
│   └── utils/                  # ユーティリティ
├── assets/                     # 静的リソース
└── test/                       # テスト
```

### 単一責任の原則

各パッケージは特定の機能領域のみを担当します：

- ✅ **良い例**: `app_preferences` - 設定管理に特化
- ✅ **良い例**: `user_authentication` - 認証処理に特化
- ❌ **悪い例**: `common_utils` - 様々な機能が混在

### 依存性注入パターン

Riverpod を使用して依存性を注入します：

```dart
// パッケージ内でプロバイダーを定義
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError();
}

// メインアプリで実装を注入
ProviderScope(
  overrides: [
    sharedPreferencesProvider.overrideWithValue(actualPrefs),
  ],
  child: App(),
)
```

## 開発ワークフロー

### コード生成

プロバイダーやモデルクラスを変更した後は必ずコード生成を実行：

```bash
# 特定パッケージで実行
cd packages/[パッケージ名]
dart run build_runner build --delete-conflicting-outputs

# または、全パッケージで実行
cd ../../
melos run gen
```

### テスト

テストは以下の種類を実装します：

```bash
# 単体テスト（プロバイダー、リポジトリ）
# ウィジェットテスト（UI コンポーネント）
# 統合テスト（完全なワークフロー）
flutter test
```

### コード品質チェック

```bash
# 静的解析
dart analyze

# フォーマット
dart format .

# 翻訳チェック（slang 使用時）
dart run slang analyze
```

## パッケージ統合ガイド

### メインアプリでの使用

新しいパッケージをメインアプリで使用するには：

1. **依存関係の追加**：

   ```yaml
   # apps/pubspec.yaml
   dependencies:
     [パッケージ名]:
       path: ../packages/[パッケージ名]
   ```

2. **初期化処理**：

   ```dart
   // main.dart で初期化
   await SomePackageInitializer.initialize();
   ```

3. **プロバイダーの監視**：
   ```dart
   class SomePage extends ConsumerWidget {
     @override
     Widget build(BuildContext context, WidgetRef ref) {
       final state = ref.watch(someProvider);
       // UI の実装
     }
   }
   ```

### パッケージ間の依存関係

- パッケージ間の依存は最小限に抑える
- 共通機能は別の専用パッケージに切り出す
- 循環依存は絶対に避ける

## 実装例：app_preferences パッケージ

### 処理フロー

1. **初期化**: SharedPreferences からの設定値読み込み
2. **状態管理**: Riverpod での設定値保持
3. **UI表示**: 現在の設定値表示
4. **ユーザー操作**: 設定変更ダイアログ
5. **永続化**: 新しい設定値の保存
6. **更新**: UI の再描画

### 主要コンポーネント

**プロバイダー:**

- `AppLocaleProvider`: 言語設定の管理
- `AppThemeProvider`: テーマ設定の管理

**ウィジェット:**

- `LocaleText`: 現在の言語表示
- `ThemeText`: 現在のテーマ表示
- `SelectionDialog`: 設定選択ダイアログ

**リポジトリ:**

- `AppPreferencesRepository`: SharedPreferences の抽象化

## よくある質問

### Q: 新機能をパッケージにするか、メインアプリに直接実装するか迷います

**A:** 以下の条件を満たす場合、パッケージ化を検討してください：

- 複数の画面で使用される
- 独立してテストできる
- 他のアプリでも再利用の可能性がある
- 特定のドメイン知識を含む

### Q: パッケージのバージョン管理はどうすればよいですか？

**A:**

- `pubspec.yaml` でバージョンを管理
- `CHANGELOG.md` で変更内容を記録
- セマンティックバージョニングに従う

### Q: パッケージを削除したい場合は？

**A:**

1. 使用箇所を特定し、代替実装に移行
2. 依存関係をすべて削除
3. ワークスペース設定から除外
4. ディレクトリを削除
5. 統合テストで問題がないことを確認

## 開発コマンド一覧

### パッケージ固有のコマンド

```bash
# パッケージディレクトリで実行
cd packages/[パッケージ名]

# コード生成
dart run build_runner build --delete-conflicting-outputs

# テスト実行
flutter test

# 静的解析
dart analyze

# コードフォーマット
dart format .
```

### モノレポ全体のコマンド

```bash
# ルートディレクトリで実行

# 全パッケージのコード生成
melos run gen

# 全パッケージのテスト
melos run test

# 全パッケージの静的解析
melos run analyze

# 全パッケージのフォーマット
melos run format

# 全パッケージの依存関係取得
melos run get
```

## まとめ

パッケージ開発では以下の点を心がけてください：

- **単一責任**: 各パッケージは明確な責任を持つ
- **テスト性**: 独立してテストできる設計
- **再利用性**: 他のプロジェクトでも使える汎用性
- **文書化**: 適切なドキュメントとコメント
- **品質**: 統一されたコード品質基準の遵守

これらの原則に従うことで、保守性が高く、拡張しやすいパッケージシステムを構築できます。
