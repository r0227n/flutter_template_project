import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_locale_preference.freezed.dart';
part 'app_locale_preference.g.dart';

@freezed
class AppLocalePreference with _$AppLocalePreference {
  const AppLocalePreference._();
  
  const factory AppLocalePreference({
    required String languageCode,
    String? countryCode,
  }) = _AppLocalePreference;

  factory AppLocalePreference.fromJson(Map<String, dynamic> json) =>
      _$AppLocalePreferenceFromJson(json);

  factory AppLocalePreference.fromLocale(Locale locale) {
    return AppLocalePreference(
      languageCode: locale.languageCode,
      countryCode: locale.countryCode,
    );
  }

  Locale toLocale() {
    return Locale(languageCode, countryCode);
  }
}
