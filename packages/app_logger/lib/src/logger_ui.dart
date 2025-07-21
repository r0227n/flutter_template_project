import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'app_logger.dart';

/// UIコンポーネントを提供するクラス
class LoggerUI {
  LoggerUI._();

  /// Talkerのログ表示画面を表示
  static void showLoggerScreen(BuildContext context) {
    if (!AppLogger.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logger is not initialized'),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => TalkerScreen(
          talker: AppLogger.instance.talker,
          appBarTitle: 'Application Logs',
        ),
      ),
    );
  }

  /// Talkerのログ表示ウィジェットを返す
  static Widget buildLoggerView({
    String? title,
    Widget? appBarTitle,
  }) {
    if (!AppLogger.isInitialized) {
      return const Center(
        child: Text('Logger is not initialized'),
      );
    }

    return TalkerScreen(
      talker: AppLogger.instance.talker,
      appBarTitle: title ?? 'Application Logs',
    );
  }

  /// ログビューア用のフローティングアクションボタン
  static Widget buildLoggerFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showLoggerScreen(context),
      tooltip: 'Show Logs',
      child: const Icon(Icons.bug_report),
    );
  }

  /// デバッグ環境でのみ表示されるログビューア
  static Widget? buildDebugLoggerFAB(BuildContext context) {
    if (!AppLogger.isInitialized) return null;

    // デバッグモードでのみ表示
    bool isDebug = false;
    assert(isDebug = true);
    
    if (!isDebug) return null;

    return buildLoggerFAB(context);
  }

  /// ログの統計情報を表示するウィジェット
  static Widget buildLoggerStats() {
    if (!AppLogger.isInitialized) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Logger is not initialized'),
        ),
      );
    }

    final talker = AppLogger.instance.talker;
    final history = talker.history;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Builder(
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Log Statistics',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text('Total logs: ${history.length}'),
              Text('Errors: ${history.where((log) => log.logLevel == LogLevel.error).length}'),
              Text('Warnings: ${history.where((log) => log.logLevel == LogLevel.warning).length}'),
              Text('Info: ${history.where((log) => log.logLevel == LogLevel.info).length}'),
              Text('Debug: ${history.where((log) => log.logLevel == LogLevel.debug).length}'),
            ],
          ),
        ),
      ),
    );
  }

  /// ログをクリアするボタン
  static Widget buildClearLogsButton({
    String? text,
    VoidCallback? onCleared,
  }) {
    return ElevatedButton.icon(
      onPressed: () {
        if (AppLogger.isInitialized) {
          AppLogger.instance.talker.cleanHistory();
          onCleared?.call();
        }
      },
      icon: const Icon(Icons.clear_all),
      label: Text(text ?? 'Clear Logs'),
    );
  }
}