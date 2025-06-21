import 'package:app_preferences/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apps/i18n/translations.g.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final themeMode = ref.watch(appThemeProvider);
    final t = Translations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.title),
      ),
      body: ListView(
        children: [
          // Language setting
          ListTile(
            title: Text(t.settings.language),
            subtitle: Text(_getLanguageName(locale)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context, ref),
          ),
          const Divider(),
          
          // Theme setting
          ListTile(
            title: Text(t.settings.theme),
            subtitle: Text(_getThemeName(context, themeMode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeDialog(context, ref),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(Locale? locale) {
    if (locale == null) return 'System';
    switch (locale.languageCode) {
      case 'ja':
        return '日本語';
      case 'en':
        return 'English';
      default:
        return locale.languageCode;
    }
  }

  String _getThemeName(BuildContext context, ThemeMode mode) {
    final t = Translations.of(context);
    switch (mode) {
      case ThemeMode.system:
        return t.settings.theme_system;
      case ThemeMode.light:
        return t.settings.theme_light;
      case ThemeMode.dark:
        return t.settings.theme_dark;
    }
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.settings.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Locale?>(
              title: const Text('System'),
              value: null,
              groupValue: ref.read(appLocaleProvider),
              onChanged: (value) {
                ref.read(appLocaleProvider.notifier).clearLocale();
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<Locale>(
              title: const Text('English'),
              value: const Locale('en'),
              groupValue: ref.read(appLocaleProvider),
              onChanged: (value) {
                if (value != null) {
                  ref.read(appLocaleProvider.notifier).setLocale(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<Locale>(
              title: const Text('日本語'),
              value: const Locale('ja'),
              groupValue: ref.read(appLocaleProvider),
              onChanged: (value) {
                if (value != null) {
                  ref.read(appLocaleProvider.notifier).setLocale(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.settings.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(t.settings.theme_system),
              value: ThemeMode.system,
              groupValue: ref.read(appThemeProvider),
              onChanged: (value) {
                if (value != null) {
                  ref.read(appThemeProvider.notifier).setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(t.settings.theme_light),
              value: ThemeMode.light,
              groupValue: ref.read(appThemeProvider),
              onChanged: (value) {
                if (value != null) {
                  ref.read(appThemeProvider.notifier).setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(t.settings.theme_dark),
              value: ThemeMode.dark,
              groupValue: ref.read(appThemeProvider),
              onChanged: (value) {
                if (value != null) {
                  ref.read(appThemeProvider.notifier).setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}