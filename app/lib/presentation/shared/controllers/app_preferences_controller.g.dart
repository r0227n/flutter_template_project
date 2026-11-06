// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 設定変更を操作順に保存し、成功した値だけを画面へ公開する。

@ProviderFor(AppPreferencesController)
final appPreferencesControllerProvider = AppPreferencesControllerProvider._();

/// 設定変更を操作順に保存し、成功した値だけを画面へ公開する。
final class AppPreferencesControllerProvider
    extends $NotifierProvider<AppPreferencesController, AppPreferences> {
  /// 設定変更を操作順に保存し、成功した値だけを画面へ公開する。
  AppPreferencesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appPreferencesControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appPreferencesControllerHash();

  @$internal
  @override
  AppPreferencesController create() => AppPreferencesController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppPreferences>(value),
    );
  }
}

String _$appPreferencesControllerHash() =>
    r'678741168af9ad5b03089c03fa6ebeb703de0d5a';

/// 設定変更を操作順に保存し、成功した値だけを画面へ公開する。

abstract class _$AppPreferencesController extends $Notifier<AppPreferences> {
  AppPreferences build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppPreferences, AppPreferences>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppPreferences, AppPreferences>,
              AppPreferences,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
