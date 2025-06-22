import 'dart:io';
import 'package:build_verify/build_verify.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ensure_build', () async {
    // Change to git root directory for build_verify
    final result = Process.runSync('git', ['rev-parse', '--show-toplevel']);
    if (result.exitCode == 0) {
      final gitRoot = result.stdout.toString().trim();
      final originalDir = Directory.current;
      try {
        Directory.current = Directory(gitRoot);
        await expectBuildClean();
      } finally {
        Directory.current = originalDir;
      }
    } else {
      await expectBuildClean();
    }
  });
}
