# App Logger パッケージ

talker ライブラリを使用したアプリケーション用の再利用可能なログパッケージです。

## 特徴

- **コンポーネント指向**: プロジェクト依存のコードを最小限に抑えた設計
- **設定可能**: 開発環境と本番環境で異なるログレベルと出力設定
- **Riverpod統合**: プロバイダーベースの依存性注入をサポート
- **構造化ログ**: ユーザーアクション、API呼び出し、パフォーマンス計測などの構造化ログ機能
- **型安全**: mixin を使用した型安全なログアクセス

## インストール

`pubspec.yaml` にパッケージを追加:

```yaml
dependencies:
  app_logger:
    path: ../packages/app_logger
```

## 基本的な使用方法

### 1. ログの初期化

```dart
import 'package:app_logger/app_logger.dart';

void main() {
  // 開発環境用設定
  final config = LoggerConfig.development();
  // または本番環境用設定
  // final config = LoggerConfig.production();

  AppLogger.initialize(config);

  // ログ出力
  final logger = AppLogger.instance;
  logger.info('アプリケーション開始');
}
```

### 2. Riverpod との統合

```dart
import 'package:app_logger/app_logger.dart';

// プロバイダーでのログアクセス
final someProvider = Provider((ref) {
  final logger = ref.read(appLoggerProvider);
  logger.info('プロバイダー初期化');
  return SomeService();
});
```

### 3. LoggerMixin の使用

```dart
import 'package:app_logger/app_logger.dart';

class MyViewModel with LoggerMixin {
  void doSomething() {
    logInfo('処理開始');
    try {
      // 何らかの処理
      logDebug('処理完了');
    } catch (e, stackTrace) {
      logError('処理エラー', e, stackTrace);
    }
  }
}
```

## 設定オプション

```dart
// カスタム設定
final config = LoggerConfig(
  logLevel: LogLevel.info,
  enableConsoleOutput: true,
  enableFileOutput: false,
  settings: TalkerSettings(
    maxHistoryItems: 500,
    useConsoleLogs: true,
  ),
);
```

## 構造化ログ機能

```dart
final logger = AppLogger.instance;

// ユーザーアクション
logger.logUserAction('ボタンクリック', {'button': 'submit'});

// API呼び出し
logger.logApiCall('/api/users', {'method': 'GET'});

// パフォーマンス計測
logger.logPerformance('データ読み込み', Duration(milliseconds: 250));
```

## ログレベル

- `LogLevel.debug`: デバッグ情報
- `LogLevel.info`: 一般的な情報
- `LogLevel.warning`: 警告
- `LogLevel.error`: エラー
- `LogLevel.critical`: 重大なエラー

## 環境別設定

### 開発環境

- すべてのログレベルを出力
- コンソール出力有効
- ファイル出力無効
- 履歴保持数: 1000件

### 本番環境

- warning以上のみ出力
- コンソール出力無効
- ファイル出力有効
- 履歴保持数: 100件

## ライセンス

このパッケージは MIT ライセンスの下で提供されています。
