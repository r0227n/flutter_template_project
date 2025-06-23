# Commitlint YAML設定ガイド

このプロジェクトでは、commitlintの設定をYAML形式で管理しています。YAML形式を採用することで、設定の可読性と保守性が向上し、より直感的な設定管理が可能になります。

## 設定ファイル

### `.commitlintrc.yml`

プロジェクトルートに配置された`.commitlintrc.yml`ファイルがcommitlintの設定を定義しています。

```yaml
extends:
  - '@commitlint/config-conventional'

rules:
  type-enum:
    - 2
    - always
    - - build
      - chore
      - ci
      - docs
      - feat
      - fix
      - perf
      - refactor
      - revert
      - style
      - test
  subject-case:
    - 2
    - never
    - - upper-case
```

## 設定の説明

### extends（拡張設定）

```yaml
extends:
  - '@commitlint/config-conventional'
```

- **`@commitlint/config-conventional`**: Conventional Commitsの標準的なルールセットを読み込みます
- この設定により、一般的なコミットメッセージの規則が自動的に適用されます

### rules（カスタムルール）

#### type-enum（許可されるタイプ）

```yaml
type-enum:
  - 2 # エラーレベル（2 = error）
  - always # 常に適用
  - - build
    - chore
    - ci
    - docs
    - feat
    - fix
    - perf
    - refactor
    - revert
    - style
    - test
```

**設定値の説明：**

- **レベル**: `2` （エラー）- ルール違反時にコミットを拒否
- **条件**: `always` - 常にこのルールを適用
- **値**: 許可されるコミットタイプのリスト

#### subject-case（件名の大文字小文字）

```yaml
subject-case:
  - 2 # エラーレベル（2 = error）
  - never # 指定した形式を禁止
  - - upper-case # 大文字での開始を禁止
```

**設定値の説明：**

- **レベル**: `2` （エラー）- ルール違反時にコミットを拒否
- **条件**: `never` - 指定した形式を禁止
- **値**: `upper-case` - コミット件名の大文字での開始を禁止

## YAML形式の利点

### 1. 可読性の向上

**JavaScript形式（従来）:**

```javascript
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [2, 'always', ['build', 'chore', 'ci']],
  },
}
```

**YAML形式（現在）:**

```yaml
extends:
  - '@commitlint/config-conventional'
rules:
  type-enum:
    - 2
    - always
    - - build
      - chore
      - ci
```

### 2. 設定の階層化

YAML形式では、ネストした設定が視覚的に理解しやすくなります。

### 3. コメントの記述

```yaml
extends:
  - '@commitlint/config-conventional'

rules:
  # コミットタイプの制限
  type-enum:
    - 2 # エラーレベル
    - always # 常に適用
    - - build # ビルド関連
      - chore # その他
      - ci # CI/CD関連
      # ... 以下省略

  # 件名の大文字小文字制御
  subject-case:
    - 2 # エラーレベル
    - never # 禁止
    - - upper-case # 大文字開始を禁止
```

## 設定ファイルの優先順位

commitlintは以下の順序で設定ファイルを検索します：

1. `.commitlintrc.yml` ← **現在使用中**
2. `.commitlintrc.yaml`
3. `.commitlintrc.json`
4. `.commitlintrc.js`
5. `commitlint.config.js`
6. `package.json`の`commitlint`セクション

## カスタムルールの追加例

### 件名の長さ制限

```yaml
rules:
  subject-max-length:
    - 2
    - always
    - 50 # 50文字以内
```

### スコープの必須化

```yaml
rules:
  scope-empty:
    - 2
    - never # スコープを必須にする
```

### 日本語対応

```yaml
rules:
  subject-case:
    - 0 # 日本語使用時は大文字小文字チェックを無効化
```

## 検証とテスト

### ローカルでの検証

```bash
# 特定のメッセージを検証
echo "feat: 新機能追加" | npx commitlint

# 最新のコミットメッセージを検証
npx commitlint --from HEAD~1 --to HEAD --verbose
```

### 設定の妥当性確認

```bash
# 設定ファイルの構文チェック
npx commitlint --print-config
```

## トラブルシューティング

### よくある問題

1. **YAML構文エラー**

   - インデントが正しいか確認
   - タブではなくスペースを使用

2. **ルール設定エラー**

   - エラーレベル（0, 1, 2）の設定確認
   - 条件（always, never）の設定確認

3. **設定が反映されない**
   - キャッシュのクリア: `rm -rf node_modules/.cache`
   - 他の設定ファイルとの競合確認

## まとめ

YAML形式でのcommitlint設定により、以下のメリットが得られます：

- **可読性の向上**: 設定内容が一目で理解できる
- **保守性の向上**: 設定の追加・修正が容易
- **コメント対応**: 設定の説明を直接記述可能
- **標準化**: 多くのツールがYAMLを採用している

この設定により、プロジェクト全体でのコミットメッセージ品質が向上し、開発チーム全体での一貫性が保たれます。
