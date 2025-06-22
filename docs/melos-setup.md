# Melos環境構築ガイド

このドキュメントでは、Flutter Template ProjectでMelosを使用したモノレポ管理の環境構築手順を説明します。

## Melosとは

Melosは、Dartプロジェクトのモノレポ管理を効率化するツールです。複数のパッケージやアプリケーションを一つのリポジトリで管理し、依存関係の解決、並列ビルド、テストの実行などを統一的に行うことができます。

### 主な機能

- **パッケージ管理**: 複数のFlutter/Dartパッケージを一括管理
- **依存関係解決**: 相互依存するパッケージの自動リンク
- **並列実行**: 複数パッケージでのコマンド並列実行
- **スクリプト管理**: プロジェクト全体で統一されたタスク実行

## 前提条件

- Flutter SDK (fvmで管理推奨)
- Dart SDK
- Git

## 環境構築手順

### 1. Melosのインストール

#### グローバルインストール

```bash
flutter pub global activate melos
```

#### プロジェクトへの追加

プロジェクトルートの`pubspec.yaml`にMelosを追加：

```yaml
name: workspace
publish_to: none

environment:
  sdk: ^3.6.0

dev_dependencies:
  melos: ^6.3.3

workspace:
  - apps
```

### 2. 依存関係のインストール

```bash
flutter pub get
```

### 3. Melos設定ファイルの作成

プロジェクトルートに`melos.yaml`を作成（すでに存在します）：

```yaml
name: flutter_template_project

packages:
  - apps/
  - packages/**

command:
  clean:
    hooks:
      pre: melos exec -- "flutter clean"

scripts:
  # Generate code for all packages using build_runner
  gen:
    description: Run build_runner for all packages
    run: |
      melos exec --depends-on="build_runner" -- "dart run build_runner build --delete-conflicting-outputs"

  # Clean and get dependencies for all packages
  get:
    description: Get dependencies for all packages
    run: melos exec -- "flutter pub get"

  # Analyze all packages
  analyze:
    description: Analyze all packages
    run: melos exec -- "dart analyze"

  # Format all packages
  format:
    description: Format all packages
    run: melos exec -- "dart format ."

  # Run tests for all packages
  test:
    description: Run tests for all packages
    run: melos exec --fail-fast -- "flutter test"

  # Build APK for apps
  build:apk:
    description: Build APK for all apps
    run: melos exec --scope="*app*" -- "flutter build apk"

  # Build iOS for apps
  build:ios:
    description: Build iOS for all apps
    run: melos exec --scope="*app*" -- "flutter build ios --no-codesign"

environment:
  sdk: '>=3.6.0 <4.0.0'
  flutter: '>=3.0.0'
```

### 4. ワークスペースの初期化

```bash
melos bootstrap
```

このコマンドにより以下が実行されます：

- 全パッケージの依存関係解決
- パッケージ間のローカルリンク設定
- IDE設定ファイルの生成

## 主要コマンド

### 基本コマンド

#### ワークスペースのブートストラップ

```bash
melos bootstrap
```

#### 全パッケージの依存関係更新

```bash
melos run get
# または
melos exec -- "flutter pub get"
```

#### コード生成（build_runner）

```bash
melos run gen
```

#### 静的解析

```bash
melos run analyze
```

#### コードフォーマット

```bash
melos run format
```

#### テスト実行

```bash
melos run test
```

### ビルドコマンド

#### APKビルド

```bash
melos run build:apk
```

#### iOSビルド

```bash
melos run build:ios
```

### 特定パッケージでのコマンド実行

#### 特定パッケージでのみ実行

```bash
melos exec --scope="apps" -- "flutter pub get"
```

#### 依存関係を持つパッケージでのみ実行

```bash
melos exec --depends-on="build_runner" -- "dart run build_runner build"
```

### デバッグ・情報表示

#### パッケージ一覧表示

```bash
melos list
```

#### 依存関係グラフ表示

```bash
melos deps graph
```

#### バージョン情報表示

```bash
melos version
```

## pub workspaceとの併用

このプロジェクトでは、Dartの標準的なpub workspaceとMelosを併用しています：

### pub workspace

- 基本的な依存関係管理
- IDEでの認識とインテリセンス
- 標準的なDartツールとの互換性

### Melos

- 高度なスクリプト管理
- 並列実行による高速化
- モノレポ特有のタスク自動化

## トラブルシューティング

### よくある問題と解決方法

#### 1. "melos command not found"エラー

```bash
# グローバルインストールを確認
flutter pub global activate melos

# PATHの確認
echo $PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

#### 2. ローカル依存関係の解決エラー

```bash
# ワークスペースの再初期化
melos clean
melos bootstrap
```

#### 3. ビルド生成ファイルの競合

```bash
# 全パッケージのクリーン
melos run gen
```

#### 4. IDE認識の問題

```bash
# IDE設定ファイルの再生成
melos bootstrap
```

### パフォーマンス最適化

#### 並列実行の最適化

```bash
# 最大並列数を制限（CPUコア数に応じて調整）
melos exec --concurrency=4 -- "flutter test"
```

#### キャッシュの活用

```bash
# build_runnerのキャッシュを活用
melos exec --depends-on="build_runner" -- "dart run build_runner build"
```

## 開発ワークフロー

### 日常的な開発フロー

1. **環境準備**

   ```bash
   melos bootstrap
   ```

2. **コード生成**

   ```bash
   melos run gen
   ```

3. **開発・実装**

   ```bash
   # 必要に応じて特定パッケージで作業
   cd apps
   flutter run
   ```

4. **品質チェック**

   ```bash
   melos run analyze
   melos run format
   melos run test
   ```

5. **ビルド確認**
   ```bash
   melos run build:apk
   ```

### CI/CDでの活用

GitHub ActionsなどのCI/CDパイプラインでMelosを活用：

```yaml
- name: Bootstrap Melos
  run: melos bootstrap

- name: Generate code
  run: melos run gen

- name: Run tests
  run: melos run test

- name: Build apps
  run: melos run build:apk
```

## 設定のカスタマイズ

### スクリプトの追加

`melos.yaml`にカスタムスクリプトを追加：

```yaml
scripts:
  # カスタムスクリプトの例
  lint:
    description: Run custom linting
    run: melos exec -- "dart analyze --fatal-infos"

  outdated:
    description: Check for outdated dependencies
    run: melos exec -- "flutter pub outdated"
```

### パッケージフィルタリング

特定の条件でパッケージをフィルタ：

```yaml
scripts:
  test:flutter:
    description: Test only Flutter packages
    run: melos exec --flutter -- "flutter test"

  test:dart:
    description: Test only Dart packages
    run: melos exec --no-flutter -- "dart test"
```

## まとめ

Melosを使用することで、Flutter Template Projectのモノレポ管理が大幅に効率化されます。特に以下の点で開発体験が向上します：

- **統一されたコマンド体系**: `melos run <script>`で全てのタスクを実行
- **並列処理による高速化**: 複数パッケージでの作業を並列実行
- **依存関係の自動管理**: パッケージ間の依存関係を自動解決
- **開発環境の標準化**: チーム全体で統一された開発環境

継続的にMelosを活用して、効率的なモノレポ開発を実現してください。
