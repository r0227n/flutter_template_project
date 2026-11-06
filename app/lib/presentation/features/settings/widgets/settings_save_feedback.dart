import 'package:app/application/errors/app_error_code.dart';
import 'package:app/application/errors/app_exception.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/dependencies/observability_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 保存失敗を一度だけ報告し、画面が残っていれば再試行を促す。
Future<void> saveSettingsWithFeedback(
  BuildContext context,
  WidgetRef ref,
  Future<void> Function() save,
) async {
  final reporter = ref.read(errorReporterProvider);
  try {
    await save();
  } on Object catch (error, stackTrace) {
    reporter.report(
      error,
      stackTrace,
      message: 'Saving app preferences failed',
    );
    if (!context.mounted) return;
    final translations = Translations.of(context);
    final failure = appExceptionForDisplay(error, stackTrace);
    final message = switch (failure.code) {
      AppErrorCode.settingsWrite => translations.saveFailed,
      AppErrorCode.unexpected => translations.unexpectedError,
    };
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
