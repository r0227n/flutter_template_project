#!/usr/bin/env node

/**
 * /memo Command Implementation
 * 
 * Claude Code セッション内メモ記録機能
 * AI Review-First 設計 - SOLID原則適用版
 */

const fs = require('fs').promises;
const path = require('path');
const crypto = require('crypto');

// 1. Single Responsibility: ファイルシステム操作の分離
class FileSystemService {
  constructor(baseDir) {
    this.baseDir = path.resolve(baseDir);
    this.maxFileSize = 10 * 1024 * 1024; // 10MB
  }

  async ensureDirectory(dirPath) {
    try {
      await fs.access(dirPath);
    } catch (error) {
      await fs.mkdir(dirPath, { recursive: true });
    }
  }

  async validateFile(filepath) {
    const stats = await fs.stat(filepath).catch(() => null);
    
    if (stats && stats.size > this.maxFileSize) {
      throw new Error(`File size exceeds limit: ${stats.size} bytes`);
    }
    
    return stats;
  }

  async writeFileSecurely(filepath, content) {
    // セキュリティ: ファイルパス検証
    const normalizedPath = path.normalize(filepath);
    if (!normalizedPath.startsWith(this.baseDir)) {
      throw new Error('File path outside allowed directory');
    }

    await this.validateFile(filepath);
    await fs.writeFile(filepath, content, 'utf8');
  }

  async appendFileSecurely(filepath, content) {
    const normalizedPath = path.normalize(filepath);
    if (!normalizedPath.startsWith(this.baseDir)) {
      throw new Error('File path outside allowed directory');
    }

    await this.validateFile(filepath);
    await fs.appendFile(filepath, content, 'utf8');
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

// 2. Single Responsibility: セキュリティ機能の分離
class SecurityService {
  constructor() {
    this.sensitivePatterns = [
      /api[_-]?key/i,
      /password/i,
      /secret/i,
      /token/i,
      /credential/i,
      /auth/i
    ];
  }

  sanitizeContent(content) {
    let sanitized = content;
    
    // 機密情報パターンのマスク
    this.sensitivePatterns.forEach(pattern => {
      sanitized = sanitized.replace(pattern, '***FILTERED***');
    });
    
    // 制御文字の除去
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

// 3. Single Responsibility: コンテンツ生成の分離
class MemoContentGenerator {
  constructor(securityService) {
    this.securityService = securityService;
  }

  generateMemoContent(sessionId) {
    const now = new Date();
    const timestamp = now.toLocaleString('ja-JP');
    
    const content = `# セッション記録 - ${timestamp}

## 概要
Claude Code セッション内でのメモ記録

## セッション情報
- セッションID: ${sessionId}
- 記録時刻: ${timestamp}
- コマンド実行: /memo

## 内容
このセッション内での重要な内容や決定事項をここに記録します。

---
*このメモは /memo コマンドにより自動生成されました*
`;

    return this.securityService.sanitizeContent(content);
  }

  generateAppendContent(originalContent) {
    const timestamp = new Date().toLocaleString('ja-JP');
    const appendSection = originalContent.split('## 内容')[1] || '追加のメモ内容';
    
    const content = `

---

## 追記 - ${timestamp}

${appendSection}
`;

    return this.securityService.sanitizeContent(content);
  }
}

// 4. Open-Closed: 拡張可能なファイル名生成戦略
class FilenameStrategy {
  generateFilename() {
    throw new Error('generateFilename must be implemented by subclass');
  }
}

class DateTimeFilenameStrategy extends FilenameStrategy {
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

// 5. Interface Segregation: ロック機能の分離
class FileLockService {
  async withLock(filepath, operation) {
    const lockFile = `${filepath}.lock`;
    
    try {
      // ロックファイル作成
      await fs.writeFile(lockFile, process.pid.toString(), { flag: 'wx' });
      
      try {
        return await operation();
      } finally {
        // ロックファイル削除
        await fs.unlink(lockFile).catch(() => {});
      }
      
    } catch (error) {
      if (error.code === 'EEXIST') {
        throw new Error('Another memo operation is in progress');
      }
      throw error;
    }
  }
}

// 6. Dependency Inversion: メインクラスの依存性注入
class MemoCommand {
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
    try {
      // ディレクトリ作成
      await this.fileSystemService.ensureDirectory(this.fileSystemService.baseDir);
      
      // ファイル名生成
      const filename = this.filenameStrategy.generateFilename();
      const filepath = path.join(this.fileSystemService.baseDir, filename);
      
      // コンテンツ生成
      const content = this.contentGenerator.generateMemoContent(this.sessionId);
      
      // ロック付きファイル操作
      await this.lockService.withLock(filepath, async () => {
        const exists = await this.fileSystemService.fileExists(filepath);
        
        if (exists) {
          // 追記
          const appendContent = this.contentGenerator.generateAppendContent(content);
          await this.fileSystemService.appendFileSecurely(filepath, appendContent);
          console.log('📝 既存ファイルに追記しました');
        } else {
          // 新規作成
          await this.fileSystemService.writeFileSecurely(filepath, content);
          console.log('📄 新規ファイルを作成しました');
        }
      });
      
      console.log(`✅ メモを保存しました: ${filepath}`);
      return { success: true, filepath };
      
    } catch (error) {
      console.error('❌ メモの保存に失敗しました:', error.message);
      return { success: false, error: error.message };
    }
  }
}

// Factory Pattern: 依存性の構築
class MemoCommandFactory {
  static create(projectRoot = process.cwd()) {
    // セキュリティサービス
    const securityService = new SecurityService();
    const validatedRoot = securityService.validateProjectRoot(projectRoot);
    
    // 各サービスの構築
    const memosDir = path.join(validatedRoot, 'memos');
    const fileSystemService = new FileSystemService(memosDir);
    const contentGenerator = new MemoContentGenerator(securityService);
    const filenameStrategy = new DateTimeFilenameStrategy();
    const lockService = new FileLockService();
    
    return new MemoCommand(
      fileSystemService,
      securityService,
      contentGenerator,
      filenameStrategy,
      lockService
    );
  }
}

// コマンド実行
async function main() {
  const memo = MemoCommandFactory.create();
  const result = await memo.execute();
  
  process.exit(result.success ? 0 : 1);
}

if (require.main === module) {
  main().catch(console.error);
}

module.exports = { 
  MemoCommand,
  MemoCommandFactory,
  FileSystemService,
  SecurityService,
  MemoContentGenerator,
  DateTimeFilenameStrategy,
  FileLockService
};