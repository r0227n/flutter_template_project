#!/usr/bin/env node

/**
 * /memo Command Implementation
 * 
 * Claude Code セッション内メモ記録機能
 * AI Review-First 設計 - SOLID原則適用版
 */

// Import optimized components with performance enhancements
const { OptimizedMemoCommandFactory } = require('./memo-optimized.js');

// コマンド実行 - パフォーマンス最適化版を使用
async function main() {
  console.log('🚀 /memo コマンド実行中...');
  
  const memo = OptimizedMemoCommandFactory.create();
  const result = await memo.execute();
  
  if (result.success) {
    console.log(`⚡ 実行時間: ${result.executionTime}ms`);
  }
  
  process.exit(result.success ? 0 : 1);
}

if (require.main === module) {
  main().catch(console.error);
}

// Export optimized factory
module.exports = { OptimizedMemoCommandFactory };