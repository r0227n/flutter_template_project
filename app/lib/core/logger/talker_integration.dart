import 'package:app/core/logger/error_reporter.dart';
import 'package:talker_flutter/talker_flutter.dart';

Talker createTalker() => TalkerFlutter.init(settings: TalkerSettings());

final class TalkerErrorReporter implements ErrorReporter {
  const TalkerErrorReporter(this._talker);
  final Talker _talker;
  @override
  void report(
    Object error,
    StackTrace? stackTrace, {
    required String message,
  }) => _talker.handle(error, stackTrace, message);
}
