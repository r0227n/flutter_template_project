import 'dart:async';

import 'package:app_preferences/app_preferences.dart';
import 'package:apps/i18n/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.title),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(t.settings.language),
            subtitle: const LocaleDisplayText(),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context, ref, t),
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
            onTap: () => _showThemeDialog(context, ref, t),
          ),
        ],
      ),
    );
  }

  Future<void> _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    Translations t,
  ) async {
    await PreferencesDialogHelpers.showLocaleSelectionDialog(
      context: context,
      ref: ref,
      title: t.settings.language,
      availableLocales: const [
        LocaleOption(languageCode: 'ja', displayName: '日本語'),
        LocaleOption(languageCode: 'en', displayName: 'English'),
      ],
      cancelLabel: t.settings.cancel,
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
    WidgetRef ref,
    Translations t,
  ) async {
    await PreferencesDialogHelpers.showThemeSelectionDialog(
      context: context,
      ref: ref,
      title: t.settings.theme,
      systemLabel: t.settings.theme_system,
      lightLabel: t.settings.theme_light,
      darkLabel: t.settings.theme_dark,
      cancelLabel: t.settings.cancel,
    );
  }
}
