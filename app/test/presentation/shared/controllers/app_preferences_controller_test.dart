import 'dart:async';

import 'package:app/application/application.dart';
import 'package:app/application/errors/settings_error.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/shared/controllers/app_preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FakeAppPreferencesRepository repository;
  late ProviderContainer container;
  late AppPreferencesController controller;

  setUp(() async {
    await LocaleSettings.setLocale(AppLocale.en);
    repository = FakeAppPreferencesRepository(
      snapshot: const AppPreferencesSnapshot(
        theme: AppThemePreference.dark,
        locale: LocalePreference(languageCode: 'en'),
      ),
    );
    container = ProviderContainer(
      overrides: [
        appPreferencesUseCaseProvider.overrideWithValue(
          AppPreferencesUseCase(repository),
        ),
        initialAppPreferencesSnapshotProvider.overrideWithValue(
          repository.load(),
        ),
      ],
    );
    controller = container.read(appPreferencesControllerProvider.notifier);
  });
  tearDown(() async {
    container.dispose();
    await LocaleSettings.setLocale(AppLocale.ja);
  });

  test('exposes persisted settings synchronously without default flashes', () {
    final state = container.read(appPreferencesControllerProvider);
    expect(state.themeMode, ThemeMode.dark);
    expect(state.locale, const Locale('en'));
    expect(state.isSaving, isFalse);
  });

  test(
    'serializes rapid updates and applies changes to the latest state',
    () async {
      final gate = Completer<void>();
      repository.beforeSave = () => gate.future;
      final themeSave = controller.setThemeMode(ThemeMode.light);
      final localeSave = controller.setLocale(AppLocale.ja);
      await Future<void>.delayed(Duration.zero);
      expect(repository.operations, ['theme:light']);
      final saving = container.read(appPreferencesControllerProvider);
      expect(saving.isSaving, isTrue);
      expect(saving.themeMode, ThemeMode.dark);
      expect(saving.locale, const Locale('en'));

      gate.complete();
      await Future.wait([themeSave, localeSave]);
      final state = container.read(appPreferencesControllerProvider);
      expect(repository.operations, ['theme:light', 'locale:ja']);
      expect(state.themeMode, ThemeMode.light);
      expect(state.locale, const Locale('ja'));
      expect(state.isSaving, isFalse);
      expect(LocaleSettings.currentLocale, AppLocale.ja);
    },
  );

  test(
    'returns failures, retains values, and continues queued operations',
    () async {
      const failure = SettingsWriteException();
      repository.beforeSave = () async {
        repository.beforeSave = null;
        throw failure;
      };
      final failedSave = expectLater(
        controller.setLocale(AppLocale.ja),
        throwsA(same(failure)),
      );
      final successfulSave = controller.setThemeMode(ThemeMode.light);
      await Future.wait([failedSave, successfulSave]);
      final state = container.read(appPreferencesControllerProvider);
      expect(state.locale, const Locale('en'));
      expect(LocaleSettings.currentLocale, AppLocale.en);
      expect(state.themeMode, ThemeMode.light);
      expect(state.isSaving, isFalse);
    },
  );

  test('does not update disposed state or run pending operations', () async {
    final gate = Completer<void>();
    repository.beforeSave = () => gate.future;
    final first = controller.setThemeMode(ThemeMode.light);
    final second = controller.setLocale(AppLocale.ja);
    await Future<void>.delayed(Duration.zero);
    container.dispose();
    gate.complete();
    await Future.wait([first, second]);
    expect(repository.operations, ['theme:light']);
    expect(LocaleSettings.currentLocale, AppLocale.en);
  });
}
