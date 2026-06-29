import 'dart:math' as math;
import 'dart:ui';

import 'package:soliel/features/test/ui/vision/models/scan_sample.dart';
import 'package:soliel/features/test/ui/vision/models/vision_frame.dart';

class ScanRequirements {
  final int minFrames;
  final int minPayloadPoints;
  final int minUniqueGazePoints;
  final int minDurationMs;
  final double minAverageConfidence;
  final int warmupMs;
  final int minSampleGapMs;
  final double minFrameConfidence;

  const ScanRequirements({
    this.minFrames = 15,
    this.minPayloadPoints = 15,
    this.minUniqueGazePoints = 10,
    this.minDurationMs = 7500,
    this.minAverageConfidence = 0.12,
    this.warmupMs = 1000,
    this.minSampleGapMs = 80,
    this.minFrameConfidence = 0.05,
  });
}

class ScanCollectionSummary {
  final int sampleCount;
  final int uniqueGazePoints;
  final int durationMs;
  final double averageConfidence;
  final double averageQuality;
  final double spread;
  final double trackingScore;
  final bool meetsMinimums;

  const ScanCollectionSummary({
    required this.sampleCount,
    required this.uniqueGazePoints,
    required this.durationMs,
    required this.averageConfidence,
    required this.averageQuality,
    required this.spread,
    required this.trackingScore,
    required this.meetsMinimums,
  });

  factory ScanCollectionSummary.empty() {
    return const ScanCollectionSummary(
      sampleCount: 0,
      uniqueGazePoints: 0,
      durationMs: 0,
      averageConfidence: 0,
      averageQuality: 0,
      spread: 0,
      trackingScore: 0,
      meetsMinimums: false,
    );
  }
}

class SampleCollector {
  final ScanRequirements requirements;
  final List<ScanSample> _samples = [];
  int? _sessionStartMs;
  int? _lastSampleTimestampMs;

  SampleCollector({required this.requirements});

  List<ScanSample> get samples => List.unmodifiable(_samples);

  void reset(int startMs) {
    _samples.clear();
    _sessionStartMs = startMs;
    _lastSampleTimestampMs = null;
  }

  ScanSample? considerFrame({
    required VisionFrame frame,
    required Offset targetPoint,
    required int nowMs,
  }) {
    final gaze = frame.gaze;
    if (gaze == null || frame.confidence < requirements.minFrameConfidence) {
      return null;
    }

    final sessionStart = _sessionStartMs ?? nowMs;
    if (nowMs - sessionStart < requirements.warmupMs) return null;

    final lastTimestamp = _lastSampleTimestampMs;
    if (lastTimestamp != null &&
        nowMs - lastTimestamp < requirements.minSampleGapMs) {
      return null;
    }

    final duration = lastTimestamp == null
        ? requirements.minSampleGapMs
        : (nowMs - lastTimestamp).clamp(16, 600);

    final sample = ScanSample(
      index: _samples.length,
      timestampMs: nowMs,
      durationMs: duration,
      gaze: Offset(
        gaze.dx.clamp(0.0, 1.0).toDouble(),
        gaze.dy.clamp(0.0, 1.0).toDouble(),
      ),
      previewPoint: frame.previewPoint ?? gaze,
      targetPoint: targetPoint,
      confidence: frame.confidence.clamp(0.0, 1.0).toDouble(),
      quality: frame.quality.clamp(0.0, 1.0).toDouble(),
    );

    _samples.add(sample);
    _lastSampleTimestampMs = nowMs;
    return sample;
  }

  ScanCollectionSummary summary() {
    if (_samples.isEmpty) return ScanCollectionSummary.empty();

    final durationMs = _samples.last.timestampMs - _samples.first.timestampMs;
    final averageConfidence =
        _samples.fold<double>(0, (sum, sample) => sum + sample.confidence) /
        _samples.length;
    final averageQuality =
        _samples.fold<double>(0, (sum, sample) => sum + sample.quality) /
        _samples.length;
    final uniqueGazePoints = _uniquePointCount(_samples);
    final spread = _dominantSpread(_samples);
    final trackingScore = _trackingScore(
      sampleCount: _samples.length,
      durationMs: durationMs,
      uniqueGazePoints: uniqueGazePoints,
      averageConfidence: averageConfidence,
      averageQuality: averageQuality,
      spread: spread,
    );
    final meetsMinimums =
        _samples.length >= requirements.minFrames &&
        durationMs >= requirements.minDurationMs &&
        uniqueGazePoints >= requirements.minUniqueGazePoints &&
        averageConfidence >= requirements.minAverageConfidence;

    return ScanCollectionSummary(
      sampleCount: _samples.length,
      uniqueGazePoints: uniqueGazePoints,
      durationMs: durationMs,
      averageConfidence: averageConfidence,
      averageQuality: averageQuality,
      spread: spread,
      trackingScore: trackingScore,
      meetsMinimums: meetsMinimums,
    );
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

  double _dominantSpread(List<ScanSample> samples) {
    var minX = samples.first.gaze.dx;
    var maxX = minX;
    var minY = samples.first.gaze.dy;
    var maxY = minY;

    for (final sample in samples.skip(1)) {
      minX = math.min(minX, sample.gaze.dx);
      maxX = math.max(maxX, sample.gaze.dx);
      minY = math.min(minY, sample.gaze.dy);
      maxY = math.max(maxY, sample.gaze.dy);
    }

    return math.max(maxX - minX, maxY - minY);
  }

  double _trackingScore({
    required int sampleCount,
    required int durationMs,
    required int uniqueGazePoints,
    required double averageConfidence,
    required double averageQuality,
    required double spread,
  }) {
    final sampleScore = (sampleCount / (requirements.minFrames * 2.0))
        .clamp(0.0, 1.0)
        .toDouble();
    final durationScore = (durationMs / requirements.minDurationMs)
        .clamp(0.0, 1.0)
        .toDouble();
    final uniqueScore =
        (uniqueGazePoints / (requirements.minUniqueGazePoints * 1.8))
            .clamp(0.0, 1.0)
            .toDouble();
    final spreadScore = (spread / 0.20).clamp(0.0, 1.0).toDouble();

    return (sampleScore * 0.22 +
            durationScore * 0.18 +
            uniqueScore * 0.18 +
            spreadScore * 0.14 +
            averageConfidence * 0.18 +
            averageQuality * 0.10)
        .clamp(0.0, 1.0)
        .toDouble();
  }
}
