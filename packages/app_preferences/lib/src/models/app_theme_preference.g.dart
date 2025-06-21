// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_theme_preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppThemePreference _$AppThemePreferenceFromJson(Map<String, dynamic> json) =>
    _AppThemePreference(mode: $enumDecode(_$AppThemeModeEnumMap, json['mode']));

Map<String, dynamic> _$AppThemePreferenceToJson(_AppThemePreference instance) =>
    <String, dynamic>{'mode': _$AppThemeModeEnumMap[instance.mode]!};

const _$AppThemeModeEnumMap = {
  AppThemeMode.system: 'system',
  AppThemeMode.light: 'light',
  AppThemeMode.dark: 'dark',
};
