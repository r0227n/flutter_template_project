///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'core_translations.g.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';

// Path: <root>
class CoreTranslationsEn implements CoreTranslations {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [CoreLocale.build] is preferred.
  CoreTranslationsEn({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<CoreLocale, CoreTranslations>? meta,
  }) : assert(
         overrides == null,
         'Set "translation_overrides: true" in order to enable this feature.',
       ),
       $meta =
           meta ??
           TranslationMetadata(
             locale: CoreLocale.en,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           );

  /// Metadata for the translations of <en>.
  @override
  final TranslationMetadata<CoreLocale, CoreTranslations> $meta;

  late final CoreTranslationsEn _root = this; // ignore: unused_field

  @override
  CoreTranslationsEn $copyWith({
    TranslationMetadata<CoreLocale, CoreTranslations>? meta,
  }) => CoreTranslationsEn(meta: meta ?? this.$meta);

  // Translations
  @override
  late final _CoreTranslationsLocaleEn locale = _CoreTranslationsLocaleEn._(
    _root,
  );
  @override
  late final _CoreTranslationsThemeEn theme = _CoreTranslationsThemeEn._(_root);
  @override
  late final _CoreTranslationsDialogEn dialog = _CoreTranslationsDialogEn._(
    _root,
  );
}

// Path: locale
class _CoreTranslationsLocaleEn implements CoreTranslationsLocaleJa {
  _CoreTranslationsLocaleEn._(this._root);

  final CoreTranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'System';
  @override
  String get language => 'English';
}

// Path: theme
class _CoreTranslationsThemeEn implements CoreTranslationsThemeJa {
  _CoreTranslationsThemeEn._(this._root);

  final CoreTranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'System';
  @override
  String get light => 'Light';
  @override
  String get dark => 'Dark';
}

// Path: dialog
class _CoreTranslationsDialogEn implements CoreTranslationsDialogJa {
  _CoreTranslationsDialogEn._(this._root);

  final CoreTranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get cancel => 'Cancel';
}
