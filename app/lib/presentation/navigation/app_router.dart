import 'package:app/presentation/navigation/routes.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Typed route を組み立てる。Router の生成と破棄は app が所有する。
GoRouter buildAppRouter({
  String? initialLocation,
  List<NavigatorObserver> observers = const [],
}) => GoRouter(
  routes: $appRoutes,
  initialLocation: initialLocation,
  observers: observers,
);
