import 'package:app/application/application.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_preferences_controller.freezed.dart';
part 'app_preferences_controller.g.dart';

@freezed
abstract class PreferencesState with _$PreferencesState {
  const factory PreferencesState({
    required AppPreferences preferences,
    @Default(false) bool saving,
    @Default(false) bool saveFailed,
  }) = _PreferencesState;
}

@Riverpod(keepAlive: true)
class AppPreferencesController extends _$AppPreferencesController {
  @override
  PreferencesState build() => PreferencesState(
    preferences: ref.watch(appPreferencesUseCaseProvider).load(),
  );
  Future<void> setTheme(AppThemePreference theme) =>
      _save(() => ref.read(appPreferencesUseCaseProvider).saveTheme(theme));
  Future<void> setLanguage(String code) =>
      _save(() => ref.read(appPreferencesUseCaseProvider).saveLanguage(code));
  Future<void> _save(Future<void> Function() operation) async {
    if (state.saving) return;
    state = state.copyWith(saving: true, saveFailed: false);
    final reporter = ref.read(errorReporterProvider);
    final useCase = ref.read(appPreferencesUseCaseProvider);
    try {
      await operation();
      if (!ref.mounted) return;
      state = PreferencesState(preferences: useCase.load());
    } on Object catch (error, stack) {
      reporter.report(error, stack, message: 'Saving app preferences failed');
      if (ref.mounted) state = state.copyWith(saving: false, saveFailed: true);
    }
  }
}
