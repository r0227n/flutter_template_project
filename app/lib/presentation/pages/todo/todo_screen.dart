import 'dart:async';

import 'package:app/core/constants/ui_constants.dart';
import 'package:app/core/constants/validation_constants.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/data/providers/todo_provider.dart';
import 'package:app/presentation/notifiers/todo_filter_notifier.dart';
import 'package:app/presentation/pages/todo/widgets/todo_filter_segment.dart';
import 'package:app/presentation/providers/filtered_todos_provider.dart';
import 'package:core/core.dart' hide LocaleSettings;
import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

/// Single-screen Todo application.
///
/// Features:
/// - Inline todo input at bottom
/// - Filter by completion status
/// - Tap to edit via dialog
/// - Swipe to delete
/// - AppBar menu for settings (language, theme, license)
class TodoScreen extends ConsumerStatefulWidget {
  /// Creates a [TodoScreen].
  const TodoScreen({super.key});

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  final _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _addTodo() async {
    final title = _inputController.text.trim();
    if (title.isEmpty) return;

    final todo = Todo(
      id: const Uuid().v4(),
      title: title,
      createdAt: DateTime.now(),
    );

    await (await ref.read(todoRepositoryProvider.future)).create(todo);
    ref.invalidate(filteredTodosProvider);
    _inputController.clear();
  }

  Future<void> _toggleCompletion(String id) async {
    await (await ref.read(todoRepositoryProvider.future)).toggleCompletion(id);
    ref.invalidate(filteredTodosProvider);
  }

  Future<void> _deleteTodo(String id) async {
    await (await ref.read(todoRepositoryProvider.future)).delete(id);
    ref.invalidate(filteredTodosProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('削除しました')),
      );
    }
  }

  Future<void> _showEditDialog(Todo todo) async {
    final titleController = TextEditingController(text: todo.title);
    final descriptionController = TextEditingController(
      text: todo.description ?? '',
    );
    var isCompleted = todo.isCompleted;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('タスクを編集'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'タイトル',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: ValidationConstants.todoTitleMaxLength,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: '説明（任意）',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  maxLength: ValidationConstants.todoDescriptionMaxLength,
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  title: const Text('完了'),
                  value: isCompleted,
                  onChanged: (value) {
                    setDialogState(() => isCompleted = value);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );

    if (result ?? false) {
      final title = titleController.text.trim();
      if (title.isEmpty) return;

      final description = descriptionController.text.trim();
      final updatedTodo = todo.copyWith(
        title: title,
        description: description.isEmpty ? null : description,
        isCompleted: isCompleted,
        completedAt: isCompleted && !todo.isCompleted
            ? DateTime.now()
            : (isCompleted ? todo.completedAt : null),
      );

      await (await ref.read(todoRepositoryProvider.future)).update(updatedTodo);
      ref.invalidate(filteredTodosProvider);
    }

    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(todoFilterProvider);
    final todosAsync = ref.watch(filteredTodosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'language':
                  unawaited(
                    PreferencesDialogHelpers.showLocaleSelectionDialog(
                      context: context,
                      title: t.settings.language,
                      onLocaleChanged: (languageCode) async {
                        final appLocale = AppLocale.values.firstWhere(
                          (locale) => locale.languageCode == languageCode,
                          orElse: () => AppLocale.ja,
                        );
                        unawaited(LocaleSettings.setLocale(appLocale));
                      },
                    ),
                  );
                case 'theme':
                  unawaited(
                    PreferencesDialogHelpers.showThemeSelectionDialog(
                      context: context,
                      title: t.settings.theme,
                    ),
                  );
                case 'license':
                  showLicensePage(
                    context: context,
                    applicationName: 'Todo App',
                  );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'language',
                child: ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(t.settings.language),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'theme',
                child: ListTile(
                  leading: Theme.of(context).brightness == Brightness.dark
                      ? const Icon(Icons.dark_mode)
                      : const Icon(Icons.light_mode),
                  title: Text(t.settings.theme),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'license',
                child: ListTile(
                  leading: const Icon(Icons.description),
                  title: Text(t.settings.licenses),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: TodoUIConstants.listPadding,
            child: TodoFilterSegment(
              selected: filter,
              onSelectionChanged: (newFilter) {
                ref.read(todoFilterProvider.notifier).setFilter(newFilter);
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: todosAsync.when(
              data: (todos) {
                if (todos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'タスクがありません',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(filteredTodosProvider);
                  },
                  child: ListView.builder(
                    padding: TodoUIConstants.listPadding,
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return _TodoListTile(
                        todo: todo,
                        onTap: () => _showEditDialog(todo),
                        onToggle: () => _toggleCompletion(todo.id),
                        onDismissed: () => _deleteTodo(todo.id),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'データの読み込みに失敗しました',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => ref.invalidate(filteredTodosProvider),
                      icon: const Icon(Icons.refresh),
                      label: const Text('再試行'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          _TodoInputBar(
            controller: _inputController,
            onSubmit: _addTodo,
          ),
        ],
      ),
    );
  }
}

class _TodoListTile extends StatelessWidget {
  const _TodoListTile({
    required this.todo,
    required this.onTap,
    required this.onToggle,
    required this.onDismissed,
  });

  final Todo todo;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy/MM/dd');

    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: theme.colorScheme.error,
        child: Icon(
          Icons.delete,
          color: theme.colorScheme.onError,
        ),
      ),
      confirmDismiss: (direction) async {
        return showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('タスクを削除'),
            content: const Text('このタスクを削除しますか？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('キャンセル'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('削除'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => onDismissed(),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          todo.title,
          style: todo.isCompleted
              ? TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: theme.colorScheme.outline,
                )
              : null,
        ),
        subtitle: todo.description != null
            ? Text(
                todo.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Text(
          dateFormat.format(todo.createdAt),
          style: theme.textTheme.bodySmall,
        ),
        onTap: onTap,
      ),
    );
  }
}

class _TodoInputBar extends StatelessWidget {
  const _TodoInputBar({
    required this.controller,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'タスクを追加...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                maxLength: ValidationConstants.todoTitleMaxLength,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onSubmit(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: onSubmit,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
