# Claude 4 プロンプトエンジニアリング ベストプラクティス

Claude 4を「シニアレビュアー」として活用し、高品質なFlutterアプリケーション開発を実現するための実践的なガイドです。

## 参照文献

- [Claude 4 Best Practices (Anthropic公式)](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/claude-4-best-practices)
- [AIレビューファースト設計 (Zenn)](https://zenn.dev/caphtech/articles/ai-review-first-design)

## 概要：AIレビューファースト設計

LLM（大規模言語モデル）は、コードを一から生成するよりも既存のコードを批評・レビューする方が効果的です。

### 核心原則

**「小さなドラフト → 厳しい批評 → 再生成 → リリース」**

- AIを「ジュニア設計者」ではなく「シニアレビュアー」として活用
- 3〜4回の反復レビューサイクルで品質向上
- セキュリティ → SOLID原則 → パフォーマンスの優先順位

## 1. 開発ワークフロー

### 基本サイクル

```mermaid
flowchart LR
    A[最小実装] --> B[AIレビュー]
    B --> C[改善実装]
    C --> D{品質OK?}
    D -->|No| B
    D -->|Yes| E[リリース]

    classDef start fill:#e1f5fe
    classDef review fill:#f3e5f5
    classDef end fill:#e8f5e8

    class A start
    class B,C review
    class E end
```

### Flutterプロジェクトでの実装ステップ

1. **最小実装**: 基本機能のみを実装
2. **AIレビュー**: 構造化されたレビューテンプレートを使用
3. **反復改善**: 優先度順に問題を修正
4. **品質確認**: `melos run analyze` でコード品質チェック
5. **リリース準備**: ドキュメント更新と最終テスト

## 2. プロンプトエンジニアリング原則

### 明確で具体的な指示

❌ **悪い例**

```text
Flutterウィジェットを作成して
```

✅ **良い例**

```text
Riverpodとhooks_riverpodを使用してユーザー設定画面を作成してください。
要件:
- ThemeMode切り替え（light/dark/system）
- 言語選択（日本語/英語）
- SharedPreferencesで設定永続化
- slangによる多言語対応
- Material Design 3準拠
```

### コンテキストの重要性

指示の背景と制約を明確にすることで、プロジェクト固有の最適な実装が得られます。

### 実例の効果的活用

- 既存コードの参照を促す
- プロジェクトの命名規則を示す
- アーキテクチャパターンを具体例で説明

## 主要な戦略

### 1. クリティカルレビューテンプレートの活用

_参照元: https://zenn.dev/caphtech/articles/ai-review-first-design#critical-review-template_

```text
以下のコードをレビューしてください。

評価カテゴリ:
1. セキュリティ脆弱性 (高優先度)
2. SOLID原則違反 (中優先度)
3. パフォーマンス最適化 (低優先度)

制約: 400文字以内で要約
```

### 2. レスポンスフォーマットの制御

_参照元: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/claude-4-best-practices#controlling-response-formatting_

#### やるべきことを伝える（避けるべきことではなく）

**悪い例:**

```text
長い説明は避けてください
```

**良い例:**

```text
3行以内で説明してください
```

#### XMLタグを使用して形式を示す

```xml
<response>
  <summary>簡潔な要約</summary>
  <details>詳細な説明</details>
</response>
```

#### プロンプトスタイルを出力スタイルに合わせる

プロンプトの書き方（フォーマル/カジュアル）が出力スタイルに影響します。

### 3. 思考能力を活用する

_参照元: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/claude-4-best-practices#leverage-thinking-capabilities_

マルチステップの推論と反映を促すプロンプトを使用します。

```text
ツール結果受領後:
1. 品質を評価
2. 問題点を特定
3. 次のアクションを決定
```

### 4. ツール使用の最適化

_参照元: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/claude-4-best-practices#optimize-for-tool-use_

#### 並列ツール呼び出しを促す

```text
# 並列実行で最大効率化
関連ツールを同時呼び出し
```

### 5. フロントエンドとコード生成

_参照元: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/claude-4-best-practices#frontend-and-code-generation_

#### 明確な奨励を提供する

- 「可能な限り多くの関連機能を含めてください」などの修飾子を使用
- ホバー状態、トランジション、アニメーションなど特定のデザイン要素を要求

```text
ダッシュボード要件:
✓ hover時の視覚フィードバック
✓ 300ms以内のアニメーション
✓ モバイル/タブレット/PC対応
✓ WCAG 2.1 AA準拠
```

### 6. テストへの過度な焦点を避ける

_参照元: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/claude-4-best-practices#avoid-overfocusing-on-tests_

- ロバストで汎用的なソリューションの作成を強調
- 問題要件の理解に焦点を当てる
- 原則に基づいた保守可能なコードの実装

## AIレビューファースト設計の実践

_参照元: https://zenn.dev/caphtech/articles/ai-review-first-design#implementation-strategy_

### 実装戦略

1. **高リスク領域に初期フォーカス**

   - セキュリティ関連のコード
   - パフォーマンスクリティカルな部分
   - ビジネスロジックのコア部分

2. **反復レビューのベストプラクティス**
   - レビューサイクルは3〜4回が最適
   - 各レビューは400文字以内に制限
   - 常に人間による最終検証を実施
   - バージョン固有の参照を使用

```mermaid
graph TB
    A[初期コード] --> B[1回目レビュー]
    B --> C[高優先度問題修正]
    C --> D[2回目レビュー]
    D --> E[中優先度問題修正]
    E --> F[3回目レビュー]
    F --> G[低優先度問題修正]
    G --> H{品質基準達成?}
    H -->|No| I[4回目レビュー]
    I --> J[最終調整]
    H -->|Yes| K[人間による最終検証]
    J --> K
    K --> L[リリース準備完了]

    style A fill:#fbb,stroke:#333,stroke-width:2px
    style K fill:#bbf,stroke:#333,stroke-width:2px
    style L fill:#bfb,stroke:#333,stroke-width:2px
```

### 制限事項の認識

_参照元: https://zenn.dev/caphtech/articles/ai-review-first-design#limitations_

AIレビューファースト設計が効果的でないケース：

- 1000行以上の複雑なシステム設計
- ドメイン固有の技術コンテキスト
- 最先端技術領域

## 実践的なヒント

### 効果的なプロンプトの構造

```yaml
structure:
  context: 'プロジェクト背景と制約'
  goal: '明確な成果物'
  requirements:
    - 機能要件
    - 非機能要件
  output_format: 'JSON/Markdown/Code'
  quality_criteria:
    - テストカバレッジ
    - パフォーマンス指標
```

### よくある落とし穴と回避方法

1. **曖昧な指示**

   - 避ける: 「良いコードを書いて」
   - 使用する: 「SOLID原則に従い、適切なエラーハンドリングとドキュメントを含むコードを書いて」

2. **否定的な指示**

   - 避ける: 「バグのあるコードを書かないで」
   - 使用する: 「テスト済みでエラーハンドリングが適切なコードを書いて」

3. **コンテキスト不足**
   - 避ける: 「関数を作成して」
   - 使用する: 「ユーザー認証のための関数を作成して。JWT トークンを使用し、セキュリティベストプラクティスに従ってください」

## 実例: AIレビューファーストプロンプト

### コード生成とレビューの組み合わせ

```python
# ステップ1: 最小実装
"""
JWTベースのユーザー認証機能を実装してください。
必須機能のみ: login(), logout(), verify_token()
"""

# ステップ2: AIレビュー
"""
セキュリティ観点でコードをレビュー:
- SQLインジェクション対策
- トークン有効期限検証
- パスワードハッシュ化

400文字以内で要約。
"""

# ステップ3: 改善実装
"""
高優先度のセキュリティ問題を修正。
"""
```

## Claude 4活用の全体ワークフロー

```mermaid
flowchart LR
    A[要件定義] --> B[プロンプト設計]
    B --> C{アプローチ選択}

    C -->|シンプルなタスク| D[直接生成]
    C -->|複雑なタスク| E[AIレビューファースト]

    D --> F[出力確認]

    E --> G[初期ドラフト作成]
    G --> H[AIレビュー実施]
    H --> I[フィードバック反映]
    I --> J{品質OK?}
    J -->|No| H
    J -->|Yes| K[最終出力]

    F --> L[人間による検証]
    K --> L

    style A fill:#f9f,stroke:#333,stroke-width:2px
    style E fill:#bbf,stroke:#333,stroke-width:2px
    style L fill:#bfb,stroke:#333,stroke-width:2px
```

## まとめ

Claude 4を最大限に活用するためには：

1. **AIレビューファースト設計**を採用し、AIを「シニアレビュアー」として活用
2. **明確で具体的な指示**を提供する
3. **構造化されたレビューテンプレート**を使用する
4. **反復的な改善サイクル**（3〜4回）を実施
5. **制限事項を理解**し、適切なケースで使用する
6. **人間による最終検証**を必ず実施する

「小さなドラフト → 厳しい批評 → 再生成 → リリース」のサイクルが、高品質な成果物を生み出す鍵です。
