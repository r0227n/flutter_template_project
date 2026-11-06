import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

/// コメントを除外し、条件付き import/export も含めた依存 URI を取得する。
Iterable<String> dependenciesOf(String source, String owner) sync* {
  final unit = parseString(content: source).unit;
  for (final directive in unit.directives) {
    if (directive is UriBasedDirective) {
      final uri = directive.uri.stringValue;
      if (uri != null) yield Uri.parse(owner).resolve(uri).toString();
    }
    if (directive is NamespaceDirective) {
      for (final configuration in directive.configurations) {
        final uri = configuration.uri.stringValue;
        if (uri != null) yield Uri.parse(owner).resolve(uri).toString();
      }
    }
  }
}

/// テンプレートの公開境界に反する依存の説明。許可された場合は null。
String? dependencyViolation(String owner, String dependency) {
  if (owner.startsWith('package:app/') &&
      dependency.startsWith('package:design_system/src/')) {
    return 'Use the design_system public entry point';
  }
  if (owner.startsWith('package:design_system/')) {
    if (![
      'dart:',
      'package:flutter/',
      'package:design_system/',
      'package:theme_extensions_builder_annotation/',
    ].any(dependency.startsWith)) {
      return 'The design system owns only theme and tokens';
    }
    return null;
  }
  final layer = owner.replaceFirst('package:app/', '').split('/').first;
  if (layer == 'domain' || layer == 'application') {
    final allowed =
        {
          'dart:async',
          'dart:collection',
          'dart:convert',
          'dart:core',
          'dart:math',
          'dart:typed_data',
        }.contains(dependency) ||
        dependency.startsWith('package:app/domain/') ||
        (layer == 'application' &&
            dependency.startsWith('package:app/application/'));
    return allowed
        ? null
        : 'Inner layers must be independent of frameworks and I/O';
  }
  if (layer == 'presentation' || layer == 'infrastructure') {
    if (dependency.startsWith('package:app/app/')) {
      return 'Outer adapters must not import the composition root';
    }
    if (dependency.startsWith('package:app/application/') &&
        dependency != 'package:app/application/application.dart' &&
        !dependency.startsWith('package:app/application/errors/')) {
      return 'Use the application public entry point or a public error library';
    }
  }
  if (dependency.startsWith('package:app/infrastructure/') &&
      layer != 'infrastructure' &&
      owner != 'package:app/app/dependency_graph.dart') {
    return 'Only the dependency graph selects concrete adapters';
  }
  if (layer == 'infrastructure' &&
      (dependency.startsWith('package:app/presentation/') ||
          dependency.contains('riverpod'))) {
    return 'Infrastructure must not depend on presentation or Riverpod';
  }
  if (layer == 'presentation') {
    if (dependency.startsWith('package:shared_preferences') ||
        dependency.startsWith('package:talker') ||
        dependency == 'package:app/core/logger/talker_integration.dart') {
      return 'Presentation must use injected use cases and ErrorReporter';
    }
    const features = 'package:app/presentation/features/';
    if (dependency.startsWith(features)) {
      if (owner.startsWith('package:app/presentation/shared/') ||
          owner.startsWith('package:app/presentation/dependencies/')) {
        return 'Shared state and dependency tokens must not depend on features';
      }
      if (owner.startsWith(features) &&
          owner.substring(features.length).split('/').first !=
              dependency.substring(features.length).split('/').first) {
        return 'Features must not directly depend on other features';
      }
    }
  }
  if (layer == 'core' &&
      dependency.startsWith('package:app/') &&
      !dependency.startsWith('package:app/core/')) {
    return 'Core must not depend on application composition or UI';
  }
  return null;
}
