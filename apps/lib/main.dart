import 'package:apps/i18n/translations.g.dart';
import 'package:apps/router/app_router.dart';
import 'package:apps/theme/app_theme.dart';
import 'package:apps/theme/theme_provider.dart';
import 'package:apps/services/locale_service.dart';
import 'package:debug/debug.dart';
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

  // Create a temporary container to get the talker instance
  final tempContainer = ProviderContainer();
  final talker = tempContainer.read(talkerProvider);
  tempContainer.dispose();
  
  final appContainer = ProviderContainer(
    observers: DebugConfig.shouldEnableTalker
        ? [TalkerRiverpodObserver(talker: talker)]
        : [],
  );
  
  runApp(
    UncontrolledProviderScope(
      container: appContainer,
      child: TranslationProvider(
        child: const ShakeDetectorWidget(
          child: MyApp(),
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
