import 'package:core/i18n/core_translations.g.dart';
import 'package:core/src/preferences/providers/app_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that displays the current theme setting as text
///
/// This widget automatically watches the current theme setting through
/// the [appThemeProviderProvider] and displays the appropriate localized
/// text for the current theme mode (System, Light, or Dark).
///
/// The widget automatically updates when the theme changes and uses
/// the core package's unified i18n system to ensure consistency
/// with the current language setting.
///
/// Example usage:
/// ```dart
/// // Basic usage
/// const ThemeText()
///
/// // With custom text style
/// const ThemeText(
///   style: TextStyle(
///     fontSize: 16,
///     color: Colors.blue,
///   ),
/// )
/// ```
class ThemeText extends ConsumerWidget {
  /// Creates a theme text widget
  const ThemeText({
    TextStyle? style,
    super.key,
  }) : _style = style;

  /// Optional text style for the theme text
  ///
  /// If not provided, uses the default text style from the theme.
  final TextStyle? _style;

  /// Builds the theme text widget
  ///
  /// Watches the current theme provider and displays the appropriate
  /// localized text based on the current theme mode setting using the
  /// unified i18n system.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(appThemeProviderProvider);
    final t = CoreTranslations.of(context);

    return Text(
      _getThemeDisplayText(currentTheme.valueOrNull, t),
      style: _style,
    );
  }

  /// Gets the display text for a given theme mode using unified i18n system
  ///
  /// Maps theme modes to their localized display names from the core
  /// package's translation system. This ensures consistent translations
  /// across the entire app.
  ///
  /// Parameters:
  /// - [themeMode]: The theme mode to get display text for
  /// - [t]: The translations instance from the core i18n system
  ///
  /// Returns the appropriate display text for the theme mode.
  String _getThemeDisplayText(ThemeMode? themeMode, CoreTranslations t) {
    if (themeMode == null) {
      return t.theme.system;
    }

    return switch (themeMode) {
      ThemeMode.system => t.theme.system,
      ThemeMode.light => t.theme.light,
      ThemeMode.dark => t.theme.dark,
    };
  }
}
