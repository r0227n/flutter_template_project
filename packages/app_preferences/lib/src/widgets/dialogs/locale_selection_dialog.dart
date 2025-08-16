import 'dart:async';

import 'package:app_preferences/src/providers/app_preferences_provider.dart';
import 'package:app_preferences/src/widgets/dialogs/selection_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Configuration for a locale option in the selection dialog
///
/// Represents a single locale choice with its language code and display name.
/// Used by [LocaleSelectionDialog] to present available language options.
class LocaleOption with Diagnosticable {
  /// Creates a locale option
  ///
  /// [languageCode] should be a valid language code (e.g., 'en', 'ja')
  /// [displayName] is the user-friendly name shown in the UI
  const LocaleOption({
    required this.languageCode,
    required this.displayName,
  });

  /// The language code for this locale (e.g., 'en', 'ja', 'es')
  final String languageCode;

  /// The display name shown to users (e.g., 'English', '日本語', 'Español')
  final String displayName;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('languageCode', languageCode))
      ..add(StringProperty('displayName', displayName));
  }
}

/// A dialog for selecting the app locale
///
/// This dialog presents a list of available locales and allows users to select
/// their preferred language. When a locale is selected, it automatically
/// updates
/// the app's locale through the [appLocaleProviderProvider] and optionally
/// calls a custom callback for additional handling.
///
/// Example usage:
/// ```dart
/// await showDialog<void>(
///   context: context,
///   builder: (context) => LocaleSelectionDialog(
///     title: 'Select Language',
///     availableLocales: [
///       LocaleOption(languageCode: 'en', displayName: 'English'),
///       LocaleOption(languageCode: 'ja', displayName: '日本語'),
///     ],
///     cancelLabel: 'Cancel',
///     onLocaleChanged: (languageCode) async {
///       // Custom app-specific logic (e.g., updating slang translations)
///       await updateTranslations(languageCode);
///     },
///   ),
/// );
/// ```
class LocaleSelectionDialog extends ConsumerWidget {
  /// Creates a locale selection dialog
  const LocaleSelectionDialog({
    required this.title,
    required this.availableLocales,
    required this.cancelLabel,
    this.onLocaleChanged,
    this.icon,
    super.key,
  });

  /// The dialog title
  final String title;

  /// List of available locale options
  final List<LocaleOption> availableLocales;

  /// Label for the cancel button
  final String cancelLabel;

  /// Optional callback called when locale changes (for custom app logic)
  final Future<void> Function(String languageCode)? onLocaleChanged;

  /// Optional icon to display in the dialog title
  final Widget? icon;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(
        IterableProperty<LocaleOption>(
          'availableLocales',
          availableLocales,
        ),
      )
      ..add(StringProperty('cancelLabel', cancelLabel))
      ..add(
        DiagnosticsProperty<Future<void> Function(String)?>(
          'onLocaleChanged',
          onLocaleChanged,
        ),
      )
      ..add(DiagnosticsProperty<Widget?>('icon', icon));
  }

  /// Builds the locale selection dialog
  ///
  /// Creates a [SelectionDialog] with the available locales and handles
  /// the locale change through both the provider and optional callback.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(appLocaleProviderProvider).valueOrNull;

    return SelectionDialog<LocaleOption>(
      title: title,
      icon: icon,
      options: availableLocales
          .map(
            (locale) => SelectionOption<LocaleOption>(
              value: locale,
              displayText: locale.displayName,
            ),
          )
          .toList(),
      currentValue: availableLocales.firstWhere(
        (option) => option.languageCode == currentLocale?.languageCode,
        orElse: () => availableLocales.first,
      ),
      onChanged: (selectedOption) async {
        final newLocale = Locale(selectedOption.languageCode);
        await ref.read(appLocaleProviderProvider.notifier).setLocale(newLocale);

        // Call custom callback if provided (for app-specific logic like slang)
        if (onLocaleChanged != null) {
          await onLocaleChanged!(selectedOption.languageCode);
        }
      },
      cancelLabel: cancelLabel,
      valueSelector: (option) => option,
    );
  }
}
