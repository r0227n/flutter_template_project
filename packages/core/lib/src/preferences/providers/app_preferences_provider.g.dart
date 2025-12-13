// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(sharedPreferences)
const sharedPreferencesProvider = SharedPreferencesProvider._();

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

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
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
  const SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'91d3d8d16af3d747cec711b8a095a63e20df9b7c';

/// Manages locale preferences and state
///
/// This provider handles the application's locale settings, including:
/// - Loading stored locale preferences from SharedPreferences
/// - Setting new locale preferences
/// - Providing default locale fallback
/// - Invalidating state when preferences change
///
/// The default locale is Japanese ('ja') to match the main application default.

@ProviderFor(AppLocaleProvider)
const appLocaleProviderProvider = AppLocaleProviderProvider._();

/// Manages locale preferences and state
///
/// This provider handles the application's locale settings, including:
/// - Loading stored locale preferences from SharedPreferences
/// - Setting new locale preferences
/// - Providing default locale fallback
/// - Invalidating state when preferences change
///
/// The default locale is Japanese ('ja') to match the main application default.
final class AppLocaleProviderProvider
    extends $NotifierProvider<AppLocaleProvider, Locale> {
  /// Manages locale preferences and state
  ///
  /// This provider handles the application's locale settings, including:
  /// - Loading stored locale preferences from SharedPreferences
  /// - Setting new locale preferences
  /// - Providing default locale fallback
  /// - Invalidating state when preferences change
  ///
  /// The default locale is Japanese ('ja') to match the main application default.
  const AppLocaleProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLocaleProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLocaleProviderHash();

  @$internal
  @override
  AppLocaleProvider create() => AppLocaleProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$appLocaleProviderHash() => r'57cb3a40e4c3dab11a60c693c8081868eb368830';

/// Manages locale preferences and state
///
/// This provider handles the application's locale settings, including:
/// - Loading stored locale preferences from SharedPreferences
/// - Setting new locale preferences
/// - Providing default locale fallback
/// - Invalidating state when preferences change
///
/// The default locale is Japanese ('ja') to match the main application default.

abstract class _$AppLocaleProvider extends $Notifier<Locale> {
  Locale build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Locale, Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale, Locale>,
              Locale,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Manages theme mode preferences and state
///
/// This provider handles the application's theme settings, including:
/// - Loading stored theme mode preferences from SharedPreferences
/// - Setting new theme mode preferences (system, light, dark)
/// - Providing default theme mode fallback
/// - Invalidating state when preferences change
///
/// The default theme mode is system to respect user's device preferences.

@ProviderFor(AppThemeProvider)
const appThemeProviderProvider = AppThemeProviderProvider._();

/// Manages theme mode preferences and state
///
/// This provider handles the application's theme settings, including:
/// - Loading stored theme mode preferences from SharedPreferences
/// - Setting new theme mode preferences (system, light, dark)
/// - Providing default theme mode fallback
/// - Invalidating state when preferences change
///
/// The default theme mode is system to respect user's device preferences.
final class AppThemeProviderProvider
    extends $AsyncNotifierProvider<AppThemeProvider, ThemeMode> {
  /// Manages theme mode preferences and state
  ///
  /// This provider handles the application's theme settings, including:
  /// - Loading stored theme mode preferences from SharedPreferences
  /// - Setting new theme mode preferences (system, light, dark)
  /// - Providing default theme mode fallback
  /// - Invalidating state when preferences change
  ///
  /// The default theme mode is system to respect user's device preferences.
  const AppThemeProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemeProviderHash();

  @$internal
  @override
  AppThemeProvider create() => AppThemeProvider();
}

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

abstract class _$AppThemeProvider extends $AsyncNotifier<ThemeMode> {
  FutureOr<ThemeMode> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<ThemeMode>, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ThemeMode>, ThemeMode>,
              AsyncValue<ThemeMode>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
