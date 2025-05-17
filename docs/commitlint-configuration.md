# Commitlint 設定ガイド

このドキュメントでは、[commitlint](https://commitlint.js.org/)の設定オプションについて説明します。commitlintは、コミットメッセージが特定の形式に従っているかをチェックするツールです。

## 目次

1. [基本設定](#基本設定)
2. [設定ファイル](#設定ファイル)
3. [ルールの設定](#ルールの設定)
4. [共有設定](#共有設定)
5. [パーサープリセット](#パーサープリセット)
6. [フォーマッター](#フォーマッター)
7. [無視パターン](#無視パターン)
8. [プロンプト設定](#プロンプト設定)
9. [CLIオプション](#cliオプション)
10. [その他の設定](#その他の設定)

## 基本設定

commitlintの設定は、`commitlint.config.js`、`.commitlintrc.js`、`.commitlintrc.json`、`.commitlintrc.yml`ファイル、または`package.json`の`commitlint`フィールドに定義できます。

基本的な設定例：

```js
// commitlint.config.js
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      ['build', 'chore', 'ci', 'docs', 'feat', 'fix', 'perf', 'refactor', 'revert', 'style', 'test']
    ],
    'subject-case': [
      2,
      'never',
      ['upper-case']
    ]
  }
};
```

## 設定ファイル

commitlintの設定ファイルには、以下のオプションを含めることができます：

| オプション | 説明 | タイプ | デフォルト |
|------------|------|--------|------------|
| `extends` | 拡張する共有設定のリスト | `string[]` | `[]` |
| `parserPreset` | コミットメッセージのパース方法を定義するプリセット | `string` \| `object` | `undefined` |
| `formatter` | 結果のフォーマット方法 | `string` \| `function` | `@commitlint/format` |
| `rules` | ルールとその設定 | `object` | `{}` |
| `plugins` | プラグインのリスト | `string[]` | `[]` |
| `ignores` | 無視するコミットメッセージのパターン | `function[]` | `[]` |
| `defaultIgnores` | デフォルトの無視パターンを有効にするかどうか | `boolean` | `true` |
| `prompt` | プロンプト設定オブジェクト | `object` | `undefined` |
| `helpUrl` | ルール違反時に表示するヘルプURLへのリンク | `string` | `undefined` |

## ルールの設定

ルールは3つの要素からなる配列として設定されます：

1. **レベル**（必須）：
   - `0` - 無効
   - `1` - 警告
   - `2` - エラー

2. **適用条件**（必須）：
   - `always` - 常に適用
   - `never` - 適用しない

3. **値**（オプション）：ルールに応じたオプションの値

例：

```js
module.exports = {
  rules: {
    'header-max-length': [2, 'always', 72],
    'subject-case': [
      2,
      'never',
      ['sentence-case', 'start-case', 'pascal-case', 'upper-case']
    ]
  }
};
```

## 共有設定

共有設定は、`extends`オプションを使用して設定に含めることができます：

```js
module.exports = {
  extends: [
    '@commitlint/config-conventional',
    '@commitlint/config-lerna-scopes'
  ]
};
```

よく使われる共有設定：

- `@commitlint/config-conventional` - [Conventional Commits](https://www.conventionalcommits.org/)の規約に基づくルール
- `@commitlint/config-angular` - Angularのコミット規約に基づくルール
- `@commitlint/config-lerna-scopes` - Lernaパッケージをスコープとして使用するルール

## パーサープリセット

`parserPreset`オプションは、コミットメッセージをパースする方法をカスタマイズできます：

```js
module.exports = {
  parserPreset: {
    parserOpts: {
      headerPattern: /^(\w*)(?:\((.*)\))?!?: (.*)$/,
      headerCorrespondence: ['type', 'scope', 'subject'],
      issuePrefixes: ['#']
    }
  }
};
```

## フォーマッター

`formatter`オプションは、ルール違反時の出力形式をカスタマイズできます：

```js
module.exports = {
  formatter: '@commitlint/format'
};
```

## 無視パターン

特定のコミットメッセージを無視するルールを設定できます：

```js
module.exports = {
  ignores: [
    commit => commit.includes('WIP'),
    commit => commit.includes('作業中')
  ],
  defaultIgnores: true
};
```

## プロンプト設定

`prompt`オプションを使用して、対話的なコミットメッセージの作成をカスタマイズできます：

```js
module.exports = {
  prompt: {
    questions: {
      type: {
        description: 'コミットの種類を選択してください:',
        enum: {
          feat: {
            description: '新機能',
            title: 'Features',
            emoji: '✨'
          },
          fix: {
            description: 'バグ修正',
            title: 'Bug Fixes',
            emoji: '🐛'
          }
          // 他のタイプ...
        }
      }
      // 他の質問...
    }
  }
};
```

## CLIオプション

commitlintはコマンドラインから様々なオプションを指定して実行できます：

| オプション | 説明 |
|------------|------|
| `-c, --color` | カラー出力を切り替え（デフォルト: true） |
| `-g, --config` | 設定ファイルへのパス |
| `--print-config` | 解決された設定を表示 |
| `-d, --cwd` | 実行するディレクトリ |
| `-e, --edit` | 最後のコミットメッセージを指定されたファイルから読み取る |
| `-E, --env` | 環境変数の値で指定されたパスのファイルでメッセージをチェック |
| `-x, --extends` | 拡張する共有設定の配列 |
| `-H, --help-url` | エラーメッセージ内のヘルプURL |
| `-f, --from` | チェックするコミット範囲の下限 |
| `-l, --last` | 最後のコミットのみを分析 |
| `-o, --format` | 結果の出力形式 |
| `-p, --parser-preset` | conventional-commits-parserに使用する設定プリセット |
| `-q, --quiet` | コンソール出力を切り替え（デフォルト: false） |
| `-t, --to` | チェックするコミット範囲の上限 |
| `-V, --verbose` | 問題のないレポートの詳細出力を有効化 |
| `-s, --strict` | 厳格モードを有効化（警告は2、エラーは3の結果コード） |

## その他の設定

詳細は[commitlint公式ドキュメント](https://commitlint.js.org/reference/configuration.html)を参照してください。
