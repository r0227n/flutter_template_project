import 'package:apps/i18n/translations.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  LocaleService._();

  static const _localeKey = 'selected_locale';

  /// 保存されたLocaleを取得
  static Future<AppLocale?> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);
    
    if (localeCode == null) {
      return null;
    }
    
    // AppLocaleからlocaleCodeに対応するものを取得
    try {
      return AppLocale.values.firstWhere(
        (locale) => locale.languageCode == localeCode,
      );
    } on Exception {
      return null;
    }
  }

  /// Localeを保存
  static Future<bool> saveLocale(AppLocale locale) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_localeKey, locale.languageCode);
  }

  /// 保存されたLocaleを削除
  static Future<bool> clearSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(_localeKey);
  }
}
