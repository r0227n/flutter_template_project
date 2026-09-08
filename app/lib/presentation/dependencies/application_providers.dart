import 'package:app/application/application.dart';
import 'package:app/core/logger/error_reporter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'application_providers.g.dart';

@Riverpod(keepAlive: true)
AppPreferencesUseCase appPreferencesUseCase(Ref ref) =>
    throw UnimplementedError(
      'Inject AppPreferencesUseCase in AppDependencyGraph',
    );
@Riverpod(keepAlive: true)
ErrorReporter errorReporter(Ref ref) =>
    throw UnimplementedError('Inject ErrorReporter in AppDependencyGraph');
