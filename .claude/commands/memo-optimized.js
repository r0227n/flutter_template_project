#!/usr/bin/env node

/**
 * /memo Command Implementation
 * 
 * Claude Code セッション内メモ記録機能
 * AI Review-First 設計 - パフォーマンス最適化版
 */

const fs = require('fs').promises;
const { createReadStream, createWriteStream } = require('fs');
const path = require('path');
const crypto = require('crypto');
const { pipeline } = require('stream/promises');

// Performance: File streaming for large files
class OptimizedFileSystemService {
  constructor(baseDir) {
    this.baseDir = path.resolve(baseDir);
    this.maxFileSize = 10 * 1024 * 1024; // 10MB
    this.streamThreshold = 1024 * 1024; // 1MB - threshold for streaming
    this.fileStatsCache = new Map(); // Performance: File stats caching
  }

  // Performance: Cached file stats
  async getFileStats(filepath) {
    if (this.fileStatsCache.has(filepath)) {
      const cached = this.fileStatsCache.get(filepath);
      // Cache expiry: 30 seconds
      if (Date.now() - cached.timestamp < 30000) {
        return cached.stats;
      }
    }

    const stats = await fs.stat(filepath).catch(() => null);
    if (stats) {
      this.fileStatsCache.set(filepath, {
        stats,
        timestamp: Date.now()
      });
    }
    
    return stats;
  }

  // Performance: Stream-based file validation for large files
  async validateFileStreaming(filepath) {
    const stats = await this.getFileStats(filepath);
    
    if (!stats) return null;
    
    if (stats.size > this.maxFileSize) {
      throw new Error(`File size exceeds limit: ${stats.size} bytes`);
    }
    
    // Performance: Use streaming for large files
    if (stats.size > this.streamThreshold) {
      return { ...stats, useStreaming: true };
    }
    
    return { ...stats, useStreaming: false };
  }

  // Performance: Optimized directory creation with caching
  async ensureDirectoryOptimized(dirPath) {
    if (this.directoryCache?.has(dirPath)) {
      return;
    }

    try {
      await fs.access(dirPath);
      if (!this.directoryCache) this.directoryCache = new Set();
      this.directoryCache.add(dirPath);
    } catch (error) {
      await fs.mkdir(dirPath, { recursive: true });
      if (!this.directoryCache) this.directoryCache = new Set();
      this.directoryCache.add(dirPath);
    }
  }

  // Performance: Streaming file operations for large content
  async writeFileOptimized(filepath, content) {
    const normalizedPath = path.normalize(filepath);
    if (!normalizedPath.startsWith(this.baseDir)) {
      throw new Error('File path outside allowed directory');
    }

    const stats = await this.validateFileStreaming(filepath);
    
    // Performance: Use streaming for large content
    if (Buffer.byteLength(content, 'utf8') > this.streamThreshold) {
      return this.streamWrite(filepath, content);
    }
    
    // Standard write for small files
    await fs.writeFile(filepath, content, 'utf8');
  }

  // Performance: Stream-based writing
  async streamWrite(filepath, content) {
    const writeStream = createWriteStream(filepath, { encoding: 'utf8' });
    
    return new Promise((resolve, reject) => {
      writeStream.on('error', reject);
      writeStream.on('finish', resolve);
      
      // Write content in chunks to optimize memory usage
      const chunkSize = 64 * 1024; // 64KB chunks
      let offset = 0;
      
      const writeChunk = () => {
        if (offset >= content.length) {
          writeStream.end();
          return;
        }
        
        const chunk = content.slice(offset, offset + chunkSize);
        offset += chunkSize;
        
        if (!writeStream.write(chunk)) {
          writeStream.once('drain', writeChunk);
        } else {
          setImmediate(writeChunk);
        }
      };
      
      writeChunk();
    });
  }

  async appendFileOptimized(filepath, content) {
    const normalizedPath = path.normalize(filepath);
    if (!normalizedPath.startsWith(this.baseDir)) {
      throw new Error('File path outside allowed directory');
    }

    await this.validateFileStreaming(filepath);
    
    // Performance: Use streaming for large appends
    if (Buffer.byteLength(content, 'utf8') > this.streamThreshold) {
      return this.streamAppend(filepath, content);
    }
    
    await fs.appendFile(filepath, content, 'utf8');
  }

  // Performance: Stream-based appending
  async streamAppend(filepath, content) {
    const writeStream = createWriteStream(filepath, { 
      flags: 'a', 
      encoding: 'utf8' 
    });
    
    return new Promise((resolve, reject) => {
      writeStream.on('error', reject);
      writeStream.on('finish', resolve);
      writeStream.end(content);
    });
  }

  async fileExists(filepath) {
    try {
      await fs.access(filepath);
      return true;
    } catch {
      return false;
    }
  }
}

// Performance: Optimized security service with pattern caching
class OptimizedSecurityService {
  constructor() {
    this.sensitivePatterns = [
      /api[_-]?key/i,
      /password/i,
      /secret/i,
      /token/i,
      /credential/i,
      /auth/i
    ];
    
    // Performance: Compiled regex cache
    this.compiledPatterns = this.sensitivePatterns.map(pattern => ({
      regex: pattern,
      global: new RegExp(pattern.source, pattern.flags + 'g')
    }));
  }

  // Performance: Optimized content sanitization
  sanitizeContentOptimized(content) {
    // Performance: Early return for small content
    if (content.length < 100) {
      return this.sanitizeContentBasic(content);
    }
    
    // Performance: Batch replace for large content
    let sanitized = content;
    
    // Use compiled global patterns for better performance
    this.compiledPatterns.forEach(({ global }) => {
      sanitized = sanitized.replace(global, '***FILTERED***');
    });
    
    // Performance: Optimized control character removal
    sanitized = sanitized.replace(/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]/g, '');
    
    return sanitized;
  }

  sanitizeContentBasic(content) {
    let sanitized = content;
    
    // Fix: Use global flag for proper replacement
    this.sensitivePatterns.forEach(pattern => {
      const globalPattern = new RegExp(pattern.source, pattern.flags + 'g');
      sanitized = sanitized.replace(globalPattern, '***FILTERED***');
    });
    
    sanitized = sanitized.replace(/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]/g, '');
    
    return sanitized;
  }

  generateSecureSessionId() {
    const randomBytes = crypto.randomBytes(16);
    const timestamp = Date.now();
    return `session_${timestamp}_${randomBytes.toString('hex')}`;
  }

  validateProjectRoot(rootPath) {
    const resolved = path.resolve(rootPath);
    
    if (resolved !== rootPath || resolved.includes('..')) {
      throw new Error('Invalid project directory detected');
    }
    
    return resolved;
  }
}

// Performance: Optimized content generator with template caching
class OptimizedMemoContentGenerator {
  constructor(securityService) {
    this.securityService = securityService;
    
    // Performance: Template caching
    this.templateCache = new Map();
  }

  // Performance: Template-based content generation
  generateMemoContentOptimized(sessionId) {
    const now = new Date();
    const timestamp = now.toLocaleString('ja-JP');
    
    // Performance: Use cached template
    const templateKey = 'memo_base';
    let template;
    
    if (this.templateCache.has(templateKey)) {
      template = this.templateCache.get(templateKey);
    } else {
      template = `# セッション記録 - {timestamp}

## 概要
Claude Code セッション内でのメモ記録

## セッション情報
- セッションID: {sessionId}
- 記録時刻: {timestamp}
- コマンド実行: /memo

## 内容
このセッション内での重要な内容や決定事項をここに記録します。

---
*このメモは /memo コマンドにより自動生成されました*
`;
      this.templateCache.set(templateKey, template);
    }
    
    // Performance: Simple string replacement instead of complex operations
    const content = template
      .replace(/{timestamp}/g, timestamp)
      .replace(/{sessionId}/g, sessionId);

    return this.securityService.sanitizeContentOptimized(content);
  }

  generateAppendContentOptimized(originalContent) {
    const timestamp = new Date().toLocaleString('ja-JP');
    
    // Fix: Generate proper append content independent of original
    const content = `

---

## 追記 - ${timestamp}

追加のメモ内容や決定事項をここに記録します。
`;

    return this.securityService.sanitizeContentOptimized(content);
  }
}

// Performance: Optimized lock service with timeout
class OptimizedFileLockService {
  constructor() {
    this.lockTimeout = 30000; // 30 seconds
    this.lockRetryInterval = 100; // 100ms
  }

  async withLockOptimized(filepath, operation) {
    const lockFile = `${filepath}.lock`;
    const startTime = Date.now();
    
    // Performance: Retry mechanism with timeout
    while (Date.now() - startTime < this.lockTimeout) {
      try {
        // Try to acquire lock
        await fs.writeFile(lockFile, process.pid.toString(), { flag: 'wx' });
        
        try {
          return await operation();
        } finally {
          // Always cleanup lock
          await fs.unlink(lockFile).catch(() => {});
        }
        
      } catch (error) {
        if (error.code === 'EEXIST') {
          // Performance: Exponential backoff
          await this.sleep(this.lockRetryInterval);
          this.lockRetryInterval = Math.min(this.lockRetryInterval * 1.5, 1000);
          continue;
        }
        throw error;
      }
    }
    
    throw new Error('Lock acquisition timeout exceeded');
  }

  // Performance: Optimized sleep function
  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}

// Main optimized command class
class OptimizedMemoCommand {
  constructor(
    fileSystemService,
    securityService,
    contentGenerator,
    filenameStrategy,
    lockService
  ) {
    this.fileSystemService = fileSystemService;
    this.securityService = securityService;
    this.contentGenerator = contentGenerator;
    this.filenameStrategy = filenameStrategy;
    this.lockService = lockService;
    
    this.sessionId = securityService.generateSecureSessionId();
  }

  async execute() {
    const startTime = Date.now();
    
    try {
      // Performance: Parallel operations where possible
      const [, filename] = await Promise.all([
        this.fileSystemService.ensureDirectoryOptimized(this.fileSystemService.baseDir),
        Promise.resolve(this.filenameStrategy.generateFilename())
      ]);
      
      const filepath = path.join(this.fileSystemService.baseDir, filename);
      
      // Performance: Generate content while checking file existence
      const [content, exists] = await Promise.all([
        Promise.resolve(this.contentGenerator.generateMemoContentOptimized(this.sessionId)),
        this.fileSystemService.fileExists(filepath)
      ]);
      
      // Performance: Optimized lock-based file operations
      await this.lockService.withLockOptimized(filepath, async () => {
        if (exists) {
          // Append mode
          const appendContent = this.contentGenerator.generateAppendContentOptimized(content);
          await this.fileSystemService.appendFileOptimized(filepath, appendContent);
          console.log('📝 既存ファイルに追記しました');
        } else {
          // Create mode
          await this.fileSystemService.writeFileOptimized(filepath, content);
          console.log('📄 新規ファイルを作成しました');
        }
      });
      
      const executionTime = Date.now() - startTime;
      console.log(`✅ メモを保存しました: ${filepath} (${executionTime}ms)`);
      
      return { 
        success: true, 
        filepath,
        executionTime
      };
      
    } catch (error) {
      const executionTime = Date.now() - startTime;
      console.error(`❌ メモの保存に失敗しました: ${error.message} (${executionTime}ms)`);
      
      return { 
        success: false, 
        error: error.message,
        executionTime
      };
    }
  }
}

// Base filename strategy (unchanged for compatibility)
class DateTimeFilenameStrategy {
  generateFilename() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hour = String(now.getHours()).padStart(2, '0');
    const minute = String(now.getMinutes()).padStart(2, '0');
    const second = String(now.getSeconds()).padStart(2, '0');
    
    return `${year}-${month}-${day}_${hour}-${minute}-${second}_memo.md`;
  }
}

// Performance: Optimized factory
class OptimizedMemoCommandFactory {
  static create(projectRoot = process.cwd()) {
    const securityService = new OptimizedSecurityService();
    const validatedRoot = securityService.validateProjectRoot(projectRoot);
    
    const memosDir = path.join(validatedRoot, 'memos');
    const fileSystemService = new OptimizedFileSystemService(memosDir);
    const contentGenerator = new OptimizedMemoContentGenerator(securityService);
    const filenameStrategy = new DateTimeFilenameStrategy();
    const lockService = new OptimizedFileLockService();
    
    return new OptimizedMemoCommand(
      fileSystemService,
      securityService,
      contentGenerator,
      filenameStrategy,
      lockService
    );
  }
}

module.exports = { 
  OptimizedMemoCommand,
  OptimizedMemoCommandFactory,
  OptimizedFileSystemService,
  OptimizedSecurityService,
  OptimizedMemoContentGenerator,
  OptimizedFileLockService
};