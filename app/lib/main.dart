import 'dart:async';

import 'package:app/core/i18n.dart' as app;
import 'package:app/router/app_router.dart';
import 'package:core/core.dart' as core;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_settings.dart';

Future<void> main() async {
  /// Initialize locale settings
  Future<void> initializeLocale(SharedPreferences prefs) async {
    final repository = core.AppPreferencesRepository(prefs: prefs);

    final storedLocale = repository.getLocale();
    if (storedLocale != null) {
      await Future.wait([
        app.LocaleSettings.setLocale(
          app.AppLocale.values.firstWhere(
            (appLocale) => appLocale.languageCode == storedLocale.languageCode,
            orElse: () => app.AppLocale.en,
          ),
        ),
        core.LocaleSettings.setLocale(
          core.CoreLocale.values.firstWhere(
            (coreLocale) =>
                coreLocale.languageCode == storedLocale.languageCode,
            orElse: () => core.CoreLocale.ja,
          ),
        ),
      ]);
    } else {
      final deviceLocale = await app.LocaleSettings.useDeviceLocale();
      await Future.wait([
        app.LocaleSettings.setLocale(deviceLocale),
        core.LocaleSettings.setLocale(
          core.CoreLocale.values.firstWhere(
            (coreLocale) =>
                coreLocale.languageCode == deviceLocale.languageCode,
            orElse: () => core.CoreLocale.ja,
          ),
        ),
      ]);
    }
  }

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger based on build mode
  final loggerConfig = kDebugMode
      ? core.LoggerConfig.development()
      : core.LoggerConfig.production();
  core.AppLogger.initialize(loggerConfig);
  final logger = core.AppLogger.instance;

  final prefs = await SharedPreferences.getInstance();
  await initializeLocale(prefs);

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
        core.talkerProvider.overrideWithValue(talker),
        core.sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: core.TranslationProvider(
        child: app.TranslationProvider(
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
    final locale = ref.watch(core.appLocaleProviderProvider);
    final themeMode = ref.watch(core.appThemeProviderProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: app.AppLocale.values.map(
        (locale) => locale.flutterLocale,
      ),
      locale: locale,
      theme: core.AppTheme.lightTheme,
      darkTheme: core.AppTheme.darkTheme,
      themeMode: switch (themeMode) {
        AsyncData(value: final mode) => mode,
        _ => ThemeMode.system,
      },
      routerConfig: router,
    );
  }
}
