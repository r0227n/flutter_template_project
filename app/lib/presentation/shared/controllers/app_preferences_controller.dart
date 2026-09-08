import 'package:app/application/application.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_preferences_controller.g.dart';

@Riverpod(keepAlive: true)
class AppPreferencesController extends _$AppPreferencesController {
  @override
  Future<AppPreferences> build() async =>
      ref.watch(appPreferencesUseCaseProvider).load();

  Future<void> setTheme(AppThemePreference theme) =>
      _save(() => ref.read(appPreferencesUseCaseProvider).saveTheme(theme));

  Future<void> setLanguage(String code) =>
      _save(() => ref.read(appPreferencesUseCaseProvider).saveLanguage(code));

  Future<void> _save(Future<void> Function() operation) async {
    if (state.isLoading) return;

    final reporter = ref.read(errorReporterProvider);
    final useCase = ref.read(appPreferencesUseCaseProvider);
    state = const AsyncLoading<AppPreferences>();
    final result = await AsyncValue.guard(() async {
      await operation();
      return useCase.load();
    });
    if (!ref.mounted) return;

    state = result;
    if (result case AsyncError(:final error, :final stackTrace)) {
      reporter.report(
        error,
        stackTrace,
        message: 'Saving app preferences failed',
      );
    }
  }
}
