import 'dart:async';

import 'package:app/application/application.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/shared/controllers/app_preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(appPreferencesControllerProvider);
    final controller = ref.read(appPreferencesControllerProvider.notifier);
    final value = preferences.value ?? const AppPreferences();

    return Scaffold(
      appBar: AppBar(title: Text(t.settings)),
      body: ListView(
        children: [
          ListTile(
            title: Text(t.theme),
            trailing: DropdownButton<AppThemePreference>(
              value: value.theme,
              items: [
                DropdownMenuItem(
                  value: AppThemePreference.system,
                  child: Text(t.system),
                ),
                DropdownMenuItem(
                  value: AppThemePreference.light,
                  child: Text(t.light),
                ),
                DropdownMenuItem(
                  value: AppThemePreference.dark,
                  child: Text(t.dark),
                ),
              ],
              onChanged: preferences.isLoading
                  ? null
                  : (value) {
                      if (value != null) unawaited(controller.setTheme(value));
                    },
            ),
          ),
          ListTile(
            title: Text(t.language),
            trailing: DropdownButton<String>(
              value: value.languageCode,
              items: const [
                DropdownMenuItem(value: 'ja', child: Text('日本語')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: preferences.isLoading
                  ? null
                  : (value) {
                      if (value != null) {
                        unawaited(controller.setLanguage(value));
                      }
                    },
            ),
          ),
          if (preferences.isLoading) const LinearProgressIndicator(),
          if (preferences.hasError)
            ListTile(
              leading: const Icon(Icons.error_outline),
              title: Text(t.saveFailed),
            ),
        ],
      ),
    );
  }
}
