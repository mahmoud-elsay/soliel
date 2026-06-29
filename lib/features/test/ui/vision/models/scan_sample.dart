import 'dart:ui';

import 'package:soliel/features/test/data/models/scan_point.dart';

class ScanSample {
  final int index;
  final int timestampMs;
  final int durationMs;
  final Offset gaze;
  final Offset previewPoint;
  final Offset targetPoint;
  final double confidence;
  final double quality;

  const ScanSample({
    required this.index,
    required this.timestampMs,
    required this.durationMs,
    required this.gaze,
    required this.previewPoint,
    required this.targetPoint,
    required this.confidence,
    required this.quality,
  });

  ScanPoint toScanPoint() {
    return ScanPoint(
      x: gaze.dx.clamp(0.0, 1.0).toDouble(),
      y: gaze.dy.clamp(0.0, 1.0).toDouble(),
      duration: durationMs.clamp(16, 1500),
    );
  }
}
