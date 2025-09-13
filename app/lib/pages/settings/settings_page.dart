import 'dart:async';

import 'package:app/core/constants.dart';
import 'package:app/core/i18n.dart';
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
        onTap: () => const LicenseMenuRoute().go(context),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.title),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(t.settings.sections.appSettings),
                _SettingsCard(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(t.settings.language),
                      subtitle: const LocaleText(),
                      onTap: () =>
                          PreferencesDialogHelpers.showLocaleSelectionDialog(
                            context: context,
                            title: t.settings.language,
                            onLocaleChanged: (languageCode) async {
                              final appLocale = AppLocale.values.firstWhere(
                                (locale) => locale.languageCode == languageCode,
                                orElse: () => AppLocale.ja,
                              );
                              unawaited(LocaleSettings.setLocale(appLocale));
                            },
                          ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Theme.of(context).brightness == Brightness.dark
                          ? const Icon(Icons.dark_mode)
                          : const Icon(Icons.light_mode),
                      title: Text(t.settings.theme),
                      subtitle: const ThemeText(),
                      onTap: () =>
                          PreferencesDialogHelpers.showThemeSelectionDialog(
                            context: context,
                            title: t.settings.theme,
                          ),
                    ),
                  ],
                ),

                // アプリ情報セクション
                _SectionHeader(t.settings.sections.other),
                _SettingsCard(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: Text(t.settings.version),
                      trailing: const VersionText(),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: Text(t.settings.licenses),
                      onTap: () => const LicenseMenuRoute().go(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(String title) : _title = title;

  final String _title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Spacing.xs,
        top: Spacing.l,
        bottom: Spacing.s,
      ),
      child: Text(
        _title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required List<Widget> children}) : _children = children;

  final List<Widget> _children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radius.s),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radius.s),
        child: Column(
          children: _children,
        ),
      ),
    );
  }
}
