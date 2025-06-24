# Web Merge Command - Claude Code Custom Slash Command

**IMPORTANT**: This command implements secure web page merging following AI Review-First design principles for high-quality output.

## Overview

Merge multiple web pages into a single Markdown file for efficient review. This command fetches multiple URLs in parallel, converts HTML to Markdown, and creates a structured document with table of contents and navigation.

## Core Principles

### Security-First Design

- **URL Validation**: Strict validation to prevent SSRF attacks
- **No Auto-Follow**: Never automatically access discovered links
- **Resource Limits**: 1MB per page, 30-second timeout
- **Scheme Restrictions**: Only HTTP/HTTPS allowed

### AI Review-First Methodology

- **Pattern**: Minimal implementation → Security review → Architecture review → Performance optimization
- **Priority**: Security (High) → SOLID Principles (Medium) → Performance (Low)
- **Cycles**: 3-4 iterative improvements

## Execution Modes

### Basic Usage

```bash
/web-merge https://example1.com https://example2.com
```

### With Options

```bash
/web-merge https://site1.com https://site2.com --output merged-pages.md --parallel 3
```

## Implementation

### Phase 1: Minimal Implementation

```typescript
interface WebMergeOptions {
  urls: string[]
  maxUrls?: number
  timeout?: number
  output?: string
  parallel?: number
  verbose?: boolean
  includeToc?: boolean
  separator?: string
}

class WebMergeCommand {
  private readonly DEFAULT_OPTIONS: Partial<WebMergeOptions> = {
    maxUrls: 10,
    timeout: 30000,
    parallel: 5,
    includeToc: true,
    separator: '---'
  }

  async execute(args: string[]): Promise<void> {
    // Parse arguments and options
    const options = this.parseArguments(args)
    
    // Validate URLs
    const validUrls = await this.validateUrls(options.urls)
    
    // Fetch pages in parallel
    const pages = await this.fetchPagesParallel(validUrls, options)
    
    // Convert HTML to Markdown
    const markdownPages = await this.convertToMarkdown(pages)
    
    // Merge into single document
    const mergedDocument = this.mergeDocuments(markdownPages, options)
    
    // Write output file
    await this.writeOutput(mergedDocument, options)
  }

  private parseArguments(args: string[]): WebMergeOptions {
    const urls: string[] = []
    const options: Partial<WebMergeOptions> = { ...this.DEFAULT_OPTIONS }
    
    for (let i = 0; i < args.length; i++) {
      const arg = args[i]
      
      if (arg.startsWith('--')) {
        const key = arg.slice(2)
        const value = args[++i]
        
        switch (key) {
          case 'max-urls':
            options.maxUrls = parseInt(value)
            break
          case 'timeout':
            options.timeout = parseInt(value) * 1000
            break
          case 'output':
            options.output = value
            break
          case 'parallel':
            options.parallel = parseInt(value)
            break
          case 'verbose':
            options.verbose = value === 'true'
            break
          case 'include-toc':
            options.includeToc = value === 'true'
            break
          case 'separator':
            options.separator = value
            break
        }
      } else if (arg.startsWith('http://') || arg.startsWith('https://')) {
        urls.push(arg)
      }
    }
    
    return { ...options, urls }
  }

  private async validateUrls(urls: string[]): Promise<string[]> {
    const validUrls: string[] = []
    
    for (const url of urls) {
      try {
        const parsed = new URL(url)
        
        // Security: Only allow HTTP/HTTPS
        if (!['http:', 'https:'].includes(parsed.protocol)) {
          console.error(`❌ Invalid protocol: ${url}`)
          continue
        }
        
        // Security: Block private IPs
        if (this.isPrivateIP(parsed.hostname)) {
          console.error(`❌ Private network access blocked: ${url}`)
          continue
        }
        
        validUrls.push(url)
      } catch (error) {
        console.error(`❌ Invalid URL: ${url}`)
      }
    }
    
    return validUrls
  }

  private isPrivateIP(hostname: string): boolean {
    // Check for private IP ranges
    const privatePatterns = [
      /^127\./,
      /^10\./,
      /^172\.(1[6-9]|2[0-9]|3[0-1])\./,
      /^192\.168\./,
      /^localhost$/i,
      /^::1$/
    ]
    
    return privatePatterns.some(pattern => pattern.test(hostname))
  }

  private async fetchPagesParallel(
    urls: string[], 
    options: WebMergeOptions
  ): Promise<Array<{url: string, content: string, metadata: any}>> {
    const results = []
    const batchSize = Math.min(options.parallel || 5, 5) // Security: Max 5 concurrent
    
    console.log(`📊 Processing ${urls.length} URLs in batches of ${batchSize}`)
    
    // Process in batches with rate limiting
    for (let i = 0; i < urls.length; i += batchSize) {
      const batch = urls.slice(i, i + batchSize)
      
      // Add delay between batches to prevent rate limiting
      if (i > 0) {
        await this.delay(1000) // 1 second delay between batches
      }
      
      const batchPromises = batch.map(url => 
        this.fetchPageWithTimeout(url, options)
      )
      
      const batchResults = await Promise.allSettled(batchPromises)
      
      for (let j = 0; j < batchResults.length; j++) {
        const result = batchResults[j]
        if (result.status === 'fulfilled') {
          results.push(result.value)
          console.log(`✅ Fetched: ${batch[j]}`)
        } else {
          console.error(`❌ Failed to fetch ${batch[j]}: ${result.reason}`)
        }
      }
    }
    
    return results
  }
  
  private async fetchPageWithTimeout(
    url: string,
    options: WebMergeOptions
  ): Promise<{url: string, content: string, metadata: any}> {
    // Implement timeout wrapper
    const timeoutPromise = new Promise((_, reject) => {
      setTimeout(() => reject(new Error('Timeout')), options.timeout || 30000)
    })
    
    return Promise.race([
      this.fetchPage(url, options),
      timeoutPromise
    ]) as Promise<{url: string, content: string, metadata: any}>
  }
  
  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms))
  }

  private async fetchPage(
    url: string, 
    options: WebMergeOptions
  ): Promise<{url: string, content: string, metadata: any}> {
    // Security: Sanitize prompt to prevent injection
    const sanitizedPrompt = 'Extract the main content, title, and metadata from this page'
      .replace(/[<>'"]/g, '') // Remove potentially dangerous characters
    
    // Use WebFetch tool to get content
    const response = await WebFetch({
      url,
      prompt: sanitizedPrompt
    })
    
    // Security: Validate content size
    if (response.content.length > 1024 * 1024) {
      throw new Error(`Content exceeds 1MB limit for ${url}`)
    }
    
    // Security: Sanitize HTML content
    const sanitizedContent = this.sanitizeHtml(response.content)
    
    return {
      url,
      content: sanitizedContent,
      metadata: {
        title: this.sanitizeText(response.title || 'Untitled'),
        retrievedAt: new Date().toISOString()
      }
    }
  }
  
  private sanitizeHtml(html: string): string {
    // Remove dangerous elements and attributes
    return html
      .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '')
      .replace(/<iframe\b[^<]*(?:(?!<\/iframe>)<[^<]*)*<\/iframe>/gi, '')
      .replace(/<embed\b[^<]*(?:(?!<\/embed>)<[^<]*)*<\/embed>/gi, '')
      .replace(/<object\b[^<]*(?:(?!<\/object>)<[^<]*)*<\/object>/gi, '')
      .replace(/javascript:/gi, '')
      .replace(/on\w+\s*=/gi, '') // Remove event handlers
      .replace(/style\s*=\s*["'][^"']*["']/gi, '') // Remove inline styles
  }
  
  private sanitizeText(text: string): string {
    // Sanitize plain text to prevent XSS
    return text
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;')
  }

  private async convertToMarkdown(
    pages: Array<{url: string, content: string, metadata: any}>
  ): Promise<Array<{url: string, markdown: string, metadata: any}>> {
    return pages.map(page => ({
      url: page.url,
      markdown: this.htmlToMarkdown(page.content),
      metadata: page.metadata
    }))
  }

  private htmlToMarkdown(html: string): string {
    // Simple HTML to Markdown conversion
    // In production, use a proper HTML to Markdown library
    return html
      .replace(/<h1>(.*?)<\/h1>/g, '# $1')
      .replace(/<h2>(.*?)<\/h2>/g, '## $1')
      .replace(/<h3>(.*?)<\/h3>/g, '### $1')
      .replace(/<p>(.*?)<\/p>/g, '$1\n')
      .replace(/<a href="(.*?)">(.*?)<\/a>/g, '[$2]($1)')
      .replace(/<[^>]+>/g, '')
  }

  private mergeDocuments(
    pages: Array<{url: string, markdown: string, metadata: any}>,
    options: WebMergeOptions
  ): string {
    let document = '# Web Pages Merge Report\n\n'
    
    // Add metadata
    document += `**Generated:** ${new Date().toISOString()}\n`
    document += `**Pages:** ${pages.length}\n\n`
    
    // Add table of contents
    if (options.includeToc) {
      document += '## Table of Contents\n\n'
      pages.forEach((page, index) => {
        document += `${index + 1}. [${page.metadata.title}](#page-${index + 1})\n`
      })
      document += '\n'
    }
    
    // Add pages
    pages.forEach((page, index) => {
      document += `${options.separator}\n\n`
      document += `## Page ${index + 1}: ${page.metadata.title}\n`
      document += `**URL:** ${page.url}\n`
      document += `**Retrieved:** ${page.metadata.retrievedAt}\n\n`
      document += page.markdown
      document += '\n\n'
      
      // Add navigation
      const navLinks = []
      if (index > 0) {
        navLinks.push(`[← Previous](#page-${index})`)
      }
      if (options.includeToc) {
        navLinks.push('[↑ Top](#table-of-contents)')
      }
      if (index < pages.length - 1) {
        navLinks.push(`[Next →](#page-${index + 2})`)
      }
      
      if (navLinks.length > 0) {
        document += navLinks.join(' | ') + '\n\n'
      }
    })
    
    return document
  }

  private async writeOutput(content: string, options: WebMergeOptions): Promise<void> {
    const filename = options.output || `web-merge-${Date.now()}.md`
    await Write({
      file_path: filename,
      content
    })
    
    console.log(`✅ Merged ${options.urls.length} pages to ${filename}`)
  }
}

// Export for use in Claude Code
export default WebMergeCommand
```

### Phase 2: Security Review

**Security Vulnerabilities Assessment**:

1. **URL Validation**: ✅ Implemented strict validation
2. **SSRF Prevention**: ✅ Private IP blocking implemented
3. **Resource Limits**: ⚠️ Need to add size limits
4. **Input Sanitization**: ⚠️ Need to sanitize HTML content

**Improvements Required**:

```typescript
// Add to fetchPage method
if (response.content.length > 1024 * 1024) {
  throw new Error('Page content exceeds 1MB limit')
}

// Add HTML sanitization
private sanitizeHtml(html: string): string {
  // Remove script tags and dangerous elements
  return html
    .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '')
    .replace(/<iframe\b[^<]*(?:(?!<\/iframe>)<[^<]*)*<\/iframe>/gi, '')
    .replace(/javascript:/gi, '')
    .replace(/on\w+\s*=/gi, '')
}
```

### Phase 3: SOLID Principles Review

**Architecture Assessment**:

1. **Single Responsibility**: ⚠️ WebMergeCommand does too much
2. **Open/Closed**: ✅ Extensible through options
3. **Interface Segregation**: ⚠️ Need to separate concerns
4. **Dependency Inversion**: ⚠️ Direct tool dependencies

**Refactored Implementation**:

```typescript
// Interfaces for dependency inversion
interface IUrlValidator {
  validate(urls: string[]): Promise<string[]>
}

interface IPageFetcher {
  fetch(url: string, options: FetchOptions): Promise<Page>
}

interface IHtmlConverter {
  convert(html: string): string
}

interface IDocumentMerger {
  merge(pages: Page[], options: MergeOptions): string
}

// Domain models
interface Page {
  url: string
  content: string
  metadata: PageMetadata
}

interface PageMetadata {
  title: string
  retrievedAt: string
}

// Concrete implementations
class SecureUrlValidator implements IUrlValidator {
  private readonly privatePatterns = [
    /^127\./,
    /^10\./,
    /^172\.(1[6-9]|2[0-9]|3[0-1])\./,
    /^192\.168\./,
    /^localhost$/i,
    /^::1$/
  ]

  async validate(urls: string[]): Promise<string[]> {
    const validUrls: string[] = []
    
    for (const url of urls) {
      try {
        const parsed = new URL(url)
        
        if (!['http:', 'https:'].includes(parsed.protocol)) {
          console.error(`❌ Invalid protocol: ${url}`)
          continue
        }
        
        if (this.isPrivateIP(parsed.hostname)) {
          console.error(`❌ Private network access blocked: ${url}`)
          continue
        }
        
        validUrls.push(url)
      } catch (error) {
        console.error(`❌ Invalid URL: ${url}`)
      }
    }
    
    return validUrls
  }

  private isPrivateIP(hostname: string): boolean {
    return this.privatePatterns.some(pattern => pattern.test(hostname))
  }
}

class ParallelPageFetcher implements IPageFetcher {
  constructor(
    private readonly maxConcurrent: number = 5,
    private readonly timeout: number = 30000
  ) {}

  async fetch(url: string, options: FetchOptions): Promise<Page> {
    const sanitizedPrompt = 'Extract the main content, title, and metadata from this page'
      .replace(/[<>'"]/g, '')
    
    const response = await this.fetchWithTimeout(url, sanitizedPrompt)
    
    if (response.content.length > 1024 * 1024) {
      throw new Error(`Content exceeds 1MB limit for ${url}`)
    }
    
    return {
      url,
      content: this.sanitizeHtml(response.content),
      metadata: {
        title: this.sanitizeText(response.title || 'Untitled'),
        retrievedAt: new Date().toISOString()
      }
    }
  }

  private async fetchWithTimeout(url: string, prompt: string): Promise<any> {
    const timeoutPromise = new Promise((_, reject) => {
      setTimeout(() => reject(new Error('Timeout')), this.timeout)
    })
    
    return Promise.race([
      WebFetch({ url, prompt }),
      timeoutPromise
    ])
  }

  private sanitizeHtml(html: string): string {
    return html
      .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '')
      .replace(/<iframe\b[^<]*(?:(?!<\/iframe>)<[^<]*)*<\/iframe>/gi, '')
      .replace(/<embed\b[^<]*(?:(?!<\/embed>)<[^<]*)*<\/embed>/gi, '')
      .replace(/<object\b[^<]*(?:(?!<\/object>)<[^<]*)*<\/object>/gi, '')
      .replace(/javascript:/gi, '')
      .replace(/on\w+\s*=/gi, '')
      .replace(/style\s*=\s*["'][^"']*["']/gi, '')
  }

  private sanitizeText(text: string): string {
    return text
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;')
  }
}

class MarkdownConverter implements IHtmlConverter {
  convert(html: string): string {
    return html
      .replace(/<h1>(.*?)<\/h1>/g, '# $1')
      .replace(/<h2>(.*?)<\/h2>/g, '## $1')
      .replace(/<h3>(.*?)<\/h3>/g, '### $3')
      .replace(/<h4>(.*?)<\/h4>/g, '#### $1')
      .replace(/<p>(.*?)<\/p>/g, '$1\n')
      .replace(/<a href="(.*?)">(.*?)<\/a>/g, '[$2]($1)')
      .replace(/<strong>(.*?)<\/strong>/g, '**$1**')
      .replace(/<em>(.*?)<\/em>/g, '*$1*')
      .replace(/<ul>(.*?)<\/ul>/gs, (match, content) => {
        return content.replace(/<li>(.*?)<\/li>/g, '- $1\n')
      })
      .replace(/<ol>(.*?)<\/ol>/gs, (match, content) => {
        let counter = 1
        return content.replace(/<li>(.*?)<\/li>/g, () => `${counter++}. $1\n`)
      })
      .replace(/<[^>]+>/g, '')
  }
}

class DocumentMerger implements IDocumentMerger {
  merge(pages: Page[], options: MergeOptions): string {
    let document = '# Web Pages Merge Report\n\n'
    
    document += `**Generated:** ${new Date().toISOString()}\n`
    document += `**Pages:** ${pages.length}\n\n`
    
    if (options.includeToc) {
      document += this.generateToc(pages)
    }
    
    pages.forEach((page, index) => {
      document += this.generatePageSection(page, index, pages.length, options)
    })
    
    return document
  }

  private generateToc(pages: Page[]): string {
    let toc = '## Table of Contents\n\n'
    pages.forEach((page, index) => {
      toc += `${index + 1}. [${page.metadata.title}](#page-${index + 1})\n`
    })
    return toc + '\n'
  }

  private generatePageSection(
    page: Page, 
    index: number, 
    totalPages: number, 
    options: MergeOptions
  ): string {
    let section = `${options.separator || '---'}\n\n`
    section += `## Page ${index + 1}: ${page.metadata.title}\n`
    section += `**URL:** ${page.url}\n`
    section += `**Retrieved:** ${page.metadata.retrievedAt}\n\n`
    section += page.content + '\n\n'
    section += this.generateNavigation(index, totalPages, options.includeToc)
    return section
  }

  private generateNavigation(
    index: number, 
    totalPages: number, 
    includeToc: boolean
  ): string {
    const navLinks = []
    
    if (index > 0) {
      navLinks.push(`[← Previous](#page-${index})`)
    }
    if (includeToc) {
      navLinks.push('[↑ Top](#table-of-contents)')
    }
    if (index < totalPages - 1) {
      navLinks.push(`[Next →](#page-${index + 2})`)
    }
    
    return navLinks.length > 0 ? navLinks.join(' | ') + '\n\n' : ''
  }
}

// Main command with dependency injection
class WebMergeCommand {
  constructor(
    private readonly validator: IUrlValidator,
    private readonly fetcher: IPageFetcher,
    private readonly converter: IHtmlConverter,
    private readonly merger: IDocumentMerger,
    private readonly options: WebMergeOptions = {}
  ) {}
  
  async execute(args: string[]): Promise<void> {
    const parsedOptions = this.parseArguments(args)
    const validUrls = await this.validator.validate(parsedOptions.urls)
    
    if (validUrls.length === 0) {
      throw new Error('No valid URLs to process')
    }
    
    const pages = await this.fetchPages(validUrls, parsedOptions)
    const convertedPages = await this.convertPages(pages)
    const mergedDocument = this.merger.merge(convertedPages, parsedOptions)
    
    await this.writeOutput(mergedDocument, parsedOptions)
  }
  
  private async fetchPages(urls: string[], options: WebMergeOptions): Promise<Page[]> {
    // Batch processing with rate limiting
    const results: Page[] = []
    const batchSize = Math.min(options.parallel || 5, 5)
    
    for (let i = 0; i < urls.length; i += batchSize) {
      if (i > 0) await this.delay(1000) // Rate limiting
      
      const batch = urls.slice(i, i + batchSize)
      const promises = batch.map(url => this.fetcher.fetch(url, options))
      const batchResults = await Promise.allSettled(promises)
      
      batchResults.forEach((result, j) => {
        if (result.status === 'fulfilled') {
          results.push(result.value)
        } else {
          console.error(`❌ Failed: ${batch[j]}`)
        }
      })
    }
    
    return results
  }
  
  private async convertPages(pages: Page[]): Promise<Page[]> {
    return pages.map(page => ({
      ...page,
      content: this.converter.convert(page.content)
    }))
  }
  
  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms))
  }
  
  private parseArguments(args: string[]): WebMergeOptions {
    // ... parsing logic ...
  }
  
  private async writeOutput(content: string, options: WebMergeOptions): Promise<void> {
    const filename = options.output || `web-merge-${Date.now()}.md`
    await Write({ file_path: filename, content })
    console.log(`✅ Merged to ${filename}`)
  }
}

// Factory for creating command with dependencies
class WebMergeCommandFactory {
  static create(options?: Partial<WebMergeOptions>): WebMergeCommand {
    return new WebMergeCommand(
      new SecureUrlValidator(),
      new ParallelPageFetcher(options?.parallel, options?.timeout),
      new MarkdownConverter(),
      new DocumentMerger(),
      options
    )
  }
}

// Export for use
export default WebMergeCommandFactory
```

### Phase 4: Performance Optimization

**Performance Assessment**:

1. **Parallel Processing**: ✅ Batch processing implemented
2. **Memory Usage**: ⚠️ Need streaming for large files
3. **Progress Tracking**: ⚠️ Add user feedback
4. **Error Recovery**: ⚠️ Improve partial success handling

**Optimized Implementation**:

```typescript
// Enhanced command with progress tracking
class PerformantWebMergeCommand extends WebMergeCommand {
  private progressBar?: any
  
  async execute(args: string[]): Promise<void> {
    const parsedOptions = this.parseArguments(args)
    
    console.log('🔍 Validating URLs...')
    const validUrls = await this.validator.validate(parsedOptions.urls)
    
    if (validUrls.length === 0) {
      throw new Error('No valid URLs to process')
    }
    
    console.log(`✅ ${validUrls.length} valid URLs found`)
    
    // Initialize progress tracking
    this.initializeProgress(validUrls.length)
    
    try {
      const pages = await this.fetchPagesWithProgress(validUrls, parsedOptions)
      const convertedPages = await this.convertPages(pages)
      const mergedDocument = this.merger.merge(convertedPages, parsedOptions)
      
      await this.writeOutput(mergedDocument, parsedOptions)
      
      // Summary report
      this.printSummary(validUrls.length, pages.length)
    } finally {
      this.cleanupProgress()
    }
  }
  
  private initializeProgress(total: number): void {
    this.progressBar = {
      total,
      current: 0,
      failed: 0,
      startTime: Date.now()
    }
  }
  
  private updateProgress(success: boolean): void {
    if (!this.progressBar) return
    
    this.progressBar.current++
    if (!success) this.progressBar.failed++
    
    const percent = Math.round((this.progressBar.current / this.progressBar.total) * 100)
    const elapsed = Math.round((Date.now() - this.progressBar.startTime) / 1000)
    
    console.log(
      `📊 Progress: ${this.progressBar.current}/${this.progressBar.total} ` +
      `(${percent}%) - ${elapsed}s elapsed`
    )
  }
  
  private async fetchPagesWithProgress(
    urls: string[], 
    options: WebMergeOptions
  ): Promise<Page[]> {
    const results: Page[] = []
    const batchSize = Math.min(options.parallel || 5, 5)
    
    for (let i = 0; i < urls.length; i += batchSize) {
      if (i > 0) await this.delay(1000) // Rate limiting
      
      const batch = urls.slice(i, i + batchSize)
      const promises = batch.map(url => 
        this.fetchWithRetry(url, options, 3) // Add retry logic
      )
      
      const batchResults = await Promise.allSettled(promises)
      
      batchResults.forEach((result, j) => {
        if (result.status === 'fulfilled') {
          results.push(result.value)
          this.updateProgress(true)
          if (options.verbose) {
            console.log(`✅ Fetched: ${batch[j]}`)
          }
        } else {
          this.updateProgress(false)
          console.error(`❌ Failed: ${batch[j]} - ${result.reason}`)
        }
      })
    }
    
    return results
  }
  
  private async fetchWithRetry(
    url: string, 
    options: any, 
    maxRetries: number
  ): Promise<Page> {
    let lastError: Error | null = null
    
    for (let i = 0; i < maxRetries; i++) {
      try {
        return await this.fetcher.fetch(url, options)
      } catch (error) {
        lastError = error as Error
        if (i < maxRetries - 1) {
          console.log(`⚠️ Retry ${i + 1}/${maxRetries} for ${url}`)
          await this.delay(1000 * (i + 1)) // Exponential backoff
        }
      }
    }
    
    throw lastError || new Error('Failed after retries')
  }
  
  private printSummary(total: number, successful: number): void {
    const failed = total - successful
    const elapsed = this.progressBar 
      ? Math.round((Date.now() - this.progressBar.startTime) / 1000)
      : 0
    
    console.log('\n📈 Summary:')
    console.log(`  Total URLs: ${total}`)
    console.log(`  Successful: ${successful} ✅`)
    if (failed > 0) {
      console.log(`  Failed: ${failed} ❌`)
    }
    console.log(`  Time elapsed: ${elapsed}s`)
    console.log(`  Average: ${(elapsed / total).toFixed(1)}s per page`)
  }
  
  private cleanupProgress(): void {
    this.progressBar = undefined
  }
}

// Memory-efficient page fetcher for large content
class StreamingPageFetcher extends ParallelPageFetcher {
  async fetch(url: string, options: FetchOptions): Promise<Page> {
    const response = await super.fetch(url, options)
    
    // For very large content, truncate with notice
    if (response.content.length > 500000) {
      console.warn(`⚠️ Large content truncated for ${url}`)
      response.content = response.content.substring(0, 500000) + 
        '\n\n[... Content truncated due to size limit ...]'
    }
    
    return response
  }
}

// Enhanced factory with performance options
class PerformantWebMergeCommandFactory {
  static create(options?: Partial<WebMergeOptions>): WebMergeCommand {
    const enhancedOptions = {
      ...options,
      parallel: Math.min(options?.parallel || 5, 5), // Cap parallelism
      timeout: options?.timeout || 30000
    }
    
    return new PerformantWebMergeCommand(
      new SecureUrlValidator(),
      new StreamingPageFetcher(enhancedOptions.parallel, enhancedOptions.timeout),
      new MarkdownConverter(),
      new DocumentMerger(),
      enhancedOptions
    )
  }
}

export default PerformantWebMergeCommandFactory
```

## Command Options

| Option | Short | Description | Default |
|--------|-------|-------------|---------|
| `--max-urls` | `-m` | Maximum URLs to process | 10 |
| `--timeout` | `-t` | Timeout per URL (seconds) | 30 |
| `--output` | `-o` | Output filename | auto-generated |
| `--parallel` | `-p` | Parallel fetch count | 5 |
| `--verbose` | `-v` | Detailed logging | false |
| `--include-toc` | | Include table of contents | true |
| `--separator` | | Page separator style | --- |

## Usage Examples

### Basic Usage

```bash
# Merge two pages
/web-merge https://example1.com https://example2.com

# With custom output
/web-merge https://site1.com https://site2.com --output review.md

# Verbose mode with custom parallelism
/web-merge https://a.com https://b.com https://c.com --verbose true --parallel 2
```

### Error Handling

```bash
/web-merge https://invalid-url
❌ Invalid URL: https://invalid-url

/web-merge http://192.168.1.1
❌ Private network access blocked: http://192.168.1.1

/web-merge file:///etc/passwd
❌ Invalid protocol: file:///etc/passwd
```

## Security Constraints

### Enforced Restrictions

1. **URL Schemes**: Only HTTP/HTTPS allowed
2. **Private Networks**: Blocked (127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)
3. **Resource Limits**: 1MB per page, 30-second timeout
4. **No Auto-Follow**: Links discovered in pages are never accessed
5. **HTML Sanitization**: Script tags and dangerous elements removed

### Security Checklist

- [ ] URL validation before fetch
- [ ] Private IP blocking
- [ ] Size limit enforcement
- [ ] Timeout enforcement
- [ ] HTML sanitization
- [ ] No external resource fetching
- [ ] Single redirect maximum

## Quality Assurance

### Testing Strategy

1. **Unit Tests**: URL validation, HTML conversion
2. **Integration Tests**: End-to-end merge workflow
3. **Security Tests**: SSRF prevention, sanitization
4. **Performance Tests**: Parallel processing, large files

### Review Cycles

1. **Security Review**: Vulnerability assessment and fixes
2. **Architecture Review**: SOLID principles compliance
3. **Performance Review**: Optimization opportunities
4. **Final Validation**: Human review of output quality

---

**Note**: This command prioritizes security through strict validation and follows AI Review-First methodology for quality assurance.