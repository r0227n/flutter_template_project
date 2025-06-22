import 'package:app_preferences/src/providers/app_preferences_provider.dart';
import 'package:app_preferences/src/widgets/dialogs/selection_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A dialog for selecting the app theme mode
///
/// This dialog allows users to choose between system, light, and dark themes.
/// When a theme is selected, it automatically updates the app's theme through
/// the [appThemeProviderProvider].
///
/// The dialog presents three predefined options:
/// - System: Follow the device's theme setting
/// - Light: Always use light theme
/// - Dark: Always use dark theme
///
/// Example usage:
/// ```dart
/// await showDialog<void>(
///   context: context,
///   builder: (context) => ThemeSelectionDialog(
///     title: 'Select Theme',
///     systemLabel: 'System',
///     lightLabel: 'Light',
///     darkLabel: 'Dark',
///     cancelLabel: 'Cancel',
///     icon: Icon(Icons.palette),
///   ),
/// );
/// ```
class ThemeSelectionDialog extends ConsumerWidget {
  /// Creates a theme selection dialog
  const ThemeSelectionDialog({
    required this.title,
    required this.systemLabel,
    required this.lightLabel,
    required this.darkLabel,
    required this.cancelLabel,
    this.icon,
    super.key,
  });

  /// The dialog title
  final String title;

  /// Label for the system theme option
  final String systemLabel;

  /// Label for the light theme option
  final String lightLabel;

  /// Label for the dark theme option
  final String darkLabel;

  /// Label for the cancel button
  final String cancelLabel;

  /// Optional icon to display in the dialog title
  final Widget? icon;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(StringProperty('systemLabel', systemLabel))
      ..add(StringProperty('lightLabel', lightLabel))
      ..add(StringProperty('darkLabel', darkLabel))
      ..add(StringProperty('cancelLabel', cancelLabel))
      ..add(DiagnosticsProperty<Widget?>('icon', icon));
  }

  /// Builds the theme selection dialog
  ///
  /// Creates a [SelectionDialog] with the three theme mode options and
  /// handles theme changes through the theme provider.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.read(appThemeProviderProvider).valueOrNull;

    return SelectionDialog<ThemeMode>(
      title: title,
      icon: icon,
      options: [
        SelectionOption(
          value: ThemeMode.system,
          displayText: systemLabel,
        ),
        SelectionOption(
          value: ThemeMode.light,
          displayText: lightLabel,
        ),
        SelectionOption(
          value: ThemeMode.dark,
          displayText: darkLabel,
        ),
      ],
      currentValue: currentTheme,
      onChanged: (themeMode) async {
        await ref
            .read(appThemeProviderProvider.notifier)
            .setThemeMode(themeMode);
      },
      cancelLabel: cancelLabel,
    );
  }
}
