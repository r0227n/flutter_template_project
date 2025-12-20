import 'package:app/pages/home_page.dart';
import 'package:app/pages/settings/menu.dart';
import 'package:app/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<SettingsRoute>(
      path: 'settings',
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<LicenseMenuRoute>(
          path: 'license',
        ),
      ],
    ),
  ],
)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}

class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsPage();
  }
}

class LicenseMenuRoute extends GoRouteData with $LicenseMenuRoute {
  const LicenseMenuRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LicenseMenu();
  }
}
