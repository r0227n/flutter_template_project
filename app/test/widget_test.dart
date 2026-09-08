import 'package:app/app/dependency_graph.dart';
import 'package:app/app/template_app.dart';
import 'package:app/application/application.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/navigation/routes.dart';
import 'package:app/presentation/shared/controllers/app_preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  testWidgets('Routes, theme and language settings work with production DI', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await LocaleSettings.setLocale(AppLocale.ja);
    final preferences = await SharedPreferences.getInstance();
    final graph = AppDependencyGraph(
      preferences,
      Talker(settings: TalkerSettings(enabled: false)),
    );
    final router = GoRouter(routes: $appRoutes);
    addTearDown(router.dispose);
    await tester.pumpWidget(graph.attach(child: TemplateApp(router: router)));
    await tester.pumpAndSettle();
    expect(find.text('ホーム'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/settings');
    final container = ProviderScope.containerOf(
      tester.element(find.byType(TemplateApp)),
    );
    await container
        .read(appPreferencesControllerProvider.notifier)
        .setTheme(AppThemePreference.dark);
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    expect(graph.preferencesUseCase.load().languageCode, 'en');
    expect(graph.preferencesUseCase.load().theme, AppThemePreference.dark);
    router.pop();
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
  });
}
