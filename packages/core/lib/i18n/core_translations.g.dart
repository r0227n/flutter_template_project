/// Generated file. Do not edit.
///
/// Source: assets/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 12 (6 per locale)

// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

import 'core_translations_en.g.dart' deferred as l_en;
part 'core_translations_ja.g.dart';

/// Supported locales.
///
/// Usage:
/// - LocaleSettings.setLocale(CoreLocale.ja) // set locale
/// - Locale locale = CoreLocale.ja.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == CoreLocale.ja) // locale check
enum CoreLocale with BaseAppLocale<CoreLocale, CoreTranslations> {
  ja(languageCode: 'ja'),
  en(languageCode: 'en');

  const CoreLocale({
    required this.languageCode,
    this.scriptCode, // ignore: unused_element, unused_element_parameter
    this.countryCode, // ignore: unused_element, unused_element_parameter
  });

  @override
  final String languageCode;
  @override
  final String? scriptCode;
  @override
  final String? countryCode;

  @override
  Future<CoreTranslations> build({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
  }) async {
    switch (this) {
      case CoreLocale.ja:
        return CoreTranslationsJa(
          overrides: overrides,
          cardinalResolver: cardinalResolver,
          ordinalResolver: ordinalResolver,
        );
      case CoreLocale.en:
        await l_en.loadLibrary();
        return l_en.CoreTranslationsEn(
          overrides: overrides,
          cardinalResolver: cardinalResolver,
          ordinalResolver: ordinalResolver,
        );
    }
  }

  @override
  CoreTranslations buildSync({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
  }) {
    switch (this) {
      case CoreLocale.ja:
        return CoreTranslationsJa(
          overrides: overrides,
          cardinalResolver: cardinalResolver,
          ordinalResolver: ordinalResolver,
        );
      case CoreLocale.en:
        return l_en.CoreTranslationsEn(
          overrides: overrides,
          cardinalResolver: cardinalResolver,
          ordinalResolver: ordinalResolver,
        );
    }
  }

  /// Gets current instance managed by [LocaleSettings].
  CoreTranslations get translations =>
      LocaleSettings.instance.getTranslations(this);
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
CoreTranslations get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = CoreTranslations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
class TranslationProvider
    extends BaseTranslationProvider<CoreLocale, CoreTranslations> {
  TranslationProvider({required super.child})
    : super(settings: LocaleSettings.instance);

  static InheritedLocaleData<CoreLocale, CoreTranslations> of(
    BuildContext context,
  ) => InheritedLocaleData.of<CoreLocale, CoreTranslations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
  CoreTranslations get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings
    extends BaseFlutterLocaleSettings<CoreLocale, CoreTranslations> {
  LocaleSettings._()
    : super(
        utils: AppLocaleUtils.instance,
        lazy: true,
      );

  static final instance = LocaleSettings._();

  // static aliases (checkout base methods for documentation)
  static CoreLocale get currentLocale => instance.currentLocale;
  static Stream<CoreLocale> getLocaleStream() => instance.getLocaleStream();
  static Future<CoreLocale> setLocale(
    CoreLocale locale, {
    bool? listenToDeviceLocale = false,
  }) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
  static Future<CoreLocale> setLocaleRaw(
    String rawLocale, {
    bool? listenToDeviceLocale = false,
  }) => instance.setLocaleRaw(
    rawLocale,
    listenToDeviceLocale: listenToDeviceLocale,
  );
  static Future<CoreLocale> useDeviceLocale() => instance.useDeviceLocale();
  static Future<void> setPluralResolver({
    String? language,
    CoreLocale? locale,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
  }) => instance.setPluralResolver(
    language: language,
    locale: locale,
    cardinalResolver: cardinalResolver,
    ordinalResolver: ordinalResolver,
  );

  // synchronous versions
  static CoreLocale setLocaleSync(
    CoreLocale locale, {
    bool? listenToDeviceLocale = false,
  }) => instance.setLocaleSync(
    locale,
    listenToDeviceLocale: listenToDeviceLocale,
  );
  static CoreLocale setLocaleRawSync(
    String rawLocale, {
    bool? listenToDeviceLocale = false,
  }) => instance.setLocaleRawSync(
    rawLocale,
    listenToDeviceLocale: listenToDeviceLocale,
  );
  static CoreLocale useDeviceLocaleSync() => instance.useDeviceLocaleSync();
  static void setPluralResolverSync({
    String? language,
    CoreLocale? locale,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
  }) => instance.setPluralResolverSync(
    language: language,
    locale: locale,
    cardinalResolver: cardinalResolver,
    ordinalResolver: ordinalResolver,
  );
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<CoreLocale, CoreTranslations> {
  AppLocaleUtils._()
    : super(
        baseLocale: CoreLocale.ja,
        locales: CoreLocale.values,
      );

  static final instance = AppLocaleUtils._();

  // static aliases (checkout base methods for documentation)
  static CoreLocale parse(String rawLocale) => instance.parse(rawLocale);
  static CoreLocale parseLocaleParts({
    required String languageCode,
    String? scriptCode,
    String? countryCode,
  }) => instance.parseLocaleParts(
    languageCode: languageCode,
    scriptCode: scriptCode,
    countryCode: countryCode,
  );
  static CoreLocale findDeviceLocale() => instance.findDeviceLocale();
  static List<Locale> get supportedLocales => instance.supportedLocales;
  static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}
