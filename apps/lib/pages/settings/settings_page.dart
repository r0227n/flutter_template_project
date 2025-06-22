import 'dart:async';

import 'package:app_preferences/app_preferences.dart';
import 'package:app_preferences/app_prefs_translations.dart' as app_prefs;
import 'package:apps/i18n/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    // App preferences translations are now available as:
    // final appPrefsT = AppPrefsTranslations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.title),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(t.settings.language),
            subtitle: LocaleDisplayText(
              systemLabel: t.settings.theme_system,
              japaneseLabel: '日本語',
              englishLabel: 'English',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context, t),
          ),
          const Divider(),

          ListTile(
            title: Text(t.settings.theme),
            subtitle: ThemeDisplayText(
              systemLabel: t.settings.theme_system,
              lightLabel: t.settings.theme_light,
              darkLabel: t.settings.theme_dark,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeDialog(context, t),
          ),
          const Divider(),

          // Demo: Using app_preferences translations directly
          ListTile(
            title: const Text('App Preferences Translations Demo'),
            subtitle: Builder(
              builder: (context) {
                final appPrefsT = app_prefs.Translations.of(context);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Locale System: ${appPrefsT.locale['system']}'),
                    Text('Theme Light: ${appPrefsT.theme['light']}'),
                    Text('Dialog Cancel: ${appPrefsT.dialog.cancel}'),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLanguageDialog(
    BuildContext context,
    Translations t,
  ) async {
    await PreferencesDialogHelpers.showLocaleSelectionDialog(
      context: context,

      title: t.settings.language,
      onLocaleChanged: (languageCode) async {
        // Update slang locale settings for immediate UI update
        final appLocale = AppLocale.values.firstWhere(
          (locale) => locale.languageCode == languageCode,
          orElse: () => AppLocale.ja,
        );
        unawaited(LocaleSettings.setLocale(appLocale));
      },
    );
  }

  Future<void> _showThemeDialog(
    BuildContext context,
    Translations t,
  ) async {
    await PreferencesDialogHelpers.showThemeSelectionDialog(
      context: context,

      title: t.settings.theme,
    );
  }
}
