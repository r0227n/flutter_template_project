// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides an instance of [TodoRepository].
///
/// The repository is created with the database service
/// from [databaseServiceProvider].

@ProviderFor(todoRepository)
final todoRepositoryProvider = TodoRepositoryProvider._();

/// Provides an instance of [TodoRepository].
///
/// The repository is created with the database service
/// from [databaseServiceProvider].

final class TodoRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<TodoRepository>,
          TodoRepository,
          FutureOr<TodoRepository>
        >
    with $FutureModifier<TodoRepository>, $FutureProvider<TodoRepository> {
  /// Provides an instance of [TodoRepository].
  ///
  /// The repository is created with the database service
  /// from [databaseServiceProvider].
  TodoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<TodoRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TodoRepository> create(Ref ref) {
    return todoRepository(ref);
  }
}

String _$todoRepositoryHash() => r'c54b162df3df04df60dadbb0a0f1073577a1166b';

/// Provides a list of all todos.
///
/// The list is automatically updated when todos are modified.

@ProviderFor(todoList)
final todoListProvider = TodoListProvider._();

/// Provides a list of all todos.
///
/// The list is automatically updated when todos are modified.

final class TodoListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Todo>>,
          List<Todo>,
          FutureOr<List<Todo>>
        >
    with $FutureModifier<List<Todo>>, $FutureProvider<List<Todo>> {
  /// Provides a list of all todos.
  ///
  /// The list is automatically updated when todos are modified.
  TodoListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoListHash();

  @$internal
  @override
  $FutureProviderElement<List<Todo>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Todo>> create(Ref ref) {
    return todoList(ref);
  }
}

String _$todoListHash() => r'ba1cd14a56c653f64f1dd13957b6f1e3b9888555';

/// Provides a single todo by its [id].
///
/// Returns null if the todo doesn't exist.

@ProviderFor(todoDetail)
final todoDetailProvider = TodoDetailFamily._();

/// Provides a single todo by its [id].
///
/// Returns null if the todo doesn't exist.

final class TodoDetailProvider
    extends $FunctionalProvider<AsyncValue<Todo?>, Todo?, FutureOr<Todo?>>
    with $FutureModifier<Todo?>, $FutureProvider<Todo?> {
  /// Provides a single todo by its [id].
  ///
  /// Returns null if the todo doesn't exist.
  TodoDetailProvider._({
    required TodoDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'todoDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$todoDetailHash();

  @override
  String toString() {
    return r'todoDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Todo?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Todo?> create(Ref ref) {
    final argument = this.argument as String;
    return todoDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TodoDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$todoDetailHash() => r'9a8faeddd8a04def003fee40313d41238c2e5e23';

/// Provides a single todo by its [id].
///
/// Returns null if the todo doesn't exist.

final class TodoDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Todo?>, String> {
  TodoDetailFamily._()
    : super(
        retry: null,
        name: r'todoDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides a single todo by its [id].
  ///
  /// Returns null if the todo doesn't exist.

  TodoDetailProvider call(String id) =>
      TodoDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'todoDetailProvider';
}
