// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'app_radius_theme.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$AppRadiusTheme on ThemeExtension<AppRadiusTheme> {
  @override
  ThemeExtension<AppRadiusTheme> copyWith({double? xs, double? s}) {
    final _this = (this as AppRadiusTheme);

    return AppRadiusTheme(xs: xs ?? _this.xs, s: s ?? _this.s);
  }

  @override
  ThemeExtension<AppRadiusTheme> lerp(
    ThemeExtension<AppRadiusTheme>? other,
    double t,
  ) {
    if (other is! AppRadiusTheme) {
      return this;
    }

    final _this = (this as AppRadiusTheme);

    return AppRadiusTheme(
      xs: lerpDouble$(_this.xs, other.xs, t)!,
      s: lerpDouble$(_this.s, other.s, t)!,
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

    final _this = (this as AppRadiusTheme);
    final _other = (other as AppRadiusTheme);

    return _other.xs == _this.xs && _other.s == _this.s;
  }

  @override
  int get hashCode {
    final _this = (this as AppRadiusTheme);

    return Object.hash(runtimeType, _this.xs, _this.s);
  }
}

extension AppRadiusThemeBuildContext on BuildContext {
  AppRadiusTheme get appRadius => Theme.of(this).extension<AppRadiusTheme>()!;
}
