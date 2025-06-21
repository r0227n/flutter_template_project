import 'package:app_preferences/app_preferences.dart';
import 'package:apps/i18n/translations.g.dart' as i18n;
import 'package:apps/router/app_router.dart';
import 'package:apps/theme/app_theme.dart';
import 'package:apps/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app preferences and set up initial locale
  final container = ProviderContainer();
  
  try {
    // Wait for shared preferences to be initialized
    await container.read(sharedPreferencesProvider.future);
    
    // Check if there's a saved locale preference
    final savedLocale = container.read(appLocaleProvider);
    if (savedLocale != null) {
      await i18n.LocaleSettings.setLocaleRaw(savedLocale.languageCode);
    } else {
      await i18n.LocaleSettings.useDeviceLocale();
    }
  } finally {
    container.dispose();
  }

  runApp(ProviderScope(child: i18n.TranslationProvider(child: const MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      locale: i18n.TranslationProvider.of(context).flutterLocale,
      supportedLocales: i18n.AppLocale.values
          .map((locale) => locale.flutterLocale),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: router,
    );
  }
}
