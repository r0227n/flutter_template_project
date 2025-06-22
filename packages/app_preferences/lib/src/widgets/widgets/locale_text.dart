import 'package:app_preferences/i18n/strings.g.dart' as app_prefs;
import 'package:app_preferences/src/providers/app_preferences_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A widget that displays the current locale setting as text
///
/// This widget automatically watches the current locale setting through
/// the [appLocaleProviderProvider] and displays the appropriate localized
/// text for the current language. It supports Japanese, English, and
/// falls back to the language code for other locales.
///
/// The widget automatically updates when the locale changes and uses
/// the app's internationalization system to display localized names.
///
/// Example usage:
/// ```dart
/// // Basic usage with default styling
/// LocaleText()
///
/// // With custom text style
/// LocaleText(
///   style: TextStyle(
///     fontSize: 16,
///     fontWeight: FontWeight.bold,
///   ),
/// )
/// ```
class LocaleText extends ConsumerWidget {
  /// Creates a locale text widget
  const LocaleText({
    this.style,
    super.key,
  });

  /// Optional text style for the locale text
  ///
  /// If not provided, uses the default text style from the theme.
  final TextStyle? style;

  /// Builds the locale text widget
  ///
  /// Watches the current locale provider and displays the appropriate
  /// localized text based on the current language setting.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(appLocaleProviderProvider);
    final t = app_prefs.Translations.of(context);

    return Text(
      _getLocaleDisplayText(currentLocale.valueOrNull, t),
      style: style,
    );
  }

  /// Gets the display text for a given locale
  ///
  /// Maps locale language codes to their localized display names:
  /// - 'ja' -> Japanese name from translations
  /// - 'en' -> English name from translations
  /// - null -> 'System' from translations
  /// - others -> Raw language code as fallback
  ///
  /// Parameters:
  /// - [locale]: The locale to get display text for
  /// - [t]: The translations instance for localized strings
  ///
  /// Returns the appropriate display text for the locale.
  String _getLocaleDisplayText(Locale? locale, app_prefs.Translations t) {
    if (locale == null) {
      return t.locale.system;
    }
    return switch (locale.languageCode) {
      'ja' => t.locale.japanese,
      'en' => t.locale.english,
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
