import 'package:app/core/logger/error_reporter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'observability_providers.g.dart';

/// Presentation が失敗を報告するための必須 token。
@Riverpod(keepAlive: true)
ErrorReporter errorReporter(Ref ref) =>
    throw UnimplementedError('ErrorReporter must be injected.');
