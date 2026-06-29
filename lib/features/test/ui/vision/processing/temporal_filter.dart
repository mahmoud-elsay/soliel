
import 'dart:ui';

import 'package:soliel/features/test/ui/vision/models/vision_frame.dart';

class TemporalVisionFilter {
  final _Smoother _gazeX = _Smoother(alpha: 0.75, windowSize: 8);
  final _Smoother _gazeY = _Smoother(alpha: 0.75, windowSize: 8);
  final _Smoother _previewX = _Smoother(alpha: 0.65, windowSize: 10);
  final _Smoother _previewY = _Smoother(alpha: 0.65, windowSize: 10);
  final _EmaFilter _confidence = _EmaFilter(alpha: 0.22);
  final _EmaFilter _quality = _EmaFilter(alpha: 0.22);

  VisionFrame apply(VisionFrame frame) {
    final gaze = frame.gaze;
    if (gaze == null) return frame;

    final filteredGaze = Offset(
      _gazeX.filter(gaze.dx),
      _gazeY.filter(gaze.dy),
    );

    final preview = frame.previewPoint;
    final filteredPreview = preview == null
        ? filteredGaze
        : Offset(
            _previewX.filter(preview.dx),
            _previewY.filter(preview.dy),
          );

    return frame.copyWith(
      gaze: filteredGaze,
      previewPoint: filteredPreview,
      confidence: _confidence.filter(frame.confidence),
      quality: _quality.filter(frame.quality),
    );
  }

  void reset() {
    _gazeX.reset();
    _gazeY.reset();
    _previewX.reset();
    _previewY.reset();
    _confidence.reset();
    _quality.reset();
  }
}

class _EmaFilter {
  final double alpha;
  double? _value;

  _EmaFilter({required this.alpha});

  double filter(double value) {
    final previous = _value;
    if (previous == null) {
      _value = value;
      return value;
    }

    final next = previous + (value - previous) * alpha;
    _value = next;
    return next;
  }

  void reset() {
    _value = null;
  }
}

class _Smoother {
  final List<double> _window = [];
  final double alpha;
  final int windowSize;
  double? _ema;

  _Smoother({this.alpha = 0.7, this.windowSize = 8});

  double filter(double value) {
    if (_window.length >= windowSize) {
      _window.removeAt(0);
    }
    _window.add(value);

    final movingAverage = _window.reduce((a, b) => a + b) / _window.length;

    if (_ema == null) {
      _ema = movingAverage;
    } else {
      _ema = alpha * movingAverage + (1 - alpha) * _ema!;
    }
    return _ema!.clamp(0.0, 1.0);
  }

  void reset() {
    _window.clear();
    _ema = null;
  }
}

