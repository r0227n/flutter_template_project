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
/// The route for the home page.
class HomeRoute extends GoRouteData with $HomeRoute {
  /// Creates a new [HomeRoute] instance.
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}

/// The route for the settings page.
class SettingsRoute extends GoRouteData with $SettingsRoute {
  /// Creates a new [SettingsRoute] instance.
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsPage();
  }
}

/// The route for the license menu page.
class LicenseMenuRoute extends GoRouteData with $LicenseMenuRoute {
  /// Creates a new [LicenseMenuRoute] instance.
  const LicenseMenuRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LicenseMenu();
  }
}
