import 'package:core/i18n/core_translations.g.dart';
import 'package:core/src/preferences/providers/app_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that displays the current locale setting as text
///
/// This widget automatically watches the current locale setting through
/// the [appLocaleProviderProvider] and displays the appropriate localized
/// text for the current language. It uses the core package's unified
/// i18n system.
///
/// The widget automatically updates when the locale changes and ensures
/// consistency across the app.
///
/// Example usage:
/// ```dart
/// // Basic usage
/// const LocaleText()
///
/// // With custom text style
/// const LocaleText(
///   style: TextStyle(
///     fontSize: 16,
///     fontWeight: FontWeight.bold,
///   ),
/// )
/// ```
class LocaleText extends ConsumerWidget {
  /// Creates a locale text widget
  const LocaleText({
    TextStyle? style,
    super.key,
  }) : _style = style;

  /// Optional text style for the locale text
  ///
  /// If not provided, uses the default text style from the theme.
  final TextStyle? _style;

  /// Builds the locale text widget
  ///
  /// Watches the current locale provider and displays the appropriate
  /// localized text based on the current language setting using the
  /// unified i18n system.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = CoreTranslations.of(context);

    return Text(
      t.locale.language,
      style: _style,
    );
  }
}
