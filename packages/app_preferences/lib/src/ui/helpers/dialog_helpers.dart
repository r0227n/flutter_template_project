import 'dart:async';

import 'package:app_preferences/src/ui/dialogs/locale_selection_dialog.dart';
import 'package:app_preferences/src/ui/dialogs/theme_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Helper methods for showing app preferences dialogs
class PreferencesDialogHelpers {
  const PreferencesDialogHelpers._();

  /// Shows the theme selection dialog
  /// 
  /// This method handles the complete flow of showing the theme selection
  /// dialog and updating the theme preference internally.
  static Future<void> showThemeSelectionDialog({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String systemLabel,
    required String lightLabel,
    required String darkLabel,
    required String cancelLabel,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => ThemeSelectionDialog(
        title: title,
        systemLabel: systemLabel,
        lightLabel: lightLabel,
        darkLabel: darkLabel,
        cancelLabel: cancelLabel,
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
    required WidgetRef ref,
    required String title,
    required List<LocaleOption> availableLocales,
    required String cancelLabel,
    Future<void> Function(String languageCode)? onLocaleChanged,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => LocaleSelectionDialog(
        title: title,
        availableLocales: availableLocales,
        cancelLabel: cancelLabel,
        onLocaleChanged: onLocaleChanged,
      ),
    );
  }
}
