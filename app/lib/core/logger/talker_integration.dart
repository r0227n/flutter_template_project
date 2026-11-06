import 'package:app/core/logger/error_reporter.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// 外部への送信を行わないローカル logger を生成する。
Talker createTalker() => TalkerFlutter.init();

/// Flutter と root isolate の未処理エラーを一つの logger へ接続する。
void installErrorHandlers(Talker talker) {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    talker.handle(details.exception, details.stack, 'Flutter error');
  };
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    talker.handle(error, stackTrace, 'Uncaught error');
    return true;
  };
}

/// Presentation の報告契約を Talker に接続する。
final class TalkerErrorReporter implements ErrorReporter {
  /// 起動時に生成した logger を共有する。
  const TalkerErrorReporter(this._talker);

  final Talker _talker;

  @override
  void report(
    Object error,
    StackTrace? stackTrace, {
    required String message,
  }) => _talker.handle(error, stackTrace, message);
}
