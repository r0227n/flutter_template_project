# Web Summary Command - Claude 4 Best Practices

**IMPORTANT**: This command implements AI Review-First design following Claude 4 best practices for automated web content analysis with comprehensive security measures.

## Overview

Analyze web pages with reference links using AI Review-First methodology. This command fetches web content, extracts reference links, applies 4-stage AI review cycles for summary improvement, and generates structured Markdown reports.

## Core Principles (Claude 4 Best Practices)

**Reference**: `docs/CLAUDE_4_BEST_PRACTICES.md`

### AI Review-First Methodology

- **Pattern**: Small draft → Critical review → Regenerate → Release
- **Approach**: Use AI as "Senior Reviewer" for content quality
- **Cycles**: 4 iterative review cycles for summary improvement
- **Priority**: Security (High) → Content Quality (Medium) → Performance (Low)

### Clear Instructions

- Eliminate ambiguity in URL processing and content extraction
- Define specific deliverables: structured Markdown reports with 4-stage improved summaries
- Provide structured review templates for content quality assessment

### Structured Quality Assessment

Apply consistent evaluation framework:

```
1. Security vulnerabilities (HIGH PRIORITY) - SSRF protection, input validation
2. Content quality violations (MEDIUM PRIORITY) - Summary accuracy, structure
3. Performance optimization (LOW PRIORITY) - Processing speed, memory usage
Constraint: Summarize findings within 400 characters
```

## Execution Modes

### Interactive Mode (No Arguments)

```bash
/web-summary
```

**Behavior**:

1. **Argument Validation**: Check if URL is provided
2. **Early Termination**: If no arguments, display "⏺ Please provide a URL as an argument" in red, skip "Update Todos" phase, and terminate immediately
3. **No further processing** when no arguments provided

### Direct Mode (With URL)

```bash
/web-summary <URL> [options]
```

**Behavior**:

- **No confirmation prompts** - immediate execution
- Validate URL format and accessibility
- Begin content analysis automatically
- Generate structured Markdown report

### Option Support

```bash
/web-summary https://example.com --max-links 5 --output report.md
```

**Supported Options**:
- `--max-links N`: Maximum reference links to process (default: 10)
- `--timeout N`: Request timeout in seconds (default: 30)
- `--output FILE`: Output filename (default: auto-generated)
- `--no-links`: Skip reference link processing
- `--verbose`: Enable detailed logging

## AI Review-First Processing Flow

### Phase 1: Content Acquisition and Initial Processing

**Objective**: Secure web content extraction for review

**Actions**:

1. **URL Validation**: SSRF protection, format validation, timeout configuration
2. **Main Content Extraction**: HTML to Markdown conversion, metadata extraction
3. **Reference Link Discovery**: Extract and filter relevant links within domain/scope
4. **Reference Content Fetching**: Parallel processing of up to 10 reference links
5. **Initial Summary Generation**: Basic content structure and key points

**Security Checklist**:
- ✅ URL format validation (no malformed URLs)
- ✅ Domain whitelist checking (prevent SSRF attacks)
- ✅ Content size limits (prevent memory exhaustion)
- ✅ Request timeout enforcement (prevent hanging requests)

**Success Criteria**: Clean, structured content ready for AI review cycles

### Phase 2: AI Review Cycles (4 Iterations)

**Review Template** (Use this exact format):

```
Please review the following web summary content.

Evaluation Categories:
1. Security vulnerabilities (high priority) - SSRF protection, input validation
2. Content quality violations (medium priority) - Summary accuracy, completeness  
3. Performance optimization opportunities (low priority) - Processing efficiency

Constraint: Provide specific, actionable feedback within 400 characters.
Focus on the highest priority issues first.
```

**Iterative Improvement Process**:

1. **Cycle 1 - Structure and Logic**: Improve content organization and logical flow
2. **Cycle 2 - Content Enrichment**: Add missing context and comprehensive details
3. **Cycle 3 - Quality and Readability**: Enhance writing quality and clarity
4. **Cycle 4 - Final Polish**: Format consistency and final adjustments

**Quality Requirements**:
- Security: Safe URL processing, no SSRF vulnerabilities
- Content: Accurate, comprehensive, well-structured summaries
- Performance: Efficient parallel processing, reasonable response times

### Phase 3: Report Generation and Output

**Actions**:

1. **Markdown Report Generation**: Structured template with metadata and statistics
2. **Mermaid Diagram Creation**: Visual processing flow representation
3. **File Output**: Save to specified or auto-generated filename
4. **Validation**: Verify output format and completeness

**Output Template**:

```markdown
# Web Summary Report

## Page Information

- **URL**: [Original URL]
- **Title**: [Page Title]
- **Processed**: [ISO8601 timestamp]
- **Processing Time**: [Duration in seconds]

## Summary

[4-stage AI improved summary content]

## Reference Links Analysis

### Discovered Links

1. [Link Title](URL) - [Brief description]
   ...

### Reference Content Summary

#### [Reference 1 Title]

[Reference content summary]

## Processing Statistics

- **Main Content Length**: [Character count]
- **Reference Links**: [Count]
- **Total Processing Time**: [Seconds]
- **AI Review Cycles**: 4

## Analysis Flow

```mermaid
[Processing flow diagram]
```
```

**Success Criteria**: Well-formatted Markdown report with comprehensive analysis

## Core Implementation Architecture

### URL Validation and Security

```typescript
// Enhanced SSRF protection and input validation
class URLValidator {
  private static readonly BLOCKED_SCHEMES = ['file', 'ftp', 'data', 'javascript'];
  private static readonly BLOCKED_HOSTS = ['localhost', '127.0.0.1', '0.0.0.0'];
  private static readonly PRIVATE_IP_RANGES = [
    /^10\./,
    /^172\.(1[6-9]|2[0-9]|3[01])\./,
    /^192\.168\./,
    /^169\.254\./
  ];

  static async validateURL(url: string): Promise<URL> {
    // Input sanitization
    if (!url || typeof url !== 'string' || url.length > 2048) {
      throw new SecurityError('Invalid URL format or length');
    }

    // Parse and validate URL structure
    let parsedURL: URL;
    try {
      parsedURL = new URL(url);
    } catch (error) {
      throw new ValidationError('Malformed URL provided');
    }

    // Scheme validation
    if (this.BLOCKED_SCHEMES.includes(parsedURL.protocol.slice(0, -1))) {
      throw new SecurityError('Blocked URL scheme detected');
    }

    // Host validation - prevent SSRF
    const hostname = parsedURL.hostname.toLowerCase();
    if (this.BLOCKED_HOSTS.includes(hostname)) {
      throw new SecurityError('Access to local resources blocked');
    }

    // Private IP range protection
    if (this.PRIVATE_IP_RANGES.some(range => range.test(hostname))) {
      throw new SecurityError('Access to private networks blocked');
    }

    // Port validation
    const port = parsedURL.port;
    if (port && (parseInt(port) < 80 || parseInt(port) > 65535)) {
      throw new SecurityError('Invalid port number');
    }

    return parsedURL;
  }
}
```

### Content Fetcher with Security Controls

```typescript
// Secure web content fetching with comprehensive protection
class WebContentFetcher {
  private static readonly MAX_CONTENT_SIZE = 10 * 1024 * 1024; // 10MB
  private static readonly DEFAULT_TIMEOUT = 30000; // 30 seconds
  private static readonly MAX_REDIRECTS = 5;

  async fetchContent(url: URL, options: FetchOptions = {}): Promise<WebContent> {
    const timeout = options.timeout || this.DEFAULT_TIMEOUT;
    
    try {
      const response = await fetch(url.toString(), {
        method: 'GET',
        headers: {
          'User-Agent': 'Claude-WebSummary/1.0',
          'Accept': 'text/html,application/xhtml+xml',
          'Accept-Language': 'en-US,en;q=0.9',
          'Cache-Control': 'no-cache'
        },
        timeout,
        redirect: 'manual', // Handle redirects manually for security
        signal: AbortSignal.timeout(timeout)
      });

      // Check response size before reading
      const contentLength = response.headers.get('content-length');
      if (contentLength && parseInt(contentLength) > this.MAX_CONTENT_SIZE) {
        throw new SecurityError('Content size exceeds limit');
      }

      // Read content with size monitoring
      const content = await this.readContentSafely(response);
      
      return {
        url: url.toString(),
        title: this.extractTitle(content),
        content: this.sanitizeContent(content),
        metadata: this.extractMetadata(content),
        links: this.extractLinks(content, url)
      };
    } catch (error) {
      if (error.name === 'TimeoutError') {
        throw new ProcessingError('Request timeout exceeded');
      }
      throw new ProcessingError(`Failed to fetch content: ${error.message}`);
    }
  }

  private async readContentSafely(response: Response): Promise<string> {
    let totalSize = 0;
    const chunks: Uint8Array[] = [];
    const reader = response.body?.getReader();

    if (!reader) {
      throw new ProcessingError('No response body available');
    }

    try {
      while (true) {
        const { done, value } = await reader.read();
        if (done) break;

        totalSize += value.length;
        if (totalSize > this.MAX_CONTENT_SIZE) {
          throw new SecurityError('Content size limit exceeded during read');
        }

        chunks.push(value);
      }

      const fullContent = new Uint8Array(totalSize);
      let position = 0;
      for (const chunk of chunks) {
        fullContent.set(chunk, position);
        position += chunk.length;
      }

      return new TextDecoder('utf-8').decode(fullContent);
    } finally {
      reader.releaseLock();
    }
  }

  private sanitizeContent(html: string): string {
    // Remove potentially dangerous content
    return html
      .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '')
      .replace(/<style\b[^<]*(?:(?!<\/style>)<[^<]*)*<\/style>/gi, '')
      .replace(/javascript:/gi, '')
      .replace(/on\w+\s*=/gi, '');
  }
}
```

### AI Review Engine

```typescript
// 4-stage AI review cycle implementation
class AIReviewEngine {
  private readonly reviewTemplates = {
    structure: `Analyze content structure and logical flow. Focus on organization, coherence, and main point identification.`,
    enrichment: `Enhance content completeness. Add missing context, clarify technical terms, expand on key concepts.`,
    quality: `Improve writing quality and readability. Fix grammar, enhance clarity, optimize sentence structure.`,
    polish: `Final review for consistency and format. Ensure professional presentation and proper Markdown formatting.`
  };

  async performReviewCycles(content: WebContent): Promise<ReviewedContent> {
    let currentSummary = this.generateInitialSummary(content);
    const reviewHistory: ReviewCycle[] = [];

    // 4-stage review process
    for (let cycle = 1; cycle <= 4; cycle++) {
      const stageName = ['structure', 'enrichment', 'quality', 'polish'][cycle - 1];
      const template = this.reviewTemplates[stageName];

      console.log(`🔄 AI Review Cycle ${cycle}: ${stageName}`);
      
      const reviewResult = await this.performSingleReview(
        currentSummary,
        template,
        cycle
      );

      reviewHistory.push({
        cycle,
        stage: stageName,
        before: currentSummary,
        after: reviewResult.improvedContent,
        feedback: reviewResult.feedback
      });

      currentSummary = reviewResult.improvedContent;
      
      // Quality gate check
      if (!this.validateReviewQuality(reviewResult, cycle)) {
        console.warn(`⚠️ Review cycle ${cycle} quality concerns detected`);
      }
    }

    return {
      finalSummary: currentSummary,
      reviewHistory,
      qualityScore: this.calculateQualityScore(reviewHistory)
    };
  }

  private async performSingleReview(
    content: string,
    template: string,
    cycle: number
  ): Promise<ReviewResult> {
    const reviewPrompt = `${template}

Original Content:
${content}

Provide improved version with specific enhancements applied.
Constraint: Maximum 400 character explanation of changes made.`;

    // This would integrate with Claude API for actual review
    const result = await this.callAIReviewer(reviewPrompt);
    
    return {
      improvedContent: result.improvedContent,
      feedback: result.feedback,
      changesSummary: result.changesSummary
    };
  }
}
```

### Reference Link Processor

```typescript
// Parallel reference link processing with rate limiting
class ReferenceLinkProcessor {
  private static readonly DEFAULT_MAX_LINKS = 10;
  private static readonly CONCURRENT_LIMIT = 3;

  async processReferenceLinks(
    links: string[],
    baseURL: URL,
    maxLinks: number = this.DEFAULT_MAX_LINKS
  ): Promise<ReferenceContent[]> {
    // Filter and prioritize links
    const processableLinks = this.filterLinks(links, baseURL)
      .slice(0, maxLinks);

    console.log(`🔗 Processing ${processableLinks.length} reference links`);

    // Process links in batches to avoid overwhelming the server
    const results: ReferenceContent[] = [];
    for (let i = 0; i < processableLinks.length; i += this.CONCURRENT_LIMIT) {
      const batch = processableLinks.slice(i, i + this.CONCURRENT_LIMIT);
      const batchResults = await Promise.allSettled(
        batch.map(link => this.processLink(link))
      );

      for (const result of batchResults) {
        if (result.status === 'fulfilled') {
          results.push(result.value);
        } else {
          console.warn(`⚠️ Failed to process link: ${result.reason}`);
        }
      }
    }

    return results;
  }

  private filterLinks(links: string[], baseURL: URL): string[] {
    return links
      .filter(link => this.isValidReferenceLink(link, baseURL))
      .filter(link => !this.isMediaFile(link))
      .sort((a, b) => this.prioritizeLink(a, baseURL) - this.prioritizeLink(b, baseURL));
  }

  private isValidReferenceLink(link: string, baseURL: URL): boolean {
    try {
      const url = new URL(link, baseURL);
      return url.hostname === baseURL.hostname && !url.hash;
    } catch {
      return false;
    }
  }
}
```

## Enhanced Error Handling and Recovery

### Comprehensive Error Types

```typescript
// Specialized error types for different failure modes
class SecurityError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'SecurityError';
  }
}

class ValidationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'ValidationError';
  }
}

class ProcessingError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'ProcessingError';
  }
}

class NetworkError extends Error {
  constructor(message: string, public readonly retryable: boolean = false) {
    super(message);
    this.name = 'NetworkError';
  }
}
```

### Retry Logic with Exponential Backoff

```typescript
// Intelligent retry mechanism for transient failures
class RetryManager {
  private static readonly MAX_RETRIES = 3;
  private static readonly BASE_DELAY = 1000; // 1 second

  async executeWithRetry<T>(
    operation: () => Promise<T>,
    errorChecker: (error: Error) => boolean = () => true
  ): Promise<T> {
    let lastError: Error;

    for (let attempt = 1; attempt <= this.MAX_RETRIES; attempt++) {
      try {
        return await operation();
      } catch (error) {
        lastError = error;

        if (!errorChecker(error) || attempt === this.MAX_RETRIES) {
          throw error;
        }

        const delay = this.BASE_DELAY * Math.pow(2, attempt - 1);
        console.log(`⏰ Retry ${attempt}/${this.MAX_RETRIES} in ${delay}ms: ${error.message}`);
        await this.sleep(delay);
      }
    }

    throw lastError!;
  }

  private sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}
```

## Execution Examples

### Basic Usage

```bash
/web-summary https://example.com

📖 Fetching: https://example.com
🔗 Found 15 reference links, processing top 10
🔄 AI Review Cycle 1: Structure and Logic
🔄 AI Review Cycle 2: Content Enrichment  
🔄 AI Review Cycle 3: Quality and Readability
🔄 AI Review Cycle 4: Final Polish
📊 Generating statistics and Mermaid diagrams
📝 Report saved: web-summary-2024-06-24-143022.md
✅ Analysis complete in 45 seconds
```

### Advanced Options

```bash
/web-summary https://docs.example.com --max-links 5 --output analysis.md --verbose

📖 URL Validation: ✅ https://docs.example.com
🔒 Security Check: ✅ SSRF protection active
📡 Fetching main content... (2.3s)
🔗 Link Discovery: Found 23 links, filtering to 5
📊 Content Stats: 15,420 characters, 8 sections
🔄 Starting 4-stage AI review process...
   Cycle 1/4: Structure improvements applied
   Cycle 2/4: Content enrichment completed
   Cycle 3/4: Quality enhancements made
   Cycle 4/4: Final polish applied
📈 Quality Score: 94/100
📝 Report saved: analysis.md
✅ Analysis complete in 67 seconds
```

### Error Examples

```bash
/web-summary

⏺ Please provide a URL as an argument
📝 Skipping Update Todos phase due to missing URL

/web-summary localhost:8080

❌ Security Error: Access to local resources blocked
💡 Use publicly accessible URLs only

/web-summary https://malformed-url

❌ Validation Error: Malformed URL provided
💡 Check URL format and try again
```

## Best Practices and Limitations

### Optimal Use Cases

- **Public documentation sites** with comprehensive link structures
- **Blog posts and articles** with rich reference materials
- **Technical documentation** requiring detailed analysis
- **Research papers** with extensive citations
- **News articles** with background links

### Limitations

- **Private/authenticated content** - cannot access login-required pages
- **Dynamic content** - JavaScript-rendered content may be incomplete
- **Large media files** - focuses on text content, skips videos/images
- **Rate limiting** - respects server rate limits, may slow processing

### Security Considerations

- **SSRF Protection**: Comprehensive validation prevents access to internal resources
- **Content Limits**: Size restrictions prevent memory exhaustion attacks
- **Input Sanitization**: All user input validated and sanitized
- **Safe Processing**: No execution of dynamic content or scripts

## Quality Standards

### AI Review-First Criteria

**High Priority - Security:**
- ✅ URL validation prevents SSRF attacks
- ✅ Content size limits protect against DoS
- ✅ Input sanitization blocks malicious payloads
- ✅ Network isolation prevents internal access

**Medium Priority - Content Quality:**
- ✅ 4-stage review process ensures comprehensive analysis
- ✅ Reference link integration provides context
- ✅ Structured output maintains readability
- ✅ Metadata preservation supports verification

**Low Priority - Performance:**
- ✅ Parallel processing optimizes speed
- ✅ Rate limiting respects server resources
- ✅ Memory management prevents system issues
- ✅ Progress indicators improve user experience

### Success Metrics

- **Processing Time**: Target ≤ 2 minutes for typical pages
- **Content Coverage**: Include ≥ 80% of main content
- **Reference Links**: Process up to 10 relevant links
- **Quality Score**: Achieve ≥ 90/100 for final summaries
- **Error Rate**: Handle ≥ 95% of valid URLs successfully

---

**Note**: This command prioritizes security through comprehensive SSRF protection and implements Claude 4 best practices through structured AI review cycles for high-quality content analysis.