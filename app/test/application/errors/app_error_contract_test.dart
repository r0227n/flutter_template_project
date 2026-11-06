import 'package:app/application/errors/app_error_code.dart';
import 'package:app/application/errors/app_exception.dart';
import 'package:app/application/errors/settings_error.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('public failure codes stay stable', () {
    expect(const SettingsWriteException().code.value, 'settings.write');
    expect(const UnexpectedAppException().code.value, 'unexpected');
  });

  test('the display boundary preserves causes and known failures', () {
    final cause = StateError('internal diagnostic');
    final stack = StackTrace.current;
    final failure = appExceptionForDisplay(cause, stack);
    expect(failure.code, AppErrorCode.unexpected);
    expect(failure.cause, same(cause));
    expect(failure.causeStackTrace, same(stack));
    expect(failure.toString(), isNot(contains('internal diagnostic')));
    expect(appExceptionForDisplay(failure, stack), same(failure));
  });
}
