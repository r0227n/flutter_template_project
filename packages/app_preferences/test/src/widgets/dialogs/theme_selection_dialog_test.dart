import 'package:app_preferences/src/providers/app_preferences_provider.dart';
import 'package:app_preferences/src/repositories/app_preferences_repository.dart';
import 'package:app_preferences/src/widgets/dialogs/theme_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ThemeSelectionDialog', () {
    late AppPreferencesRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final mockPrefs = await SharedPreferences.getInstance();
      repository = AppPreferencesRepository(prefs: mockPrefs);
    });

    Future<Widget> createTestWidget({Widget? icon}) async {
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
                    builder: (context) => ThemeSelectionDialog(
                      title: 'Select Theme',
                      systemLabel: 'System',
                      lightLabel: 'Light',
                      darkLabel: 'Dark',
                      cancelLabel: 'Cancel',
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

      expect(find.text('Select Theme'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('displays all theme mode options', (tester) async {
      await tester.pumpWidget(await createTestWidget());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('System'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
    });

    testWidgets('displays icon when provided', (tester) async {
      const icon = Icon(Icons.palette, key: Key('test_icon'));
      await tester.pumpWidget(await createTestWidget(icon: icon));
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('test_icon')), findsOneWidget);
    });

    testWidgets('updates theme when system option is selected', (tester) async {
      // Set initial theme to light
      await repository.setTheme(ThemeMode.light);

      await tester.pumpWidget(await createTestWidget());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap on System option (this automatically closes dialog)
      await tester.tap(find.text('System'));
      await tester.pumpAndSettle();

      // Dialog should be closed now
      expect(find.text('Select Theme'), findsNothing);

      // Verify theme was updated
      final storedTheme = await repository.getTheme();
      expect(storedTheme, ThemeMode.system);
    });

    testWidgets('updates theme when light option is selected', (tester) async {
      await tester.pumpWidget(await createTestWidget());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap on Light option (this automatically closes dialog)
      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();

      // Dialog should be closed now
      expect(find.text('Select Theme'), findsNothing);

      // Verify theme was updated
      final storedTheme = await repository.getTheme();
      expect(storedTheme, ThemeMode.light);
    });

    testWidgets('updates theme when dark option is selected', (tester) async {
      await tester.pumpWidget(await createTestWidget());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap on Dark option (this automatically closes dialog)
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      // Dialog should be closed now
      expect(find.text('Select Theme'), findsNothing);

      // Verify theme was updated
      final storedTheme = await repository.getTheme();
      expect(storedTheme, ThemeMode.dark);
    });

    testWidgets('does not update theme when cancelled', (tester) async {
      // Set initial theme
      await repository.setTheme(ThemeMode.light);

      await tester.pumpWidget(await createTestWidget());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap Cancel button
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Dialog should be closed
      expect(find.text('Select Theme'), findsNothing);

      // Verify theme was not changed
      final storedTheme = await repository.getTheme();
      expect(storedTheme, ThemeMode.light);
    });
  });
}
