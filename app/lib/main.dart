import 'dart:async';

import 'package:app_preferences/app_preferences.dart' as prefs;
import 'package:apps/i18n/translations.g.dart';
import 'package:apps/router/app_router.dart';
import 'package:debug/debug.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize debug service for development
  DebugService.initialize();

  // Initialize locale from stored preferences or use device locale as fallback
  final sharedPrefs = await prefs.AppPreferencesInitializer.initializeLocale(
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
        prefs.sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: TranslationProvider(
        child: prefs.TranslationProvider(
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
    final locale = ref.watch(prefs.appLocaleProviderProvider);
    final themeMode = ref.watch(prefs.appThemeProviderProvider);
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
      theme: prefs.AppTheme.lightTheme,
      darkTheme: prefs.AppTheme.darkTheme,
      themeMode: switch (themeMode) {
        AsyncData(value: final mode) => mode,
        _ => ThemeMode.system,
      },
      routerConfig: router,
    );
  }
}
