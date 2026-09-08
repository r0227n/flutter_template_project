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
    extends $NotifierProvider<AppPreferencesController, PreferencesState> {
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
  Override overrideWithValue(PreferencesState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PreferencesState>(value),
    );
  }
}

String _$appPreferencesControllerHash() =>
    r'4d0d7aff94a10aa3876c1bb5bd8d435b21cfbf69';

abstract class _$AppPreferencesController extends $Notifier<PreferencesState> {
  PreferencesState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PreferencesState, PreferencesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PreferencesState, PreferencesState>,
              PreferencesState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
