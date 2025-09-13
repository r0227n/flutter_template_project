# CLAUDE.md

## 概要

仕様書に基づいたアプリケーション開発を、TDD + AIレビューファーストで実行する。

## 参照ドキュメント

- **仕様書**: `docs/spec.md`
- **画面仕様書**: `docs/pages/*.md`
- **機能仕様書**: `docs/features/*.md`
- **ベストプラクティス**: `docs/CLAUDE_4_BEST_PRACTICES.md`
- **Flutter開発ガイドライン**: `docs/FLUTTER_CODING_GUIDELINES.md`
- **ドキュメントガイドライン**: `docs/DOCUMENTATION_GUIDELINES.md`
- **Flutter LLMS Documentation**: https://docs.flutter.dev/llms.txt

## 開発ワークフロー

### TDD + AIレビューファーストサイクル

```
Red（失敗テスト） → Green（最小実装） → AIレビュー → Refactor（改善）
```

### 実装手順

1. **Red Phase（5分以内）**

   ```dart
   // 30%テスト：最小限の期待値定義
   test('認証機能が正常に動作する', () {
     final authService = AuthService();
     final result = authService.authenticate();
     expect(result, isA<AuthResult>());
   });
   ```

2. **Green Phase（10分以内）**
   - Claude 4に最小実装を依頼
   - テストを通す最小限のコードのみ実装

3. **AIレビュー Phase（5分以内）**

   ```yaml
   レビュー観点:
     🔴 セキュリティ（高優先度）:
       - 認証実装の安全性
       - データ保存の暗号化
       - セキュリティベストプラクティス

     🟡 SOLID原則（中優先度）:
       - 単一責任原則の遵守
       - 依存性逆転の実装
       - インターフェース分離

     🟢 パフォーマンス（低優先度）:
       - API呼び出し効率
       - キャッシュ戦略
       - メモリ使用量最適化
   ```

4. **Refactor Phase（10分以内）**
   - 優先度順に問題修正
   - 品質確認: `flutter test && flutter analyze`

## 技術スタック

### 状態管理

- Riverpod（推奨）
- Freezed（イミュータブルモデル）
- 適切な状態管理パターン

### ルーティング

- Go Router（推奨）
- 適切なナビゲーション設計

### UI/UX

- Material Design 3（推奨）
- 多言語対応（slang等）
- アクセシビリティ対応

## 開発コマンド例

### 新機能開発

```bash
# 1. テスト作成（Red）
flutter test test/features/[feature_name]/[feature_name]_test.dart

# 2. 実装（Green）
# Claude 4に実装依頼

# 3. レビュー・リファクタリング
flutter analyze
flutter test

# 4. パッケージ追加
flutter pub add <package_name>
```

### 品質チェック

```bash
# 全テスト実行
flutter test

# 静的解析
flutter analyze

# コード整形
mise run format

# 翻訳チェック（多言語対応プロジェクトの場合）
melos run analyze:slang
```

## 引数の読み取り機能

### ファイル読み取り処理

1. **引数として渡されたファイルを読み取る**
   - 指定されたパスのファイルを自動的に読み込み
   - ファイルの存在確認とエラーハンドリング
   - 複数ファイルの場合は順次読み込み

2. **読み取った内容に準拠したプログラムを作成**
   - ファイル内容を解析し、仕様要件を抽出
   - 抽出した要件に基づいてTDDサイクルを実行
   - 仕様書の構造に応じた実装計画の自動生成

### 実装例

```dart
// ファイル読み取り処理
final specFile = args['spec-file'];
if (specFile != null) {
  final content = await File(specFile).readAsString();
  final requirements = parseSpecification(content);

  // 読み取った内容に基づく開発実行
  await executeDevCycle(requirements);
}
```

## 品質基準

### 必須チェック項目

- [ ] 全テスト成功
- [ ] 静的解析パス
- [ ] セキュリティ要件満足
- [ ] SOLID原則遵守

### パフォーマンス要件

- 画面遷移: 1秒以内
- API応答: 3秒以内
- 画像読み込み: プログレッシブ表示

## 使用方法

1. 機能要件を30%テストで定義
2. Claude 4に構造化された指示で実装依頼
3. AIレビューで品質向上
4. リファクタリングで完成度向上

このコマンドに従って、仕様書に基づいた高品質なアプリケーションを効率的に開発してください。
