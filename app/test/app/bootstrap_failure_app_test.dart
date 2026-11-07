import 'dart:async';

import 'package:app/app/bootstrap_failure_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('retry is disabled until initialization finishes', (
    tester,
  ) async {
    final completion = Completer<void>();
    var attempts = 0;
    await tester.pumpWidget(
      BootstrapFailureApp(
        onRetry: () {
          attempts++;
          return completion.future;
        },
      ),
    );
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(attempts, 1);
    completion.complete();
    await tester.pump();
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNotNull,
    );
  });
}
