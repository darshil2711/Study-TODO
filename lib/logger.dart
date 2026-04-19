import 'package:flutter/foundation.dart';

/// Part 7: Logging & Monitoring
/// Simple logging utility that disables debug logs in production mode.
class AppLogger {
  static void debug(String message) {
    if (!kReleaseMode) {
      debugPrint('🐛 DEBUG: $message');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (!kReleaseMode) {
      debugPrint('❌ ERROR: $message \n${error ?? ''} \n${stackTrace ?? ''}');
    } else {
      // Future improvement: Ship error to Firebase Crashlytics/Sentry in production
    }
  }
}
