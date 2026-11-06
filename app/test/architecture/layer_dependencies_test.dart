import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'architecture_rules.dart';

void main() {
  test('source respects inward dependencies and public entry points', () {
    final violations = <String>[];
    for (final (directory, package) in [
      ('lib', 'app'),
      ('../packages/design_system/lib', 'design_system'),
    ]) {
      for (final file in Directory(
        directory,
      ).listSync(recursive: true).whereType<File>()) {
        if (!file.path.endsWith('.dart')) continue;
        final relative = file.path.substring(directory.length + 1);
        final owner = 'package:$package/$relative';
        for (final dependency in dependenciesOf(
          file.readAsStringSync(),
          owner,
        )) {
          final violation = dependencyViolation(owner, dependency);
          if (violation != null) {
            violations.add('$owner → $dependency: $violation');
          }
        }
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test(
    'presentation is feature-first and design_system has no widget layer',
    () {
      final topLevels = Directory(
        'lib/presentation',
      ).listSync().whereType<Directory>();
      expect(
        topLevels.map((entry) => entry.path.split('/').last),
        everyElement(
          isIn(['features', 'shared', 'dependencies', 'navigation']),
        ),
      );
      for (final file in Directory(
        '../packages/design_system/lib',
      ).listSync(recursive: true).whereType<File>()) {
        if (!file.path.endsWith('.dart')) continue;
        expect(
          file.readAsStringSync(),
          isNot(
            matches(
              r'extends\s+(StatelessWidget|StatefulWidget|RenderObjectWidget)',
            ),
          ),
          reason: file.path,
        );
      }
    },
  );

  test(
    'dependency parser includes relative and conditional imports and exports',
    () {
      const source = '''
// import 'package:forbidden/comment.dart';
import '../../infrastructure/io.dart'
  if (dart.library.html) 'package:app/infrastructure/web.dart';
export 'package:app/application/models/private.dart';
''';
      expect(
        dependenciesOf(source, 'package:app/presentation/shared/example.dart'),
        [
          'package:app/infrastructure/io.dart',
          'package:app/infrastructure/web.dart',
          'package:app/application/models/private.dart',
        ],
      );
    },
  );

  final forbidden = <(String, String)>[
    ('domain/example.dart', 'dart:io'),
    ('domain/example.dart', 'package:app/application/application.dart'),
    ('application/ports/example.dart', 'package:flutter/widgets.dart'),
    ('application/models/example.dart', 'package:riverpod/riverpod.dart'),
    (
      'infrastructure/persistence/example.dart',
      'package:app/presentation/navigation/routes.dart',
    ),
    (
      'infrastructure/persistence/example.dart',
      'package:riverpod_annotation/riverpod_annotation.dart',
    ),
    (
      'presentation/features/home/screens/example.dart',
      'package:app/presentation/features/settings/screens/settings_screen.dart',
    ),
    (
      'presentation/shared/example.dart',
      'package:app/presentation/features/home/screens/home_screen.dart',
    ),
    (
      'presentation/shared/example.dart',
      'package:app/application/models/app_preferences.dart',
    ),
    (
      'presentation/shared/example.dart',
      'package:shared_preferences/shared_preferences.dart',
    ),
    (
      'presentation/shared/example.dart',
      'package:app/infrastructure/infrastructure.dart',
    ),
    ('presentation/shared/example.dart', 'package:talker/talker.dart'),
    ('presentation/shared/example.dart', 'package:app/app/bootstrap.dart'),
    (
      'presentation/shared/example.dart',
      'package:design_system/src/tokens/spacing.dart',
    ),
    ('app/bootstrap.dart', 'package:app/infrastructure/infrastructure.dart'),
    ('core/example.dart', 'package:app/presentation/navigation/routes.dart'),
  ];
  for (final (owner, dependency) in forbidden) {
    test('rejects $owner → $dependency', () {
      expect(dependencyViolation('package:app/$owner', dependency), isNotNull);
    });
  }

  test('allows explicit public exception libraries and typed navigation', () {
    const owner =
        'package:app/presentation/features/settings/screens/example.dart';
    for (final dependency in [
      'package:app/application/application.dart',
      'package:app/application/errors/settings_error.dart',
      'package:app/presentation/navigation/routes.dart',
      'package:design_system/design_system.dart',
    ]) {
      expect(dependencyViolation(owner, dependency), isNull);
    }
    expect(
      dependencyViolation(
        'package:design_system/src/theme/app_theme.dart',
        'package:app/application/application.dart',
      ),
      isNotNull,
    );
  });
}
