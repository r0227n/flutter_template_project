import 'package:app_preferences/app_preferences.dart';
import 'package:apps/i18n/translations.g.dart';
import 'package:apps/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize locale
  await LocaleSettings.useDeviceLocale();

  runApp(
    ProviderScope(
      child: TranslationProvider(
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocalePreferenceProvider);
    final themeMode = ref.watch(appThemePreferenceProvider);

    return MaterialApp.router(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocale.values
          .map((locale) => locale.flutterLocale),
      locale: locale.when(
        data: (locale) => locale,
        loading: () => const Locale('en'),
        error: (_, __) => const Locale('en'),
      ),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode.when(
        data: (mode) => mode,
        loading: () => ThemeMode.system,
        error: (_, __) => ThemeMode.system,
      ),
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}