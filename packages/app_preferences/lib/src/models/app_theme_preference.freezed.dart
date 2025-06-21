// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_theme_preference.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppThemePreference {

 AppThemeMode get mode;
/// Create a copy of AppThemePreference
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppThemePreferenceCopyWith<AppThemePreference> get copyWith => _$AppThemePreferenceCopyWithImpl<AppThemePreference>(this as AppThemePreference, _$identity);

  /// Serializes this AppThemePreference to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppThemePreference&&(identical(other.mode, mode) || other.mode == mode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode);

@override
String toString() {
  return 'AppThemePreference(mode: $mode)';
}


}

/// @nodoc
abstract mixin class $AppThemePreferenceCopyWith<$Res>  {
  factory $AppThemePreferenceCopyWith(AppThemePreference value, $Res Function(AppThemePreference) _then) = _$AppThemePreferenceCopyWithImpl;
@useResult
$Res call({
 AppThemeMode mode
});




}
/// @nodoc
class _$AppThemePreferenceCopyWithImpl<$Res>
    implements $AppThemePreferenceCopyWith<$Res> {
  _$AppThemePreferenceCopyWithImpl(this._self, this._then);

  final AppThemePreference _self;
  final $Res Function(AppThemePreference) _then;

/// Create a copy of AppThemePreference
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AppThemeMode,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _AppThemePreference extends AppThemePreference {
  const _AppThemePreference({required this.mode}): super._();
  factory _AppThemePreference.fromJson(Map<String, dynamic> json) => _$AppThemePreferenceFromJson(json);

@override final  AppThemeMode mode;

/// Create a copy of AppThemePreference
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppThemePreferenceCopyWith<_AppThemePreference> get copyWith => __$AppThemePreferenceCopyWithImpl<_AppThemePreference>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppThemePreferenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppThemePreference&&(identical(other.mode, mode) || other.mode == mode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode);

@override
String toString() {
  return 'AppThemePreference(mode: $mode)';
}


}

/// @nodoc
abstract mixin class _$AppThemePreferenceCopyWith<$Res> implements $AppThemePreferenceCopyWith<$Res> {
  factory _$AppThemePreferenceCopyWith(_AppThemePreference value, $Res Function(_AppThemePreference) _then) = __$AppThemePreferenceCopyWithImpl;
@override @useResult
$Res call({
 AppThemeMode mode
});




}
/// @nodoc
class __$AppThemePreferenceCopyWithImpl<$Res>
    implements _$AppThemePreferenceCopyWith<$Res> {
  __$AppThemePreferenceCopyWithImpl(this._self, this._then);

  final _AppThemePreference _self;
  final $Res Function(_AppThemePreference) _then;

/// Create a copy of AppThemePreference
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,}) {
  return _then(_AppThemePreference(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AppThemeMode,
  ));
}


}

// dart format on
