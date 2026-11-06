import 'package:flutter/material.dart';

/// 配色の起点。個別コンポーネントでは Theme の ColorScheme を参照する。
abstract final class AppColors {
  /// アプリごとに差し替えるブランドカラー。
  static const Color seed = Color(0xFF6750A4);
}
