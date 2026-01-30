import 'package:app/presentation/pages/home/home_page.dart';
import 'package:app/presentation/pages/settings/menu.dart';
import 'package:app/presentation/pages/settings/settings_page.dart';
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
/// The main application route, corresponding to the home screen.
///
/// This route is configured with nested routes for settings and license pages.
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}

/// The route for the settings screen, accessible from the home screen.
///
/// This route includes a nested route for the license page.
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsPage();
  }
}

/// The route for the license page, accessible from the settings screen.
///
/// This route displays the open-source licenses for the application.
class LicenseMenuRoute extends GoRouteData with $LicenseMenuRoute {
  const LicenseMenuRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LicenseMenu();
  }
}
