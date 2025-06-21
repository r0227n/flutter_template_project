# File-to-Issue Processing Command

Convert bullet-point files into Linear Issues with direct translation workflow.

## Overview

This command reads local files with bullet points, translates content to English, creates Linear Issues, and then generates a local .issue.md file for record-keeping.

## Execution Modes

### Interactive Mode (No Arguments)
```bash
/file-to-issue
```

**Behavior**:
1. Prompt for file path input
2. Display file content preview
3. Confirm before processing

### Direct Mode (With File Path)
```bash
/file-to-issue path/to/file.md
```

**Behavior**:
- No confirmation prompts - immediate execution
- Validate file path and begin processing

## Processing Flow

### Phase 1: File Reading and Validation
1. Verify file exists and is readable
2. Check file extension (.md, .txt, .markdown only)
3. Validate file size (max 10MB)
4. Read and parse bullet points

### Phase 2: Direct Translation
1. Extract bullet point content
2. Translate Japanese content to English
3. Generate issue title and description

### Phase 3: Linear Issue Creation
1. Create Linear Issue with English content
2. Set appropriate issue type and priority
3. Capture created issue ID and URL

### Phase 4: Japanese Comment
1. Add original Japanese content as comment
2. Format as structured comment for reference

### Phase 5: Local File Creation
1. Create .issue.md file with issue details
2. Include Linear Issue URL and metadata
3. Store both Japanese and English content

### Phase 6: Cleanup
1. Remove .issue.md file if requested
2. Provide completion summary

## Implementation

```typescript
// Main command flow
async function fileToIssue(filePath: string) {
  // Phase 1: File validation
  const content = await validateAndReadFile(filePath)
  const bullets = parseBulletPoints(content)
  
  // Phase 2: Translation
  const translated = await translateToEnglish(bullets)
  
  // Phase 3: Create Linear Issue
  const issue = await createLinearIssue({
    title: translated.title,
    description: translated.description,
    type: detectIssueType(content),
    priority: 'medium'
  })
  
  // Phase 4: Add Japanese comment
  await addLinearComment(issue.id, {
    body: `## Original Japanese Content\n\n${formatBulletPoints(bullets)}`
  })
  
  // Phase 5: Create local record
  const issueFilePath = await createIssueFile(filePath, {
    linearUrl: issue.url,
    originalContent: content,
    translatedContent: translated,
    metadata: {
      createdAt: new Date(),
      issueId: issue.id
    }
  })
  
  // Phase 6: Cleanup (optional)
  if (shouldCleanup) {
    await removeFile(issueFilePath)
  }
  
  return issue.url
}
```

## Security Requirements

### File Access
- Path validation to prevent directory traversal
- Extension whitelist enforcement
- Size limits (10MB max)
- Read permission verification

### API Security
- Environment variable for Linear API key
- Input sanitization before API calls
- Rate limiting compliance
- Secure credential storage

## Error Handling

### File Errors
```bash
❌ Error: File not found
💡 Check file path and permissions
```

### Translation Errors
```bash
❌ Translation failed
🔄 Retrying with fallback...
```

### Linear API Errors
```bash
❌ Issue creation failed
📋 Content saved locally for retry
```

## Usage Examples

### Basic Usage
```bash
/file-to-issue tasks.md

📖 Reading: tasks.md
🌐 Translating content...
📤 Creating Linear Issue...
💬 Adding Japanese comment...
📝 Created: tasks.issue.md
✅ Issue: https://linear.app/team/issue/ABC-123
```

### Direct Execution
```bash
/file-to-issue ./requirements.md

🚀 Processing requirements.md
✅ Linear Issue created successfully
📁 Local record saved
```

## File Format Support

### Input File Example
```markdown
- todoアプリを作りたい
- flutterで作る
- データを永続化する
```

### Generated .issue.md
```markdown
# Todo App Development

Linear Issue: https://linear.app/team/issue/ABC-123
Created: 2025-01-23T00:00:00Z

## English Content
- Create a todo application
- Build with Flutter
- Implement data persistence

## Original Japanese
- todoアプリを作りたい
- flutterで作る
- データを永続化する

---
Generated from: tasks.md
Issue ID: ABC-123
Type: feature
Priority: medium
```

## Configuration

### Required Environment Variables
```bash
export LINEAR_API_KEY="your_api_key"
export LINEAR_TEAM_ID="your_team_id"
```

### Optional Settings
```bash
export FILE_SIZE_LIMIT_MB=10
export AUTO_CLEANUP_ISSUE_FILE=false
export TRANSLATION_CACHE_TTL=3600
```

---

**Note**: This command prioritizes direct Linear Issue creation with translation, followed by local file generation for record-keeping purposes.