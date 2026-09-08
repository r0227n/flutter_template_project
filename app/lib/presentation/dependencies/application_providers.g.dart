// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appPreferencesUseCase)
final appPreferencesUseCaseProvider = AppPreferencesUseCaseProvider._();

final class AppPreferencesUseCaseProvider
    extends
        $FunctionalProvider<
          AppPreferencesUseCase,
          AppPreferencesUseCase,
          AppPreferencesUseCase
        >
    with $Provider<AppPreferencesUseCase> {
  AppPreferencesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appPreferencesUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appPreferencesUseCaseHash();

  @$internal
  @override
  $ProviderElement<AppPreferencesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppPreferencesUseCase create(Ref ref) {
    return appPreferencesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppPreferencesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppPreferencesUseCase>(value),
    );
  }
}

String _$appPreferencesUseCaseHash() =>
    r'a7be61bb90b05868c8cd7d608edb6eca6c242ea2';

@ProviderFor(errorReporter)
final errorReporterProvider = ErrorReporterProvider._();

final class ErrorReporterProvider
    extends $FunctionalProvider<ErrorReporter, ErrorReporter, ErrorReporter>
    with $Provider<ErrorReporter> {
  ErrorReporterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'errorReporterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$errorReporterHash();

  @$internal
  @override
  $ProviderElement<ErrorReporter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ErrorReporter create(Ref ref) {
    return errorReporter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ErrorReporter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ErrorReporter>(value),
    );
  }
}

String _$errorReporterHash() => r'5d48c67a74fc7f1b4036416abfa01af92e46faaa';
