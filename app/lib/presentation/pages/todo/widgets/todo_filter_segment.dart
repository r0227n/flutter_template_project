import 'package:app/core/constants/ui_constants.dart';
import 'package:database/database.dart';
import 'package:flutter/material.dart';

/// A segmented button for filtering todos by completion status.
///
/// Displays three options: All, Active (uncompleted), and Completed.
class TodoFilterSegment extends StatelessWidget {
  /// Creates a [TodoFilterSegment].
  const TodoFilterSegment({
    required this.selected,
    required this.onSelectionChanged,
    super.key,
  });

  /// The currently selected filter.
  final TodoFilter selected;

  /// Callback when the selection changes.
  final ValueChanged<TodoFilter> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TodoUIConstants.filterSegmentHeight,
      child: SegmentedButton<TodoFilter>(
        segments: const [
          ButtonSegment(
            value: TodoFilter.all,
            label: Text('すべて'),
          ),
          ButtonSegment(
            value: TodoFilter.active,
            label: Text('未完了'),
          ),
          ButtonSegment(
            value: TodoFilter.completed,
            label: Text('完了'),
          ),
        ],
        selected: {selected},
        onSelectionChanged: (selection) {
          onSelectionChanged(selection.first);
        },
      ),
    );
  }
}
