import 'dart:async';
import 'package:app/application/application.dart';
import 'package:app/core/logger/error_reporter.dart';
import 'package:app/infrastructure/infrastructure.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/shared/controllers/app_preferences_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FailingRepository implements AppPreferencesRepository {
  @override
  AppPreferences load() => const AppPreferences();
  @override
  Future<void> saveTheme(AppThemePreference theme) async =>
      throw StateError('disk failure');
  @override
  Future<void> saveLanguage(String languageCode) async =>
      throw StateError('disk failure');
}

class RecordingReporter implements ErrorReporter {
  Object? error;
  @override
  void report(Object error, StackTrace? stackTrace, {required String message}) {
    this.error = error;
  }
}

class PendingRepository extends FailingRepository {
  final completion = Completer<void>();
  int saves = 0;
  @override
  Future<void> saveTheme(AppThemePreference theme) {
    saves++;
    return completion.future;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'Defaults, invalid stored values and persistence across adapters',
    () async {
      SharedPreferences.setMockInitialValues({
        'app.theme': 42,
        'app.language': 'unknown',
      });
      final preferences = await SharedPreferences.getInstance();
      final useCase = AppPreferencesUseCase(
        LocalAppPreferencesRepository(preferences),
      );
      expect(useCase.load().theme, AppThemePreference.system);
      expect(useCase.load().languageCode, 'ja');
      await useCase.saveTheme(AppThemePreference.dark);
      await useCase.saveLanguage('en');
      final reopened = LocalAppPreferencesRepository(preferences);
      expect(reopened.load().theme, AppThemePreference.dark);
      expect(reopened.load().languageCode, 'en');
      expect(() => useCase.saveLanguage('invalid'), throwsArgumentError);
    },
  );
  test(
    'Save failure retains preferences, exposes feedback and reports error',
    () async {
      final reporter = RecordingReporter();
      final container = ProviderContainer(
        overrides: [
          appPreferencesUseCaseProvider.overrideWithValue(
            AppPreferencesUseCase(FailingRepository()),
          ),
          errorReporterProvider.overrideWithValue(reporter),
        ],
      );
      addTearDown(container.dispose);
      await container.read(appPreferencesControllerProvider.future);
      await container
          .read(appPreferencesControllerProvider.notifier)
          .setTheme(AppThemePreference.dark);
      final state = container.read(appPreferencesControllerProvider);
      expect(state.value?.theme, AppThemePreference.system);
      expect(state.isLoading, isFalse);
      expect(state.hasError, isTrue);
      expect(reporter.error, isA<StateError>());
    },
  );
  test(
    'Concurrent updates are ignored while saving and disposal is safe',
    () async {
      final repository = PendingRepository();
      final container = ProviderContainer(
        overrides: [
          appPreferencesUseCaseProvider.overrideWithValue(
            AppPreferencesUseCase(repository),
          ),
          errorReporterProvider.overrideWithValue(RecordingReporter()),
        ],
      );
      await container.read(appPreferencesControllerProvider.future);
      final controller = container.read(
        appPreferencesControllerProvider.notifier,
      );
      final pending = controller.setTheme(AppThemePreference.dark);
      expect(
        container.read(appPreferencesControllerProvider).isLoading,
        isTrue,
      );
      await controller.setTheme(AppThemePreference.light);
      expect(repository.saves, 1);
      container.dispose();
      repository.completion.complete();
      await expectLater(pending, completes);
    },
  );
}
