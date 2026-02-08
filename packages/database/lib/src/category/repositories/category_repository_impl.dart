import 'package:database/src/category/models/category.dart';
import 'package:database/src/category/repositories/category_repository.dart';
import 'package:database/src/service/database_service.dart';

/// DuckDB implementation of [CategoryRepository].
class CategoryRepositoryImpl implements CategoryRepository {
  /// Creates a category repository implementation.
  CategoryRepositoryImpl(this._db);

  final DatabaseService _db;

  @override
  Future<List<Category>> getAll() async {
    final results = await _db.query('''
      SELECT * FROM categories ORDER BY name ASC
    ''');
    return results.map(_mapRowToCategory).toList();
  }

  @override
  Future<Category?> getById(String id) async {
    final escapedId = _escape(id);
    final results = await _db.query('''
      SELECT * FROM categories WHERE id = '$escapedId'
    ''');
    if (results.isEmpty) return null;
    return _mapRowToCategory(results.first);
  }

  @override
  Future<void> create(Category category) async {
    final escapedName = _escape(category.name);
    await _db.execute('''
      INSERT INTO categories (id, name, color)
      VALUES (
        '${_escape(category.id)}',
        '$escapedName',
        ${category.color}
      )
    ''');
  }

  @override
  Future<void> update(Category category) async {
    final escapedName = _escape(category.name);
    await _db.execute('''
      UPDATE categories SET
        name = '$escapedName',
        color = ${category.color}
      WHERE id = '${_escape(category.id)}'
    ''');
  }

  @override
  Future<void> delete(String id) async {
    final escapedId = _escape(id);
    // Update todos to remove category reference
    await _db.execute('''
      UPDATE todos SET category_id = NULL WHERE category_id = '$escapedId'
    ''');
    // Delete the category
    await _db.execute("DELETE FROM categories WHERE id = '$escapedId'");
  }

  @override
  Future<Category?> findByName(String name) async {
    final escapedName = _escape(name);
    final results = await _db.query('''
      SELECT * FROM categories WHERE LOWER(name) = LOWER('$escapedName')
    ''');
    if (results.isEmpty) return null;
    return _mapRowToCategory(results.first);
  }

  Category _mapRowToCategory(Map<String, dynamic> row) {
    return Category(
      id: row['id'] as String,
      name: row['name'] as String,
      color: row['color'] as int,
    );
  }

  String _escape(String value) {
    return value.replaceAll("'", "''");
  }
}
