// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtered_todos_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides a filtered list of todos based on the current filter.
///
/// Uses [todoFilterProvider] to fetch the appropriate subset of todos
/// from the database.

@ProviderFor(filteredTodos)
final filteredTodosProvider = FilteredTodosProvider._();

/// Provides a filtered list of todos based on the current filter.
///
/// Uses [todoFilterProvider] to fetch the appropriate subset of todos
/// from the database.

final class FilteredTodosProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Todo>>,
          List<Todo>,
          FutureOr<List<Todo>>
        >
    with $FutureModifier<List<Todo>>, $FutureProvider<List<Todo>> {
  /// Provides a filtered list of todos based on the current filter.
  ///
  /// Uses [todoFilterProvider] to fetch the appropriate subset of todos
  /// from the database.
  FilteredTodosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredTodosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredTodosHash();

  @$internal
  @override
  $FutureProviderElement<List<Todo>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Todo>> create(Ref ref) {
    return filteredTodos(ref);
  }
}

String _$filteredTodosHash() => r'481be0b08e1fcb6f49e6d1f89ad9022cdd52f78b';
