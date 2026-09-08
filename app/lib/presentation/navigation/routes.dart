import 'package:app/presentation/features/home/screens/home_screen.dart';
import 'package:app/presentation/features/settings/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
part 'routes.g.dart';

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [TypedGoRoute<SettingsRoute>(path: 'settings')],
)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}
