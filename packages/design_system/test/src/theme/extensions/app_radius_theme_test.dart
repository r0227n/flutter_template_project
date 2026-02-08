import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppRadiusTheme', () {
    test('default values match AppRadius constants', () {
      const theme = AppRadiusTheme();

      expect(theme.xs, AppRadius.xs);
      expect(theme.s, AppRadius.s);
    });

    group('copyWith', () {
      test('returns new instance with overridden values', () {
        const theme = AppRadiusTheme();
        final copied = theme.copyWith(s: 16) as AppRadiusTheme;

        expect(copied.xs, AppRadius.xs);
        expect(copied.s, 16);
      });

      test('returns equivalent instance with no arguments', () {
        const theme = AppRadiusTheme();
        final copied = theme.copyWith() as AppRadiusTheme;

        expect(copied.xs, theme.xs);
        expect(copied.s, theme.s);
      });
    });

    group('lerp', () {
      test('at t=0 returns original values', () {
        const a = AppRadiusTheme();
        const b = AppRadiusTheme(xs: 8, s: 16);

        final result = a.lerp(b, 0) as AppRadiusTheme;

        expect(result.xs, a.xs);
        expect(result.s, a.s);
      });

      test('at t=1 returns other values', () {
        const a = AppRadiusTheme();
        const b = AppRadiusTheme(xs: 8, s: 16);

        final result = a.lerp(b, 1) as AppRadiusTheme;

        expect(result.xs, b.xs);
        expect(result.s, b.s);
      });

      test('at t=0.5 returns midpoint values', () {
        const a = AppRadiusTheme(xs: 0, s: 0);
        const b = AppRadiusTheme(xs: 10, s: 20);

        final result = a.lerp(b, 0.5) as AppRadiusTheme;

        expect(result.xs, 5);
        expect(result.s, 10);
      });

      test('with null returns this', () {
        const theme = AppRadiusTheme();

        final result = theme.lerp(null, 0.5) as AppRadiusTheme;

        expect(result.xs, theme.xs);
        expect(result.s, theme.s);
      });
    });
  });
}
