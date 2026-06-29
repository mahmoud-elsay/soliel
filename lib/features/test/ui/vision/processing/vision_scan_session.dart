import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart' show DeviceOrientation;
import 'package:soliel/features/test/ui/vision/camera/image_converter.dart';
import 'package:soliel/features/test/ui/vision/debug/logger.dart';
import 'package:soliel/features/test/ui/vision/detection/face_detector.dart';
import 'package:soliel/features/test/ui/vision/detection/gaze_estimator.dart';
import 'package:soliel/features/test/ui/vision/models/vision_frame.dart';
import 'package:soliel/features/test/ui/vision/models/vision_state.dart';
import 'package:soliel/features/test/ui/vision/processing/payload_validator.dart';
import 'package:soliel/features/test/ui/vision/processing/quality_analyzer.dart';
import 'package:soliel/features/test/ui/vision/processing/sample_collector.dart';
import 'package:soliel/features/test/ui/vision/processing/temporal_filter.dart';

class VisionScanSession {
  static const int _faceLostGraceMs = 650;
  static const int _minProcessIntervalMs = 33;

  final VisionLogger _logger;
  final ScanRequirements requirements;
  late final CameraImageConverter _converter;
  late final MobileFaceDetector _faceDetector;
  late final GazeEstimator _gazeEstimator;
  late final SampleCollector _sampleCollector;
  final TemporalVisionFilter _temporalFilter = TemporalVisionFilter();
  final ScanPayloadValidator _payloadValidator = ScanPayloadValidator();

  VisionState _state = VisionState.initial();
  VisionFrame? _lastUsableFrame;
  int? _lastProcessedMs;
  int? _lastFaceSeenMs;
  int? _lastFpsTickMs;
  int _framesInFpsWindow = 0;

  VisionScanSession({
    required VisionLogger logger,
    this.requirements = const ScanRequirements(),
  }) : _logger = logger {
    _converter = CameraImageConverter(logger: logger);
    _faceDetector = MobileFaceDetector(logger: logger);
    _sampleCollector = SampleCollector(requirements: requirements);
    _gazeEstimator = GazeEstimator(
      converter: _converter,
      qualityAnalyzer: FrameQualityAnalyzer(),
    );
  }

  VisionState get state => _state;

  void start(int startMs) {
    _lastProcessedMs = null;
    _lastFaceSeenMs = null;
    _lastFpsTickMs = null;
    _framesInFpsWindow = 0;
    _lastUsableFrame = null;
    _temporalFilter.reset();
    _sampleCollector.reset(startMs);
    _state = VisionState.initial().copyWith(isRunning: true);
  }

  VisionState stop() {
    _state = _state.copyWith(isRunning: false);
    return _state;
  }

  Future<VisionState?> processFrame({
    required CameraImage image,
    required CameraDescription camera,
    required DeviceOrientation deviceOrientation,
    required Offset targetPoint,
    required int nowMs,
  }) async {
    final previousProcessed = _lastProcessedMs;
    if (previousProcessed != null &&
        nowMs - previousProcessed < _minProcessIntervalMs) {
      return null;
    }
    _lastProcessedMs = nowMs;

    final converted = _converter.convert(
      image: image,
      camera: camera,
      deviceOrientation: deviceOrientation,
    );

    if (converted == null) {
      return _publishRejected(
        VisionFrame.rejected(
          timestampMs: nowMs,
          reason: 'image_conversion_failed',
        ),
        nowMs,
      );
    }

    final detection = await _faceDetector.detect(converted);
    final face = detection.primaryFace;
    if (face == null) {
      return _publishRejected(
        VisionFrame.rejected(
          timestampMs: nowMs,
          reason: detection.error == null ? 'no_face' : 'detector_error',
          faceCount: detection.faces.length,
        ),
        nowMs,
      );
    }

    _lastFaceSeenMs = nowMs;

    final estimated = _gazeEstimator.estimate(
      face: face,
      faceCount: detection.faces.length,
      image: converted,
      camera: camera,
      timestampMs: nowMs,
      previousFrame: _lastUsableFrame,
    );

    if (!estimated.isUsable) {
      return _publishRejected(estimated, nowMs);
    }

    final filtered = _temporalFilter.apply(estimated);
    _lastUsableFrame = filtered;
    final sample = _sampleCollector.considerFrame(
      frame: filtered,
      targetPoint: targetPoint,
      nowMs: nowMs,
    );

    if (sample != null) {
      _logger.sample('collected', <String, Object?>{
        'count': _sampleCollector.samples.length,
        'x': sample.gaze.dx.toStringAsFixed(4),
        'y': sample.gaze.dy.toStringAsFixed(4),
        'confidence': sample.confidence.toStringAsFixed(3),
        'quality': sample.quality.toStringAsFixed(3),
      });
    }

    final summary = _sampleCollector.summary();
    final fps = _updateFps(nowMs);
    _state = VisionState(
      isRunning: true,
      faceVisible: true,
      lastFrame: filtered,
      framesProcessed: _state.framesProcessed + 1,
      framesRejected: _state.framesRejected,
      sampleCount: summary.sampleCount,
      uniqueGazePoints: summary.uniqueGazePoints,
      validDurationMs: summary.durationMs,
      averageConfidence: summary.averageConfidence,
      averageQuality: summary.averageQuality,
      trackingScore: summary.trackingScore,
      fps: fps,
      lastRejectedReason: null,
      readyForUpload: summary.meetsMinimums,
    );

    _logger.detection('frame', <String, Object?>{
      'quality': filtered.quality.toStringAsFixed(3),
      'confidence': filtered.confidence.toStringAsFixed(3),
      'gazeX': filtered.gaze!.dx.toStringAsFixed(4),
      'gazeY': filtered.gaze!.dy.toStringAsFixed(4),
      'leftContour': filtered.leftEyeContourPoints,
      'rightContour': filtered.rightEyeContourPoints,
      'samples': summary.sampleCount,
      'averageConfidence': summary.averageConfidence.toStringAsFixed(3),
    });

    return _state;
  }

  ScanPayloadValidationResult validatePayload({
    required int childId,
    required String notes,
  }) {
    final result = _payloadValidator.validate(
      childId: childId,
      notes: notes,
      samples: _sampleCollector.samples,
      requirements: requirements,
    );

    _logger.payload(result.isValid ? 'valid' : 'invalid', <String, Object?>{
      'childId': childId,
      'sampleCount': _sampleCollector.samples.length,
      'payloadPoints': result.scanPath.length,
      'uniqueGazePoints': result.uniqueGazePoints,
      'durationMs': result.durationMs,
      'averageConfidence': result.averageConfidence.toStringAsFixed(3),
      'issues': result.issues,
    });

    return result;
  }

  Future<void> dispose() => _faceDetector.dispose();

  VisionState _publishRejected(VisionFrame frame, int nowMs) {
    final summary = _sampleCollector.summary();
    final faceRecentlyVisible =
        _lastFaceSeenMs != null && nowMs - _lastFaceSeenMs! <= _faceLostGraceMs;
    final fps = _updateFps(nowMs);

    _state = VisionState(
      isRunning: true,
      faceVisible: frame.hasFace || faceRecentlyVisible,
      lastFrame: frame.hasFace ? frame : _state.lastFrame,
      framesProcessed: _state.framesProcessed + 1,
      framesRejected: _state.framesRejected + 1,
      sampleCount: summary.sampleCount,
      uniqueGazePoints: summary.uniqueGazePoints,
      validDurationMs: summary.durationMs,
      averageConfidence: summary.averageConfidence,
      averageQuality: summary.averageQuality,
      trackingScore: summary.trackingScore,
      fps: fps,
      lastRejectedReason: frame.rejectionReason,
      readyForUpload: summary.meetsMinimums,
    );

    _logger.detection('rejected', <String, Object?>{
      'reason': frame.rejectionReason,
      'hasFace': frame.hasFace,
      'quality': frame.quality.toStringAsFixed(3),
      'samples': summary.sampleCount,
      'faceVisible': _state.faceVisible,
    });

    return _state;
  }

  double _updateFps(int nowMs) {
    _framesInFpsWindow++;
    final lastTick = _lastFpsTickMs;
    if (lastTick == null) {
      _lastFpsTickMs = nowMs;
      return _state.fps;
    }

    final elapsed = nowMs - lastTick;
    if (elapsed < 800) return _state.fps;

    final fps = _framesInFpsWindow * 1000 / elapsed;
    _framesInFpsWindow = 0;
    _lastFpsTickMs = nowMs;
    return fps;
  }
}
