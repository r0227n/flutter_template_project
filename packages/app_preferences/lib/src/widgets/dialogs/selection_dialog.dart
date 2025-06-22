// Generic types with function parameters trigger unsafe_variance warnings
// but this is the intended design for a reusable selection dialog component
// ignore_for_file: unsafe_variance

import 'package:flutter/foundation.dart';
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
    required this.title,
    required this.options,
    required this.currentValue,
    required this.onChanged,
    required this.cancelLabel,
    this.valueSelector,
    this.icon,
    super.key,
  });

  /// The title of the dialog
  final String title;

  /// List of selectable options
  final List<SelectionOption<T>> options;

  /// Currently selected value
  final T? currentValue;

  /// Callback when a value is selected
  final Future<void> Function(T value) onChanged;

  /// Label for the cancel button
  final String cancelLabel;

  /// Optional value selector function for complex objects
  /// If null, uses the value directly for comparison
  final Object? Function(T value)? valueSelector;

  /// Optional icon to display in the dialog title
  final Widget? icon;

  /// Builds the selection dialog UI
  ///
  /// Creates an AlertDialog with:
  /// - Optional icon in the title
  /// - Radio button list for options
  /// - Cancel button to dismiss without selection
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: icon,
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: options
            .map(
              (option) => _SelectionOptionTile<T>(
                option: option,
                currentValue: currentValue,
                onChanged: onChanged,
                valueSelector: valueSelector,
              ),
            )
            .toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(cancelLabel),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(IterableProperty<SelectionOption<T>>('options', options));
    properties.add(DiagnosticsProperty<T?>('currentValue', currentValue));
    properties.add(StringProperty('cancelLabel', cancelLabel));
    properties.add(
      ObjectFlagProperty<Future<void> Function(T value)?>.has(
        'onChanged',
        onChanged,
      ),
    );
    properties.add(
      ObjectFlagProperty<Object? Function(T value)?>.has(
        'valueSelector',
        valueSelector,
      ),
    );
    properties.add(
      DiagnosticsProperty<Widget?>('icon', icon),
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

/// A radio list tile for selection options
///
/// Internal widget that renders a single option as a radio button.
/// Handles the selection logic and automatically dismisses the dialog
/// when an option is selected.
class _SelectionOptionTile<T> extends StatelessWidget {
  const _SelectionOptionTile({
    required this.option,
    required this.currentValue,
    required this.onChanged,
    this.valueSelector,
  });

  /// The selection option to display
  final SelectionOption<T> option;

  /// The currently selected value
  final T? currentValue;

  /// Callback when this option is selected
  final Future<void> Function(T value) onChanged;

  /// Optional value selector for complex object comparison
  final Object? Function(T value)? valueSelector;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SelectionOption<T>>('option', option));
    properties.add(DiagnosticsProperty<T?>('currentValue', currentValue));
    properties.add(
      ObjectFlagProperty<Future<void> Function(T value)?>.has(
        'onChanged',
        onChanged,
      ),
    );
    properties.add(
      ObjectFlagProperty<Object? Function(T value)?>.has(
        'valueSelector',
        valueSelector,
      ),
    );
  }

  /// Builds the radio list tile
  ///
  /// Uses [valueSelector] if provided to compare values, otherwise
  /// compares the values directly. Automatically closes the dialog
  /// when selected.
  @override
  Widget build(BuildContext context) {
    // Use valueSelector if provided, otherwise use the value directly
    final optionValue = valueSelector?.call(option.value) ?? option.value;
    final selectedValue = currentValue != null && valueSelector != null
        ? valueSelector!(currentValue as T)
        : currentValue;

    return RadioListTile<Object?>(
      title: Text(option.displayText),
      value: optionValue,
      groupValue: selectedValue,
      onChanged: (value) async {
        if (value != null) {
          await onChanged(option.value);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
    );
  }
}
