import 'package:app/application/application.dart';
import 'package:app/application/errors/settings_error.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';

void main() {
  test(
    'loads the persisted snapshot and updates independent settings',
    () async {
      final repository = FakeAppPreferencesRepository();
      final useCase = AppPreferencesUseCase(repository);

      await useCase.saveTheme(AppThemePreference.dark);
      await useCase.saveLocale(const LocalePreference(languageCode: 'en'));

      expect(useCase.load().theme, AppThemePreference.dark);
      expect(useCase.load().locale?.languageCode, 'en');
    },
  );

  test('rejects unsupported locales before writing', () {
    final repository = FakeAppPreferencesRepository();
    final useCase = AppPreferencesUseCase(repository);

    expect(
      () => useCase.saveLocale(const LocalePreference(languageCode: 'invalid')),
      throwsArgumentError,
    );
    expect(repository.operations, isEmpty);
  });

  test('returns storage failures unchanged', () async {
    const failure = SettingsWriteException();
    final repository = FakeAppPreferencesRepository()
      ..beforeSave = () async => throw failure;

    await expectLater(
      AppPreferencesUseCase(repository).saveTheme(AppThemePreference.light),
      throwsA(same(failure)),
    );
    expect(repository.snapshot.theme, AppThemePreference.system);
  });
}
