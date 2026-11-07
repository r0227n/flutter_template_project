import 'package:app/application/errors/app_error_code.dart';

/// 外部境界の失敗を分類し、診断用の原因を保持する。
abstract class AppException implements Exception {
  /// 原因と発生箇所を保持する。UI には生の例外を表示しない。
  const AppException({this.cause, this.causeStackTrace});

  /// 元の失敗。plugin 型を利用側の契約へ露出させない。
  final Object? cause;

  /// 元の失敗が発生した場所。
  final StackTrace? causeStackTrace;

  /// ユーザー向け表示を選ぶための公開分類。
  AppErrorCode get code;

  @override
  String toString() => 'AppException(${code.value})';
}

/// 最終表示境界でのみ使用する、分類できない失敗。
final class UnexpectedAppException extends AppException {
  /// 診断情報を失わずに表示用の失敗へ変換する。
  const UnexpectedAppException({super.cause, super.causeStackTrace});

  @override
  AppErrorCode get code => AppErrorCode.unexpected;
}

/// 最終表示境界で未知の例外を分類する。業務処理では使用しない。
AppException appExceptionForDisplay(Object error, StackTrace stackTrace) =>
    switch (error) {
      AppException() => error,
      _ => UnexpectedAppException(cause: error, causeStackTrace: stackTrace),
    };
