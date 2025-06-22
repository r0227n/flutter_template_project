import 'package:debug/debug.dart';
import 'package:apps/i18n/translations.g.dart' as i18n;
import 'package:apps/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize locale
  await i18n.LocaleSettings.useDeviceLocale();

  // Create provider container with debug observers
  final container = ProviderContainer(
    observers: DebugConfig.shouldEnableTalker ? [TalkerRiverpodObserver(talker: Talker())] : [],
  );

  runApp(
    ProviderScope(
      parent: container,
      child: i18n.TranslationProvider(
        child: DebugConfig.shouldEnableShakeDetector
            ? ShakeDetectorWidget(child: const MyApp())
            : const MyApp(),
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
    final talker = ref.watch(talkerProvider);

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      locale: i18n.TranslationProvider.of(context).flutterLocale,
      supportedLocales: i18n.AppLocale.values
          .map((locale) => locale.flutterLocale),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: router,
      navigatorObservers: DebugConfig.shouldEnableTalker
          ? [TalkerRouteObserver(talker)]
          : [],
    );
  }
}