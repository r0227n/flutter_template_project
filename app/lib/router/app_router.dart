import 'package:apps/router/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: '/',
    routes: $appRoutes,
  );
}
