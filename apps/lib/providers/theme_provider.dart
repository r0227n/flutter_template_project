import 'package:flutter/material.dart' as material show ThemeMode;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeModeEnum build() {
    return ThemeModeEnum.system;
  }

  void setTheme(ThemeModeEnum mode) {
    state = mode;
  }

  void toggleTheme() {
    state = switch (state) {
      ThemeModeEnum.light => ThemeModeEnum.dark,
      ThemeModeEnum.dark => ThemeModeEnum.light,
      ThemeModeEnum.system => ThemeModeEnum.light,
    };
  }
}

enum ThemeModeEnum {
  light,
  dark,
  system;

  material.ThemeMode get flutterThemeMode => switch (this) {
        ThemeModeEnum.light => material.ThemeMode.light,
        ThemeModeEnum.dark => material.ThemeMode.dark,
        ThemeModeEnum.system => material.ThemeMode.system,
      };

  String get displayName => switch (this) {
        ThemeModeEnum.light => 'ライト',
        ThemeModeEnum.dark => 'ダーク',
        ThemeModeEnum.system => 'システム',
      };
}