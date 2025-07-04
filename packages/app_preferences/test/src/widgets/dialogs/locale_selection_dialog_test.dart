import 'package:app_preferences/src/providers/app_preferences_provider.dart';
import 'package:app_preferences/src/repositories/app_preferences_repository.dart';
import 'package:app_preferences/src/widgets/dialogs/locale_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LocaleOption', () {
    test('creates with required properties', () {
      const option = LocaleOption(
        languageCode: 'en',
        displayName: 'English',
      );

      expect(option.languageCode, 'en');
      expect(option.displayName, 'English');
    });
  });

  group('LocaleSelectionDialog', () {
    late List<LocaleOption> testLocales;
    late AppPreferencesRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final mockPrefs = await SharedPreferences.getInstance();
      repository = AppPreferencesRepository(prefs: mockPrefs);

      testLocales = const [
        LocaleOption(languageCode: 'en', displayName: 'English'),
        LocaleOption(languageCode: 'ja', displayName: '日本語'),
        LocaleOption(languageCode: 'es', displayName: 'Español'),
      ];
    });

    Future<Widget> createTestWidget({
      Future<void> Function(String)? onLocaleChanged,
      Widget? icon,
    }) async {
      final mockPrefs = await SharedPreferences.getInstance();
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          appPreferencesRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  await showDialog<void>(
                    context: context,
                    builder: (context) => LocaleSelectionDialog(
                      title: 'Select Language',
                      availableLocales: testLocales,
                      cancelLabel: 'Cancel',
                      onLocaleChanged: onLocaleChanged,
                      icon: icon,
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('displays title and cancel button', (tester) async {
      await tester.pumpWidget(await createTestWidget());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Select Language'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('displays all available locale options', (tester) async {
      await tester.pumpWidget(await createTestWidget());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('English'), findsOneWidget);
      expect(find.text('日本語'), findsOneWidget);
      expect(find.text('Español'), findsOneWidget);
    });

    testWidgets('displays icon when provided', (tester) async {
      const icon = Icon(Icons.language, key: Key('test_icon'));
      await tester.pumpWidget(await createTestWidget(icon: icon));
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('test_icon')), findsOneWidget);
    });

    testWidgets('updates locale when option is selected', (tester) async {
      await tester.pumpWidget(await createTestWidget());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap on Spanish option (this automatically closes dialog)
      await tester.tap(find.text('Español'));
      await tester.pumpAndSettle();

      // Dialog should be closed now
      expect(find.text('Select Language'), findsNothing);

      // Verify locale was updated
      final storedLocale = await repository.getLocale();
      expect(storedLocale?.languageCode, 'es');
    });

    testWidgets('calls onLocaleChanged callback when provided', (tester) async {
      String? changedLanguageCode;

      await tester.pumpWidget(
        await createTestWidget(
          onLocaleChanged: (languageCode) async {
            changedLanguageCode = languageCode;
          },
        ),
      );
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap on Japanese option (this automatically closes dialog)
      await tester.tap(find.text('日本語'));
      await tester.pumpAndSettle();

      // Dialog should be closed now
      expect(find.text('Select Language'), findsNothing);

      // Verify callback was called
      expect(changedLanguageCode, 'ja');
    });

    testWidgets('does not update locale when cancelled', (tester) async {
      // Set initial locale
      await repository.setLocale(const Locale('en'));

      await tester.pumpWidget(await createTestWidget());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap Cancel button
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Dialog should be closed
      expect(find.text('Select Language'), findsNothing);

      // Verify locale was not changed
      final storedLocale = await repository.getLocale();
      expect(storedLocale?.languageCode, 'en');
    });
  });
}
