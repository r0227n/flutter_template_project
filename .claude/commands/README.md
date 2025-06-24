# Claude Code Custom Slash Commands

This directory contains custom slash commands for Claude Code that extend its functionality.

## Available Commands

### `/web-merge` - Web Page Merger
Merge multiple web pages into a single Markdown file for efficient review.

**Usage:**
```bash
/web-merge https://example1.com https://example2.com [options]
```

**Key Features:**
- Secure URL validation (SSRF protection)
- Parallel fetching with rate limiting
- HTML to Markdown conversion
- Table of contents generation
- Progress tracking with retry logic

**Security:**
- Blocks private network access
- Sanitizes HTML content
- Enforces size limits (1MB per page)
- No automatic link following

See [web-merge.md](./web-merge.md) for full documentation.

### `/task` - GitHub Issue Processor
Process GitHub Issues with AI Review-First methodology.

**Usage:**
```bash
/task #123
/task  # Interactive selection
```

See [task.md](./task.md) for full documentation.

### `/file-to-issue` - File to GitHub Issue Converter
Convert bullet-point files into GitHub Issues.

**Usage:**
```bash
/file-to-issue path/to/file.md
```

See [file-to-issue.md](./file-to-issue.md) for full documentation.

### `/prompt-review` - Prompt Review Tool
Review and improve prompts using Claude 4 best practices.

**Usage:**
```bash
/prompt-review "Your prompt here"
```

See [prompt-review.md](./prompt-review.md) for full documentation.

## Command Development Guidelines

When creating new commands:

1. **Security First**: Validate all inputs, prevent injection attacks
2. **AI Review-First**: Apply 3-4 review cycles for quality
3. **SOLID Principles**: Keep concerns separated, use dependency injection
4. **Performance**: Add progress tracking, handle errors gracefully
5. **Documentation**: Include detailed usage examples and security notes

## Quality Standards

All commands must meet:
- ✅ Security review passed
- ✅ Architecture follows SOLID principles
- ✅ Performance optimized
- ✅ Documentation complete
- ✅ Error handling comprehensive