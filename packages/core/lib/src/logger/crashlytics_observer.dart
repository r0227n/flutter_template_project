import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:talker/talker.dart';

class CrashlyticsTalkerObserver extends TalkerObserver {
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
