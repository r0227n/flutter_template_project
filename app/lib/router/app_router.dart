import 'package:app/router/routes.dart';
import 'package:app_logger/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'app_router.g.dart';

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
