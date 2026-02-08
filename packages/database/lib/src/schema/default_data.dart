/// Default category data for initial database population.
///
/// These categories are inserted when the database is first created.
class DefaultCategory {
  /// Creates a default category.
  const DefaultCategory({
    required this.id,
    required this.name,
    required this.color,
  });

  /// Unique identifier for the category.
  final String id;

  /// Display name of the category.
  final String name;

  /// Color value as an integer.
  final int color;
}

/// Default categories to insert on first database creation.
const List<DefaultCategory> defaultCategories = [
  DefaultCategory(
    id: 'default-work',
    name: '仕事',
    color: 0xFF2196F3, // Blue
  ),
  DefaultCategory(
    id: 'default-personal',
    name: 'プライベート',
    color: 0xFF4CAF50, // Green
  ),
  DefaultCategory(
    id: 'default-shopping',
    name: '買い物',
    color: 0xFFFF9800, // Orange
  ),
];
