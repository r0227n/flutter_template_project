///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsJa = Translations; // ignore: unused_element

class Translations implements BaseTranslations<AppLocale, Translations> {
  /// Returns the current translations of the given [context].
  ///
  /// Usage:
  /// final t = Translations.of(context);
  static Translations of(BuildContext context) =>
      InheritedLocaleData.of<AppLocale, Translations>(context).translations;

  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  Translations({
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
             locale: AppLocale.ja,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           );

  /// Metadata for the translations of <ja>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  late final Translations _root = this; // ignore: unused_field

  Translations $copyWith({
    TranslationMetadata<AppLocale, Translations>? meta,
  }) => Translations(meta: meta ?? this.$meta);

  // Translations
  late final TranslationsLocaleJa locale = TranslationsLocaleJa._(_root);
  late final TranslationsThemeJa theme = TranslationsThemeJa._(_root);
  late final TranslationsDialogJa dialog = TranslationsDialogJa._(_root);
}

// Path: locale
class TranslationsLocaleJa {
  TranslationsLocaleJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: 'システム'
  String get system => 'システム';

  /// ja: '日本語'
  String get japanese => '日本語';

  /// ja: 'English'
  String get english => 'English';
}

// Path: theme
class TranslationsThemeJa {
  TranslationsThemeJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: 'システム'
  String get system => 'システム';

  /// ja: 'ライト'
  String get light => 'ライト';

  /// ja: 'ダーク'
  String get dark => 'ダーク';
}

// Path: dialog
class TranslationsDialogJa {
  TranslationsDialogJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: 'キャンセル'
  String get cancel => 'キャンセル';
}
