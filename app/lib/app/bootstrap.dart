import 'dart:ui';
import 'package:app/app/dependency_graph.dart';
import 'package:app/app/template_app.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/core/logger/talker_integration.dart';
import 'package:app/presentation/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final talker = createTalker();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    talker.handle(details.exception, details.stack, 'Flutter error');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    talker.handle(error, stack, 'Uncaught error');
    return true;
  };
  try {
    final graph = AppDependencyGraph(
      await SharedPreferences.getInstance(),
      talker,
    );
    await LocaleSettings.setLocaleRaw(
      graph.preferencesUseCase.load().languageCode,
    );
    runApp(graph.attach(child: const _AppRoot()));
  } on Object catch (error, stack) {
    talker.handle(error, stack, 'Bootstrap failed');
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: FilledButton(
              onPressed: bootstrap,
              child: Text('再試行 / Retry'),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppRoot extends ConsumerStatefulWidget {
  const _AppRoot();
  @override
  ConsumerState<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<_AppRoot> {
  late final GoRouter _router = GoRouter(routes: $appRoutes);
  @override
  Widget build(BuildContext context) {
    return TemplateApp(router: _router);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }
}
