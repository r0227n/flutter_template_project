import 'package:database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_filter_notifier.g.dart';

/// Manages the current todo filter state.
///
/// The filter determines which todos are displayed in the list:
/// - [TodoFilter.all]: Show all todos
/// - [TodoFilter.active]: Show only uncompleted todos
/// - [TodoFilter.completed]: Show only completed todos
@riverpod
class TodoFilterNotifier extends _$TodoFilterNotifier {
  @override
  TodoFilter build() => TodoFilter.all;

  /// Updates the current filter.
  void setFilter(TodoFilter filter) {
    state = filter;
  }
}
