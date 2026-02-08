import '../models/todo.dart';

/// Interface for Todo data access operations.
///
/// Implementations of this interface handle CRUD operations
/// for todos in the database.
abstract class TodoRepository {
  /// Retrieves all todos ordered by creation date (newest first).
  Future<List<Todo>> getAll();

  /// Retrieves a todo by its unique [id].
  ///
  /// Returns null if no todo with the given ID exists.
  Future<Todo?> getById(String id);

  /// Retrieves todos filtered by completion status.
  ///
  /// - [isCompleted]: Filter by completion status (null for all)
  Future<List<Todo>> getFiltered({
    bool? isCompleted,
  });

  /// Creates a new todo in the database.
  Future<void> create(Todo todo);

  /// Updates an existing todo.
  Future<void> update(Todo todo);

  /// Deletes a todo by its [id].
  Future<void> delete(String id);

  /// Toggles the completion status of a todo.
  ///
  /// If the todo is currently incomplete, it will be marked as complete
  /// with the current timestamp. If it's already complete, it will be
  /// marked as incomplete.
  Future<void> toggleCompletion(String id);
}
