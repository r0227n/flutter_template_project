import 'dart:async';

import 'package:app/app/dependency_graph.dart';
import 'package:app/app/template_app.dart';
import 'package:app/application/application.dart';
import 'package:app/application/errors/settings_error.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/dependencies/observability_providers.dart';
import 'package:app/presentation/navigation/app_router.dart';
import 'package:app/presentation/shared/controllers/app_preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

import '../support/fakes.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    binding.platformDispatcher.localesTestValue = [const Locale('ja')];
    SharedPreferences.setMockInitialValues({});
    await LocaleSettings.setLocale(AppLocale.ja);
  });
  tearDown(() async {
    binding.platformDispatcher.clearLocalesTestValue();
    await LocaleSettings.setLocale(AppLocale.ja);
  });

  testWidgets('production graph restores settings before the first frame', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'app.theme': 'dark',
      'app.language': 'en',
    });
    final graph = AppDependencyGraph(
      sharedPreferences: await SharedPreferences.getInstance(),
      talker: Talker(settings: TalkerSettings(enabled: false)),
    );
    await LocaleSettings.setLocale(AppLocale.en);
    final router = buildAppRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(graph.attach(child: TemplateApp(router: router)));

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);
    expect(materialApp.locale, const Locale('en'));
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('real controls save theme and locale and typed routes go back', (
    tester,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    final graph = AppDependencyGraph(
      sharedPreferences: preferences,
      talker: Talker(settings: TalkerSettings(enabled: false)),
    );
    final router = buildAppRouter();
    addTearDown(router.dispose);
    await tester.pumpWidget(graph.attach(child: TemplateApp(router: router)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('設定'));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/settings');
    await tester.tap(find.text('テーマ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ダーク'));
    await tester.pumpAndSettle();
    expect(preferences.getString('app.theme'), 'dark');
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    await tester.tap(find.text('言語'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    expect(preferences.getString('app.language'), 'en');
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).locale,
      const Locale('en'),
    );
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.path, '/');
  });

  testWidgets(
    'deep link opens settings and survives large text on narrow screens',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2.5;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final graph = AppDependencyGraph(
        sharedPreferences: await SharedPreferences.getInstance(),
        talker: Talker(settings: TalkerSettings(enabled: false)),
      );
      final router = buildAppRouter(initialLocation: '/settings');
      addTearDown(router.dispose);
      await tester.pumpWidget(graph.attach(child: TemplateApp(router: router)));
      await tester.pumpAndSettle();
      expect(find.text('設定'), findsOneWidget);
      await tester.tap(find.text('テーマ'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('ダーク'));
      await tester.tap(find.text('ダーク'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('ホーム'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'saving disables controls and failure retains values and reports once',
    (tester) async {
      final gate = Completer<void>();
      final repository = FakeAppPreferencesRepository(
        snapshot: const AppPreferencesSnapshot(
          theme: AppThemePreference.dark,
          locale: LocalePreference(languageCode: 'ja'),
        ),
      )..beforeSave = () => gate.future;
      final reporter = RecordingErrorReporter();
      final router = buildAppRouter(initialLocation: '/settings');
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appPreferencesUseCaseProvider.overrideWithValue(
              AppPreferencesUseCase(repository),
            ),
            initialAppPreferencesSnapshotProvider.overrideWithValue(
              repository.load(),
            ),
            errorReporterProvider.overrideWithValue(reporter),
          ],
          child: TemplateApp(router: router),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('テーマ'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ライト'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      final tile = tester.widget<ListTile>(find.widgetWithText(ListTile, '言語'));
      expect(tile.enabled, isFalse);
      gate.completeError(const SettingsWriteException());
      await tester.pumpAndSettle();
      expect(find.text('設定を保存できませんでした。もう一度お試しください。'), findsOneWidget);
      expect(reporter.errors, hasLength(1));
      expect(
        tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
        ThemeMode.dark,
      );
      final container = ProviderScope.containerOf(
        tester.element(find.byType(TemplateApp)),
      );
      expect(
        container.read(appPreferencesControllerProvider).isSaving,
        isFalse,
      );
    },
  );
}
