import 'dart:async';

import 'package:app_preferences/app_preferences.dart';
import 'package:app_preferences/app_prefs_translations.dart' as app_prefs;
import 'package:apps/i18n/translations.g.dart';
import 'package:apps/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  // Initialize locale from stored preferences or use device locale as fallback
  await AppPreferencesInitializer.initializeLocale(
    prefs: prefs,
    onLocaleFound: (languageCode) async {
      final appLocale = AppLocale.values.firstWhere(
        (locale) => locale.languageCode == languageCode,
        orElse: () => AppLocale.ja,
      );
      await LocaleSettings.setLocale(appLocale);
    },
    onUseDeviceLocale: () async {
      await LocaleSettings.useDeviceLocale();
    },
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: TranslationProvider(
        child: app_prefs.TranslationProvider(
          child: const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProviderProvider);
    final themeMode = ref.watch(appThemeProviderProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocale.values.map((locale) => locale.flutterLocale),
      locale: switch (locale) {
        AsyncData(value: final locale) => locale,
        _ => const Locale('ja'),
      },
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: switch (themeMode) {
        AsyncData(value: final mode) => mode,
        _ => ThemeMode.system,
      },
      routerConfig: router,
    );
  }
}
