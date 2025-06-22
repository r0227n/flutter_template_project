import 'dart:async';

import 'package:app_preferences/i18n/strings.g.dart' as app_prefs;
import 'package:app_preferences/src/widgets/dialogs/locale_selection_dialog.dart';
import 'package:app_preferences/src/widgets/dialogs/theme_selection_dialog.dart';
import 'package:flutter/material.dart';

/// Helper methods for showing app preferences dialogs
class PreferencesDialogHelpers {
  const PreferencesDialogHelpers._();

  /// Shows the theme selection dialog
  ///
  /// This method handles the complete flow of showing the theme selection
  /// dialog and updating the theme preference internally.
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
        systemLabel: systemLabel ?? t.theme['system']!,
        lightLabel: lightLabel ?? t.theme['light']!,
        darkLabel: darkLabel ?? t.theme['dark']!,
        cancelLabel: cancelLabel ?? t.dialog.cancel,
        icon: icon,
      ),
    );
  }

  /// Shows the locale selection dialog
  ///
  /// This method handles the complete flow of showing the locale selection
  /// dialog and updating the locale preference internally. Optionally calls
  /// a callback for app-specific logic (like updating slang locale settings).
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
          LocaleOption(languageCode: 'ja', displayName: t.locale['japanese']!),
          LocaleOption(languageCode: 'en', displayName: t.locale['english']!),
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
