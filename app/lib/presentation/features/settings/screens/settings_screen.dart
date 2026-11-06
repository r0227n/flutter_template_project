import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/features/settings/widgets/settings_save_feedback.dart';
import 'package:app/presentation/features/settings/widgets/settings_selection_tile.dart';
import 'package:app/presentation/shared/controllers/app_preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// アプリ全体で共有するテーマと言語を即時保存する画面。
class SettingsScreen extends ConsumerWidget {
  /// 設定画面を生成する。
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translations = Translations.of(context);
    final preferences = ref.watch(appPreferencesControllerProvider);
    final controller = ref.read(appPreferencesControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(translations.settings)),
      body: SafeArea(
        child: ListView(
          children: [
            SettingsSelectionTile<ThemeMode>(
              title: translations.theme,
              value: preferences.themeMode,
              enabled: !preferences.isSaving,
              options: {
                ThemeMode.system: translations.system,
                ThemeMode.light: translations.light,
                ThemeMode.dark: translations.dark,
              },
              onSelected: (value) => saveSettingsWithFeedback(
                context,
                ref,
                () => controller.setThemeMode(value),
              ),
            ),
            SettingsSelectionTile<AppLocale>(
              title: translations.language,
              value: AppLocaleUtils.parse(preferences.locale.languageCode),
              enabled: !preferences.isSaving,
              options: {
                AppLocale.ja: translations.languageJapanese,
                AppLocale.en: translations.languageEnglish,
              },
              onSelected: (value) => saveSettingsWithFeedback(
                context,
                ref,
                () => controller.setLocale(value),
              ),
            ),
            if (preferences.isSaving)
              LinearProgressIndicator(semanticsLabel: translations.saving),
          ],
        ),
      ),
    );
  }
}
