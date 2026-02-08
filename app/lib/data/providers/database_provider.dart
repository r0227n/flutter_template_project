import 'package:database/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

/// Provides a singleton instance of [DatabaseService].
///
/// The database is opened at the application documents directory with
/// the filename 'todos.duckdb'. The connection is automatically closed
/// when the provider is disposed.
@Riverpod(keepAlive: true)
Future<DatabaseService> databaseService(Ref ref) async {
  final service = DatabaseService();

  // Get application documents directory for database file
  final directory = await getApplicationDocumentsDirectory();
  final dbPath = '${directory.path}/todos.duckdb';

  await service.open(dbPath);

  // Close database when provider is disposed
  ref.onDispose(() async {
    await service.close();
  });

  return service;
}
