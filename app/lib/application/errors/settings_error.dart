import 'package:app/application/errors/app_error_code.dart';
import 'package:app/application/errors/app_exception.dart';

/// 設定を端末へ保存できなかったことを表す。
final class SettingsWriteException extends AppException {
  /// plugin の失敗または書き込み拒否を保持する。
  const SettingsWriteException({super.cause, super.causeStackTrace});

  @override
  AppErrorCode get code => AppErrorCode.settingsWrite;
}
