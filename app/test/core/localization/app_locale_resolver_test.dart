import 'dart:ui';

import 'package:app/core/gen/slang.g.dart';
import 'package:app/core/localization/app_locale_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('saved language has priority over device preferences', () {
    expect(resolveAppLocale('ja', [const Locale('en')]), AppLocale.ja);
  });

  test(
    'uses the first supported device language for unset or invalid values',
    () {
      for (final saved in [null, 'invalid']) {
        expect(
          resolveAppLocale(saved, [
            const Locale('fr'),
            const Locale('en', 'US'),
          ]),
          AppLocale.en,
        );
      }
    },
  );

  test('falls back to Japanese without a supported language', () {
    expect(resolveAppLocale(null, []), AppLocale.ja);
    expect(resolveAppLocale(null, [const Locale('fr')]), AppLocale.ja);
  });
}
