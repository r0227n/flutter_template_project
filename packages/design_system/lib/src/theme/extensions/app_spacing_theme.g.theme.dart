// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'app_spacing_theme.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$AppSpacingTheme on ThemeExtension<AppSpacingTheme> {
  @override
  ThemeExtension<AppSpacingTheme> copyWith({
    double? xs,
    double? s,
    double? m,
    double? l,
    double? xl,
  }) {
    final _this = (this as AppSpacingTheme);

    return AppSpacingTheme(
      xs: xs ?? _this.xs,
      s: s ?? _this.s,
      m: m ?? _this.m,
      l: l ?? _this.l,
      xl: xl ?? _this.xl,
    );
  }

  @override
  ThemeExtension<AppSpacingTheme> lerp(
    ThemeExtension<AppSpacingTheme>? other,
    double t,
  ) {
    if (other is! AppSpacingTheme) {
      return this;
    }

    final _this = (this as AppSpacingTheme);

    return AppSpacingTheme(
      xs: lerpDouble$(_this.xs, other.xs, t)!,
      s: lerpDouble$(_this.s, other.s, t)!,
      m: lerpDouble$(_this.m, other.m, t)!,
      l: lerpDouble$(_this.l, other.l, t)!,
      xl: lerpDouble$(_this.xl, other.xl, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as AppSpacingTheme);
    final _other = (other as AppSpacingTheme);

    return _other.xs == _this.xs &&
        _other.s == _this.s &&
        _other.m == _this.m &&
        _other.l == _this.l &&
        _other.xl == _this.xl;
  }

  @override
  int get hashCode {
    final _this = (this as AppSpacingTheme);

    return Object.hash(
      runtimeType,
      _this.xs,
      _this.s,
      _this.m,
      _this.l,
      _this.xl,
    );
  }
}

extension AppSpacingThemeBuildContext on BuildContext {
  AppSpacingTheme get appSpacing =>
      Theme.of(this).extension<AppSpacingTheme>()!;
}
