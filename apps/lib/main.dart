import 'package:apps/i18n/translations.g.dart';
import 'package:apps/router/app_router.dart';
import 'package:apps/theme/app_theme.dart';
import 'package:apps/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleSettings.useDeviceLocale();

  runApp(ProviderScope(child: TranslationProvider(child: const MyApp())));
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
      locale: TranslationProvider.of(context).flutterLocale, // use provider
      supportedLocales: AppLocale.values.map((locale) => locale.flutterLocale),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: router,
    );
  }
}
