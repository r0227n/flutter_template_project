// Generic types with function parameters trigger unsafe_variance warnings
// but this is the intended design for a reusable selection dialog component
// ignore_for_file: unsafe_variance

import 'package:flutter/material.dart';

/// A generic selection dialog component
///
/// This is a reusable AlertDialog that displays a list of selectable options
/// with radio buttons and handles the selection logic.
///
/// This dialog supports generic types to handle different data types while
/// maintaining type safety. The dialog automatically closes when an option
/// is selected and calls the provided callback.
///
/// Example usage:
/// ```dart
/// await showDialog<void>(
///   context: context,
///   builder: (context) => SelectionDialog<Locale>(
///     title: 'Select Language',
///     options: [
///       SelectionOption(value: Locale('en'), displayText: 'English'),
///       SelectionOption(value: Locale('ja'), displayText: '日本語'),
///     ],
///     currentValue: currentLocale,
///     onChanged: (locale) async {
///       await updateLocale(locale);
///     },
///     cancelLabel: 'Cancel',
///   ),
/// );
/// ```
class SelectionDialog<T> extends StatelessWidget {
  const SelectionDialog({
    required String title,
    required List<SelectionOption<T>> options,
    required T? currentValue,
    required Future<void> Function(T value) onChanged,
    required String cancelLabel,
    T? Function(T value)? valueSelector,
    Widget? icon,
    super.key,
  }) : _title = title,
       _options = options,
       _currentValue = currentValue,
       _onChanged = onChanged,
       _cancelLabel = cancelLabel,
       _valueSelector = valueSelector,
       _icon = icon;

  /// The title of the dialog
  final String _title;

  /// List of selectable options
  final List<SelectionOption<T>> _options;

  /// Currently selected value
  final T? _currentValue;

  /// Callback when a value is selected
  final Future<void> Function(T value) _onChanged;

  /// Label for the cancel button
  final String _cancelLabel;

  /// Optional value selector function for complex objects
  /// If null, uses the value directly for comparison
  final T? Function(T value)? _valueSelector;

  /// Optional icon to display in the dialog _title
  final Widget? _icon;

  /// Gets the currently selected value using _valueSelector if provided
  T? _getSelectedValue() {
    if (_currentValue == null) {
      return null;
    }
    if (_valueSelector != null) {
      return _valueSelector(_currentValue as T);
    }
    return _currentValue;
  }

  /// Handles selection from RadioGroup
  Future<void> _handleSelection(T? value, BuildContext context) async {
    if (value == null) {
      return;
    }

    // Find the option that matches the selected value
    for (final option in _options) {
      final optionValue = _valueSelector?.call(option.value) ?? option.value;
      if (optionValue == value) {
        await _onChanged(option.value);
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        return;
      }
    }
  }

  /// Builds the selection dialog UI
  ///
  /// Creates an AlertDialog with:
  /// - Optional _icon in the _title
  /// - Radio button list for _options
  /// - Cancel button to dismiss without selection
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: _icon,
      title: Text(_title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioGroup<T?>(
            groupValue: _getSelectedValue(),
            onChanged: (value) => _handleSelection(value, context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _options.map(
                (option) {
                  final optionValue =
                      _valueSelector?.call(option.value) ?? option.value;
                  return ListTile(
                    leading: Radio<T?>(
                      value: optionValue,
                    ),
                    title: Text(option.displayText),
                    onTap: () async {
                      await _onChanged(option.value);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(_cancelLabel),
        ),
      ],
    );
  }
}

/// Configuration for a selection option
///
/// Represents a single selectable item in a [SelectionDialog].
/// Contains both the actual value and the display text shown to the user.
class SelectionOption<T> {
  const SelectionOption({
    required this.value,
    required this.displayText,
  });

  /// The value associated with this option
  final T value;

  /// The text to display for this option
  final String displayText;
}
