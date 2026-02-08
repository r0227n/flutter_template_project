/// Database package for DuckDB integration with Todo and Category models.
///
/// This package provides:
/// - DuckDB database service for local data persistence
/// - Todo model and repository for task management
/// - Category model and repository for task categorization
library database;

// Service
export 'src/service/database_service.dart';

// Todo
export 'src/todo/models/todo.dart';
export 'src/todo/models/todo_filter.dart';
export 'src/todo/repositories/todo_repository.dart';
export 'src/todo/repositories/todo_repository_impl.dart';

// Category
export 'src/category/models/category.dart';
export 'src/category/constants/color_constants.dart';
export 'src/category/repositories/category_repository.dart';
export 'src/category/repositories/category_repository_impl.dart';

// Schema
export 'src/schema/default_data.dart';
