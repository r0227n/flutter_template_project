/// Reports an operational failure without exposing the reporting backend.
// A single-purpose interface keeps presentation independent from Talker.
// ignore: one_member_abstracts
abstract interface class ErrorReporter {
  /// Reports [error] with the context required for diagnosis.
  void report(
    Object error,
    StackTrace? stackTrace, {
    required String message,
  });
}
