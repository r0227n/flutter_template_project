import 'package:app/core/gen/slang.g.dart' as app_translations;
import 'package:app/data/providers/todo_provider.dart';
import 'package:app/presentation/pages/todo/todo_screen.dart';
import 'package:core/core.dart';
import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// A fake [TodoRepository] for testing.
class FakeTodoRepository implements TodoRepository {
  final List<Todo> _todos = [];

  @override
  Future<List<Todo>> getAll() async => _todos;

  @override
  Future<Todo?> getById(String id) async =>
      _todos.where((t) => t.id == id).firstOrNull;

  @override
  Future<List<Todo>> getFiltered({bool? isCompleted}) async {
    if (isCompleted == null) return _todos;
    return _todos.where((t) => t.isCompleted == isCompleted).toList();
  }

  @override
  Future<void> create(Todo todo) async => _todos.add(todo);

  @override
  Future<void> update(Todo todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index >= 0) _todos[index] = todo;
  }

  @override
  Future<void> delete(String id) async =>
      _todos.removeWhere((t) => t.id == id);

  @override
  Future<void> toggleCompletion(String id) async {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index >= 0) {
      final todo = _todos[index];
      _todos[index] = todo.copyWith(
        isCompleted: !todo.isCompleted,
        completedAt: !todo.isCompleted ? DateTime.now() : null,
      );
    }
  }
}

void main() {
  setUpAll(() {
    if (!AppLogger.isInitialized) {
      AppLogger.initialize(LoggerConfig.development());
    }
  });

  group('TodoScreen', () {
    testWidgets('renders correctly with empty state', (tester) async {
      final fakeRepo = FakeTodoRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todoRepositoryProvider.overrideWith((_) async => fakeRepo),
          ],
          child: app_translations.TranslationProvider(
            child: const MaterialApp(home: TodoScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Todo'), findsOneWidget);
      expect(find.text('タスクがありません'), findsOneWidget);
    });

    testWidgets('displays filter segment', (tester) async {
      final fakeRepo = FakeTodoRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todoRepositoryProvider.overrideWith((_) async => fakeRepo),
          ],
          child: app_translations.TranslationProvider(
            child: const MaterialApp(home: TodoScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('すべて'), findsOneWidget);
      expect(find.text('未完了'), findsOneWidget);
      expect(find.text('完了'), findsOneWidget);
    });

    testWidgets('displays input bar', (tester) async {
      final fakeRepo = FakeTodoRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todoRepositoryProvider.overrideWith((_) async => fakeRepo),
          ],
          child: app_translations.TranslationProvider(
            child: const MaterialApp(home: TodoScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
