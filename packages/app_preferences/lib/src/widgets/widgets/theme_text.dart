import 'package:app_preferences/i18n/strings.g.dart' as app_prefs;
import 'package:app_preferences/src/providers/app_preferences_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A widget that displays the current theme setting as text
///
/// This widget automatically watches the current theme setting through
/// the [appThemeProviderProvider] and displays the appropriate localized
/// text for the current theme mode (System, Light, or Dark).
///
/// The widget automatically updates when the theme changes and uses
/// the app's internationalization system to display localized theme names.
///
/// Example usage:
/// ```dart
/// // Basic usage with default styling
/// ThemeText()
///
/// // With custom text style
/// ThemeText(
///   style: TextStyle(
///     fontSize: 16,
///     color: Colors.blue,
///   ),
/// )
/// ```
class ThemeText extends ConsumerWidget {
  /// Creates a theme text widget
  const ThemeText({
    this.style,
    super.key,
  });

  /// Optional text style for the theme text
  ///
  /// If not provided, uses the default text style from the theme.
  final TextStyle? style;

  /// Builds the theme text widget
  ///
  /// Watches the current theme provider and displays the appropriate
  /// localized text based on the current theme mode setting.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(appThemeProviderProvider);
    final t = app_prefs.Translations.of(context);

    return Text(
      _getThemeDisplayText(currentTheme.valueOrNull, t),
      style: style,
    );
  }

  /// Gets the display text for a given theme mode
  ///
  /// Maps theme modes to their localized display names:
  /// - [ThemeMode.system] -> 'System' from translations
  /// - [ThemeMode.light] -> 'Light' from translations
  /// - [ThemeMode.dark] -> 'Dark' from translations
  /// - null -> 'System' from translations (fallback)
  ///
  /// Parameters:
  /// - [themeMode]: The theme mode to get display text for
  /// - [t]: The translations instance for localized strings
  ///
  /// Returns the appropriate display text for the theme mode.
  String _getThemeDisplayText(ThemeMode? themeMode, app_prefs.Translations t) {
    if (themeMode == null) {
      return t.theme.system;
    }
    return switch (themeMode) {
      ThemeMode.system => t.theme.system,
      ThemeMode.light => t.theme.light,
      ThemeMode.dark => t.theme.dark,
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
