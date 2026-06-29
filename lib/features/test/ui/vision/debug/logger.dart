import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class VisionLogger {
  final bool enabled;

  const VisionLogger({required this.enabled});

  factory VisionLogger.debug() => const VisionLogger(enabled: kDebugMode);

  void camera(String event, Map<String, Object?> fields) {
    _log('camera.$event', fields);
  }

  void detection(String event, Map<String, Object?> fields) {
    _log('detection.$event', fields);
  }

  void sample(String event, Map<String, Object?> fields) {
    _log('sample.$event', fields);
  }

  void payload(String event, Map<String, Object?> fields) {
    _log('payload.$event', fields);
  }

  void _log(String event, Map<String, Object?> fields) {
    if (!enabled) return;

    developer.log(
      jsonEncode(<String, Object?>{
        'event': event,
        'timestampMs': DateTime.now().millisecondsSinceEpoch,
        ...fields,
      }),
      name: 'EyeScanner',
    );
  }
}
