import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_theme_preference.freezed.dart';
part 'app_theme_preference.g.dart';

// Converter for ThemeMode enum serialization
class ThemeModeConverter implements JsonConverter<ThemeMode, String> {
  const ThemeModeConverter();

  @override
  ThemeMode fromJson(String json) {
    switch (json) {
      case 'system':
        return ThemeMode.system;
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  String toJson(ThemeMode object) {
    switch (object) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
  }
}

@freezed
class AppThemePreference with _$AppThemePreference {
  const AppThemePreference._();
  
  const factory AppThemePreference({
    @ThemeModeConverter() required ThemeMode mode,
  }) = _AppThemePreference;

  factory AppThemePreference.fromJson(Map<String, dynamic> json) =>
      _$AppThemePreferenceFromJson(json);
}