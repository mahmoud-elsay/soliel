import 'package:soliel/features/test/data/models/scan_point.dart';
import 'package:soliel/features/test/ui/vision/models/scan_sample.dart';
import 'package:soliel/features/test/ui/vision/processing/sample_collector.dart';

class ScanPayloadValidationResult {
  final bool isValid;
  final List<String> issues;
  final List<ScanPoint> scanPath;
  final int uniqueGazePoints;
  final int durationMs;
  final double averageConfidence;

  const ScanPayloadValidationResult({
    required this.isValid,
    required this.issues,
    required this.scanPath,
    required this.uniqueGazePoints,
    required this.durationMs,
    required this.averageConfidence,
  });
}

class ScanPayloadValidator {
  ScanPayloadValidationResult validate({
    required int childId,
    required String notes,
    required List<ScanSample> samples,
    required ScanRequirements requirements,
  }) {
    final issues = <String>[];

    if (childId <= 0) {
      issues.add('معرف الطفل غير صالح.');
    }
    if (notes.length > 1000) {
      issues.add('الملاحظات طويلة جدًا.');
    }
    if (samples.length < requirements.minFrames) {
      issues.add(
        'تم التقاط ${samples.length} إطار صالح فقط. نحتاج ${requirements.minFrames} على الأقل.',
      );
    }

    final durationMs = samples.isEmpty
        ? 0
        : samples.last.timestampMs - samples.first.timestampMs;
    if (durationMs < requirements.minDurationMs) {
      issues.add(
        'مدة الفحص قصيرة (${(durationMs / 1000).toStringAsFixed(1)} ثانية).',
      );
    }

    final uniquePoints = _uniquePointCount(samples);
    if (uniquePoints < requirements.minUniqueGazePoints) {
      issues.add('تنوع مسار العين غير كاف ($uniquePoints نقاط مختلفة).');
    }

    final averageConfidence = samples.isEmpty
        ? 0.0
        : samples.fold<double>(0, (sum, sample) => sum + sample.confidence) /
              samples.length;
    if (averageConfidence < requirements.minAverageConfidence) {
      issues.add('متوسط الثقة منخفض (${(averageConfidence * 100).round()}%).');
    }

    if (!_timestampsAreIncreasing(samples)) {
      issues.add('ترتيب توقيت نقاط الفحص غير صالح.');
    }

    final path = _buildDeduplicatedPath(samples);
    if (path.length < requirements.minPayloadPoints) {
      issues.add(
        'مسار الإرسال يحتوي على ${path.length} نقطة فقط بعد إزالة التكرار.',
      );
    }

    for (final point in path) {
      if (!_isValidCoordinate(point.x) ||
          !_isValidCoordinate(point.y) ||
          point.duration <= 0) {
        issues.add('مسار العين يحتوي على نقطة غير صالحة.');
        break;
      }
    }

    return ScanPayloadValidationResult(
      isValid: issues.isEmpty,
      issues: issues,
      scanPath: path,
      uniqueGazePoints: uniquePoints,
      durationMs: durationMs,
      averageConfidence: averageConfidence,
    );
  }

  List<ScanPoint> _buildDeduplicatedPath(List<ScanSample> samples) {
    final points = <ScanPoint>[];
    String? lastKey;
    int duplicateCount = 0;

    for (final sample in samples) {
      final x = sample.gaze.dx.clamp(0.0, 1.0).toDouble();
      final y = sample.gaze.dy.clamp(0.0, 1.0).toDouble();
      final key = '${(x * 100).round()}:${(y * 100).round()}';

      if (points.isNotEmpty && key == lastKey && duplicateCount < 4) {
        duplicateCount++;
        final previous = points.removeLast();
        points.add(
          ScanPoint(
            x: previous.x,
            y: previous.y,
            duration: (previous.duration + sample.durationMs).clamp(16, 3000),
          ),
        );
        continue;
      }

      duplicateCount = 0;
      points.add(
        ScanPoint(
          x: x,
          y: y,
          duration: sample.durationMs.clamp(16, 1500),
        ),
      );
      lastKey = key;
    }

    return List.unmodifiable(points);
  }

  int _uniquePointCount(List<ScanSample> samples) {
    final keys = <String>{};
    for (final sample in samples) {
      keys.add(
        '${(sample.gaze.dx * 40).round()}:${(sample.gaze.dy * 40).round()}',
      );
    }
    return keys.length;
  }

  bool _timestampsAreIncreasing(List<ScanSample> samples) {
    var previous = -1;
    for (final sample in samples) {
      if (sample.timestampMs <= previous) return false;
      previous = sample.timestampMs;
    }
    return true;
  }

  bool _isValidCoordinate(double value) {
    return !value.isNaN &&
        value.isFinite &&
        value >= 0 &&
        value <= 1 &&
        value != double.maxFinite;
  }
}
