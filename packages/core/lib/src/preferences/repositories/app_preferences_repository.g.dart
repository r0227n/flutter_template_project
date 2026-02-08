// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app preferences repository instance
///
/// This provider creates and configures an [AppPreferencesRepository] instance
/// with the SharedPreferences dependency injected from
/// [sharedPreferencesProvider].
///
/// Returns:
/// A configured [AppPreferencesRepository] instance

@ProviderFor(appPreferencesRepository)
final appPreferencesRepositoryProvider = AppPreferencesRepositoryProvider._();

/// Provides the app preferences repository instance
///
/// This provider creates and configures an [AppPreferencesRepository] instance
/// with the SharedPreferences dependency injected from
/// [sharedPreferencesProvider].
///
/// Returns:
/// A configured [AppPreferencesRepository] instance

final class AppPreferencesRepositoryProvider
    extends
        $FunctionalProvider<
          AppPreferencesRepository,
          AppPreferencesRepository,
          AppPreferencesRepository
        >
    with $Provider<AppPreferencesRepository> {
  /// Provides the app preferences repository instance
  ///
  /// This provider creates and configures an [AppPreferencesRepository] instance
  /// with the SharedPreferences dependency injected from
  /// [sharedPreferencesProvider].
  ///
  /// Returns:
  /// A configured [AppPreferencesRepository] instance
  AppPreferencesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appPreferencesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appPreferencesRepositoryHash();

  @$internal
  @override
  $ProviderElement<AppPreferencesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppPreferencesRepository create(Ref ref) {
    return appPreferencesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppPreferencesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppPreferencesRepository>(value),
    );
  }
}

String _$appPreferencesRepositoryHash() =>
    r'70f9f013d024973fe76a29fb3fa41a355aed5281';
