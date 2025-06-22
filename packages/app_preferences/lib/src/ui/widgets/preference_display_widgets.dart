import 'package:app_preferences/src/providers/app_preferences_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A widget that displays the current locale setting as text
class LocaleDisplayText extends ConsumerWidget {
  const LocaleDisplayText({
    this.style,
    super.key,
  });

  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(appLocaleProviderProvider);

    return Text(
      _getLocaleDisplayText(currentLocale.valueOrNull),
      style: style,
    );
  }

  String _getLocaleDisplayText(Locale? locale) {
    if (locale == null) {
      return 'System';
    }
    return switch (locale.languageCode) {
      'ja' => '日本語',
      'en' => 'English',
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

    return Text(
      _getThemeDisplayText(currentTheme.valueOrNull),
      style: style,
    );
  }

  String _getThemeDisplayText(ThemeMode? themeMode) {
    if (themeMode == null) {
      return 'System';
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
