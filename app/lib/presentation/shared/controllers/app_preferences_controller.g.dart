// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppPreferencesController)
final appPreferencesControllerProvider = AppPreferencesControllerProvider._();

final class AppPreferencesControllerProvider
    extends $AsyncNotifierProvider<AppPreferencesController, AppPreferences> {
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
}

String _$appPreferencesControllerHash() =>
    r'3600fce5c1199c819fae923d9f5414371a70df78';

abstract class _$AppPreferencesController
    extends $AsyncNotifier<AppPreferences> {
  FutureOr<AppPreferences> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppPreferences>, AppPreferences>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppPreferences>, AppPreferences>,
              AsyncValue<AppPreferences>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
