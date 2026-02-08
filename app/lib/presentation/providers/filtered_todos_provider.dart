import 'package:app/data/providers/todo_provider.dart';
import 'package:app/presentation/notifiers/todo_filter_notifier.dart';
import 'package:database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_todos_provider.g.dart';

/// Provides a filtered list of todos based on the current filter.
///
/// Uses [todoFilterProvider] to fetch the appropriate subset of todos
/// from the database.
@riverpod
Future<List<Todo>> filteredTodos(Ref ref) async {
  final repository = await ref.watch(todoRepositoryProvider.future);
  final filter = ref.watch(todoFilterProvider);

  bool? isCompleted;
  switch (filter) {
    case TodoFilter.active:
      isCompleted = false;
    case TodoFilter.completed:
      isCompleted = true;
    case TodoFilter.all:
      isCompleted = null;
  }

  return repository.getFiltered(
    isCompleted: isCompleted,
  );
}
