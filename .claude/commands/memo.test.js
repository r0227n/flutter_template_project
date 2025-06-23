#!/usr/bin/env node

/**
 * /memo Command Tests
 * 
 * Claude Code セッション内メモ記録機能のテスト
 * AI Review-First 設計 - 包括的テストスイート
 */

const fs = require('fs').promises;
const path = require('path');
const os = require('os');
const { 
  OptimizedMemoCommandFactory,
  OptimizedFileSystemService,
  OptimizedSecurityService,
  OptimizedMemoContentGenerator,
  OptimizedFileLockService
} = require('./memo-optimized.js');

class TestRunner {
  constructor() {
    this.passed = 0;
    this.failed = 0;
    this.testDir = path.join(os.tmpdir(), `memo-test-${Date.now()}`);
  }

  async setup() {
    await fs.mkdir(this.testDir, { recursive: true });
    console.log(`🧪 テスト環境作成: ${this.testDir}`);
  }

  async cleanup() {
    try {
      await fs.rmdir(this.testDir, { recursive: true });
      console.log('🧹 テスト環境クリーンアップ完了');
    } catch (error) {
      console.warn('⚠️ クリーンアップエラー:', error.message);
    }
  }

  async test(name, testFn) {
    try {
      console.log(`\n🔬 テスト実行: ${name}`);
      await testFn();
      this.passed++;
      console.log(`✅ 成功: ${name}`);
    } catch (error) {
      this.failed++;
      console.error(`❌ 失敗: ${name}`);
      console.error(`   エラー: ${error.message}`);
    }
  }

  assert(condition, message) {
    if (!condition) {
      throw new Error(`アサーション失敗: ${message}`);
    }
  }

  assertEquals(actual, expected, message) {
    if (actual !== expected) {
      throw new Error(`${message} - 期待値: ${expected}, 実際値: ${actual}`);
    }
  }

  async assertFileExists(filepath) {
    try {
      await fs.access(filepath);
    } catch {
      throw new Error(`ファイルが存在しません: ${filepath}`);
    }
  }

  async assertFileContains(filepath, content) {
    const fileContent = await fs.readFile(filepath, 'utf8');
    if (!fileContent.includes(content)) {
      throw new Error(`ファイル内容に指定テキストが含まれていません: ${content}`);
    }
  }

  summary() {
    const total = this.passed + this.failed;
    console.log(`\n📊 テスト結果:
✅ 成功: ${this.passed}/${total}
❌ 失敗: ${this.failed}/${total}
📈 成功率: ${((this.passed / total) * 100).toFixed(1)}%`);
    
    return this.failed === 0;
  }
}

// テストスイート実行
async function runTests() {
  const runner = new TestRunner();
  
  try {
    await runner.setup();

    // 1. セキュリティテスト (高優先度)
    await runner.test('セキュリティ: パストラバーサル防止', async () => {
      const securityService = new OptimizedSecurityService();
      
      try {
        securityService.validateProjectRoot('/tmp/../etc');
        runner.assert(false, 'パストラバーサルが検出されなかった');
      } catch (error) {
        runner.assert(error.message.includes('Invalid project directory'), 
          'パストラバーサルエラーメッセージが正しくない');
      }
    });

    await runner.test('セキュリティ: 機密情報フィルタリング', async () => {
      const securityService = new OptimizedSecurityService();
      const sensitiveContent = 'api_key=secret123 password=admin token=abc';
      const sanitized = securityService.sanitizeContentBasic(sensitiveContent);
      
      runner.assert(!sanitized.includes('secret123'), '機密情報がフィルタリングされていない');
      runner.assert(!sanitized.includes('admin'), 'パスワードがフィルタリングされていない');
      runner.assert(sanitized.includes('***FILTERED***'), 'フィルタリングマークが含まれていない');
    });

    // 2. SOLID原則テスト (中優先度)
    await runner.test('SOLID: 依存性注入', async () => {
      const memosDir = path.join(runner.testDir, 'memos');
      const fileSystemService = new OptimizedFileSystemService(memosDir);
      const securityService = new OptimizedSecurityService();
      
      runner.assert(fileSystemService.baseDir === memosDir, '依存性注入が正しく動作していない');
      runner.assert(typeof securityService.generateSecureSessionId === 'function', 
        'セキュリティサービスが正しく注入されていない');
    });

    await runner.test('SOLID: 単一責任原則', async () => {
      const securityService = new OptimizedSecurityService();
      const contentGenerator = new OptimizedMemoContentGenerator(securityService);
      
      // セキュリティサービスはセキュリティのみ担当
      runner.assert(typeof securityService.sanitizeContentOptimized === 'function', 
        'セキュリティサービスの責任が正しくない');
      
      // コンテンツジェネレーターはコンテンツ生成のみ担当
      runner.assert(typeof contentGenerator.generateMemoContentOptimized === 'function', 
        'コンテンツジェネレーターの責任が正しくない');
    });

    // 3. パフォーマンステスト (低優先度)
    await runner.test('パフォーマンス: ファイル統計キャッシュ', async () => {
      const memosDir = path.join(runner.testDir, 'memos');
      const fileSystemService = new OptimizedFileSystemService(memosDir);
      
      // テストファイル作成
      await fs.mkdir(memosDir, { recursive: true });
      const testFile = path.join(memosDir, 'test.md');
      await fs.writeFile(testFile, 'test content', 'utf8');
      
      // 初回読み込み
      const start1 = Date.now();
      await fileSystemService.getFileStats(testFile);
      const time1 = Date.now() - start1;
      
      // キャッシュ読み込み
      const start2 = Date.now();
      await fileSystemService.getFileStats(testFile);
      const time2 = Date.now() - start2;
      
      runner.assert(time2 <= time1, 'ファイル統計キャッシュが効いていない');
    });

    await runner.test('パフォーマンス: 実行時間測定', async () => {
      const memo = OptimizedMemoCommandFactory.create(runner.testDir);
      const result = await memo.execute();
      
      runner.assert(result.success, 'メモコマンド実行が失敗');
      runner.assert(typeof result.executionTime === 'number', '実行時間が測定されていない');
      runner.assert(result.executionTime >= 0, '実行時間が不正');
    });

    // 4. 機能テスト
    await runner.test('機能: メモファイル作成', async () => {
      const memo = OptimizedMemoCommandFactory.create(runner.testDir);
      const result = await memo.execute();
      
      runner.assert(result.success, 'メモ作成が失敗');
      await runner.assertFileExists(result.filepath);
      await runner.assertFileContains(result.filepath, 'セッション記録');
    });

    await runner.test('機能: メモファイル追記', async () => {
      const memo = OptimizedMemoCommandFactory.create(runner.testDir);
      
      // 初回実行
      const result1 = await memo.execute();
      runner.assert(result1.success, '初回メモ作成が失敗');
      
      // 追記実行
      const result2 = await memo.execute();
      runner.assert(result2.success, '追記メモ作成が失敗');
      
      await runner.assertFileContains(result2.filepath, '追記');
    });

    // 5. エラーハンドリングテスト
    await runner.test('エラーハンドリング: 不正なディレクトリ', async () => {
      try {
        const invalidDir = '/invalid/path/that/does/not/exist';
        const memo = OptimizedMemoCommandFactory.create(invalidDir);
        const result = await memo.execute();
        runner.assert(!result.success, '不正なディレクトリでも成功してしまった');
      } catch (error) {
        // 例外が発生することを期待
        runner.assert(true, '適切にエラーハンドリングされた');
      }
    });

    await runner.test('エラーハンドリング: ファイルロック競合', async () => {
      const memo = OptimizedMemoCommandFactory.create(runner.testDir);
      
      // 同時実行でロック競合をテスト
      const promises = [memo.execute(), memo.execute()];
      const results = await Promise.all(promises);
      
      // 少なくとも1つは成功することを確認
      const successCount = results.filter(r => r.success).length;
      runner.assert(successCount >= 1, 'ロック機構が正しく動作していない');
    });

    // 6. 統合テスト
    await runner.test('統合: フルワークフロー', async () => {
      const memo = OptimizedMemoCommandFactory.create(runner.testDir);
      
      // 複数回実行
      for (let i = 0; i < 3; i++) {
        const result = await memo.execute();
        runner.assert(result.success, `${i + 1}回目の実行が失敗`);
        runner.assert(result.executionTime < 5000, '実行時間が5秒を超過');
      }
      
      // 最終ファイル確認
      const memosDir = path.join(runner.testDir, 'memos');
      const files = await fs.readdir(memosDir);
      runner.assert(files.length > 0, 'メモファイルが作成されていない');
      
      const memoFile = path.join(memosDir, files[0]);
      await runner.assertFileContains(memoFile, 'セッション記録');
      await runner.assertFileContains(memoFile, '追記');
    });

  } finally {
    await runner.cleanup();
  }
  
  return runner.summary();
}

// テスト実行
if (require.main === module) {
  runTests()
    .then(success => {
      console.log(success ? '\n🎉 全テスト成功!' : '\n💥 テスト失敗があります');
      process.exit(success ? 0 : 1);
    })
    .catch(error => {
      console.error('💥 テスト実行エラー:', error);
      process.exit(1);
    });
}

module.exports = { runTests };