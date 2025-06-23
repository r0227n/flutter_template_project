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

1. Prompt for file path input
2. Display file content preview
3. Show parsed bullet points
4. Confirm before processing

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
import { resolve, relative, join } from 'path'
import { stat, readFile } from 'fs/promises'

const ALLOWED_EXTENSIONS = ['.md', '.txt', '.markdown']
const MAX_FILE_SIZE = 10 * 1024 * 1024 // 10MB
const WORK_DIRECTORY = process.env.WORK_DIRECTORY || '.claude-workspaces'

async function validateAndReadFile(filePath: string): Promise<string> {
  // Prevent directory traversal attacks
  const resolvedPath = resolve(filePath)
  const workDir = resolve(WORK_DIRECTORY)
  const relativePath = relative(workDir, resolvedPath)

  if (relativePath.startsWith('..') || path.isAbsolute(relativePath)) {
    throw new SecurityError('File access outside allowed directory')
  }

  // Validate file extension
  const ext = path.extname(filePath).toLowerCase()
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
    const lines = content.split('\n').filter(line => line.trim())
    return this.buildHierarchy(lines)
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
    return line.replace(this.BULLET_PATTERNS[0], '').trim()
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

// Factory pattern for converter selection
class TemplateConverterFactory {
  static create(type: 'feature' | 'bugfix'): TemplateConverter {
    switch (type) {
      case 'feature':
        return new FeatureTemplateConverter()
      case 'bugfix':
        return new BugfixTemplateConverter()
      default:
        throw new Error(`Unsupported template type: ${type}`)
    }
  }
}
```

### 4. Translation and Linear Integration

```typescript
// Secure API integration with credential management
import { LinearClient } from '@linear/sdk'

class SecureLinearIntegration {
  private client: LinearClient

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
    const cached = await this.translationCache.get(cacheKey)
    if (cached) return cached

    // Implement secure translation with Claude 4 API
    const translation = await this.callTranslationAPI(content)

    // Cache result for future use
    await this.translationCache.set(cacheKey, translation, { ttl: 3600 })
    return translation
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

        const response = await this.claudeClient.translate({
          text: content,
          from: 'ja',
          to: 'en',
        })

        return this.validateTranslation(response.text)
      } catch (error) {
        attempt++
        if (attempt >= maxRetries) throw error
      }
    }
  }

  private generateCacheKey(content: string): string {
    return crypto.createHash('sha256').update(content).digest('hex')
  }
}

// Main command orchestrator (Dependency Inversion)
class FileToIssueCommand {
  constructor(
    private fileValidator: FileValidator,
    private contentParser: ContentParser,
    private templateFactory: TemplateConverterFactory,
    private linearIntegration: SecureLinearIntegration
  ) {}

  async execute(filePath: string): Promise<string> {
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

  private async createIssueFile(originalPath: string, template: IssueTemplate): Promise<string> {
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

- ✅ **3-4 review cycles completed successfully**
- ✅ **Security**: All file access and API security issues resolved
- ✅ **SOLID Principles**: Clean command architecture implemented
- ✅ **Performance**: Efficient file processing optimized

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
