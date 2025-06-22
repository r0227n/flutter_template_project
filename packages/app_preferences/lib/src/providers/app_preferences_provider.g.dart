// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'91d3d8d16af3d747cec711b8a095a63e20df9b7c';

/// Provides access to SharedPreferences instance
///
/// This provider should be overridden in main.dart with the actual
/// SharedPreferences instance during app initialization.
///
/// Example usage:
/// ```dart
/// ProviderScope(
///   overrides: [
///     sharedPreferencesProvider.overrideWithValue(sharedPrefsInstance),
///   ],
///   child: MyApp(),
/// )
/// ```
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider =
    AutoDisposeProvider<SharedPreferences>.internal(
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
typedef SharedPreferencesRef = AutoDisposeProviderRef<SharedPreferences>;
String _$appLocaleProviderHash() => r'5ef599be9c03cf2a9e778332a7ca43103494063a';

/// Manages locale preferences and state
///
/// This provider handles the application's locale settings, including:
/// - Loading stored locale preferences from SharedPreferences
/// - Setting new locale preferences
/// - Providing default locale fallback
/// - Invalidating state when preferences change
///
/// The default locale is Japanese ('ja') to match the main application default.
///
/// Copied from [AppLocaleProvider].
@ProviderFor(AppLocaleProvider)
final appLocaleProviderProvider =
    AutoDisposeAsyncNotifierProvider<AppLocaleProvider, Locale>.internal(
      AppLocaleProvider.new,
      name: r'appLocaleProviderProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$appLocaleProviderHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AppLocaleProvider = AutoDisposeAsyncNotifier<Locale>;
String _$appThemeProviderHash() => r'04ad1f520a92387683cd75c890fb6f9f6dc36fef';

/// Manages theme mode preferences and state
///
/// This provider handles the application's theme settings, including:
/// - Loading stored theme mode preferences from SharedPreferences
/// - Setting new theme mode preferences (system, light, dark)
/// - Providing default theme mode fallback
/// - Invalidating state when preferences change
///
/// The default theme mode is system to respect user's device preferences.
///
/// Copied from [AppThemeProvider].
@ProviderFor(AppThemeProvider)
final appThemeProviderProvider =
    AutoDisposeAsyncNotifierProvider<AppThemeProvider, ThemeMode>.internal(
      AppThemeProvider.new,
      name: r'appThemeProviderProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$appThemeProviderHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AppThemeProvider = AutoDisposeAsyncNotifier<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
