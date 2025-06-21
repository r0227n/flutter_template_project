import 'package:flutter/material.dart';

class AppThemeData {
  const AppThemeData({
    this.seedColor = Colors.deepPurple,
    this.cardElevation = 2.0,
    this.appBarElevation = 0.0,
    this.cardBorderRadius = const BorderRadius.all(Radius.circular(12)),
    this.buttonBorderRadius = const BorderRadius.all(Radius.circular(8)),
    this.buttonPadding = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 12,
    ),
  });
  final Color seedColor;
  final double cardElevation;
  final double appBarElevation;
  final BorderRadius cardBorderRadius;
  final BorderRadius buttonBorderRadius;
  final EdgeInsets buttonPadding;

  AppThemeData copyWith({
    Color? seedColor,
    double? cardElevation,
    double? appBarElevation,
    BorderRadius? cardBorderRadius,
    BorderRadius? buttonBorderRadius,
    EdgeInsets? buttonPadding,
  }) {
    return AppThemeData(
      seedColor: seedColor ?? this.seedColor,
      cardElevation: cardElevation ?? this.cardElevation,
      appBarElevation: appBarElevation ?? this.appBarElevation,
      cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
      buttonBorderRadius: buttonBorderRadius ?? this.buttonBorderRadius,
      buttonPadding: buttonPadding ?? this.buttonPadding,
    );
  }

  ThemeData toLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: appBarElevation,
      ),
      cardTheme: CardThemeData(
        elevation: cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: cardBorderRadius,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: buttonBorderRadius,
          ),
        ),
      ),
    );
  }

  ThemeData toDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: appBarElevation,
      ),
      cardTheme: CardThemeData(
        elevation: cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: cardBorderRadius,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: buttonBorderRadius,
          ),
        ),
      ),
    );
  }
}

ThemeData get lightTheme => const AppThemeData().toLightTheme();
ThemeData get darkTheme => const AppThemeData().toDarkTheme();
