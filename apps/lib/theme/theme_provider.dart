import 'package:app_preferences/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    // Watch the theme preference from app_preferences
    return ref.watch(appThemeProvider);
  }

  Future<void> setTheme(ThemeMode mode) async {
    // Use app_preferences to persist the theme
    await ref.read(appThemeProvider.notifier).setThemeMode(mode);
  }

  Future<void> toggleTheme() async {
    final currentMode = state;
    final nextMode = switch (currentMode) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.light,
    };
    await setTheme(nextMode);
  }
}
