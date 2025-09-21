///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'slang.g.dart';

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
  late final TranslationsSettingsJa settings = TranslationsSettingsJa._(_root);
}

// Path: settings
class TranslationsSettingsJa {
  TranslationsSettingsJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '設定'
  String get title => '設定';

  /// ja: '言語'
  String get language => '言語';

  /// ja: 'テーマ'
  String get theme => 'テーマ';

  /// ja: 'バージョン'
  String get version => 'バージョン';

  /// ja: 'ライセンス'
  String get licenses => 'ライセンス';

  late final TranslationsSettingsSectionsJa sections =
      TranslationsSettingsSectionsJa._(_root);
}

// Path: settings.sections
class TranslationsSettingsSectionsJa {
  TranslationsSettingsSectionsJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: 'アプリ設定'
  String get appSettings => 'アプリ設定';

  /// ja: 'その他'
  String get other => 'その他';
}
