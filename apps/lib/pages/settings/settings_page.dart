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
    final currentLocale = ref.watch(appLocaleProviderProvider);
    final currentTheme = ref.watch(appThemeProviderProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.title),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(t.settings.language),
            subtitle: Text(_getLocaleDisplayName(currentLocale.valueOrNull)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context, ref, t),
          ),
          const Divider(),

          ListTile(
            title: Text(t.settings.theme),
            subtitle: Text(_getThemeDisplayName(currentTheme.valueOrNull, t)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeDialog(context, ref, t),
          ),
        ],
      ),
    );
  }

  String _getLocaleDisplayName(Locale? locale) {
    if (locale == null) {
      return 'System';
    }
    return switch (locale.languageCode) {
      'ja' => '日本語',
      'en' => 'English',
      _ => locale.languageCode,
    };
  }

  String _getThemeDisplayName(ThemeMode? themeMode, Translations t) {
    if (themeMode == null) {
      return 'System';
    }
    return switch (themeMode) {
      ThemeMode.system => t.settings.theme_system,
      ThemeMode.light => t.settings.theme_light,
      ThemeMode.dark => t.settings.theme_dark,
    };
  }

  Future<void> _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    Translations t,
  ) async {
    final currentLocale = ref.read(appLocaleProviderProvider).valueOrNull;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.settings.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('日本語'),
              value: 'ja',
              groupValue: currentLocale?.languageCode,
              onChanged: (value) async {
                if (value != null) {
                  final newLocale = Locale(value);
                  await ref
                      .read(appLocaleProviderProvider.notifier)
                      .setLocale(newLocale);
                  
                  // Update slang locale settings for immediate UI update
                  final appLocale = AppLocale.values.firstWhere(
                    (locale) => locale.languageCode == value,
                    orElse: () => AppLocale.ja,
                  );
                  unawaited(LocaleSettings.setLocale(appLocale));
                  
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: currentLocale?.languageCode,
              onChanged: (value) async {
                if (value != null) {
                  final newLocale = Locale(value);
                  await ref
                      .read(appLocaleProviderProvider.notifier)
                      .setLocale(newLocale);
                  
                  // Update slang locale settings for immediate UI update
                  final appLocale = AppLocale.values.firstWhere(
                    (locale) => locale.languageCode == value,
                    orElse: () => AppLocale.ja,
                  );
                  unawaited(LocaleSettings.setLocale(appLocale));
                  
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.settings.cancel),
          ),
        ],
      ),
    );
  }

  Future<void> _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    Translations t,
  ) async {
    final currentTheme = ref.read(appThemeProviderProvider).valueOrNull;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.settings.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(t.settings.theme_system),
              value: ThemeMode.system,
              groupValue: currentTheme,
              onChanged: (value) async {
                if (value != null) {
                  await ref
                      .read(appThemeProviderProvider.notifier)
                      .setThemeMode(value);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(t.settings.theme_light),
              value: ThemeMode.light,
              groupValue: currentTheme,
              onChanged: (value) async {
                if (value != null) {
                  await ref
                      .read(appThemeProviderProvider.notifier)
                      .setThemeMode(value);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(t.settings.theme_dark),
              value: ThemeMode.dark,
              groupValue: currentTheme,
              onChanged: (value) async {
                if (value != null) {
                  await ref
                      .read(appThemeProviderProvider.notifier)
                      .setThemeMode(value);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.settings.cancel),
          ),
        ],
      ),
    );
  }
}
