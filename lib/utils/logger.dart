import 'package:flutter/foundation.dart';

/// Logger utility for clean, production-ready logging
class AppLogger {
  static const String _tag = 'MoodMusicApp';

  /// Log informational messages (only in debug mode)
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('ℹ️ [${tag ?? _tag}] $message');
    }
  }

  /// Log success messages (only in debug mode)
  static void success(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('✅ [${tag ?? _tag}] $message');
    }
  }

  /// Log warning messages
  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('⚠️ [${tag ?? _tag}] $message');
    }
  }

  /// Log error messages (always logged, even in release mode)
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    debugPrint('❌ [${tag ?? _tag}] $message');
    if (error != null) {
      debugPrint('Error: $error');
    }
    if (stackTrace != null && kDebugMode) {
      debugPrint('StackTrace: $stackTrace');
    }
  }

  /// Log debug messages (only in debug mode)
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('🔍 [${tag ?? _tag}] $message');
    }
  }
}
