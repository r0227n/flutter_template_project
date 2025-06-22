import 'package:app_preferences/i18n/strings.g.dart' as app_prefs;
import 'package:app_preferences/src/providers/app_preferences_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A widget that displays the current locale setting as text
class LocaleDisplayText extends ConsumerWidget {
  const LocaleDisplayText({
    required this.systemLabel,
    required this.japaneseLabel,
    required this.englishLabel,
    this.style,
    super.key,
  });

  final String systemLabel;
  final String japaneseLabel;
  final String englishLabel;
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
      return systemLabel;
    }
    return switch (locale.languageCode) {
      'ja' => japaneseLabel,
      'en' => englishLabel,
      _ => locale.languageCode,
    };
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('systemLabel', systemLabel));
    properties.add(StringProperty('japaneseLabel', japaneseLabel));
    properties.add(StringProperty('englishLabel', englishLabel));
    properties.add(
      DiagnosticsProperty<TextStyle?>('style', style, defaultValue: null),
    );
  }
}

/// A widget that displays the current theme setting as text
class ThemeDisplayText extends ConsumerWidget {
  const ThemeDisplayText({
    required this.systemLabel,
    required this.lightLabel,
    required this.darkLabel,
    this.style,
    super.key,
  });

  final String systemLabel;
  final String lightLabel;
  final String darkLabel;
  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(appThemeProviderProvider);
    final t = app_prefs.Translations.of(context);

    return Text(
      _getThemeDisplayText(currentTheme.valueOrNull, t),
      style: style,
    );
  }

  String _getThemeDisplayText(ThemeMode? themeMode, app_prefs.Translations t) {
    if (themeMode == null) {
      return systemLabel;
    }
    return switch (themeMode) {
      ThemeMode.system => systemLabel,
      ThemeMode.light => lightLabel,
      ThemeMode.dark => darkLabel,
    };
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('systemLabel', systemLabel));
    properties.add(StringProperty('lightLabel', lightLabel));
    properties.add(StringProperty('darkLabel', darkLabel));
    properties.add(
      DiagnosticsProperty<TextStyle?>('style', style, defaultValue: null),
    );
  }
}
