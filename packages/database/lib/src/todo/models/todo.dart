import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

/// A task/todo item with title, description, and completion status.
///
/// Todos can optionally be assigned to a category via [categoryId].
@freezed
sealed class Todo with _$Todo {
  const factory Todo({
    /// Unique identifier for the todo.
    required String id,

    /// Title of the todo (required, 1-100 characters).
    required String title,

    /// Optional detailed description (0-500 characters).
    String? description,

    /// Whether the todo is completed.
    @Default(false) bool isCompleted,

    /// Optional category ID for grouping todos.
    String? categoryId,

    /// Timestamp when the todo was created.
    required DateTime createdAt,

    /// Timestamp when the todo was marked as completed.
    DateTime? completedAt,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
