import 'package:design_system/src/theme/extensions/app_radius_theme.dart';
import 'package:design_system/src/theme/extensions/app_spacing_theme.dart';
import 'package:design_system/src/tokens/colors.dart';
import 'package:flutter/material.dart';

/// アプリの機能に依存しない Material 3 のテーマ。
abstract final class AppTheme {
  /// ライトテーマ。テーマ定義は一度だけ生成する。
  static final ThemeData lightTheme = _build(Brightness.light);

  /// ダークテーマ。ライトテーマと同じトークンを共有する。
  static final ThemeData darkTheme = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: colorScheme,
      extensions: const [AppSpacingTheme(), AppRadiusTheme()],
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
      ),
    );
  }
}
