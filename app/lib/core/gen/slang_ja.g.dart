///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'slang.g.dart';

// Path: <root>
typedef TranslationsJa = Translations; // ignore: unused_element

class Translations with BaseTranslations<AppLocale, Translations> {
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
           ) {
    $meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <ja>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  dynamic operator [](String key) => $meta.getTranslation(key);

  late final Translations _root = this; // ignore: unused_field

  Translations $copyWith({
    TranslationMetadata<AppLocale, Translations>? meta,
  }) => Translations(meta: meta ?? this.$meta);

  // Translations

  /// ja: 'Flutter Template'
  String get appName => 'Flutter Template';

  /// ja: 'ホーム'
  String get home => 'ホーム';

  /// ja: 'アプリの開発を始めましょう'
  String get welcome => 'アプリの開発を始めましょう';

  /// ja: '設定'
  String get settings => '設定';

  /// ja: 'テーマ'
  String get theme => 'テーマ';

  /// ja: '端末に合わせる'
  String get system => '端末に合わせる';

  /// ja: 'ライト'
  String get light => 'ライト';

  /// ja: 'ダーク'
  String get dark => 'ダーク';

  /// ja: '言語'
  String get language => '言語';

  /// ja: '設定を保存できませんでした。もう一度お試しください。'
  String get saveFailed => '設定を保存できませんでした。もう一度お試しください。';
}

/// The flat map containing all translations for locale <ja>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'appName' => 'Flutter Template',
      'home' => 'ホーム',
      'welcome' => 'アプリの開発を始めましょう',
      'settings' => '設定',
      'theme' => 'テーマ',
      'system' => '端末に合わせる',
      'light' => 'ライト',
      'dark' => 'ダーク',
      'language' => '言語',
      'saveFailed' => '設定を保存できませんでした。もう一度お試しください。',
      _ => null,
    };
  }
}
