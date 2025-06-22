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
          // Placeholder for future settings
          ListTile(
            title: Text(t.settings.language),
            subtitle: const Text('System'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement language selection
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Language settings will be implemented later'),
                ),
              );
            },
          ),
          const Divider(),

          ListTile(
            title: Text(t.settings.theme),
            subtitle: const Text('System'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement theme selection
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Theme settings will be implemented later'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
