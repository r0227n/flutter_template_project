import 'dart:async';

import 'package:app_preferences/i18n/strings.g.dart' as app_prefs;
import 'package:app_preferences/src/widgets/dialogs/locale_selection_dialog.dart';
import 'package:app_preferences/src/widgets/dialogs/theme_selection_dialog.dart';
import 'package:flutter/material.dart';

/// Helper methods for showing app preferences dialogs
///
/// This class provides convenient static methods for displaying common
/// preference dialogs with proper internationalization and consistent styling.
/// It handles the setup of dialog content and provides sensible defaults
/// for labels and options.
///
/// Example usage:
/// ```dart
/// // Show theme selection dialog
/// await PreferencesDialogHelpers.showThemeSelectionDialog(
///   context: context,
///   title: 'Select Theme',
/// );
///
/// // Show locale selection dialog with custom callback
/// await PreferencesDialogHelpers.showLocaleSelectionDialog(
///   context: context,
///   title: 'Select Language',
///   onLocaleChanged: (languageCode) async {
///     // Update app-specific translations
///     await updateSlangTranslations(languageCode);
///   },
/// );
/// ```
class PreferencesDialogHelpers {
  /// Private constructor to prevent instantiation
  const PreferencesDialogHelpers._();

  /// Shows the theme selection dialog
  ///
  /// Displays a dialog allowing users to select between system, light, and
  /// dark themes.
  /// The theme preference is automatically updated when a selection is made.
  ///
  /// Parameters:
  /// - [context]: The build context for the dialog
  /// - [title]: The dialog title
  /// - [systemLabel]: Optional label for system theme (defaults to
  ///   localized text)
  /// - [lightLabel]: Optional label for light theme (defaults to
  ///   localized text)
  /// - [darkLabel]: Optional label for dark theme (defaults to
  ///   localized text)
  /// - [cancelLabel]: Optional label for cancel button (defaults to
  ///   localized text)
  /// - [icon]: Optional icon for the dialog (defaults to palette icon)
  ///
  /// Returns a [Future] that completes when the dialog is dismissed.
  static Future<void> showThemeSelectionDialog({
    required BuildContext context,
    required String title,
    String? systemLabel,
    String? lightLabel,
    String? darkLabel,
    String? cancelLabel,
    Widget icon = const Icon(Icons.palette),
  }) async {
    final t = app_prefs.Translations.of(context);

    await showDialog<void>(
      context: context,
      builder: (context) => ThemeSelectionDialog(
        title: title,
        systemLabel: systemLabel ?? t.theme.system,
        lightLabel: lightLabel ?? t.theme.light,
        darkLabel: darkLabel ?? t.theme.dark,
        cancelLabel: cancelLabel ?? t.dialog.cancel,
        icon: icon,
      ),
    );
  }

  /// Shows the locale selection dialog
  ///
  /// Displays a dialog allowing users to select their preferred language.
  /// The locale preference is automatically updated when a selection is made.
  /// Optionally calls a callback for app-specific logic (like updating slang
  /// locale settings).
  ///
  /// Parameters:
  /// - [context]: The build context for the dialog
  /// - [title]: The dialog title
  /// - [availableLocales]: Optional list of locale options (defaults to
  ///   Japanese and English)
  /// - [cancelLabel]: Optional label for cancel button (defaults to
  ///   localized text)
  /// - [icon]: Optional icon for the dialog (defaults to language icon)
  /// - [onLocaleChanged]: Optional callback for custom locale change handling
  ///
  /// Returns a [Future] that completes when the dialog is dismissed.
  ///
  /// Example with custom locales:
  /// ```dart
  /// await PreferencesDialogHelpers.showLocaleSelectionDialog(
  ///   context: context,
  ///   title: 'Select Language',
  ///   availableLocales: [
  ///     LocaleOption(languageCode: 'en', displayName: 'English'),
  ///     LocaleOption(languageCode: 'ja', displayName: '日本語'),
  ///     LocaleOption(languageCode: 'es', displayName: 'Español'),
  ///   ],
  /// );
  /// ```
  static Future<void> showLocaleSelectionDialog({
    required BuildContext context,
    required String title,
    List<LocaleOption>? availableLocales,
    String? cancelLabel,
    Widget icon = const Icon(Icons.language),
    Future<void> Function(String languageCode)? onLocaleChanged,
  }) async {
    final t = app_prefs.Translations.of(context);

    final locales =
        availableLocales ??
        [
          LocaleOption(languageCode: 'ja', displayName: t.locale.japanese),
          LocaleOption(languageCode: 'en', displayName: t.locale.english),
        ];

    await showDialog<void>(
      context: context,
      builder: (context) => LocaleSelectionDialog(
        title: title,
        availableLocales: locales,
        cancelLabel: cancelLabel ?? t.dialog.cancel,
        onLocaleChanged: onLocaleChanged,
        icon: icon,
      ),
    );
  }
}
