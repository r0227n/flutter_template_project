///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'slang.g.dart';

// Path: <root>
class TranslationsEn
    with BaseTranslations<AppLocale, Translations>
    implements Translations {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsEn({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(
         overrides == null,
         'Set "translation_overrides: true" in order to enable this feature.',
       ),
       $meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.en,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ) {
    $meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <en>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  @override
  dynamic operator [](String key) => $meta.getTranslation(key);

  late final TranslationsEn _root = this; // ignore: unused_field

  @override
  TranslationsEn $copyWith({
    TranslationMetadata<AppLocale, Translations>? meta,
  }) => TranslationsEn(meta: meta ?? this.$meta);

  // Translations
  @override
  String get appName => 'Flutter Template';
  @override
  String get home => 'Home';
  @override
  String get welcome => 'Start building your app';
  @override
  String get settings => 'Settings';
  @override
  String get theme => 'Theme';
  @override
  String get system => 'System';
  @override
  String get light => 'Light';
  @override
  String get dark => 'Dark';
  @override
  String get language => 'Language';
  @override
  String get saveFailed => 'Could not save settings. Please try again.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEn {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'appName' => 'Flutter Template',
      'home' => 'Home',
      'welcome' => 'Start building your app',
      'settings' => 'Settings',
      'theme' => 'Theme',
      'system' => 'System',
      'light' => 'Light',
      'dark' => 'Dark',
      'language' => 'Language',
      'saveFailed' => 'Could not save settings. Please try again.',
      _ => null,
    };
  }
}
