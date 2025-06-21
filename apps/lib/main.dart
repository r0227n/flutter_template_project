import 'package:apps/i18n/translations.g.dart';
import 'package:apps/router/app_router.dart';
import 'package:apps/services/locale_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 保存されたLocaleがあるかチェック
  final savedLocale = await LocaleService.getSavedLocale();
  if (savedLocale != null) {
    await LocaleSettings.setLocaleRaw(savedLocale.languageCode);
  } else {
    await LocaleSettings.useDeviceLocale();
  }

  runApp(ProviderScope(child: TranslationProvider(child: const MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      locale: TranslationProvider.of(context).flutterLocale, // use provider
      supportedLocales: AppLocale.values.map((locale) => locale.flutterLocale),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: router,
    );
  }
}
