import 'package:app_preferences/i18n/strings.g.dart' as app_prefs;
import 'package:app_preferences/src/providers/app_preferences_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A widget that displays the current theme setting as text
class ThemeText extends ConsumerWidget {
  const ThemeText({
    this.style,
    super.key,
  });

  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(appThemeProviderProvider);
    final t = app_prefs.Translations.of(context);

    return Text(
      _getThemeDisplayText(currentTheme.valueOrNull, t),
      style: style,
    );
  }

  String _getThemeDisplayText(ThemeMode? themeMode, app_prefs.Translations t) {
    if (themeMode == null) {
      return t.theme['system']!;
    }
    return switch (themeMode) {
      ThemeMode.system => t.theme['system']!,
      ThemeMode.light => t.theme['light']!,
      ThemeMode.dark => t.theme['dark']!,
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
