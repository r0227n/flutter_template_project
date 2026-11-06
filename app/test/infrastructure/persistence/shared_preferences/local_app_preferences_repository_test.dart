import 'package:app/application/application.dart';
import 'package:app/application/errors/settings_error.dart';
import 'package:app/infrastructure/infrastructure.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferencesStorePlatform originalStore;

  setUp(() {
    originalStore = SharedPreferencesStorePlatform.instance;
    SharedPreferences.resetStatic();
  });
  tearDown(() {
    SharedPreferencesStorePlatform.instance = originalStore;
    SharedPreferences.resetStatic();
  });

  test('defaults tolerate missing, unknown, and wrongly typed data', () async {
    for (final data in [
      <String, Object>{},
      {'app.theme': 'invalid', 'app.language': 'fr'},
      {'app.theme': 42, 'app.language': true},
    ]) {
      SharedPreferences.setMockInitialValues(data);
      final repository = LocalAppPreferencesRepository(
        await SharedPreferences.getInstance(),
      );
      expect(repository.load().theme, AppThemePreference.system);
      expect(repository.load().locale, isNull);
    }
  });

  test(
    'uses existing keys and restores values from a fresh instance',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final repository = LocalAppPreferencesRepository(preferences);

      await repository.saveTheme(AppThemePreference.dark);
      await repository.saveLocale(const LocalePreference(languageCode: 'en'));
      expect(preferences.getString('app.theme'), 'dark');
      expect(preferences.getString('app.language'), 'en');
      SharedPreferences.resetStatic();
      final reopened = LocalAppPreferencesRepository(
        await SharedPreferences.getInstance(),
      );
      expect(reopened.load().theme, AppThemePreference.dark);
      expect(reopened.load().locale?.languageCode, 'en');
    },
  );

  for (final throwsPlatformException in [false, true]) {
    for (final savesLocale in [false, true]) {
      test(
        'failed write restores cache: throw=$throwsPlatformException, '
        'locale=$savesLocale',
        () async {
          final store = _FailingStore(
            throwsPlatformException: throwsPlatformException,
          );
          SharedPreferencesStorePlatform.instance = store;
          final repository = LocalAppPreferencesRepository(
            await SharedPreferences.getInstance(),
          );
          await expectLater(
            savesLocale
                ? repository.saveLocale(
                    const LocalePreference(languageCode: 'ja'),
                  )
                : repository.saveTheme(AppThemePreference.light),
            throwsA(isA<SettingsWriteException>()),
          );
          expect(repository.load().theme, AppThemePreference.dark);
          expect(repository.load().locale?.languageCode, 'en');

          store.fails = false;
          await repository.saveTheme(AppThemePreference.light);
          expect(repository.load().theme, AppThemePreference.light);
          expect(repository.load().locale?.languageCode, 'en');
        },
      );
    }
  }
}

class _FailingStore extends InMemorySharedPreferencesStore {
  _FailingStore({required this.throwsPlatformException})
    : super.withData({
        'flutter.app.theme': 'dark',
        'flutter.app.language': 'en',
      });

  final bool throwsPlatformException;
  bool fails = true;

  @override
  Future<bool> setValue(String valueType, String key, Object value) {
    if (!fails) return super.setValue(valueType, key, value);
    if (throwsPlatformException) {
      throw PlatformException(code: 'write-failed');
    }
    return Future.value(false);
  }
}
