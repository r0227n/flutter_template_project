import 'dart:async';

import 'package:app/i18n/translations.g.dart';
import 'package:app/router/routes.dart';
import 'package:core/core.dart'
    hide AppLocale, LocaleSettings, TranslationProvider, Translations;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);

    // TranslationProvider is now available as:
    // app_prefs.TranslationProvider

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.title),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(t.settings.language),
            subtitle: const LocaleText(),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context, t),
          ),
          const Divider(),
          ListTile(
            title: Text(t.settings.theme),
            subtitle: const ThemeText(),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeDialog(context, t),
          ),
          const Divider(),
          ListTile(
            title: Text(t.settings.version),
            subtitle: const VersionText(),
            trailing: const Icon(Icons.info_outline),
            // Version is display-only
          ),
          const Divider(),
          ListTile(
            title: Text(t.settings.licenses),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => const LicenseRoute().go(context),
          ),
          const Divider(),
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
