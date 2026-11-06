import 'package:app/presentation/features/home/screens/home_screen.dart';
import 'package:app/presentation/features/settings/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

/// ホーム画面。設定への遷移でも戻り先として残す。
@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [TypedGoRoute<SettingsRoute>(path: 'settings')],
)
class HomeRoute extends GoRouteData with $HomeRoute {
  /// ホームへの型安全な遷移を生成する。
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

/// アプリ基本設定への deep link。
class SettingsRoute extends GoRouteData with $SettingsRoute {
  /// 設定への型安全な遷移を生成する。
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}
