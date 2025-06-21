// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'87f7c0811db991852c74d72376df550977c6d6db';

/// See also [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = FutureProvider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = FutureProviderRef<SharedPreferences>;
String _$appPreferencesRepositoryHash() =>
    r'1b15a67c8ac06124c744e70d186fb8885cdcda13';

/// See also [appPreferencesRepository].
@ProviderFor(appPreferencesRepository)
final appPreferencesRepositoryProvider =
    Provider<AppPreferencesRepository>.internal(
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
typedef AppPreferencesRepositoryRef = ProviderRef<AppPreferencesRepository>;
String _$appLocaleHash() => r'66a4634e9467a722a2afc9bda3319ae1d410a5ec';

/// See also [AppLocale].
@ProviderFor(AppLocale)
final appLocaleProvider =
    AutoDisposeNotifierProvider<AppLocale, Locale?>.internal(
      AppLocale.new,
      name: r'appLocaleProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$appLocaleHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AppLocale = AutoDisposeNotifier<Locale?>;
String _$appThemeHash() => r'91dd531fa2085086d27faba06401a9ffea424b58';

/// See also [AppTheme].
@ProviderFor(AppTheme)
final appThemeProvider =
    AutoDisposeNotifierProvider<AppTheme, ThemeMode>.internal(
      AppTheme.new,
      name: r'appThemeProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$appThemeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AppTheme = AutoDisposeNotifier<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
