# Flutter Template Project

**CLAUDE.md と README.md の1:1対応による GitHub Issues 統合 AI支援開発プラットフォーム**

## ドキュメント構造と関係性

このプロジェクトは、AIと人間の両方に対応した包括的なドキュメント体系を採用しています：

### CLAUDE.md - README.md 統合システム

```mermaid
graph TD
    A[CLAUDE.md] --> B[Claude Code処理]
    C[README.md] --> D[人間の理解]
    A -.->|1:1対応関係| C
    B --> E[自動開発]
    D --> F[手動レビュー]
    E --> G[品質保証]
    F --> G
    G --> H[GitHub Issues統合]
    H --> I[リリース準備]
```

### ドキュメント構成

| ファイル      | 目的                              | 読者       | 関係性 |
| ------------- | --------------------------------- | ---------- | ------ |
| **CLAUDE.md** | Claude Code用ワークフロー設定     | AIシステム | ←→     |
| **README.md** | 人間向けプロジェクト説明（本文書）| 開発チーム | ←→     |

**1:1対応の原則**: CLAUDE.mdの各セクションは、README.mdで対応する人間向け説明を持ちます。

### 言語設定

- **デフォルト言語**: Japanese（日本語）
- **README.md言語**: デフォルト言語設定に従い日本語で記述
- **多言語対応**: slang i18nシステムによる拡張可能

## プロジェクト概要

AI支援開発とモダンアーキテクチャを組み合わせた、GitHub Issues統合エンタープライズ対応Flutterアプリケーションテンプレートです。

### ドキュメント構造とAI統合システム

このプロジェクトは、AI支援開発と人間による開発の両方を最適化するための統合ドキュメントシステムを採用しています：

```mermaid
graph TD
    A[CLAUDE.md] --> B[Claude Code処理]
    C[README.md] --> D[人間の理解]
    A -.->|1:1対応関係| C
    B --> E[自動化開発]
    D --> F[手動レビュー]
    E --> G[品質保証]
    F --> G
    G --> H[リリース準備]
```

#### ドキュメント分担

| ファイル      | 対象者           | 内容                         | 言語   |
| ------------- | ---------------- | ---------------------------- | ------ |
| **CLAUDE.md** | Claude Code (AI) | ワークフロー、設定、技術指示 | 英語   |
| **README.md** | 開発者 (人間)    | プロジェクト概要、使用方法   | 日本語 |

#### 1:1対応原則

- CLAUDE.mdの各セクションは、README.mdの対応セクションで人間向けに説明
- 技術的な詳細は両方のファイルで一貫性を保持
- 変更時は両ファイルを同期更新

### 核となる特徴

- **🤖 AI支援開発**: Claude CodeとGitHub Issuesの統合による自動開発
- **📋 GitHub Issues統合**: ネイティブGitHub Issue管理による効率的なタスク処理
- **📦 モノレポ構造**: Melosによる効率的なパッケージ管理
- **🎯 型安全性**: Riverpod、go_router、slangによる堅牢なアーキテクチャ
- **⚡ 開発効率**: 自動コード生成と高速開発サイクル
- **🔍 高度な品質保証**: AI Review-First方式による多段階品質管理

## セットアップ

### 前提条件

- **Flutter SDK**: fvmによる管理
- **Git**: worktree対応版
- **GitHub CLI**: 認証済み環境
- **Node.js**: commitlint、prettier用
- **Claude Code**: バックグラウンドタスク有効化

### クイックスタート

```bash
# 1. プロジェクトを取得
git clone <repository-url>
cd flutter_template_project

# 2. 開発環境を構築
fvm install && fvm use
npm install
melos bootstrap

# 3. GitHub CLI認証（必須）
gh auth login

# 4. 環境変数設定
export ENABLE_BACKGROUND_TASKS=true
export TASK_MANAGEMENT_SYSTEM=github
export GITHUB_ACTIONS_CHECK=true

# 5. コード生成を実行
melos run gen

# 6. アプリを起動
cd app && fvm flutter run
```
## アーキテクチャ概要

### システム構成図

```mermaid
graph TB
    subgraph "GitHub Integration"
        A[GitHub Issues] --> B[Claude Code /task]
        B --> C[Git Worktree]
        C --> D[Isolated Development]
    end
    
    subgraph "Flutter Architecture"
        E[Riverpod State] --> F[Go Router Navigation]
        F --> G[Slang i18n]
        G --> H[UI Components]
    end
    
    subgraph "Quality Assurance Pipeline"
        I[AI Review Cycles] --> J[Static Analysis]
        J --> K[Automated Tests]
        K --> L[GitHub Actions]
        L --> M[Quality Gates]
    end
    
    D --> E
    A --> I
    M --> N[Production Release]
```

### 技術スタック

| 分野               | 技術                     | 役割                             |
| ------------------ | ------------------------ | -------------------------------- |
| **フレームワーク** | Flutter + FVM            | マルチプラットフォーム開発       |
| **状態管理**       | Riverpod + Hooks         | リアクティブな状態アーキテクチャ |
| **ナビゲーション** | go_router                | 型安全なルーティング             |
| **国際化**         | slang                    | コード生成による多言語対応       |
| **モノレポ**       | Melos                    | パッケージ統合管理               |
| **AI開発**         | Claude Code + GitHub Issues | 自動化された開発ワークフロー     |
| **品質管理**       | AI Review-First + GitHub Actions | 多段階品質保証システム |

## AI支援開発ワークフロー

### GitHub Issues統合プロセス

```mermaid
sequenceDiagram
    participant Dev as 開発者
    participant GitHub as GitHub Issues
    participant Claude as Claude Code
    participant Workspace as Git Worktree
    participant QA as 品質保証
    participant Actions as GitHub Actions
    
    Dev->>GitHub: Issue作成
    Dev->>Claude: /task #123
    Claude->>GitHub: Issue詳細取得
    Claude->>Workspace: 分離環境作成
    
    Note over Claude,QA: AI Review-First実装
    Claude->>QA: セキュリティレビュー
    Claude->>QA: アーキテクチャレビュー  
    Claude->>QA: パフォーマンスレビュー
    Claude->>QA: 最終検証
    
    Claude->>GitHub: PR作成
    GitHub->>Actions: CI/CDパイプライン実行
    Actions->>QA: 品質ゲート検証
    QA->>Dev: 完了通知
    Dev->>GitHub: Issue完了
```

### /task コマンドの使用方法

```bash
# インタラクティブモード
/task
? Select Issues to process: #123, #456

# 直接実行モード  
/task #123 #456

# 実行内容:
# ✅ GitHub Issue詳細の取得
# ✅ 分離された作業環境の作成
# ✅ AI Review-Firstによる実装
# ✅ 多段階品質保証の実行
# ✅ GitHub Actions統合
# ✅ 完了通知
```

## 品質管理システム

### AI Review-First品質保証パイプライン

```mermaid
sequenceDiagram
    participant Task as /task Command
    participant AI as AI Reviewer
    participant QA as Quality Assurance
    participant GitHub as GitHub API
    participant Actions as GitHub Actions
    participant Alert as Completion Alert

    Note over Task,Alert: 品質保証パイプラインプロセス

    Task->>GitHub: Issue #123 詳細取得
    Task->>AI: 最小実装生成
    
    rect rgb(255, 235, 238)
        Note over AI,QA: AI Review サイクル (3-4回)
        
        loop セキュリティレビュー
            AI->>QA: 脆弱性スキャン
            QA-->>AI: 高優先度問題検出
            AI->>AI: セキュリティ修正適用
        end
        
        loop アーキテクチャレビュー
            AI->>QA: SOLID原則検証
            QA-->>AI: 中優先度違反検出
            AI->>AI: アーキテクチャ修正
        end
        
        loop パフォーマンスレビュー
            AI->>QA: パフォーマンス分析
            QA-->>AI: 最適化機会発見
            AI->>AI: パフォーマンス改善
        end
    end
    
    Task->>GitHub: PR作成
    GitHub->>Actions: CI/CDパイプライン実行
    
    alt 全チェック成功
        Actions-->>GitHub: ✅ ワークフロー成功
        GitHub-->>Task: PR承認準備完了
    else チェック失敗
        Actions-->>GitHub: ❌ ワークフロー失敗
        GitHub->>Task: 失敗詳細
        Task->>QA: 自動修正実行
        QA->>Actions: 修正後再実行
    end
    
    Task->>Alert: 完了アラーム送信
    Alert-->>Task: ✅ 品質パイプライン完了
```

### 品質基準

#### セキュリティ（高優先度）
- ✅ ハードコードされたシークレットなし
- ✅ 入力値検証の実装
- ✅ セキュアなデータストレージ
- ✅ ネットワーク通信の暗号化

#### アーキテクチャ（中優先度）
- ✅ SOLID原則の遵守
- ✅ 適切なデザインパターンの使用
- ✅ 論理的なコード構成

#### パフォーマンス（低優先度）
- ✅ 明らかなボトルネックなし
- ✅ 効率的なアルゴリズムの使用
- ✅ リソース使用量の最適化

## 開発コマンド

### Melosコマンド（推奨）

```bash
# 依存関係管理
melos run get      # 依存関係の更新
melos run gen      # コード生成（riverpod、freezed等）

# 品質管理
melos run analyze  # 静的解析
melos run test     # テスト実行
melos run format   # コード整形
melos run ci:format # CI用フォーマットチェック

# 多言語対応
melos run analyze:slang # 翻訳キー検証
```

### 直接Flutterコマンド

```bash
# アプリケーション実行
cd app && fvm flutter run

# 個別テスト実行
cd app && fvm flutter test test/widget_test.dart

# ビルド
cd app && fvm flutter build apk
cd app && fvm flutter build ios --no-codesign
```

#### AI支援開発プロセス

```mermaid
sequenceDiagram
    participant Dev as 開発者
    participant Claude as Claude Code
    participant GitHub as GitHub Issues
    participant Git as Git Repository
    participant CI as GitHub Actions

    Dev->>Claude: /task #123
    Claude->>GitHub: Issue詳細取得
    GitHub->>Claude: 要件・受け入れ条件
    Claude->>Git: git worktree作成
    Claude->>Claude: AI Review-First実装
    loop 品質改善サイクル (3-4回)
        Claude->>Claude: コード実装
        Claude->>Claude: セキュリティレビュー
        Claude->>Claude: SOLID原則チェック
        Claude->>Claude: パフォーマンス最適化
    end
    Claude->>Git: コミット＆プッシュ
    Claude->>CI: PR作成・自動テスト
    CI->>Claude: 品質チェック結果
    Claude->>GitHub: ステータス更新
    Claude->>Dev: 完了通知
```

**特徴:**

- GitHub Issueの内容を解析し、自動実装
- AI品質レビューによる反復改善（3-4サイクル）
- 自動テスト実行とPR作成
- 並行開発のためのgit worktree活用
- セキュリティ・SOLID原則・パフォーマンスの体系的チェック

## プロジェクト構成

```
flutter_template_project/
├── 📱 app/                      # メインアプリケーション
│   ├── lib/                     # アプリケーションコード
│   │   ├── main.dart           # エントリーポイント
│   │   ├── pages/              # UIページ
│   │   ├── router/             # go_router設定
│   │   └── i18n/               # 多言語対応ファイル
│   ├── assets/i18n/            # 翻訳JSONファイル
│   └── test/                   # ウィジェットテスト
├── 📦 packages/                 # 共有パッケージ
├── 🤖 .claude-workspaces/       # AI開発用分離環境
├── 📋 CLAUDE.md                 # AI用プロジェクト設定
├── 📋 README.md                 # 人間用プロジェクト説明（本文書）
├── 🔧 scripts/                 # 自動化スクリプト
├── 🔧 .claude/                 # Claude Code設定
│   └── commands/
│       └── task.md             # GitHub Issue処理コマンド
└── 📚 docs/                    # 専用ドキュメント
    ├── CLAUDE_4_BEST_PRACTICES.md # AI設計原則
    ├── MELOS_SETUP.md          # Melos設定詳細
    ├── VSCODE_SETTINGS.md      # エディタ設定
    └── WORKTREE_ARCHITECTURE.md # 並列開発アーキテクチャ
```

## 自動化されたワークフロー

### Workflow 1: コード品質保証

**目的**: 全開発活動において一貫したコード品質を保証

**実行内容**:
1. `melos run analyze` - 静的解析
2. `melos run ci:format` - フォーマット検証
3. `melos run test` - 自動テスト
4. `melos run analyze:slang` - 翻訳検証

### Workflow 2: ドキュメント同期

**目的**: CLAUDE.mdと関連ドキュメントの整合性維持

### 品質管理パイプライン

```mermaid
flowchart LR
    subgraph "AI Review-First"
        A1[小さなドラフト作成]
        A2[批判的レビュー]
        A3[再生成・改善]
        A4[リリース判定]
        A1 --> A2 --> A3 --> A4
        A3 -.->|3-4サイクル| A2
    end

    subgraph "自動品質チェック"
        B1[静的解析<br/>dart analyze]
        B2[コード整形<br/>dart format]
        B3[自動テスト<br/>flutter test]
        B4[多言語検証<br/>slang check]
    end

    subgraph "CI/CD Pipeline"
        C1[GitHub Actions]
        C2[全品質チェック実行]
        C3[結果レポート]
        C4[マージ可否判定]
    end

    A4 --> B1
    B1 --> B2 --> B3 --> B4
    B4 --> C1 --> C2 --> C3 --> C4

    C4 -.->|失敗時| A2

    style A2 fill:#ffeb3b
    style C2 fill:#4caf50
    style C4 fill:#2196f3
```

### コード品質ツール

- **commitlint**: [Conventional Commits](https://conventionalcommits.org/)準拠
- **prettier**: YAML/Markdown自動フォーマット
- **dart analyze**: Flutter静的解析
- **自動テスト**: ユニット・ウィジェット・統合テスト
- **AI Review-First**: セキュリティ・SOLID原則・パフォーマンスの体系的評価

**実行内容**:
1. プロジェクト構造変更の監視
2. 自動更新による構造セクションの維持
3. Claude 4 Best Practices準拠の検証

### Workflow 3: 開発環境検証

**目的**: 適切な開発環境のセットアップと設定の保証

**実行内容**:
1. `fvm` Flutter バージョン検証
2. GitHub CLI 設定確認
3. `git worktree` サポート検証
4. 環境変数の妥当性確認

## ドキュメント体系

### 包括的ドキュメント構成

| ドキュメント                                         | 内容           | 対象者      | CLAUDE.md対応セクション |
| ---------------------------------------------------- | -------------- | ----------- | ----------------------- |
| [README.md](README.md)                               | プロジェクト概要| 開発者      | 全体構成                |
| [CLAUDE.md](CLAUDE.md)                               | AI開発設定     | Claude Code | 全体構成                |
| [docs/CLAUDE_4_BEST_PRACTICES.md](docs/CLAUDE_4_BEST_PRACTICES.md) | AI設計原則 | AI開発者 | AI Review-First |
| [docs/MELOS_SETUP.md](docs/MELOS_SETUP.md)         | モノレポ設定   | 開発者      | 開発コマンド            |
| [docs/VSCODE_SETTINGS.md](docs/VSCODE_SETTINGS.md) | エディタ設定   | 開発者      | 開発環境                |
| [docs/WORKTREE_ARCHITECTURE.md](docs/WORKTREE_ARCHITECTURE.md) | 並列開発 | AI開発者 | Git Worktree |
| [.claude/commands/task.md](.claude/commands/task.md) | Issue処理 | Claude Code | カスタムコマンド |

### Mermaid可視化の活用

このREADMEでは、以下の要素をMermaid記法で図式化しています：

1. **ドキュメント関係図**: CLAUDE.mdとREADME.mdの1:1対応関係
2. **システム構成図**: GitHub Issues統合アーキテクチャ全体の俯瞰
3. **AI開発フロー図**: GitHub Issues統合AI支援開発プロセスの可視化
4. **品質管理シーケンス図**: AI Review-First品質保証プロセスの詳細化

## 環境変数設定

### 必須設定

```bash
# Claude Code基本設定
export ENABLE_BACKGROUND_TASKS=true
export FLUTTER_VERSION_MANAGEMENT=fvm
export TASK_MANAGEMENT_SYSTEM=github

# GitHub統合設定
export GITHUB_ACTIONS_CHECK=true
export CHECK_PR_WORKFLOW="check-pr.yml"

# 並列開発設定
export PARALLEL_DEVELOPMENT=git_worktree
export CLAUDE_ISOLATION_MODE=true
export CLAUDE_WORKSPACE_DIR=".claude-workspaces"

# UI・通知設定
export PR_LANGUAGE=japanese
export COMPLETION_NOTIFICATION=alarm
export INTERACTIVE_MODE=true
export ISSUE_SELECTION_UI=enabled
```

## アーキテクチャ概要

### システム全体構成

```mermaid
graph TB
    subgraph "開発環境"
        IDE[VS Code + Extensions]
        Claude[Claude Code AI]
        Git[Git + Worktree]
    end

    subgraph "プロジェクト管理"
        GitHub[GitHub Issues]
        GitHubRepo[GitHub Repository]
        Actions[GitHub Actions]
    end

    subgraph "Flutter アプリケーション"
        App[メインアプリ]
        Packages[共有パッケージ]
        subgraph "アーキテクチャ層"
            UI[UI Layer - Pages/Widgets]
            State[State Layer - Riverpod]
            Domain[Domain Layer - Models]
            Data[Data Layer - Repositories]
        end
    end

    subgraph "品質管理"
        Tests[自動テスト]
        Lint[静的解析]
        Format[コード整形]
        I18n[多言語対応]
    end

    Claude <--> GitHub
    Claude <--> Git
    Claude <--> App
    Git <--> GitHubRepo
    GitHubRepo <--> Actions
    Actions <--> Tests
    Actions <--> Lint
    Actions <--> Format
    Actions <--> I18n

    UI --> State
    State --> Domain
    Domain --> Data
```

### 状態管理パターン

**Riverpod + Hooks** による宣言的UI：

```dart
@riverpod
class CounterNotifier extends _$CounterNotifier {
  @override
  int build() => 0;

  void increment() => state++;
}

// UI での使用
class CounterPage extends ConsumerWidget {
  Widget build(context, ref) {
    final count = ref.watch(counterNotifierProvider);
    return Text('Count: $count');
  }
}
```

### 国際化アプローチ

**slang** による型安全な多言語対応：

```dart
// assets/i18n/ja.i18n.json
{
  "welcome": "ようこそ",
  "settings": {
    "title": "設定"
  }
}

// UI での使用
Text(context.i18n.welcome)
Text(context.i18n.settings.title)
```

## テスト戦略

| テストレベル | 対象              | ツール           |
| ------------ | ----------------- | ---------------- |
| ユニット     | ビジネスロジック  | flutter_test     |
| ウィジェット | UI コンポーネント | flutter_test     |
| 統合         | ユーザーフロー    | integration_test |

```bash
# 全テスト実行
melos run test

# カバレッジ付き実行
melos run test --coverage
```

## ドキュメント体系

### 包括的ドキュメント構成

| ドキュメント                                         | 内容           | 対象者      | CLAUDE.md対応セクション |
| ---------------------------------------------------- | -------------- | ----------- | ----------------------- |
| [README.md](README.md)                               | プロジェクト概要| 開発者      | 全体構成                |
| [CLAUDE.md](CLAUDE.md)                               | AI開発設定     | Claude Code | 全体構成                |
| [docs/CLAUDE_4_BEST_PRACTICES.md](docs/CLAUDE_4_BEST_PRACTICES.md) | AI設計原則 | AI開発者 | AI Review-First |
| [docs/MELOS_SETUP.md](docs/MELOS_SETUP.md)         | モノレポ設定   | 開発者      | 開発コマンド            |
| [docs/VSCODE_SETTINGS.md](docs/VSCODE_SETTINGS.md) | エディタ設定   | 開発者      | 開発環境                |
| [docs/WORKTREE_ARCHITECTURE.md](docs/WORKTREE_ARCHITECTURE.md) | 並列開発 | AI開発者 | Git Worktree |
| [.claude/commands/task.md](.claude/commands/task.md) | Issue処理 | Claude Code | カスタムコマンド |
## 貢献方法

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/ISSUE-123`)
3. 変更をコミット (`git commit -m 'feat: add new feature [ISSUE-123]'`)
4. ブランチをプッシュ (`git push origin feature/ISSUE-123`)
5. プルリクエストを作成

### ブランチ命名規則

- **形式**: `feature/ISSUE-123` (Issue番号のみ)
- **禁止**: 日本語・英語での説明文追加は不可
- **理由**: 自動化されたワークフローとの整合性

## ライセンス

このプロジェクトは MIT ライセンスの下で公開されています。詳細は [LICENSE](LICENSE) を参照してください。

## サポート・コミュニティ

- 📖 [ドキュメント](docs/)
- 🐛 [Issue報告](https://github.com/your-org/flutter_template_project/issues)
- 💬 [ディスカッション](https://github.com/your-org/flutter_template_project/discussions)
- 🤖 [Claude Code統合ガイド](.claude/commands/task.md)

---

**CLAUDE.md と README.md の1:1対応により、AIと人間の両方に最適化されたGitHub Issues統合開発環境を提供します。**