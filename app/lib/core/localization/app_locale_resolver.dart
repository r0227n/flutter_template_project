import 'dart:ui';

import 'package:app/core/gen/slang.g.dart';

/// 保存済み言語、端末の優先言語、日本語の順に表示言語を解決する。
AppLocale resolveAppLocale(
  String? savedLanguageCode,
  Iterable<Locale> preferredLocales,
) {
  for (final code in [
    ?savedLanguageCode,
    ...preferredLocales.map((locale) => locale.languageCode),
  ]) {
    for (final locale in AppLocale.values) {
      if (locale.languageCode == code) return locale;
    }
  }
  return AppLocale.ja;
}
