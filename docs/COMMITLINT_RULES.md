# Commitlint ルール

このプロジェクトでは、[Conventional Commits](https://www.conventionalcommits.org/)の仕様に基づいたコミットメッセージの形式を採用しています。これにより、コミット履歴が読みやすくなり、自動的にセマンティックバージョニングを生成することが可能になります。

## コミットメッセージの形式

コミットメッセージは以下の形式に従う必要があります：

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### 構成要素

1. **type（必須）**: コミットの種類を示します。
2. **scope（任意）**: コミットの影響範囲を示します（例：コンポーネント名、ファイル名など）。
3. **description（必須）**: コミットの簡潔な説明。
4. **body（任意）**: コミットの詳細な説明。
5. **footer（任意）**: 破壊的変更（BREAKING CHANGE）の注記や、Issueへの参照など。

## 使用可能なタイプ

このプロジェクトでは、以下のタイプを使用できます：

| タイプ     | 説明                                                                                      |
| ---------- | ----------------------------------------------------------------------------------------- |
| `build`    | ビルドシステムまたは外部依存関係に影響する変更（例：npm、cargo、yarn、gradle など）       |
| `chore`    | その他の変更（ソースやテストの変更を含まない）                                            |
| `ci`       | CI設定ファイルとスクリプトの変更（例：GitHub Actions、Travis、Circle、BrowserStack など） |
| `docs`     | ドキュメントのみの変更                                                                    |
| `feat`     | 新機能の追加                                                                              |
| `fix`      | バグ修正                                                                                  |
| `perf`     | パフォーマンスを向上させるコード変更                                                      |
| `refactor` | バグを修正せず、機能も追加しないコード変更（リファクタリング）                            |
| `revert`   | 以前のコミットを元に戻す                                                                  |
| `style`    | コードの意味に影響しない変更（空白、フォーマット、セミコロンの欠落など）                  |
| `test`     | 不足しているテストの追加または既存のテストの修正                                          |

## 使用例

### 機能追加

```
feat: ユーザー認証機能の追加
```

```
feat(auth): ログイン画面を実装
```

### バグ修正

```
fix: ナビゲーションバーのスクロール問題を修正
```

```
fix(ui): ダークモードでのテキスト色問題を修正
```

### ドキュメント更新

```
docs: READMEにインストール手順追加
```

```
docs(api): APIエンドポイントの使用例を更新
```

### リファクタリング

```
refactor: ユーザーサービスのコードを整理
```

```
refactor(state): Riverpodプロバイダーの構造を改善
```

### 破壊的変更を含むコミット

```
feat!: APIレスポンス形式の変更

BREAKING CHANGE: APIレスポンスの形式が変更されました。
古い形式: { data: [...] }
新しい形式: { items: [...], meta: {...} }
```

## コミットメッセージの検証

このプロジェクトでは、コミットメッセージが上記のルールに従っているかを自動的に検証するために、[commitlint](https://commitlint.js.org/)を使用しています。コミットメッセージがルールに違反している場合、コミットは拒否されます。

### ローカルでの検証

コミットする前にメッセージを検証するには：

```bash
npx commitlint --edit
```

## 推奨事項

- コミットメッセージは**命令形**で書きましょう（例：「追加する」ではなく「追加」）
- 最初の文字は**小文字**にしましょう
- 末尾にピリオドを付けないようにしましょう
- 説明は簡潔に、50文字以内に収めるようにしましょう
- 詳細な説明が必要な場合は、空行を挟んでbodyに記述しましょう

## 参考リンク

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Angular Commit Message Guidelines](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#commit)
- [Commitlint](https://commitlint.js.org/)
