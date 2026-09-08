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
    final t = Translations.of(context);
    final state = ref.watch(appPreferencesControllerProvider);
    final controller = ref.read(appPreferencesControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(t.settings)),
      body: ListView(
        children: [
          ListTile(
            title: Text(t.theme),
            trailing: DropdownButton<AppThemePreference>(
              value: state.preferences.theme,
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
              onChanged: state.saving
                  ? null
                  : (value) {
                      if (value != null) unawaited(controller.setTheme(value));
                    },
            ),
          ),
          ListTile(
            title: Text(t.language),
            trailing: DropdownButton<String>(
              value: state.preferences.languageCode,
              items: const [
                DropdownMenuItem(value: 'ja', child: Text('日本語')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: state.saving
                  ? null
                  : (value) {
                      if (value != null) {
                        unawaited(controller.setLanguage(value));
                      }
                    },
            ),
          ),
          if (state.saving) const LinearProgressIndicator(),
          if (state.saveFailed)
            ListTile(
              leading: const Icon(Icons.error_outline),
              title: Text(t.saveFailed),
            ),
        ],
      ),
    );
  }
}
