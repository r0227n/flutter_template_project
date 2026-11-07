import 'package:app/application/application.dart';
import 'package:app/core/logger/error_reporter.dart';

/// 保存順序と失敗を制御できる、端末 API を使わない repository。
class FakeAppPreferencesRepository implements AppPreferencesRepository {
  /// 初期の保存値を指定する。
  FakeAppPreferencesRepository({
    this.snapshot = const AppPreferencesSnapshot(),
  });

  /// 保存に成功した値だけを保持する。
  AppPreferencesSnapshot snapshot;

  /// 各書き込み前の待機または失敗を注入する。
  Future<void> Function()? beforeSave;

  /// 書き込み開始順の記録。
  final List<String> operations = [];

  @override
  AppPreferencesSnapshot load() => snapshot;

  @override
  Future<void> saveTheme(AppThemePreference theme) async {
    operations.add('theme:${theme.name}');
    await beforeSave?.call();
    snapshot = AppPreferencesSnapshot(theme: theme, locale: snapshot.locale);
  }

  @override
  Future<void> saveLocale(LocalePreference locale) async {
    operations.add('locale:${locale.languageCode}');
    await beforeSave?.call();
    snapshot = AppPreferencesSnapshot(theme: snapshot.theme, locale: locale);
  }
}

/// 報告を記録し、外部への送信を行わない。
class RecordingErrorReporter implements ErrorReporter {
  /// 報告された原因。
  final List<Object> errors = [];

  @override
  void report(Object error, StackTrace? stackTrace, {required String message}) {
    errors.add(error);
  }
}
