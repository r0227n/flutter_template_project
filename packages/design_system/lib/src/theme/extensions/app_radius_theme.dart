import 'package:design_system/src/tokens/radius.dart';
import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'app_radius_theme.g.theme.dart';

/// Theme extension for border radius design tokens.
///
/// Provides radius values through the Flutter theme system.
/// Default values are sourced from [AppRadius] static constants.
@ThemeExtensions(contextAccessorName: 'appRadius')
class AppRadiusTheme extends ThemeExtension<AppRadiusTheme>
    with _$AppRadiusTheme {
  /// Creates an [AppRadiusTheme] with the given radius values.
  const AppRadiusTheme({
    this.xs = AppRadius.xs,
    this.s = AppRadius.s,
  });

  /// Extra small radius.
  final double xs;

  /// Small radius.
  final double s;
}
