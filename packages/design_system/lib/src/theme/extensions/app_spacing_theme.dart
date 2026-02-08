import 'package:design_system/src/tokens/spacing.dart';
import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'app_spacing_theme.g.theme.dart';

/// Theme extension for spacing design tokens.
///
/// Provides spacing values through the Flutter theme system.
/// Default values are sourced from [AppSpacing] static constants.
@ThemeExtensions(contextAccessorName: 'appSpacing')
class AppSpacingTheme extends ThemeExtension<AppSpacingTheme>
    with _$AppSpacingTheme {
  /// Creates an [AppSpacingTheme] with the given spacing values.
  const AppSpacingTheme({
    this.xs = AppSpacing.xs,
    this.s = AppSpacing.s,
    this.m = AppSpacing.m,
    this.l = AppSpacing.l,
    this.xl = AppSpacing.xl,
  });

  /// Extra small spacing.
  final double xs;

  /// Small spacing.
  final double s;

  /// Medium spacing.
  final double m;

  /// Large spacing.
  final double l;

  /// Extra large spacing.
  final double xl;
}
