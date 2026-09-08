import 'dart:async';
import 'package:app/application/application.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/shared/controllers/app_preferences_controller.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TemplateApp extends ConsumerWidget {
  const TemplateApp({required this.router, super.key});
  final GoRouter router;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      appPreferencesControllerProvider.select(
        (value) => value.value?.languageCode,
      ),
      (_, code) {
        if (code != null) {
          unawaited(LocaleSettings.setLocaleRaw(code));
        }
      },
    );
    final preferences =
        ref.watch(appPreferencesControllerProvider).value ??
        const AppPreferences();
    final locale = AppLocale.values.firstWhere(
      (locale) => locale.languageCode == preferences.languageCode,
    );
    return TranslationProvider(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => Translations.of(context).appName,
        locale: locale.flutterLocale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: switch (preferences.theme) {
          AppThemePreference.system => ThemeMode.system,
          AppThemePreference.light => ThemeMode.light,
          AppThemePreference.dark => ThemeMode.dark,
        },
        routerConfig: router,
      ),
    );
  }
}
