import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Dependencies point inward and features stay independent', () {
    final directives = RegExp(r'''(?:import|export)\s+['"]([^'"]+)['"]''');
    for (final file
        in Directory('lib')
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))) {
      final path = file.path.replaceAll(r'\', '/');
      for (final match in directives.allMatches(file.readAsStringSync())) {
        final raw = match.group(1)!;
        final resolved = Uri.parse(path).resolve(raw).toString();
        final uri = raw.contains(':')
            ? raw
            : resolved.replaceFirst('lib/', 'package:app/');
        if (path.startsWith('lib/domain/') ||
            path.startsWith('lib/application/')) {
          expect(
            (uri.startsWith('dart:') && uri != 'dart:io' && uri != 'dart:ui') ||
                uri.startsWith('package:app/domain/') ||
                (path.startsWith('lib/application/') &&
                    uri.startsWith('package:app/application/')),
            isTrue,
            reason: '$path imports $uri',
          );
        }
        if (path.startsWith('lib/presentation/') ||
            path.startsWith('lib/infrastructure/')) {
          expect(
            uri.startsWith('package:app/app/'),
            isFalse,
            reason: '$path imports $uri',
          );
          if (uri.startsWith('package:app/application/')) {
            expect(uri, 'package:app/application/application.dart');
          }
        }
        if (path.startsWith('lib/presentation/')) {
          expect(
            uri.startsWith('package:app/infrastructure/'),
            isFalse,
            reason: '$path imports $uri',
          );
        }
        if (path.startsWith('lib/infrastructure/')) {
          expect(
            uri.startsWith('package:app/presentation/'),
            isFalse,
            reason: '$path imports $uri',
          );
        }
        if (path.startsWith('lib/presentation/features/') &&
            uri.startsWith('package:app/presentation/features/')) {
          expect(
            uri.split('/')[3],
            path.split('/')[3],
            reason: '$path imports another feature: $uri',
          );
        }
      }
    }
  });
}
