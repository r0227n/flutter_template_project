import 'package:app/router/routes.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'app_router.g.dart';

/// The application's router provider.
///
/// This provider creates and configures the `GoRouter` instance for the app.
@riverpod
GoRouter appRouter(Ref ref) {
  final talker = ref.watch(talkerProvider);

  return GoRouter(
    debugLogDiagnostics: kDebugMode,
    observers: [
      TalkerRouteObserver(talker),
    ],
    initialLocation: '/',
    routes: $appRoutes,
  );
}
