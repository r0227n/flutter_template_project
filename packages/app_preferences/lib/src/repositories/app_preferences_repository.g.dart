// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appPreferencesRepositoryHash() =>
    r'70f9f013d024973fe76a29fb3fa41a355aed5281';

/// Provides the app preferences repository instance
///
/// This provider creates and configures an [AppPreferencesRepository] instance
/// with the SharedPreferences dependency injected from
/// [sharedPreferencesProvider].
///
/// Returns:
/// A configured [AppPreferencesRepository] instance
///
/// Copied from [appPreferencesRepository].
@ProviderFor(appPreferencesRepository)
final appPreferencesRepositoryProvider =
    AutoDisposeProvider<AppPreferencesRepository>.internal(
      appPreferencesRepository,
      name: r'appPreferencesRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$appPreferencesRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppPreferencesRepositoryRef =
    AutoDisposeProviderRef<AppPreferencesRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
