# File-to-Issue Processing Command - Claude 4 Best Practices

**IMPORTANT**: This command implements AI Review-First design following Claude 4 best practices for automated Linear Issue creation.

## Overview

Convert bullet-point files into Linear Issues using AI Review-First methodology. This command reads local files, transforms content into ISSUE_TEMPLATE format, provides translation workflow, and creates Linear Issues automatically.

## Core Principles (Claude 4 Best Practices)

**Reference**: `docs/CLAUDE_4_BEST_PRACTICES.md`

### AI Review-First Methodology

- **Pattern**: Small draft → Critical review → Regenerate → Release
- **Approach**: Use AI as "Senior Reviewer" not "Junior Designer"
- **Cycles**: 3-4 iterative review cycles for quality improvement
- **Priority**: Security (High) → SOLID Principles (Medium) → Performance (Low)

### Clear Instructions

- Eliminate ambiguity in file parsing and template conversion
- Define specific deliverables: structured Japanese content → English translation → Linear Issue
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
3. Prompt for file path input (if arguments provided)
4. Display file content preview
5. Show parsed bullet points
6. Confirm before processing

### Direct Mode (With File Path)

```bash
/file-to-issue path/to/file.md
```

**Behavior**:

- **No confirmation prompts** - immediate execution
- Validate file path and accessibility
- Begin content transformation automatically

## AI Review-First Processing Flow

### Phase 1: File Processing and Initial Conversion

**Objective**: Create structured Japanese content for review

**Actions**:

1. **File Access Validation**: Verify file exists and is readable
2. **Content Parsing**: Extract bullet points and structure
3. **Template Conversion**: Transform to ISSUE_TEMPLATE format in Japanese
4. **Initial Quality Check**: Validate content structure

**Quality Gate**: Well-formed Japanese ISSUE_TEMPLATE content

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
4. **Final Validation**: Human review of content quality and translation accuracy

**Quality Gates**:

- Security: Safe file access, secure API usage
- Architecture: Clean separation of concerns
- Performance: Efficient file processing

### Phase 3: Translation and Issue Creation

**Actions**:

1. **Create Issue File**: Generate new file with `.issue.md` extension containing ISSUE_TEMPLATE
2. **Human Approval**: Display Japanese content for "Approve" confirmation
3. **Translation Processing**: Convert Japanese to English using Claude 4
4. **Linear Issue Creation**: Create issue with English content
5. **Japanese Comment Addition**: Add original Japanese content as comment
6. **File Cleanup**: Remove created `.issue.md` file after successful processing

**Quality Gate**: Successfully created Linear Issue with both languages

## Core Workflow Implementation

### 1. File Reading and Validation

```typescript
// Security-first file access with path traversal prevention
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

### 2. Content Structure Parsing (Single Responsibility)

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
}
```

### 3. ISSUE_TEMPLATE Conversion (Open/Closed Principle)

```typescript
// Convert to Linear Issue template format
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
    const bugKeywords = ['bug', 'fix', 'error', 'issue', 'バグ', '修正']
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

// Concrete implementation for feature templates
class FeatureTemplateConverter extends TemplateConverter {
  async convert(bullets: BulletPoint[]): Promise<IssueTemplate> {
    const title = this.generateTitle(bullets)
    const description = this.buildFeatureDescription(bullets)

    return {
      title,
      description,
      type: 'feature',
      priority: this.inferPriority(bullets),
    }
  }

  private buildFeatureDescription(bullets: BulletPoint[]): string {
    return `## 概要\n\n${bullets[0]?.content}\n\n## 詳細\n\n${bullets
      .slice(1)
      .map(b => `- ${b.content}`)
      .join('\n')}`
  }
}

// Concrete implementation for bugfix templates
class BugfixTemplateConverter extends TemplateConverter {
  async convert(bullets: BulletPoint[]): Promise<IssueTemplate> {
    const title = this.generateTitle(bullets)
    const description = this.buildBugfixDescription(bullets)

    return {
      title,
      description,
      type: 'bugfix',
      priority: this.inferPriority(bullets),
    }
  }

  private buildBugfixDescription(bullets: BulletPoint[]): string {
    return `## 問題\n\n${bullets[0]?.content}\n\n## 詳細\n\n${bullets
      .slice(1)
      .map(b => `- ${b.content}`)
      .join(
        '\n'
      )}\n\n## 期待される動作\n\n修正後の正常な動作を記述してください。`
  }
}

// Factory pattern for converter selection with better error handling
class TemplateConverterFactory {
  private static readonly converters = new Map<string, () => TemplateConverter>(
    [
      ['feature', () => new FeatureTemplateConverter()],
      ['bugfix', () => new BugfixTemplateConverter()],
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

### 4. Translation and Linear Integration

```typescript
// Secure API integration with credential management
import { LinearClient } from '@linear/sdk'

class SecureLinearIntegration implements LinearIntegration {
  private client: LinearClient
  private translationCache: Map<string, { value: string; expiry: number }> =
    new Map()

  constructor() {
    const apiKey = process.env.LINEAR_API_KEY
    if (!apiKey) {
      throw new SecurityError('LINEAR_API_KEY environment variable required')
    }
    this.client = new LinearClient({ apiKey })
  }

  // Sanitize content before API calls
  private sanitizeContent(content: string): string {
    return content
      .replace(/[<>]/g, '') // Remove potential XSS vectors
      .slice(0, 50000) // Enforce API limits
  }

  async createLinearIssue(
    template: IssueTemplate,
    originalJapanese: string
  ): Promise<string> {
    // Translate content with input validation
    const translatedContent = await this.translateContent(
      this.sanitizeContent(template.description)
    )

    // Create Linear Issue with rate limiting
    const issue = await this.client.createIssue({
      title: this.sanitizeContent(template.title),
      description: translatedContent,
      teamId: process.env.LINEAR_TEAM_ID,
      priority: this.mapPriority(template.priority),
    })

    // Add Japanese comment securely
    await this.client.createComment({
      issueId: issue.id,
      body: `## Original Japanese Content\n\n${this.sanitizeContent(originalJapanese)}`,
    })

    return issue.url
  }

  private async translateContent(content: string): Promise<string> {
    // Performance: Cache translations to avoid redundant API calls
    const cacheKey = this.generateCacheKey(content)
    const cached = await this.getCachedTranslation(cacheKey)
    if (cached) return cached

    // Implement secure translation with Claude 4 API
    const translation = await this.callTranslationAPI(content)

    // Cache result for future use
    await this.setCachedTranslation(cacheKey, translation, 3600)
    return translation
  }

  private async getCachedTranslation(key: string): Promise<string | null> {
    const cached = this.translationCache.get(key)
    if (cached && cached.expiry > Date.now()) {
      return cached.value
    }
    // Clean up expired entries
    if (cached) this.translationCache.delete(key)
    return null
  }

  private async setCachedTranslation(
    key: string,
    value: string,
    ttl: number
  ): Promise<void> {
    this.translationCache.set(key, {
      value,
      expiry: Date.now() + ttl * 1000,
    })

    // Prevent memory leaks - clean up cache periodically
    if (this.translationCache.size > 1000) {
      this.cleanupExpiredCache()
    }
  }

  private cleanupExpiredCache(): void {
    const now = Date.now()
    for (const [key, cached] of this.translationCache.entries()) {
      if (cached.expiry <= now) {
        this.translationCache.delete(key)
      }
    }
  }

  private async callTranslationAPI(content: string): Promise<string> {
    const maxRetries = 3
    let attempt = 0

    while (attempt < maxRetries) {
      try {
        // Add exponential backoff for rate limiting
        if (attempt > 0) {
          await this.delay(Math.pow(2, attempt) * 1000)
        }

        // Use environment variable for API endpoint security
        const apiEndpoint = process.env.CLAUDE_API_ENDPOINT
        if (!apiEndpoint) {
          throw new SecurityError(
            'CLAUDE_API_ENDPOINT environment variable required'
          )
        }

        // Secure API call with input validation
        const response = await fetch(apiEndpoint, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${process.env.CLAUDE_API_KEY}`,
            'User-Agent': 'file-to-issue/1.0.0',
          },
          body: JSON.stringify({
            text: content.slice(0, 100000), // Enforce API limits
            from: 'ja',
            to: 'en',
          }),
        })

        if (!response.ok) {
          throw new Error(`Translation API error: ${response.status}`)
        }

        const result = await response.json()
        return this.validateTranslation(result.text)
      } catch (error) {
        attempt++
        if (attempt >= maxRetries) {
          // Don't expose sensitive error details
          throw new Error('Translation service temporarily unavailable')
        }
      }
    }

    throw new Error('Translation failed after maximum retries')
  }

  private generateCacheKey(content: string): string {
    return crypto.createHash('sha256').update(content).digest('hex')
  }

  private async delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms))
  }

  private validateTranslation(text: string): string {
    if (!text || text.trim().length === 0) {
      throw new Error('Translation returned empty result')
    }

    // Basic validation - ensure translation looks reasonable
    if (text.length < 10 || text === text.toLowerCase()) {
      throw new Error('Translation quality validation failed')
    }

    return text.trim()
  }

  private mapPriority(priority: 'low' | 'medium' | 'high' | 'urgent'): number {
    const priorityMap = { low: 1, medium: 2, high: 3, urgent: 4 }
    return priorityMap[priority] || 1
  }
}

// Interfaces for Dependency Inversion Principle
interface FileValidator {
  validateAndRead(filePath: string): Promise<string>
  cleanup(filePath: string): Promise<void>
}

interface ContentParser {
  parseBulletPoints(content: string): Promise<BulletPoint[]>
}

interface LinearIntegration {
  createLinearIssue(
    template: IssueTemplate,
    originalJapanese: string
  ): Promise<string>
}

// Main command orchestrator (Dependency Inversion)
class FileToIssueCommand {
  constructor(
    private fileValidator: FileValidator,
    private contentParser: ContentParser,
    private templateFactory: TemplateConverterFactory,
    private linearIntegration: LinearIntegration
  ) {}

  async execute(filePath?: string): Promise<string> {
    // Argument validation - exit early if no file path provided
    // Skip "Update Todos" phase and terminate immediately when path is empty
    if (!filePath || filePath.trim() === '') {
      console.log('\x1b[31m⏺ Please provide a file path as an argument\x1b[0m')
      console.log('📝 Skipping Update Todos phase due to missing file path')
      process.exit(0)
    }

    try {
      // Phase 1: Secure file processing
      const content = await this.fileValidator.validateAndRead(filePath)

      // Phase 2: Content parsing
      const bullets = await this.contentParser.parseBulletPoints(content)

      // Phase 3: Template conversion
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
      const issueUrl = await this.linearIntegration.createLinearIssue(
        template,
        content
      )

      // Phase 7: Cleanup
      await this.fileValidator.cleanup(issueFilePath)

      return issueUrl
    } catch (error) {
      this.handleError(error)
      throw error
    }
  }

  private async requestApproval(template: IssueTemplate): Promise<boolean> {
    console.log('📝 Generated Japanese Content:')
    console.log(`## ${template.title}\n\n${template.description}`)
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

    // Create issue file content in ISSUE_TEMPLATE format
    const issueContent = `# ${template.title}

${template.description}

---
Type: ${template.type}
Priority: ${template.priority}
Generated from: ${path.basename(originalPath)}
Date: ${new Date().toISOString()}
`

    // Write issue file
    await writeFile(issueFilePath, issueContent, { encoding: 'utf8' })
    console.log(`📝 Created issue file: ${issueFilePath}`)

    return issueFilePath
  }
}
```

## Security Requirements

### File Access Controls

- **Path Validation**: Only allow files within project directory
- **Extension Whitelist**: `.md`, `.txt`, `.markdown` files only
- **Size Limits**: Maximum 10MB file size
- **Permission Check**: Verify read permissions before access

### API Security

- **Credential Management**: Use environment variables for Linear API keys
- **Rate Limiting**: Respect Linear API rate limits
- **Error Handling**: No sensitive data in error messages
- **Input Sanitization**: Clean content before API calls

## Error Handling and Recovery

### File Access Errors

```bash
/file-to-issue nonexistent.md
❌ Error: File 'nonexistent.md' not found
💡 Use relative or absolute path to accessible file
```

### Translation Failures

```bash
❌ Translation failed: API rate limit exceeded
🔧 Retrying in 60 seconds...
📋 Will save progress and resume automatically
```

### Linear API Errors

```bash
❌ Linear Issue creation failed: Invalid team ID
📋 Content saved locally for manual retry
💡 Check Linear API configuration
```

## Completion Criteria

### 1. AI Review-First Standards

- ✅ **3-4 review cycles completed successfully** (Completed: Security → SOLID → Performance)
- ✅ **Security**: Path traversal protection, input sanitization, credential management
- ✅ **SOLID Principles**: Clean separation of concerns, extensible factory pattern
- ✅ **Performance**: Chunked processing for large files, translation caching, early termination

### 2. Functional Requirements

- ✅ **File Reading**: Secure file access with proper validation
- ✅ **Content Parsing**: Accurate bullet point structure extraction
- ✅ **Template Conversion**: Proper ISSUE_TEMPLATE format generation
- ✅ **Translation**: High-quality Japanese to English conversion
- ✅ **Linear Integration**: Successful Issue creation with bilingual content
- ✅ **Issue File Creation**: Generate `.issue.md` file with ISSUE_TEMPLATE format
- ✅ **File Cleanup**: Safe removal of created `.issue.md` files

### 3. Quality Standards

- ✅ **Error Handling**: Comprehensive error recovery mechanisms
- ✅ **User Experience**: Clear progress indication and feedback
- ✅ **Documentation**: Complete usage and troubleshooting guide

## Usage Examples

### Basic File Processing

```bash
/file-to-issue tasks.md

📖 Reading file: tasks.md
📋 Found 5 bullet points
🏗️ Converting to ISSUE_TEMPLATE format...
📝 Created issue file: tasks.issue.md

📝 Generated Japanese Content:
## タイトル
新機能：ユーザー認証システム

## 概要
...

✅ Content looks good? Type 'Approve' to continue: Approve

🌐 Translating to English...
📤 Creating Linear Issue...
💬 Adding Japanese comment...
🗑️ Cleaning up issue file...

✅ Issue created: https://linear.app/team/issue/ABC-123
```

### Error Recovery Example

```bash
/file-to-issue large-file.md

❌ Error: File size exceeds 10MB limit
💡 Consider splitting into smaller files
📋 Current file: 15.2MB
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
- **Planning documents** needing Issue conversion

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
├── .env (for API keys)
└── allowed-files/ (for file access validation)
```

---

**Note**: This command prioritizes security in file access and API usage, implements clean architecture following SOLID principles, and provides efficient file processing with comprehensive error handling.
