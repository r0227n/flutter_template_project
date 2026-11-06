import 'package:app/app/bootstrap_failure_app.dart';
import 'package:app/app/dependency_graph.dart';
import 'package:app/app/template_app.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/core/localization/app_locale_resolver.dart';
import 'package:app/core/logger/talker_integration.dart';
import 'package:app/presentation/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

/// 外部サービスの設定なしで依存と翻訳を初期化して起動する。
Future<void> bootstrap() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  final talker = createTalker();
  installErrorHandlers(talker);
  try {
    final graph = AppDependencyGraph(
      sharedPreferences: await SharedPreferences.getInstance(),
      talker: talker,
    );
    await LocaleSettings.setLocale(
      resolveAppLocale(
        graph.initialAppPreferences.locale?.languageCode,
        binding.platformDispatcher.locales,
      ),
    );
    runApp(
      graph.attach(
        observers: [TalkerRiverpodObserver(talker: talker)],
        child: const _AppRoot(),
      ),
    );
  } on Object catch (error, stackTrace) {
    talker.handle(error, stackTrace, 'Bootstrap failed');
    runApp(const BootstrapFailureApp(onRetry: bootstrap));
  }
}

class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  late final GoRouter _router = buildAppRouter();

  @override
  Widget build(BuildContext context) => TemplateApp(router: _router);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }
}
