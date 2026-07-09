import 'dart:ui';

/// Per-session gaze calibration.
///
/// The rest of the pipeline (GazeEstimator + fixed gain constants) only
/// produces a *rough* normalized gaze estimate — it has no idea about this
/// particular user's eye geometry, camera framing, or head distance. This
/// class fixes that the same way the Python/MediaPipe reference script does:
/// show the user N known points on screen, record the raw estimated gaze
/// while they look at each one, then fit a simple linear regression
/// (equivalent to `np.polyfit(rawX, targetX, 1)`) per axis. At runtime that
/// mapping is applied to every new raw gaze point before it's used.
class GazeCalibrator {
  static const int minSamplesToFit = 4;

  final List<Offset> _rawSamples = [];
  final List<Offset> _targetSamples = [];

  double _slopeX = 1.0;
  double _interceptX = 0.0;
  double _slopeY = 1.0;
  double _interceptY = 0.0;
  bool _isCalibrated = false;

  bool get isCalibrated => _isCalibrated;
  int get sampleCount => _rawSamples.length;

  void reset() {
    _rawSamples.clear();
    _targetSamples.clear();
    _slopeX = 1.0;
    _interceptX = 0.0;
    _slopeY = 1.0;
    _interceptY = 0.0;
    _isCalibrated = false;
  }

  /// Record one calibration observation: the raw (uncalibrated) gaze point
  /// the estimator produced while the user was looking at [target].
  void addSample(Offset rawGaze, Offset target) {
    _rawSamples.add(rawGaze);
    _targetSamples.add(target);
  }

  /// Fits the linear mapping from the collected samples. Safe to call with
  /// too few samples — in that case calibration is simply left disabled and
  /// [apply] falls back to identity (raw gaze passes through unchanged).
  bool fit() {
    if (_rawSamples.length < minSamplesToFit) {
      _isCalibrated = false;
      return false;
    }

    final fitX = _linearFit(
      _rawSamples.map((p) => p.dx).toList(),
      _targetSamples.map((p) => p.dx).toList(),
    );
    final fitY = _linearFit(
      _rawSamples.map((p) => p.dy).toList(),
      _targetSamples.map((p) => p.dy).toList(),
    );

    if (fitX == null || fitY == null) {
      _isCalibrated = false;
      return false;
    }

    _slopeX = fitX.$1;
    _interceptX = fitX.$2;
    _slopeY = fitY.$1;
    _interceptY = fitY.$2;
    _isCalibrated = true;
    return true;
  }

  /// Applies the fitted mapping to a raw gaze point. Returns the point
  /// unchanged (clamped) if calibration hasn't been fitted yet.
  Offset apply(Offset rawGaze) {
    if (!_isCalibrated) return rawGaze;

    final x = _slopeX * rawGaze.dx + _interceptX;
    final y = _slopeY * rawGaze.dy + _interceptY;

    return Offset(x.clamp(0.0, 1.0).toDouble(), y.clamp(0.0, 1.0).toDouble());
  }

  /// Ordinary least squares fit of y = slope*x + intercept.
  /// Same result as `np.polyfit(x, y, 1)`.
  (double, double)? _linearFit(List<double> xs, List<double> ys) {
    final n = xs.length;
    if (n < 2) return null;

    var sumX = 0.0, sumY = 0.0, sumXY = 0.0, sumXX = 0.0;
    for (var i = 0; i < n; i++) {
      sumX += xs[i];
      sumY += ys[i];
      sumXY += xs[i] * ys[i];
      sumXX += xs[i] * xs[i];
    }

    final denominator = n * sumXX - sumX * sumX;
    if (denominator.abs() < 1e-9) return null; // no horizontal/vertical spread

    final slope = (n * sumXY - sumX * sumY) / denominator;
    final intercept = (sumY - slope * sumX) / n;

    if (slope.isNaN ||
        slope.isInfinite ||
        intercept.isNaN ||
        intercept.isInfinite) {
      return null;
    }

    return (slope, intercept);
  }
}
