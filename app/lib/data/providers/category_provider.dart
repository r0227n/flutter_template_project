import 'package:app/data/providers/database_provider.dart';
import 'package:database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_provider.g.dart';

/// Provides an instance of [CategoryRepository].
///
/// The repository is created with the database service
/// from [databaseServiceProvider].
@riverpod
CategoryRepository categoryRepository(Ref ref) {
  final db = ref.watch(databaseServiceProvider).requireValue;
  return CategoryRepositoryImpl(db);
}

/// Provides a list of all categories.
///
/// The list is automatically updated when categories are modified.
@riverpod
Future<List<Category>> categories(Ref ref) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getAll();
}

/// Provides a single category by its [id].
///
/// Returns null if the category doesn't exist.
@riverpod
Future<Category?> categoryDetail(Ref ref, String id) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getById(id);
}
