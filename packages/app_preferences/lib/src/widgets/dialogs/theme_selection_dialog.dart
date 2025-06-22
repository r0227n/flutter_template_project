import 'package:app_preferences/src/providers/app_preferences_provider.dart';
import 'package:app_preferences/src/widgets/dialogs/selection_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A dialog for selecting the app theme mode
class ThemeSelectionDialog extends ConsumerWidget {
  const ThemeSelectionDialog({
    required this.title,
    required this.systemLabel,
    required this.lightLabel,
    required this.darkLabel,
    required this.cancelLabel,
    this.icon,
    super.key,
  });

  final String title;
  final String systemLabel;
  final String lightLabel;
  final String darkLabel;
  final String cancelLabel;
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
