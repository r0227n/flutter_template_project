import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_theme_preference.freezed.dart';
part 'app_theme_preference.g.dart';

enum AppThemeMode {
  @JsonValue('system')
  system,
  @JsonValue('light')
  light,
  @JsonValue('dark')
  dark,
}

@freezed
class AppThemePreference with _$AppThemePreference {
  const AppThemePreference._();
  
  const factory AppThemePreference({
    required AppThemeMode mode,
  }) = _AppThemePreference;

  factory AppThemePreference.fromJson(Map<String, dynamic> json) =>
      _$AppThemePreferenceFromJson(json);
}