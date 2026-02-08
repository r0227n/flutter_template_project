import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

/// A category for grouping and organizing todos.
///
/// Each category has a name and a color for visual identification.
@freezed
sealed class Category with _$Category {
  const Category._();

  const factory Category({
    /// Unique identifier for the category.
    required String id,

    /// Display name of the category (1-30 characters).
    required String name,

    /// Color value as an integer (e.g., 0xFF2196F3).
    required int color,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  /// Returns the color as a Flutter [Color] object.
  Color get colorValue => Color(color);
}
