# File-to-Issue Processing Command - Claude 4 Best Practices

**IMPORTANT**: This command implements AI Review-First design following Claude 4 best practices for automated Linear Issue creation with GitHub Issue Template compliance.

## Overview

Convert bullet-point files into Linear Issues using AI Review-First methodology. This command reads local files, transforms content into structured GitHub ISSUE_TEMPLATE format, provides translation workflow, and creates Linear Issues automatically.

## Core Principles (Claude 4 Best Practices)

**Reference**: `docs/CLAUDE_4_BEST_PRACTICES.md` and `.github/ISSUE_TEMPLATE/feature.yml`

### AI Review-First Methodology

- **Pattern**: Small draft → Critical review → Regenerate → Release
- **Approach**: Use AI as "Senior Reviewer" not "Junior Designer"
- **Cycles**: 3-4 iterative review cycles for quality improvement
- **Priority**: Security (High) → SOLID Principles (Medium) → Performance (Low)

### Clear Instructions

- Eliminate ambiguity in file parsing and template conversion
- Define specific deliverables: structured Japanese content → GitHub template format → English translation → Linear Issue
- Provide structured review templates for content quality

### Structured Quality Assessment

Apply consistent evaluation framework:

```
1. Security vulnerabilities (HIGH PRIORITY) - File access, API credentials
2. SOLID principle violations (MEDIUM PRIORITY) - Command architecture
3. Performance optimization (LOW PRIORITY) - File processing speed
Constraint: Summarize findings within 400 characters
```

## Execution Modes

### Interactive Mode (No Arguments)

```bash
/file-to-issue
```

**Behavior**:

1. **Argument Validation**: Check if file path is provided
2. **Early Termination**: If no arguments, display "⏺ Please provide a file path as an argument" in red, skip "Update Todos" phase, and terminate immediately
3. **No further processing** when no arguments provided

### Direct Mode (With File Path)

```bash
/file-to-issue path/to/file.md
```

**Behavior**:

- **No confirmation prompts** - immediate execution
- Validate file path and accessibility
- Begin content transformation automatically
- Generate GitHub Issue Template compliant structure

## AI Review-First Processing Flow

### Phase 1: File Processing and Initial Conversion

**Objective**: Create structured Japanese content for review

**Actions**:

1. **File Access Validation**: Verify file exists and is readable
2. **Content Parsing**: Extract bullet points and structure
3. **Template Conversion**: Transform to GitHub ISSUE_TEMPLATE format in Japanese
4. **Initial Quality Check**: Validate content structure against feature.yml

**Quality Gate**: Well-formed Japanese GitHub ISSUE_TEMPLATE content

### Phase 2: Critical Review Cycles (3-4 Iterations)

**Review Template** (Use this exact format):

```
Please review the following file-to-issue conversion implementation.

Evaluation Categories:
1. Security vulnerabilities (high priority) - File access controls, API security
2. SOLID principle violations (medium priority) - Command architecture
3. Performance optimization opportunities (low priority) - File processing efficiency

Constraint: Provide specific, actionable feedback within 400 characters.
Focus on the highest priority issues first.
```

**Iterative Improvement Process**:

1. **Cycle 1**: Address ALL high priority security issues (file access, API credentials)
2. **Cycle 2**: Fix major SOLID principle violations in command architecture
3. **Cycle 3**: Optimize file processing performance within feasible scope
4. **Final Validation**: Human review of content quality and GitHub template compliance

**Quality Gates**:

- Security: Safe file access, secure API usage
- Architecture: Clean separation of concerns
- Performance: Efficient file processing
- **GitHub Template Compliance**: Proper feature.yml structure

### Phase 3: Translation and Issue Creation

**Actions**:

1. **Create Issue File**: Generate new file with `.issue.md` extension containing GitHub ISSUE_TEMPLATE format
2. **Human Approval**: Display Japanese content for "Approve" confirmation
3. **Translation Processing**: Convert Japanese to English using Claude 4
4. **Linear Issue Creation**: Create issue with English content
5. **Japanese Comment Addition**: Add original Japanese content as comment
6. **File Cleanup**: Remove created `.issue.md` file after successful processing

**Quality Gate**: Successfully created Linear Issue with both languages and GitHub template compliance

## Enhanced Core Workflow Implementation

### 1. File Reading and Validation

```typescript
// Enhanced security-first file access with path traversal prevention
import { resolve, relative, join, extname, isAbsolute } from 'path'
import { stat, readFile } from 'fs/promises'

const ALLOWED_EXTENSIONS = ['.md', '.txt', '.markdown']
const MAX_FILE_SIZE = 10 * 1024 * 1024 // 10MB
const WORK_DIRECTORY = process.env.WORK_DIRECTORY || '.claude-workspaces'

async function validateAndReadFile(filePath: string): Promise<string> {
  // Input sanitization - prevent null bytes and control characters
  if (!filePath || /[\x00-\x1f\x7f-\x9f]/.test(filePath)) {
    throw new SecurityError('Access denied: Invalid file path characters')
  }

  // Prevent directory traversal attacks
  const resolvedPath = resolve(filePath)
  const workDir = resolve(WORK_DIRECTORY)
  const relativePath = relative(workDir, resolvedPath)

  // Enhanced path validation - check for traversal and absolute paths
  if (
    relativePath.startsWith('..') ||
    isAbsolute(relativePath) ||
    relativePath.includes('..')
  ) {
    throw new SecurityError('Access denied: Path traversal attempt detected')
  }

  // Validate file extension using imported function
  const ext = extname(filePath).toLowerCase()
  if (!ALLOWED_EXTENSIONS.includes(ext)) {
    throw new ValidationError(`Unsupported file extension: ${ext}`)
  }

  // Check file size before reading
  const stats = await stat(resolvedPath)
  if (stats.size > MAX_FILE_SIZE) {
    throw new ValidationError(`File too large: ${stats.size} bytes`)
  }

  // Read with encoding validation
  return await readFile(resolvedPath, { encoding: 'utf8' })
}
```

### 2. Enhanced Content Structure Parsing

```typescript
// Parse bullet points into structured format
interface BulletPoint {
  level: number
  content: string
  children?: BulletPoint[]
}

// Single responsibility: Parse content only
class ContentParser {
  private readonly BULLET_PATTERNS = [/^[\s]*[-*+]\s/, /^[\s]*\d+\.\s/]

  async parseBulletPoints(content: string): Promise<BulletPoint[]> {
    // Performance optimization: Process lines in chunks for large files
    const lines = content.split('\n').filter(line => line.trim())

    if (lines.length > 1000) {
      // Process large files in chunks to prevent memory issues
      return this.buildHierarchyChunked(lines)
    }

    return this.buildHierarchy(lines)
  }

  private buildHierarchyChunked(lines: string[]): BulletPoint[] {
    const CHUNK_SIZE = 100
    const result: BulletPoint[] = []

    for (let i = 0; i < lines.length; i += CHUNK_SIZE) {
      const chunk = lines.slice(i, i + CHUNK_SIZE)
      const chunkResult = this.buildHierarchy(chunk)
      result.push(...chunkResult)
    }

    return result
  }

  private buildHierarchy(lines: string[]): BulletPoint[] {
    const result: BulletPoint[] = []
    const stack: BulletPoint[] = []

    for (const line of lines) {
      const level = this.getIndentLevel(line)
      const content = this.extractContent(line)

      if (!content) continue

      const point: BulletPoint = { level, content }
      this.insertIntoHierarchy(point, stack, result)
    }

    return result
  }

  private getIndentLevel(line: string): number {
    return (line.match(/^[\s]*/)?.[0].length || 0) / 2
  }

  private extractContent(line: string): string {
    // Input validation - prevent malicious patterns
    if (line.length > 10000) return '' // Prevent DoS via massive lines

    // Sanitize content - remove potential script injection patterns
    const cleaned = line
      .replace(this.BULLET_PATTERNS[0], '')
      .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '') // Remove script tags
      .replace(/javascript:/gi, '') // Remove javascript: URLs
      .trim()

    return cleaned.slice(0, 5000) // Enforce reasonable content length
  }

  private insertIntoHierarchy(
    point: BulletPoint,
    stack: BulletPoint[],
    result: BulletPoint[]
  ): void {
    // Pop items from stack that are at same or higher level
    while (stack.length > 0 && stack[stack.length - 1].level >= point.level) {
      stack.pop()
    }

    if (stack.length === 0) {
      // Top level item
      result.push(point)
    } else {
      // Child item
      const parent = stack[stack.length - 1]
      if (!parent.children) {
        parent.children = []
      }
      parent.children.push(point)
    }

    stack.push(point)
  }
}
```

### 3. GitHub ISSUE_TEMPLATE Conversion (Enhanced)

```typescript
// Convert to GitHub Issue template format
interface IssueTemplate {
  title: string
  description: string
  type: 'feature' | 'bugfix'
  priority: 'low' | 'medium' | 'high' | 'urgent'
}

// Abstract template converter for extensibility
abstract class TemplateConverter {
  abstract convert(bullets: BulletPoint[]): Promise<IssueTemplate>

  protected generateTitle(bullets: BulletPoint[]): string {
    return bullets[0]?.content || 'Untitled Issue'
  }

  protected detectType(content: string): 'feature' | 'bugfix' {
    const bugKeywords = [
      'bug',
      'fix',
      'error',
      'issue',
      'バグ',
      '修正',
      '不具合',
    ]
    return bugKeywords.some(keyword => content.toLowerCase().includes(keyword))
      ? 'bugfix'
      : 'feature'
  }

  protected inferPriority(
    bullets: BulletPoint[]
  ): 'low' | 'medium' | 'high' | 'urgent' {
    const urgentKeywords = ['urgent', '緊急', 'critical', '重大']
    const highKeywords = ['important', '重要', 'blocking', 'ブロッキング']
    const content = bullets
      .map(b => b.content)
      .join(' ')
      .toLowerCase()

    if (urgentKeywords.some(keyword => content.includes(keyword)))
      return 'urgent'
    if (highKeywords.some(keyword => content.includes(keyword))) return 'high'
    if (bullets.length > 5) return 'medium' // Complex issues get medium priority
    return 'low'
  }
}

// Enhanced GitHub template compliant converter
class GitHubFeatureTemplateConverter extends TemplateConverter {
  async convert(bullets: BulletPoint[]): Promise<IssueTemplate> {
    const title = this.generateTitle(bullets)
    const description = this.buildGitHubFeatureDescription(bullets)

    return {
      title,
      description,
      type: 'feature',
      priority: this.inferPriority(bullets),
    }
  }

  private buildGitHubFeatureDescription(bullets: BulletPoint[]): string {
    const mainContent = bullets[0]?.content || ''
    const details = bullets
      .slice(1)
      .map(b => b.content)
      .join('\n- ')

    return `## Feature Title
${mainContent}

## Context and Motivation

**Why is this feature needed?**
${this.inferBusinessContext(bullets)}

**User value:**
${this.inferUserValue(bullets)}

**Context:**
${this.inferTechnicalContext(bullets)}

## Detailed Requirements

### Functional Requirements:
- [ ] ${details}

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
- [ ] バックグラウンドタスクを有効化: \`ENABLE_BACKGROUND_TASKS=true\`
- [ ] 分離開発にgit worktreeを使用
- [ ] 完了時に日本語でPRを作成
- [ ] 完了確認のためにGitHub Actionsを監視

### Quality Assurance:
- [ ] コミット前に \`melos run analyze\` を実行
- [ ] コミット前に \`melos run test\` を実行
- [ ] コミット前に \`melos run format\` を実行
- [ ] 全てのCIチェックが成功することを確認

## Additional Context

**Expected Output Format:**
機能の詳細な説明、実装ガイドライン、テスト戦略を含む構造化されたLinear Issue`
  }

  private inferBusinessContext(bullets: BulletPoint[]): string {
    const content = bullets.map(b => b.content).join(' ')
    // Simple heuristics for business context
    if (content.includes('ユーザー') || content.includes('user')) {
      return 'ユーザー体験の向上とビジネス価値の実現のため'
    }
    if (content.includes('レビュー') || content.includes('review')) {
      return '開発効率の向上と品質の一貫性を実現するため'
    }
    return '開発効率の向上と品質の一貫性を実現するため'
  }

  private inferUserValue(bullets: BulletPoint[]): string {
    return '- 機能の利便性向上\n- 作業効率の改善\n- 品質の向上'
  }

  private inferTechnicalContext(bullets: BulletPoint[]): string {
    return '現在の実装では要件を満たすのが困難な状況にある'
  }
}

// Enhanced bugfix template converter
class GitHubBugfixTemplateConverter extends TemplateConverter {
  async convert(bullets: BulletPoint[]): Promise<IssueTemplate> {
    const title = this.generateTitle(bullets)
    const description = this.buildGitHubBugfixDescription(bullets)

    return {
      title,
      description,
      type: 'bugfix',
      priority: this.inferPriority(bullets),
    }
  }

  private buildGitHubBugfixDescription(bullets: BulletPoint[]): string {
    const mainContent = bullets[0]?.content || ''
    const details = bullets
      .slice(1)
      .map(b => b.content)
      .join('\n- ')

    return `## Bug Title
${mainContent}

## Problem Description

**What is the issue?**
${mainContent}

**Impact:**
- 機能の利用に支障をきたす
- ユーザー体験の悪化
- システムの信頼性低下

## Detailed Bug Report

### Current Behavior:
- [ ] ${details}

### Expected Behavior:
- [ ] 正常な動作が期待される
- [ ] エラーが発生しない
- [ ] 適切なフィードバックが提供される

### Steps to Reproduce:
- [ ] 具体的な再現手順を記載
- [ ] 環境情報を含める
- [ ] 発生条件を明確にする

## Technical Analysis

### Root Cause Analysis:
- [ ] 問題の原因を特定
- [ ] 影響範囲を調査
- [ ] 関連するコンポーネントを確認

### Fix Strategy:
- [ ] 修正方針の決定
- [ ] 副作用の検討
- [ ] テスト戦略の策定

## Quality Assurance

### Testing Requirements:
- [ ] バグ修正のユニットテスト
- [ ] 回帰テストの実施
- [ ] 統合テストの確認

### Validation Criteria:
- [ ] 問題が解決されている
- [ ] 新たな問題が発生していない
- [ ] パフォーマンスに影響がない`
  }
}

// Enhanced factory pattern
class TemplateConverterFactory {
  private static readonly converters = new Map<string, () => TemplateConverter>(
    [
      ['feature', () => new GitHubFeatureTemplateConverter()],
      ['bugfix', () => new GitHubBugfixTemplateConverter()],
    ]
  )

  static create(type: 'feature' | 'bugfix'): TemplateConverter {
    const converterFactory = this.converters.get(type)
    if (!converterFactory) {
      throw new ValidationError(`Unsupported template type: ${type}`)
    }
    return converterFactory()
  }

  static getSupportedTypes(): string[] {
    return Array.from(this.converters.keys())
  }
}
```

### 4. Enhanced Main Command Orchestrator

```typescript
// Enhanced main command orchestrator with proper error handling
class FileToIssueCommand {
  constructor(
    private fileValidator: FileValidator,
    private contentParser: ContentParser,
    private templateFactory: TemplateConverterFactory,
    private linearIntegration: LinearIntegration
  ) {}

  async execute(filePath?: string): Promise<string> {
    // Enhanced argument validation - exit early if no file path provided
    // Skip "Update Todos" phase and terminate immediately when path is empty
    if (!filePath || filePath.trim() === '') {
      console.log('\x1b[31m⏺ Please provide a file path as an argument\x1b[0m')
      console.log('📝 Skipping Update Todos phase due to missing file path')
      process.exit(0)
    }

    try {
      // Phase 1: Secure file processing
      console.log(`📖 Reading file: ${filePath}`)
      const content = await this.fileValidator.validateAndRead(filePath)

      // Phase 2: Content parsing
      const bullets = await this.contentParser.parseBulletPoints(content)
      console.log(`📋 Found ${bullets.length} bullet points`)

      // Phase 3: Template conversion
      console.log('🏗️ Converting to GitHub ISSUE_TEMPLATE format...')
      const templateType = this.detectTemplateType(bullets)
      const converter = this.templateFactory.create(templateType)
      const template = await converter.convert(bullets)

      // Phase 4: Create issue file
      const issueFilePath = await this.createIssueFile(filePath, template)

      // Phase 5: Human approval workflow
      const approved = await this.requestApproval(template)
      if (!approved) {
        // Cleanup issue file if user doesn't approve
        await this.fileValidator.cleanup(issueFilePath)
        throw new Error('Processing cancelled by user')
      }

      // Phase 6: Linear integration
      console.log('🌐 Translating to English...')
      console.log('📤 Creating Linear Issue...')
      const issueUrl = await this.linearIntegration.createLinearIssue(
        template,
        content
      )

      // Phase 7: Cleanup
      console.log('🗑️ Cleaning up issue file...')
      await this.fileValidator.cleanup(issueFilePath)

      console.log(`✅ Issue created: ${issueUrl}`)
      return issueUrl
    } catch (error) {
      this.handleError(error)
      throw error
    }
  }

  private async requestApproval(template: IssueTemplate): Promise<boolean> {
    console.log('📝 Generated Japanese Content:')
    console.log(`## ${template.title}\n`)

    // Show first few lines of description for preview
    const lines = template.description.split('\n')
    const preview = lines.slice(0, 10).join('\n')
    console.log(preview)
    if (lines.length > 10) {
      console.log('...')
    }

    console.log('\n✅ Content looks good? Type "Approve" to continue:')

    // Wait for user input
    const input = await this.getUserInput()
    return input.toLowerCase() === 'approve'
  }

  private async getUserInput(): Promise<string> {
    return new Promise(resolve => {
      const readline = require('readline')
      const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
      })

      rl.question('', (answer: string) => {
        rl.close()
        resolve(answer.trim())
      })
    })
  }

  private detectTemplateType(bullets: BulletPoint[]): 'feature' | 'bugfix' {
    const content = bullets.map(b => b.content).join(' ')
    const bugKeywords = [
      'bug',
      'fix',
      'error',
      'issue',
      'バグ',
      '修正',
      '不具合',
    ]
    return bugKeywords.some(keyword => content.toLowerCase().includes(keyword))
      ? 'bugfix'
      : 'feature'
  }

  private handleError(error: Error): void {
    console.error('❌ Error:', error.message)

    // Log error details for debugging (without sensitive info)
    if (error.name === 'SecurityError') {
      console.error('🔒 Security validation failed')
    } else if (error.name === 'ValidationError') {
      console.error('⚠️ Input validation failed')
    } else {
      console.error('💥 Unexpected error occurred')
    }
  }

  private async createIssueFile(
    originalPath: string,
    template: IssueTemplate
  ): Promise<string> {
    // Generate issue file path by adding .issue.md extension
    const parsedPath = path.parse(originalPath)
    const issueFilePath = path.join(
      parsedPath.dir,
      `${parsedPath.name}.issue.md`
    )

    // Create issue file content in GitHub ISSUE_TEMPLATE format
    const issueContent = template.description

    // Write issue file
    await writeFile(issueFilePath, issueContent, { encoding: 'utf8' })
    console.log(`📝 Created issue file: ${issueFilePath}`)

    return issueFilePath
  }
}
```

## Enhanced Security Requirements

### File Access Controls

- **Path Validation**: Only allow files within project directory
- **Extension Whitelist**: `.md`, `.txt`, `.markdown` files only
- **Size Limits**: Maximum 10MB file size
- **Permission Check**: Verify read permissions before access
- **Input Sanitization**: Prevent null bytes and control characters

### API Security

- **Credential Management**: Use environment variables for Linear API keys
- **Rate Limiting**: Respect Linear API rate limits
- **Error Handling**: No sensitive data in error messages
- **Input Sanitization**: Clean content before API calls
- **Content Validation**: Validate translation results

## Error Handling and Recovery

### File Access Errors

```bash
/file-to-issue nonexistent.md
❌ Error: File 'nonexistent.md' not found
💡 Use relative or absolute path to accessible file
```

### No Arguments Error

```bash
/file-to-issue
⏺ Please provide a file path as an argument
📝 Skipping Update Todos phase due to missing file path
```

### Translation Failures

```bash
❌ Translation failed: API rate limit exceeded
🔧 Retrying in 60 seconds...
📋 Will save progress and resume automatically
```

## Completion Criteria

### 1. AI Review-First Standards

- ✅ **3-4 review cycles completed successfully**
- ✅ **Security**: Path traversal protection, input sanitization, credential management
- ✅ **SOLID Principles**: Clean separation of concerns, extensible factory pattern
- ✅ **Performance**: Chunked processing for large files, translation caching, early termination

### 2. Functional Requirements

- ✅ **File Reading**: Secure file access with proper validation
- ✅ **Content Parsing**: Accurate bullet point structure extraction
- ✅ **Template Conversion**: GitHub ISSUE_TEMPLATE format generation
- ✅ **Translation**: High-quality Japanese to English conversion
- ✅ **Linear Integration**: Successful Issue creation with bilingual content
- ✅ **Issue File Creation**: Generate `.issue.md` file with proper format
- ✅ **File Cleanup**: Safe removal of created `.issue.md` files

### 3. Quality Standards

- ✅ **Error Handling**: Comprehensive error recovery mechanisms
- ✅ **User Experience**: Clear progress indication and feedback
- ✅ **GitHub Template Compliance**: Proper feature.yml structure adherence

## Usage Examples

### Basic File Processing

```bash
/file-to-issue tasks.md

📖 Reading file: tasks.md
📋 Found 5 bullet points
🏗️ Converting to GitHub ISSUE_TEMPLATE format...
📝 Created issue file: tasks.issue.md

📝 Generated Japanese Content:
## タイトル
新機能：ユーザー認証システム

## Context and Motivation
...

✅ Content looks good? Type 'Approve' to continue: Approve

🌐 Translating to English...
📤 Creating Linear Issue...
🗑️ Cleaning up issue file...

✅ Issue created: https://linear.app/team/issue/ABC-123
```

### No Arguments Example

```bash
/file-to-issue

⏺ Please provide a file path as an argument
📝 Skipping Update Todos phase due to missing file path
```

## Best Practices and Limitations

### Optimal Use Cases

- **Structured bullet-point files** with clear hierarchy
- **Japanese content** requiring English translation
- **Feature requests** and bug reports in bullet format
- **Planning documents** needing GitHub Issue Template format

### Limitations

- **Large files** (>10MB) require manual splitting
- **Complex formatting** may need manual adjustment
- **Non-standard bullet formats** may not parse correctly
- **API rate limits** may cause temporary delays

### Success Factors

1. **Clear bullet-point structure** with consistent indentation
2. **Meaningful content** with sufficient detail for Issues
3. **Proper file permissions** for read access
4. **Valid Linear API configuration** for Issue creation
5. **GitHub Issue Template compliance** for structured output

## Configuration Requirements

### Environment Variables

```bash
export LINEAR_API_KEY="your_linear_api_key"
export LINEAR_TEAM_ID="your_team_id"
export FILE_SIZE_LIMIT_MB=10
export ALLOWED_FILE_EXTENSIONS=".md,.txt,.markdown"
export WORK_DIRECTORY=".claude-workspaces"
```

### File Structure Requirements

```
project-root/
├── .claude/
│   └── commands/
│       └── file-to-issue.md
├── .github/
│   └── ISSUE_TEMPLATE/
│       └── feature.yml
├── docs/
│   └── CLAUDE_4_BEST_PRACTICES.md
├── .env (for API keys)
└── allowed-files/ (for file access validation)
```

---

**Note**: This enhanced command prioritizes GitHub Issue Template compliance, implements Claude 4 best practices throughout, and provides comprehensive error handling with secure file processing.
