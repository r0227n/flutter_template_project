import 'dart:async';

import 'package:app/i18n/translations.g.dart';
import 'package:app/router/app_router.dart';
import 'package:app_logger/app_logger.dart';
import 'package:app_preferences/app_preferences.dart' as prefs;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger based on build mode
  final loggerConfig = kDebugMode
      ? LoggerConfig.development()
      : LoggerConfig.production();
  AppLogger.initialize(loggerConfig);
  final logger = AppLogger.instance;

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

  final talker = logger.talker;

  runApp(
    ProviderScope(
      observers: [
        TalkerRiverpodObserver(
          talker: talker,
          settings: const TalkerRiverpodLoggerSettings(
            printStateFullData: false,
          ),
        ),
      ],
      overrides: [
        talkerProvider.overrideWithValue(talker),
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
