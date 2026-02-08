import 'package:app/data/providers/database_provider.dart';
import 'package:database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_provider.g.dart';

/// Provides an instance of [TodoRepository].
///
/// The repository is created with the database service
/// from [databaseServiceProvider].
@riverpod
Future<TodoRepository> todoRepository(Ref ref) async {
  final db = await ref.watch(databaseServiceProvider.future);
  return TodoRepositoryImpl(db);
}

/// Provides a list of all todos.
///
/// The list is automatically updated when todos are modified.
@riverpod
Future<List<Todo>> todoList(Ref ref) async {
  final repository = await ref.watch(todoRepositoryProvider.future);
  return repository.getAll();
}

/// Provides a single todo by its [id].
///
/// Returns null if the todo doesn't exist.
@riverpod
Future<Todo?> todoDetail(Ref ref, String id) async {
  final repository = await ref.watch(todoRepositoryProvider.future);
  return repository.getById(id);
}
