import 'package:app_preferences/i18n/strings.g.dart' as app_prefs;
import 'package:app_preferences/src/providers/app_preferences_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A widget that displays the current locale setting as text
class LocaleText extends ConsumerWidget {
  const LocaleText({
    this.style,
    super.key,
  });

  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(appLocaleProviderProvider);
    final t = app_prefs.Translations.of(context);

    return Text(
      _getLocaleDisplayText(currentLocale.valueOrNull, t),
      style: style,
    );
  }

  String _getLocaleDisplayText(Locale? locale, app_prefs.Translations t) {
    if (locale == null) {
      return t.locale['system']!;
    }
    return switch (locale.languageCode) {
      'ja' => t.locale['japanese']!,
      'en' => t.locale['english']!,
      _ => locale.languageCode,
    };
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<TextStyle?>('style', style, defaultValue: null),
    );
  }
}
