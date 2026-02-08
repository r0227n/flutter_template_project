import '../models/category.dart';

/// Interface for Category data access operations.
///
/// Implementations of this interface handle CRUD operations
/// for categories in the database.
abstract class CategoryRepository {
  /// Retrieves all categories ordered by name.
  Future<List<Category>> getAll();

  /// Retrieves a category by its unique [id].
  ///
  /// Returns null if no category with the given ID exists.
  Future<Category?> getById(String id);

  /// Creates a new category in the database.
  Future<void> create(Category category);

  /// Updates an existing category.
  Future<void> update(Category category);

  /// Deletes a category by its [id].
  ///
  /// Also updates any todos with this category to have no category.
  Future<void> delete(String id);

  /// Finds a category by its [name] (case-insensitive).
  ///
  /// Used for duplicate name checking. Returns null if not found.
  Future<Category?> findByName(String name);
}
