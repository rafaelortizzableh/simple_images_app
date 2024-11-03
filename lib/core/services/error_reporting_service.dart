import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final errorReportingServiceProvider =
    Provider.autoDispose<ErrorReportingService>(
  (_) => LocalLoggingErrorReportingService(),
);

abstract class ErrorReportingService {
  void recordMessage({
    required String message,
    required String tag,
  });

  void recordError({
    required Object error,
    required StackTrace stackTrace,
    required String tag,
  }) {}
}

class LocalLoggingErrorReportingService implements ErrorReportingService {
  @override
  void recordError({
    required Object error,
    required StackTrace stackTrace,
    required String tag,
  }) {
    log('[‼️ ERROR] $tag: $error', error: error, stackTrace: stackTrace);
  }

  @override
  void recordMessage({
    required String message,
    required String tag,
  }) {
    log('[ℹ️ INFO] $tag: $message');
  }
}
