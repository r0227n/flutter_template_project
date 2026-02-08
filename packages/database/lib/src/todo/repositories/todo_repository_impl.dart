import 'package:database/src/service/database_service.dart';
import 'package:database/src/todo/models/todo.dart';
import 'package:database/src/todo/repositories/todo_repository.dart';

/// DuckDB implementation of [TodoRepository].
class TodoRepositoryImpl implements TodoRepository {
  /// Creates a todo repository implementation.
  TodoRepositoryImpl(this._db);

  final DatabaseService _db;

  @override
  Future<List<Todo>> getAll() async {
    final results = await _db.query('''
      SELECT * FROM todos ORDER BY created_at DESC
    ''');
    return results.map(_mapRowToTodo).toList();
  }

  @override
  Future<Todo?> getById(String id) async {
    final escapedId = _escape(id);
    final results = await _db.query('''
      SELECT * FROM todos WHERE id = '$escapedId'
    ''');
    if (results.isEmpty) return null;
    return _mapRowToTodo(results.first);
  }

  @override
  Future<List<Todo>> getFiltered({
    bool? isCompleted,
  }) async {
    final conditions = <String>[];

    if (isCompleted != null) {
      conditions.add('is_completed = ${isCompleted ? 'TRUE' : 'FALSE'}');
    }

    final whereClause = conditions.isEmpty
        ? ''
        : 'WHERE ${conditions.join(' AND ')}';

    final results = await _db.query('''
      SELECT * FROM todos $whereClause ORDER BY created_at DESC
    ''');
    return results.map(_mapRowToTodo).toList();
  }

  @override
  Future<void> create(Todo todo) async {
    final escapedTitle = _escape(todo.title);
    final escapedDescription = todo.description != null
        ? "'${_escape(todo.description!)}'"
        : 'NULL';
    final escapedCategoryId = todo.categoryId != null
        ? "'${_escape(todo.categoryId!)}'"
        : 'NULL';
    final completedAtValue = todo.completedAt != null
        ? "'${todo.completedAt!.toIso8601String()}'"
        : 'NULL';

    await _db.execute('''
      INSERT INTO todos (id, title, description, is_completed, category_id, created_at, completed_at)
      VALUES (
        '${_escape(todo.id)}',
        '$escapedTitle',
        $escapedDescription,
        ${todo.isCompleted ? 'TRUE' : 'FALSE'},
        $escapedCategoryId,
        '${todo.createdAt.toIso8601String()}',
        $completedAtValue
      )
    ''');
  }

  @override
  Future<void> update(Todo todo) async {
    final escapedTitle = _escape(todo.title);
    final escapedDescription = todo.description != null
        ? "'${_escape(todo.description!)}'"
        : 'NULL';
    final escapedCategoryId = todo.categoryId != null
        ? "'${_escape(todo.categoryId!)}'"
        : 'NULL';
    final completedAtValue = todo.completedAt != null
        ? "'${todo.completedAt!.toIso8601String()}'"
        : 'NULL';

    await _db.execute('''
      UPDATE todos SET
        title = '$escapedTitle',
        description = $escapedDescription,
        is_completed = ${todo.isCompleted ? 'TRUE' : 'FALSE'},
        category_id = $escapedCategoryId,
        completed_at = $completedAtValue
      WHERE id = '${_escape(todo.id)}'
    ''');
  }

  @override
  Future<void> delete(String id) async {
    final escapedId = _escape(id);
    await _db.execute("DELETE FROM todos WHERE id = '$escapedId'");
  }

  @override
  Future<void> toggleCompletion(String id) async {
    final todo = await getById(id);
    if (todo == null) return;

    final newIsCompleted = !todo.isCompleted;
    final completedAt = newIsCompleted ? DateTime.now() : null;
    final completedAtValue = completedAt != null
        ? "'${completedAt.toIso8601String()}'"
        : 'NULL';

    await _db.execute('''
      UPDATE todos SET
        is_completed = ${newIsCompleted ? 'TRUE' : 'FALSE'},
        completed_at = $completedAtValue
      WHERE id = '${_escape(id)}'
    ''');
  }

  Todo _mapRowToTodo(Map<String, dynamic> row) {
    return Todo(
      id: row['id'] as String,
      title: row['title'] as String,
      description: row['description'] as String?,
      isCompleted: row['is_completed'] as bool,
      categoryId: row['category_id'] as String?,
      createdAt: DateTime.parse(row['created_at'].toString()),
      completedAt: row['completed_at'] != null
          ? DateTime.parse(row['completed_at'].toString())
          : null,
    );
  }

  String _escape(String value) {
    return value.replaceAll("'", "''");
  }
}
