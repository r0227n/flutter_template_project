// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_filter_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the current todo filter state.
///
/// The filter determines which todos are displayed in the list:
/// - [TodoFilter.all]: Show all todos
/// - [TodoFilter.active]: Show only uncompleted todos
/// - [TodoFilter.completed]: Show only completed todos

@ProviderFor(TodoFilterNotifier)
final todoFilterProvider = TodoFilterNotifierProvider._();

/// Manages the current todo filter state.
///
/// The filter determines which todos are displayed in the list:
/// - [TodoFilter.all]: Show all todos
/// - [TodoFilter.active]: Show only uncompleted todos
/// - [TodoFilter.completed]: Show only completed todos
final class TodoFilterNotifierProvider
    extends $NotifierProvider<TodoFilterNotifier, TodoFilter> {
  /// Manages the current todo filter state.
  ///
  /// The filter determines which todos are displayed in the list:
  /// - [TodoFilter.all]: Show all todos
  /// - [TodoFilter.active]: Show only uncompleted todos
  /// - [TodoFilter.completed]: Show only completed todos
  TodoFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoFilterNotifierHash();

  @$internal
  @override
  TodoFilterNotifier create() => TodoFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoFilter>(value),
    );
  }
}

String _$todoFilterNotifierHash() =>
    r'35063fd0eb43b1c6990ca8e9f62a8c7ee655dedc';

/// Manages the current todo filter state.
///
/// The filter determines which todos are displayed in the list:
/// - [TodoFilter.all]: Show all todos
/// - [TodoFilter.active]: Show only uncompleted todos
/// - [TodoFilter.completed]: Show only completed todos

abstract class _$TodoFilterNotifier extends $Notifier<TodoFilter> {
  TodoFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TodoFilter, TodoFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TodoFilter, TodoFilter>,
              TodoFilter,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
