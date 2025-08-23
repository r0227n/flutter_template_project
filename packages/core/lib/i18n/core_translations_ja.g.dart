///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'core_translations.g.dart';

// Path: <root>
typedef CoreTranslationsJa = CoreTranslations; // ignore: unused_element

class CoreTranslations
    implements BaseTranslations<CoreLocale, CoreTranslations> {
  /// Returns the current translations of the given [context].
  ///
  /// Usage:
  /// final t = CoreTranslations.of(context);
  static CoreTranslations of(BuildContext context) =>
      InheritedLocaleData.of<CoreLocale, CoreTranslations>(
        context,
      ).translations;

  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [CoreLocale.build] is preferred.
  CoreTranslations({
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
             locale: CoreLocale.ja,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           );

  /// Metadata for the translations of <ja>.
  @override
  final TranslationMetadata<CoreLocale, CoreTranslations> $meta;

  late final CoreTranslations _root = this; // ignore: unused_field

  CoreTranslations $copyWith({
    TranslationMetadata<CoreLocale, CoreTranslations>? meta,
  }) => CoreTranslations(meta: meta ?? this.$meta);

  // Translations
  late final CoreTranslationsLocaleJa locale =
      CoreTranslationsLocaleJa.internal(_root);
  late final CoreTranslationsThemeJa theme = CoreTranslationsThemeJa.internal(
    _root,
  );
  late final CoreTranslationsDialogJa dialog =
      CoreTranslationsDialogJa.internal(_root);
}

// Path: locale
class CoreTranslationsLocaleJa {
  CoreTranslationsLocaleJa.internal(this._root);

  final CoreTranslations _root; // ignore: unused_field

  // Translations

  /// ja: 'システム'
  String get system => 'システム';

  /// ja: '日本語'
  String get language => '日本語';
}

// Path: theme
class CoreTranslationsThemeJa {
  CoreTranslationsThemeJa.internal(this._root);

  final CoreTranslations _root; // ignore: unused_field

  // Translations

  /// ja: 'システム'
  String get system => 'システム';

  /// ja: 'ライト'
  String get light => 'ライト';

  /// ja: 'ダーク'
  String get dark => 'ダーク';
}

// Path: dialog
class CoreTranslationsDialogJa {
  CoreTranslationsDialogJa.internal(this._root);

  final CoreTranslations _root; // ignore: unused_field

  // Translations

  /// ja: 'キャンセル'
  String get cancel => 'キャンセル';
}
