import 'package:dart_duckdb/dart_duckdb.dart';

import '../schema/default_data.dart';

/// DuckDB database service for initialization and management.
///
/// This class handles:
/// - Database file opening and connection management
/// - Table initialization for todos and categories
/// - Default category data insertion
/// - Query and statement execution
class DatabaseService {
  Database? _database;
  Connection? _connection;

  /// Returns true if the database is currently open.
  bool get isOpen => _database != null && _connection != null;

  /// Opens the database at the specified path.
  ///
  /// Creates necessary tables if they don't exist and inserts default
  /// categories if the categories table is empty.
  Future<void> open(String path) async {
    _database = await duckdb.open(path);
    _connection = await duckdb.connect(_database!);
    await _initializeTables();
  }

  /// Initializes the database tables.
  Future<void> _initializeTables() async {
    // Create categories table
    await _connection!.execute('''
      CREATE TABLE IF NOT EXISTS categories (
        id VARCHAR PRIMARY KEY,
        name VARCHAR NOT NULL,
        color BIGINT NOT NULL
      )
    ''');

    // Create todos table with foreign key reference
    await _connection!.execute('''
      CREATE TABLE IF NOT EXISTS todos (
        id VARCHAR PRIMARY KEY,
        title VARCHAR NOT NULL,
        description VARCHAR,
        is_completed BOOLEAN NOT NULL DEFAULT FALSE,
        category_id VARCHAR,
        created_at TIMESTAMP NOT NULL,
        completed_at TIMESTAMP
      )
    ''');

    // Insert default categories if empty
    await _insertDefaultCategories();
  }

  /// Inserts default categories if the table is empty.
  Future<void> _insertDefaultCategories() async {
    final result = await _connection!.query(
      'SELECT COUNT(*) as count FROM categories',
    );
    final rows = result.fetchAll();
    final count = rows.first.first as int;

    if (count == 0) {
      for (final category in defaultCategories) {
        await _connection!.execute('''
          INSERT INTO categories (id, name, color) VALUES
          ('${category.id}', '${category.name}', ${category.color})
        ''');
      }
    }
    await result.dispose();
  }

  /// Executes a SQL query and returns the results as a list of maps.
  Future<List<Map<String, dynamic>>> query(String sql) async {
    final result = await _connection!.query(sql);
    final columnNames = result.columnNames;
    final rows = result.fetchAll();

    final mapped = rows.map((row) {
      final map = <String, dynamic>{};
      for (var i = 0; i < columnNames.length; i++) {
        map[columnNames[i]] = row[i];
      }
      return map;
    }).toList();

    await result.dispose();
    return mapped;
  }

  /// Executes a SQL statement (INSERT, UPDATE, DELETE).
  Future<void> execute(String sql) async {
    await _connection!.execute(sql);
  }

  /// Closes the database connection.
  Future<void> close() async {
    await _connection?.dispose();
    await _database?.dispose();
    _connection = null;
    _database = null;
  }
}
