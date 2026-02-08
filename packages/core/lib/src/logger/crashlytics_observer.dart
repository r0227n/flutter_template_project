import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:talker/talker.dart';

/// Talker observer that forwards errors and exceptions to Firebase Crashlytics.
class CrashlyticsTalkerObserver extends TalkerObserver {
  /// Creates a Crashlytics Talker observer.
  CrashlyticsTalkerObserver();

  @override
  void onError(TalkerError err) {
    unawaited(
      FirebaseCrashlytics.instance.recordError(
        err.error,
        err.stackTrace,
        reason: err.message,
      ),
    );
  }

  @override
  void onException(TalkerException err) {
    unawaited(
      FirebaseCrashlytics.instance.recordError(
        err.exception,
        err.stackTrace,
        reason: err.message,
      ),
    );
  }
}
