// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_locale_preference.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppLocalePreference {

 String get languageCode; String? get countryCode;
/// Create a copy of AppLocalePreference
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppLocalePreferenceCopyWith<AppLocalePreference> get copyWith => _$AppLocalePreferenceCopyWithImpl<AppLocalePreference>(this as AppLocalePreference, _$identity);

  /// Serializes this AppLocalePreference to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppLocalePreference&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,languageCode,countryCode);

@override
String toString() {
  return 'AppLocalePreference(languageCode: $languageCode, countryCode: $countryCode)';
}


}

/// @nodoc
abstract mixin class $AppLocalePreferenceCopyWith<$Res>  {
  factory $AppLocalePreferenceCopyWith(AppLocalePreference value, $Res Function(AppLocalePreference) _then) = _$AppLocalePreferenceCopyWithImpl;
@useResult
$Res call({
 String languageCode, String? countryCode
});




}
/// @nodoc
class _$AppLocalePreferenceCopyWithImpl<$Res>
    implements $AppLocalePreferenceCopyWith<$Res> {
  _$AppLocalePreferenceCopyWithImpl(this._self, this._then);

  final AppLocalePreference _self;
  final $Res Function(AppLocalePreference) _then;

/// Create a copy of AppLocalePreference
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? languageCode = null,Object? countryCode = freezed,}) {
  return _then(_self.copyWith(
languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _AppLocalePreference extends AppLocalePreference {
  const _AppLocalePreference({required this.languageCode, this.countryCode}): super._();
  factory _AppLocalePreference.fromJson(Map<String, dynamic> json) => _$AppLocalePreferenceFromJson(json);

@override final  String languageCode;
@override final  String? countryCode;

/// Create a copy of AppLocalePreference
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppLocalePreferenceCopyWith<_AppLocalePreference> get copyWith => __$AppLocalePreferenceCopyWithImpl<_AppLocalePreference>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppLocalePreferenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppLocalePreference&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,languageCode,countryCode);

@override
String toString() {
  return 'AppLocalePreference(languageCode: $languageCode, countryCode: $countryCode)';
}


}

/// @nodoc
abstract mixin class _$AppLocalePreferenceCopyWith<$Res> implements $AppLocalePreferenceCopyWith<$Res> {
  factory _$AppLocalePreferenceCopyWith(_AppLocalePreference value, $Res Function(_AppLocalePreference) _then) = __$AppLocalePreferenceCopyWithImpl;
@override @useResult
$Res call({
 String languageCode, String? countryCode
});




}
/// @nodoc
class __$AppLocalePreferenceCopyWithImpl<$Res>
    implements _$AppLocalePreferenceCopyWith<$Res> {
  __$AppLocalePreferenceCopyWithImpl(this._self, this._then);

  final _AppLocalePreference _self;
  final $Res Function(_AppLocalePreference) _then;

/// Create a copy of AppLocalePreference
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? languageCode = null,Object? countryCode = freezed,}) {
  return _then(_AppLocalePreference(
languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
