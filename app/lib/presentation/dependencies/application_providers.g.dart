// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Presentation が利用する入力境界。具象値は composition root が注入する。

@ProviderFor(appPreferencesUseCase)
final appPreferencesUseCaseProvider = AppPreferencesUseCaseProvider._();

/// Presentation が利用する入力境界。具象値は composition root が注入する。

final class AppPreferencesUseCaseProvider
    extends
        $FunctionalProvider<
          AppPreferencesUseCase,
          AppPreferencesUseCase,
          AppPreferencesUseCase
        >
    with $Provider<AppPreferencesUseCase> {
  /// Presentation が利用する入力境界。具象値は composition root が注入する。
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
    r'328b60f14493bbadecd7912357f9f2e60c345aed';

/// 起動時に一度だけ取得した設定。必ず root scope へ注入する。

@ProviderFor(initialAppPreferencesSnapshot)
final initialAppPreferencesSnapshotProvider =
    InitialAppPreferencesSnapshotProvider._();

/// 起動時に一度だけ取得した設定。必ず root scope へ注入する。

final class InitialAppPreferencesSnapshotProvider
    extends
        $FunctionalProvider<
          AppPreferencesSnapshot,
          AppPreferencesSnapshot,
          AppPreferencesSnapshot
        >
    with $Provider<AppPreferencesSnapshot> {
  /// 起動時に一度だけ取得した設定。必ず root scope へ注入する。
  InitialAppPreferencesSnapshotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initialAppPreferencesSnapshotProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initialAppPreferencesSnapshotHash();

  @$internal
  @override
  $ProviderElement<AppPreferencesSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppPreferencesSnapshot create(Ref ref) {
    return initialAppPreferencesSnapshot(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppPreferencesSnapshot value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppPreferencesSnapshot>(value),
    );
  }
}

String _$initialAppPreferencesSnapshotHash() =>
    r'd583be4cc40f66e6e73772888c4db4e3ad6d27a7';
