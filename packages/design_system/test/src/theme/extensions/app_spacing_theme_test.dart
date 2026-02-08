import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSpacingTheme', () {
    test('default values match AppSpacing constants', () {
      const theme = AppSpacingTheme();

      expect(theme.xs, AppSpacing.xs);
      expect(theme.s, AppSpacing.s);
      expect(theme.m, AppSpacing.m);
      expect(theme.l, AppSpacing.l);
      expect(theme.xl, AppSpacing.xl);
    });

    group('copyWith', () {
      test('returns new instance with overridden values', () {
        const theme = AppSpacingTheme();
        final copied = theme.copyWith(m: 20, xl: 40) as AppSpacingTheme;

        expect(copied.xs, AppSpacing.xs);
        expect(copied.s, AppSpacing.s);
        expect(copied.m, 20);
        expect(copied.l, AppSpacing.l);
        expect(copied.xl, 40);
      });

      test('returns equivalent instance with no arguments', () {
        const theme = AppSpacingTheme();
        final copied = theme.copyWith() as AppSpacingTheme;

        expect(copied.xs, theme.xs);
        expect(copied.s, theme.s);
        expect(copied.m, theme.m);
        expect(copied.l, theme.l);
        expect(copied.xl, theme.xl);
      });
    });

    group('lerp', () {
      test('at t=0 returns original values', () {
        const a = AppSpacingTheme();
        const b = AppSpacingTheme(xs: 8, s: 16, m: 32, l: 48, xl: 64);

        final result = a.lerp(b, 0) as AppSpacingTheme;

        expect(result.xs, a.xs);
        expect(result.s, a.s);
        expect(result.m, a.m);
        expect(result.l, a.l);
        expect(result.xl, a.xl);
      });

      test('at t=1 returns other values', () {
        const a = AppSpacingTheme();
        const b = AppSpacingTheme(xs: 8, s: 16, m: 32, l: 48, xl: 64);

        final result = a.lerp(b, 1) as AppSpacingTheme;

        expect(result.xs, b.xs);
        expect(result.s, b.s);
        expect(result.m, b.m);
        expect(result.l, b.l);
        expect(result.xl, b.xl);
      });

      test('at t=0.5 returns midpoint values', () {
        const a = AppSpacingTheme(xs: 0, s: 0, m: 0, l: 0, xl: 0);
        const b = AppSpacingTheme(xs: 10, s: 20, m: 30, l: 40, xl: 50);

        final result = a.lerp(b, 0.5) as AppSpacingTheme;

        expect(result.xs, 5);
        expect(result.s, 10);
        expect(result.m, 15);
        expect(result.l, 20);
        expect(result.xl, 25);
      });

      test('with null returns this', () {
        const theme = AppSpacingTheme();

        final result = theme.lerp(null, 0.5) as AppSpacingTheme;

        expect(result.xs, theme.xs);
        expect(result.s, theme.s);
        expect(result.m, theme.m);
        expect(result.l, theme.l);
        expect(result.xl, theme.xl);
      });
    });
  });
}
