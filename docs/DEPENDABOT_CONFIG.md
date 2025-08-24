# Dependabot設定ドキュメント

## 概要

`.github/dependabot.yml`ファイルは、GitHubのDependabotを使用して依存関係の自動更新を管理するための設定です。

このFlutterテンプレートプロジェクトでは、4つの異なるパッケージエコシステム（pub、npm、GitHub Actions）に対して月次の自動更新を設定しています。

## 基本設定

### スケジュール

- **頻度**: 月次更新
- **実行日**: 毎月第1月曜日
- **実行時刻**: 06:00 (Asia/Tokyo)

### 共通設定

- **レビュー者**: r0227n
- **担当者**: r0227n
- **コミットメッセージプレフィックス**: `deps`
- **コミット形式**: Conventional Commits準拠

## パッケージエコシステム別設定

### 1. Flutter/Dart依存関係 (メインアプリ)

- **対象ディレクトリ**: `/app`
- **PR上限数**: 10
- **ラベル**: `dependencies`, `flutter`

#### グループ化設定

**flutter-sdk**

- パターン: `flutter`, `flutter_*`
- 更新タイプ: minor, patch

**state-management**

- パターン: `riverpod*`, `hooks_riverpod`
- 更新タイプ: minor, patch

**code-generation**

- パターン: `build_runner`, `freezed*`, `json_*`, `*_generator`, `*_builder`
- 更新タイプ: minor, patch

**navigation**

- パターン: `go_router*`
- 更新タイプ: minor, patch

**internationalization**

- パターン: `slang*`
- 更新タイプ: minor, patch

**linting**

- パターン: `*_lint*`, `flutter_lints`, `custom_lint`
- 更新タイプ: minor, patch

### 2. Flutter/Dart依存関係 (パッケージ)

- **対象ディレクトリ**: `/packages/core`
- **PR上限数**: 5
- **ラベル**: `dependencies`, `packages`

### 3. Node.js依存関係

- **対象ディレクトリ**: `/` (package.json)
- **PR上限数**: 5
- **ラベル**: `dependencies`, `nodejs`

#### グループ化設定

**dev-tools**

- パターン: `@commitlint/*`, `husky`, `prettier`
- 更新タイプ: minor, patch

### 4. GitHub Actions

- **対象ディレクトリ**: `/` (workflow files)
- **PR上限数**: 5
- **ラベル**: `dependencies`, `github-actions`

## 運用方針

### 更新頻度の理由

- **月次更新**: プロジェクトの安定性を重視し、頻繁すぎる更新を避ける
- **月曜日実行**: 週の始まりに更新を確認し、問題があれば週内に対応可能

### グループ化の利点

- **関連する依存関係をまとめて更新**: 互換性の問題を減らす
- **PR数の制限**: レビュー負荷を軽減
- **minor/patchのみ**: 破壊的変更（major）は手動で慎重に対応

### セキュリティ更新

- Dependabotは自動的にセキュリティ脆弱性のある依存関係を検出
- セキュリティ更新は設定されたスケジュールに関係なく即座に実行
- 重要度の高い脆弱性はPRが即座に作成されます

## 注意事項

### Renovateとの競合

現在、同じリポジトリでRenovate（`.github/renovate.json5`）も設定されています。両方が同時に動作すると以下の問題が発生する可能性があります：

- 同じ依存関係に対して複数のPRが作成される
- 競合するコミットが発生する
- CI/CDパイプラインが不必要に実行される

### 推奨対応

1. **Dependabotを使用する場合**: `.github/renovate.json5`を削除または無効化
2. **Renovateを継続使用する場合**: `.github/dependabot.yml`を削除

### テスト・品質チェック

Dependabotで更新された依存関係は、以下のコマンドで検証してください：

```bash
# 完全なCI チェック
mise run ci-check

# 個別チェック
mise run analyze           # 静的解析
mise run test              # テスト実行
mise run analyze-slang     # 翻訳検証（i18n変更時）
```

### PRレビューのワークフロー

1. **自動テスト**: GitHub ActionsのCI/CDパイプラインが自動実行
2. **手動確認**: 破壊的変更がないことを確認
3. **ローカルテスト**: 必要に応じて `mise run dev` でローカル検証
4. **マージ**: 問題なければPRをマージ

## カスタマイズ例

### より頻繁な更新が必要な場合

```yaml
schedule:
  interval: 'weekly' # monthly から weekly に変更
```

### 特定のパッケージを除外する場合

```yaml
ignore:
  - dependency-name: 'package-name'
    versions: ['^1.0.0']
```

### major更新も含める場合

```yaml
update-types:
  - 'minor'
  - 'patch'
  - 'major' # major更新を追加
```

## トラブルシューティング

### よくある問題

**1. コンフリクト発生時**

```bash
# ローカルで最新を取得
git pull origin main
# コンフリクト解決後
mise run ci-check  # 品質チェック
```

**2. 依存関係の互換性エラー**

```bash
# 依存関係を再構築
melos clean
melos bootstrap
melos run gen  # コード再生成
```

**3. テスト失敗時**

```bash
# 個別にテスト実行して問題を特定
mise run test
# 特定のパッケージのみテスト
melos exec --scope=app -- flutter test
```

### 設定変更時の注意点

- 設定変更後は次回の実行スケジュールで反映
- 即座に反映したい場合は手動でDependabot実行を起動
- グループ設定の変更は既存のPRには影響しない

## 参考リンク

- [Dependabot公式ドキュメント](https://docs.github.com/en/code-security/dependabot)
- [設定オプション一覧](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file)
- [Flutterプロジェクトでのベストプラクティス](https://docs.flutter.dev/deployment/continuous-delivery)
- [pub.dev依存関係管理](https://dart.dev/tools/pub/dependencies)
