import 'dart:async';

import 'package:app_preferences/src/providers/app_preferences_provider.dart';
import 'package:app_preferences/src/ui/dialogs/selection_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Configuration for a locale option in the selection dialog
class LocaleOption with Diagnosticable {
  const LocaleOption({
    required this.languageCode,
    required this.displayName,
  });

  final String languageCode;
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
class LocaleSelectionDialog extends ConsumerWidget {
  const LocaleSelectionDialog({
    required this.title,
    required this.availableLocales,
    required this.cancelLabel,
    this.onLocaleChanged,
    super.key,
  });

  final String title;
  final List<LocaleOption> availableLocales;
  final String cancelLabel;
  final Future<void> Function(String languageCode)? onLocaleChanged;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(IterableProperty<LocaleOption>(
        'availableLocales', 
        availableLocales,
      ))
      ..add(StringProperty('cancelLabel', cancelLabel))
      ..add(DiagnosticsProperty<Future<void> Function(String)?>
          ('onLocaleChanged', onLocaleChanged));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(appLocaleProviderProvider).valueOrNull;

    return SelectionDialog<LocaleOption>(
      title: title,
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
      valueSelector: (option) => option.languageCode,
    );
  }
}
