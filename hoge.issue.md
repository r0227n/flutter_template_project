## Feature Title

Claude CodeのSlash commandを作成してください

## Context and Motivation

**Why is this feature needed?**
開発効率の向上と品質の一貫性を実現するため

**User value:**

- 機能の利便性向上
- 作業効率の改善
- 品質の向上

**Context:**
現在の実装では要件を満たすのが困難な状況にある

## Detailed Requirements

### Functional Requirements:

- [ ] セッション内で入力および出力された内容で一般的ではない単語をリストアップし、xml形式でファイルに書き出してください

### Non-Functional Requirements:

- [ ] レスポンス時間: 2秒以内
- [ ] クロスプラットフォーム対応（iOS/Android）
- [ ] アクセシビリティ対応（WCAG 2.1 AA準拠）

### Security Requirements:

- [ ] 入力値検証の実装
- [ ] 適切なエラーハンドリング
- [ ] セキュリティテストの実施

## Technical Constraints and Guidelines

### Technology Stack:

- [ ] プロジェクトのFlutter + Riverpodアーキテクチャに準拠
- [ ] 既存のgo_routerナビゲーションを活用
- [ ] slang i18nシステムとの統合
- [ ] SOLID原則の遵守

### Code Standards:

- [ ] 包括的なユニットテストを含む
- [ ] UIコンポーネントのウィジェットテスト
- [ ] 既存のコード規約に従う
- [ ] 適切なエラーハンドリングを含む

## AI Review-First Quality Criteria

### Review Categories (Priority Order):

**High Priority - Security:**

- [ ] セキュリティ脆弱性の排除（SQLインジェクション、XSS等）
- [ ] 適切な入力値検証とサニタイゼーション
- [ ] 認証・認可の適切な実装
- [ ] 機密データの適切な取り扱い

**Medium Priority - SOLID Principles:**

- [ ] 単一責任原則の遵守
- [ ] 開放閉鎖原則の適用
- [ ] 依存性注入の適切な実装
- [ ] インターフェース分離の実現

**Low Priority - Performance:**

- [ ] 効率的な状態管理
- [ ] 最小限の再レンダリング・リビルド
- [ ] 適切なメモリ管理
- [ ] 最適化されたネットワークリクエスト

### Review Constraints:

- Each review summary: ≤ 400 characters
- 3-4 review cycles maximum
- Human final validation required

## Acceptance Criteria

### Core Functionality:

- [ ] 主要機能が正常に動作する
- [ ] ユーザーインターフェースが直感的である
- [ ] エラーケースが適切に処理される

### Quality Gates:

- [ ] 全ての自動テストが成功（ユニット、ウィジェット、統合）
- [ ] 静的解析（dart analyze）が成功
- [ ] コードフォーマット（dart format）が適用済み
- [ ] AIレビューサイクルが完了（3-4回の反復）
- [ ] セキュリティレビューが承認
- [ ] パフォーマンスベンチマークが達成
- [ ] アクセシビリティ要件が満たされる

### Documentation:

- [ ] APIドキュメントが更新済み
- [ ] ユーザーガイドが更新済み（該当する場合）
- [ ] 複雑なロジックにコードコメントが追加済み

## Testing Strategy

### Test Types Required:

- [ ] ビジネスロジックのユニットテスト
- [ ] UIコンポーネントのウィジェットテスト
- [ ] クリティカルフローの統合テスト
- [ ] セキュリティテスト

### Test Coverage Goals:

- [ ] ビジネスロジック: 90%+
- [ ] UIコンポーネント: 80%+
- [ ] クリティカルパス: 100%

### Manual Testing:

- [ ] クロスプラットフォーム互換性（iOS/Android）
- [ ] スクリーンリーダーでのアクセシビリティテスト
- [ ] 負荷テスト

## Claude Code Implementation Instructions

### Implementation Approach:

- [ ] AIレビューファースト設計を使用: 小さなドラフト → 厳しい批評 → 再生成 → リリース
- [ ] セキュリティ → SOLID → パフォーマンスに焦点を当てた3-4回のレビューサイクル
- [ ] 最初に最小限の動作実装を作成
- [ ] 包括的なエラーハンドリングを含む
- [ ] プロジェクトのRiverpod + go_routerパターンに従う

### Automation Settings:

- [ ] バックグラウンドタスクを有効化: `ENABLE_BACKGROUND_TASKS=true`
- [ ] 分離開発にgit worktreeを使用
- [ ] 完了時に日本語でPRを作成
- [ ] 完了確認のためにGitHub Actionsを監視

### Quality Assurance:

- [ ] コミット前に `melos run analyze` を実行
- [ ] コミット前に `melos run test` を実行
- [ ] コミット前に `melos run format` を実行
- [ ] 全てのCIチェックが成功することを確認

## Additional Context

**Expected Output Format:**
機能の詳細な説明、実装ガイドライン、テスト戦略を含む構造化されたLinear Issue
