import 'dart:async';

import 'package:app/i18n/translations.g.dart';
import 'package:app/router/routes.dart';
import 'package:core/core.dart' hide LocaleSettings;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListItem {
  const ListItem({
    required Widget title,
    Widget? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) : _title = title,
       _subtitle = subtitle,
       _trailing = trailing,
       _onTap = onTap;

  final Widget _title;
  final Widget? _subtitle;
  final Widget? _trailing;
  final VoidCallback? _onTap;

  ListTile toListTile() {
    return ListTile(
      title: _title,
      subtitle: _subtitle,
      trailing: _trailing,
      onTap: _onTap,
    );
  }

  static const iconOpenPage = Icon(Icons.chevron_right);
  static const iconOpenBrowser = Icon(Icons.open_in_new);
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);

    final children = [
      ListItem(
        title: Text(t.settings.language),
        subtitle: const LocaleText(),
        trailing: ListItem.iconOpenPage,
        onTap: () => PreferencesDialogHelpers.showLocaleSelectionDialog(
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
        ),
      ),
      ListItem(
        title: Text(t.settings.theme),
        subtitle: const ThemeText(),
        trailing: ListItem.iconOpenPage,
        onTap: () => PreferencesDialogHelpers.showThemeSelectionDialog(
          context: context,
          title: t.settings.theme,
        ),
      ),

      ListItem(
        title: Text(t.settings.version),
        subtitle: const VersionText(),
        trailing: const Icon(Icons.info_outline),
      ),
      ListItem(
        title: Text(t.settings.licenses),
        trailing: ListItem.iconOpenPage,
        onTap: () => const LicenseRoute().go(context),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.title),
      ),
      body: ListView.separated(
        itemBuilder: (context, indext) {
          final item = children[indext];
          return item.toListTile();
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: children.length,
      ),
    );
  }
}
