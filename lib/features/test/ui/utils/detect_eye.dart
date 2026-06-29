import 'dart:developer' as developer;
import 'dart:math' as math;
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

/// Multi-signal gaze estimator designed for mobile ML Kit.
///
/// Combines three gaze signals:
///   1. **Dark pupil position** — estimated from camera luminance inside each
///      ML Kit eye contour.
///   2. **Head Pose** — yaw/pitch from ML Kit Euler angles, used as a helper.
///   3. **Eye Asymmetry** — left/right pupil-ratio difference.
///
/// ML Kit face detection does not provide iris landmarks. Using the eye-contour
/// centroid as an iris proxy makes the path look valid while carrying little
/// gaze information, so this detector samples the Y plane directly instead.
class EyeDetector {
  // ── Quality gate thresholds ────────────────────────────────────────────────
  static const double _maxYaw = 40;
  static const double _maxPitch = 35;
  static const double _minEyeOpenProbability = 0.20;
  static const int _minEyeContourPoints = 10;
  static const double _minPupilConfidence = 0.05;

  // ── Gaze model signal weights ──────────────────────────────────────────────
  /// Real pupil movement must dominate; head pose alone is too easy to
  /// misclassify as a valid gaze path.
  static const double _pupilPositionWeight = 0.45;

  /// Head pose stabilizes the estimate but is intentionally not primary.
  static const double _headPoseWeight = 0.45;

  /// Left/right eye asymmetry captures lateral gaze shifts.
  static const double _eyeAsymmetryWeight = 0.10;

  // ── Head-pose → gaze mapping ───────────────────────────────────────────────
  /// The full angular range mapped to [0..1] gaze.
  /// Yaw range of ±25° maps to full horizontal gaze.
  static const double _yawRangeDeg = 25.0;

  /// Pitch range of ±20° maps to full vertical gaze.
  static const double _pitchRangeDeg = 20.0;

  // ── Pupil position scaling ─────────────────────────────────────────────────
  /// How much to amplify small pupil-ratio deviations from center.
  /// Higher = more sensitive to small eye movements.
  static const double _pupilHorizontalGain = 1.8;
  static const double _pupilVerticalGain = 1.5;

  final FaceDetector _faceDetector;

  EyeDetector()
    : _faceDetector = FaceDetector(
        options: FaceDetectorOptions(
          enableContours: true,
          enableClassification: true,
          enableLandmarks: false,
          enableTracking: false,
          performanceMode: FaceDetectorMode.fast,
          minFaceSize: 0.10,
        ),
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // Public API
  // ═══════════════════════════════════════════════════════════════════════════

  /// Whether we've logged the image format info (one-shot per session).
  bool _loggedImageFormat = false;

  Future<Map<String, double>?> detectGazePoint(
    CameraImage image,
    CameraDescription camera,
  ) async {
    try {
      // ── Phase 0: one-shot image format diagnostics ──────────────────────
      if (!_loggedImageFormat) {
        _loggedImageFormat = true;
        developer.log(
          '[EyeDetector] Image format: planes=${image.planes.length}, '
          'format.group=${image.format.group}, '
          'format.raw=${image.format.raw}, '
          'size=${image.width}x${image.height}',
          name: 'EyeScanner',
        );
      }

      final inputImage = _toInputImage(image, camera);
      if (inputImage == null) return null;

      final faces = await _faceDetector.processImage(inputImage);
      if (faces.isEmpty) {
        developer.log('[EyeDetector] No faces detected', name: 'EyeScanner');
        return null;
      }

      final face = _pickPrimaryFace(faces);

      final headGaze = _headPoseGaze(face);
      final leftContour = face.contours[FaceContourType.leftEye];
      final rightContour = face.contours[FaceContourType.rightEye];

      final leftPts = leftContour?.points.length ?? 0;
      final rightPts = rightContour?.points.length ?? 0;

      final hasLeft = _hasEnoughContourPoints(leftContour);
      final hasRight = _hasEnoughContourPoints(rightContour);
      if (!hasLeft && !hasRight && headGaze == null) {
        developer.log(
          '[EyeDetector] Rejected: contours L=$leftPts R=$rightPts, '
          'headGaze=null',
          name: 'EyeScanner',
        );
        return null;
      }

      final leftPupil = hasLeft ? _darkPupilSample(leftContour, image) : null;
      final rightPupil = hasRight
          ? _darkPupilSample(rightContour, image)
          : null;
      final pupilConfidence = _combinedPupilConfidence(leftPupil, rightPupil);

      // Soft quality: a phone camera should not fail the scan only because
      // pupil contrast is weak in one frame.
      final quality = _computeFrameQuality(face, pupilConfidence);

      // ── Phase 0: per-frame diagnostics ─────────────────────────────────
      developer.log(
        '[EyeDetector] contourPts L=$leftPts R=$rightPts | '
        'pupilConf=${pupilConfidence.toStringAsFixed(3)} | '
        'quality=${quality.toStringAsFixed(3)} | '
        'yaw=${face.headEulerAngleY?.toStringAsFixed(1)} '
        'pitch=${face.headEulerAngleX?.toStringAsFixed(1)}',
        name: 'EyeScanner',
      );

      if (quality <= 0.05) return null;

      // ── Compute the gaze signals ─────────────────────────────────────────
      final pupilGaze = _pupilPositionGaze(leftPupil, rightPupil);
      final asymmetryGaze = _eyeAsymmetryGaze(leftPupil, rightPupil);

      // ── Weighted fusion ──────────────────────────────────────────────────
      double totalWeight = 0;
      double gazeX = 0;
      double gazeY = 0;

      if (pupilGaze != null && pupilConfidence >= _minPupilConfidence) {
        final pupilWeight = _pupilPositionWeight * pupilConfidence;
        gazeX += pupilGaze['x']! * pupilWeight;
        gazeY += pupilGaze['y']! * pupilWeight;
        totalWeight += pupilWeight;
      }

      if (asymmetryGaze != null) {
        final asymmetryWeight = _eyeAsymmetryWeight * pupilConfidence;
        gazeX += asymmetryGaze['x']! * asymmetryWeight;
        gazeY += asymmetryGaze['y']! * asymmetryWeight;
        totalWeight += asymmetryWeight;
      }

      if (headGaze != null) {
        final headWeight = pupilGaze == null ? 1.0 : _headPoseWeight;
        gazeX += headGaze['x']! * headWeight;
        gazeY += headGaze['y']! * headWeight;
        totalWeight += headWeight;
      }

      if (totalWeight <= 0) return null;
      gazeX /= totalWeight;
      gazeY /= totalWeight;

      // Front camera mirror correction.
      if (camera.lensDirection == CameraLensDirection.front) {
        gazeX = 1.0 - gazeX;
      }

      gazeX = gazeX.clamp(0.0, 1.0);
      gazeY = gazeY.clamp(0.0, 1.0);

      // Preview coordinates for scan path visualization.
      final eyeCenter = _resolveEyeCenter(
        leftPupil?.center,
        rightPupil?.center,
      );
      final previewNorm = eyeCenter != null
          ? _normalizePreviewCoordinates(
              eyeCenter.dx,
              eyeCenter.dy,
              image,
              camera,
            )
          : {'x': gazeX, 'y': gazeY};

      return {
        'normX': gazeX,
        'normY': gazeY,
        'previewX': previewNorm['x']!,
        'previewY': previewNorm['y']!,
        'quality': quality,
      };
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    _faceDetector.close();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Signal 1: Head Pose → Gaze
  // ═══════════════════════════════════════════════════════════════════════════

  /// Maps head Euler angles to normalized [0..1] gaze coordinates.
  /// This is the most reliable signal on mobile — children naturally turn
  /// their heads toward what they're looking at.
  Map<String, double>? _headPoseGaze(Face face) {
    final yaw = face.headEulerAngleY;
    final pitch = face.headEulerAngleX;
    if (yaw == null || pitch == null) return null;

    // Yaw: positive = looking right, negative = looking left
    // Map ±_yawRangeDeg to [0, 1]
    final gazeX = 0.5 + (yaw / _yawRangeDeg) * 0.5;

    // Pitch: positive = looking up, negative = looking down
    // Map ±_pitchRangeDeg to [0, 1] (inverted: up = lower Y on screen)
    final gazeY = 0.5 - (pitch / _pitchRangeDeg) * 0.5;

    return {'x': gazeX.clamp(0.0, 1.0), 'y': gazeY.clamp(0.0, 1.0)};
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Signal 2: Pupil Position within Eye Aperture
  // ═══════════════════════════════════════════════════════════════════════════

  /// Estimates gaze from the darkest stable pixel cluster inside the eye contour.
  Map<String, double>? _pupilPositionGaze(
    _EyeSample? leftPupil,
    _EyeSample? rightPupil,
  ) {
    final pupilRatio = _weightedPupilRatio(leftPupil, rightPupil);
    if (pupilRatio == null) return null;

    final gazeX = 0.5 + (pupilRatio['x']! - 0.5) * _pupilHorizontalGain;
    final gazeY = 0.5 + (pupilRatio['y']! - 0.5) * _pupilVerticalGain;

    return {'x': gazeX.clamp(0.0, 1.0), 'y': gazeY.clamp(0.0, 1.0)};
  }

  Map<String, double>? _weightedPupilRatio(
    _EyeSample? leftPupil,
    _EyeSample? rightPupil,
  ) {
    final samples = <_EyeSample>[
      if (leftPupil != null) leftPupil,
      if (rightPupil != null) rightPupil,
    ];
    if (samples.isEmpty) return null;

    var totalWeight = 0.0;
    var sumX = 0.0;
    var sumY = 0.0;

    for (final sample in samples) {
      final weight = math.max(sample.confidence, 0.01);
      totalWeight += weight;
      sumX += sample.ratioX * weight;
      sumY += sample.ratioY * weight;
    }

    if (totalWeight <= 0) return null;
    return {'x': sumX / totalWeight, 'y': sumY / totalWeight};
  }

  _EyeSample? _darkPupilSample(FaceContour? contour, CameraImage image) {
    final bounds = _eyeContourBounds(contour);
    if (bounds == null) return null;

    final lumaPlane = image.planes.first;
    final luma = lumaPlane.bytes;
    final rowStride = lumaPlane.bytesPerRow;
    final imageWidth = image.width;
    final imageHeight = image.height;

    final minX = math.max(0, bounds.left.floor());
    final maxX = math.min(imageWidth - 1, bounds.right.ceil());
    final minY = math.max(0, bounds.top.floor());
    final maxY = math.min(imageHeight - 1, bounds.bottom.ceil());

    if (maxX <= minX || maxY <= minY) return null;

    final eyeWidth = (maxX - minX).toDouble();
    final eyeHeight = (maxY - minY).toDouble();
    if (eyeWidth < 4 || eyeHeight < 2) return null;

    final centerX = (minX + maxX) / 2.0;
    final centerY = (minY + maxY) / 2.0;
    final radiusX = math.max(eyeWidth / 2.0, 1.0);
    final radiusY = math.max(eyeHeight / 2.0, 1.0);

    var sampleCount = 0;
    var lumaSum = 0.0;
    var minLuma = 255.0;

    for (var y = minY; y <= maxY; y++) {
      for (var x = minX; x <= maxX; x++) {
        final dx = (x - centerX) / radiusX;
        final dy = (y - centerY) / radiusY;
        final normalizedRadius = dx * dx + dy * dy;
        if (normalizedRadius > 1.0 || dy.abs() > 0.82) continue;

        final byteIndex = y * rowStride + x;
        if (byteIndex < 0 || byteIndex >= luma.length) continue;

        final value = luma[byteIndex].toDouble();
        sampleCount++;
        lumaSum += value;
        if (value < minLuma) minLuma = value;
      }
    }

    if (sampleCount < 8) return null;

    final meanLuma = lumaSum / sampleCount;
    var weightSum = 0.0;
    var weightedX = 0.0;
    var weightedY = 0.0;

    for (var y = minY; y <= maxY; y++) {
      for (var x = minX; x <= maxX; x++) {
        final dx = (x - centerX) / radiusX;
        final dy = (y - centerY) / radiusY;
        final normalizedRadius = dx * dx + dy * dy;
        if (normalizedRadius > 1.0 || dy.abs() > 0.82) continue;

        final byteIndex = y * rowStride + x;
        if (byteIndex < 0 || byteIndex >= luma.length) continue;

        final darkness = meanLuma - luma[byteIndex].toDouble();
        if (darkness <= 4) continue;

        final edgeWeight = (1.0 - normalizedRadius * 0.35)
            .clamp(0.45, 1.0)
            .toDouble();
        final weight = darkness * darkness * edgeWeight;
        weightSum += weight;
        weightedX += x * weight;
        weightedY += y * weight;
      }
    }

    if (weightSum <= 0) return null;

    final pupilX = weightedX / weightSum;
    final pupilY = weightedY / weightSum;
    final ratioX = ((pupilX - minX) / eyeWidth).clamp(0.0, 1.0).toDouble();
    final ratioY = ((pupilY - minY) / eyeHeight).clamp(0.0, 1.0).toDouble();
    final contrast = ((meanLuma - minLuma) / 55.0).clamp(0.0, 1.0).toDouble();
    final support = (sampleCount / 80.0).clamp(0.0, 1.0).toDouble();
    final confidence = (contrast * 0.85 + support * 0.15)
        .clamp(0.0, 1.0)
        .toDouble();

    return _EyeSample(
      center: Offset(pupilX, pupilY),
      ratioX: ratioX,
      ratioY: ratioY,
      confidence: confidence,
    );
  }

  Rect? _eyeContourBounds(FaceContour? contour) {
    if (contour == null || contour.points.length < _minEyeContourPoints) {
      return null;
    }

    final points = contour.points;
    var minX = points.first.x.toDouble();
    var maxX = minX;
    var minY = points.first.y.toDouble();
    var maxY = minY;

    for (final point in points.skip(1)) {
      final px = point.x.toDouble();
      final py = point.y.toDouble();
      minX = math.min(minX, px);
      maxX = math.max(maxX, px);
      minY = math.min(minY, py);
      maxY = math.max(maxY, py);
    }

    if (maxX - minX < 4 || maxY - minY < 2) return null;
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  double _combinedPupilConfidence(
    _EyeSample? leftPupil,
    _EyeSample? rightPupil,
  ) {
    final samples = <_EyeSample>[
      if (leftPupil != null) leftPupil,
      if (rightPupil != null) rightPupil,
    ];
    if (samples.isEmpty) return 0.0;

    final total = samples.fold<double>(
      0.0,
      (sum, sample) => sum + sample.confidence,
    );
    return (total / samples.length).clamp(0.0, 1.0).toDouble();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Signal 3: Eye Asymmetry (lateral gaze)
  // ═══════════════════════════════════════════════════════════════════════════

  /// When looking left, the left and right pupil ratios diverge slightly.
  /// This signal only contributes as a small stabilizer.
  Map<String, double>? _eyeAsymmetryGaze(
    _EyeSample? leftPupil,
    _EyeSample? rightPupil,
  ) {
    if (leftPupil == null || rightPupil == null) return null;

    final confidence = math.min(leftPupil.confidence, rightPupil.confidence);
    if (confidence < _minPupilConfidence) return null;

    final asymmetry = leftPupil.ratioX - rightPupil.ratioX;
    final gazeX = 0.5 + asymmetry * 2.0;

    final verticalAverage = (leftPupil.ratioY + rightPupil.ratioY) / 2;
    final gazeY = 0.5 + (verticalAverage - 0.5) * 1.2;

    return {'x': gazeX.clamp(0.0, 1.0), 'y': gazeY.clamp(0.0, 1.0)};
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Quality Estimation
  // ═══════════════════════════════════════════════════════════════════════════

  double _computeFrameQuality(Face face, double pupilConfidence) {
    // 1. Head pose stability — better quality when more frontal.
    final yaw = (face.headEulerAngleY ?? 0).abs().toDouble();
    final pitch = (face.headEulerAngleX ?? 0).abs().toDouble();

    // Quadratic falloff: severe angles penalized more.
    final yawScore = math.pow(1.0 - (yaw / _maxYaw).clamp(0.0, 1.0), 1.5);
    final pitchScore = math.pow(1.0 - (pitch / _maxPitch).clamp(0.0, 1.0), 1.5);
    final poseScore = ((yawScore + pitchScore) / 2).toDouble();

    // 2. Eye visibility.
    final leftOpen = face.leftEyeOpenProbability ?? 0.5;
    final rightOpen = face.rightEyeOpenProbability ?? 0.5;
    if (leftOpen < _minEyeOpenProbability &&
        rightOpen < _minEyeOpenProbability) {
      return 0.0;
    }
    final eyeOpenScore = ((leftOpen + rightOpen) / 2).clamp(0.0, 1.0);

    // 3. Face size — larger face = closer = better data.
    final faceArea = face.boundingBox.width * face.boundingBox.height;
    final faceSizeScore = (faceArea / (300 * 300)).clamp(0.0, 1.0);

    // 4. Contour availability bonus.
    final hasLeftEye = _hasEnoughContourPoints(
      face.contours[FaceContourType.leftEye],
    );
    final hasRightEye = _hasEnoughContourPoints(
      face.contours[FaceContourType.rightEye],
    );
    final contourScore = (hasLeftEye && hasRightEye)
        ? 1.0
        : (hasLeftEye || hasRightEye)
        ? 0.6
        : 0.0;

    return (poseScore * 0.22 +
            eyeOpenScore * 0.20 +
            faceSizeScore * 0.13 +
            contourScore * 0.15 +
            pupilConfidence * 0.30)
        .clamp(0.0, 1.0)
        .toDouble();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Utilities
  // ═══════════════════════════════════════════════════════════════════════════

  Face _pickPrimaryFace(List<Face> faces) {
    return faces.reduce((current, next) {
      final currentArea =
          current.boundingBox.width.abs() * current.boundingBox.height.abs();
      final nextArea =
          next.boundingBox.width.abs() * next.boundingBox.height.abs();
      return currentArea >= nextArea ? current : next;
    });
  }

  bool _hasEnoughContourPoints(FaceContour? contour) {
    return contour != null && contour.points.length >= _minEyeContourPoints;
  }

  Offset? _resolveEyeCenter(Offset? leftEye, Offset? rightEye) {
    if (leftEye != null && rightEye != null) {
      return Offset(
        (leftEye.dx + rightEye.dx) / 2,
        (leftEye.dy + rightEye.dy) / 2,
      );
    }
    return leftEye ?? rightEye;
  }

  Map<String, double> _normalizePreviewCoordinates(
    double rawX,
    double rawY,
    CameraImage image,
    CameraDescription camera,
  ) {
    final bufW = image.width.toDouble();
    final bufH = image.height.toDouble();
    final sensorAngle = camera.sensorOrientation;

    double normX;
    double normY;

    switch (sensorAngle) {
      case 90:
        normX = rawY / bufH;
        normY = 1.0 - (rawX / bufW);
        break;
      case 270:
        normX = 1.0 - (rawY / bufH);
        normY = rawX / bufW;
        break;
      case 180:
        normX = 1.0 - (rawX / bufW);
        normY = 1.0 - (rawY / bufH);
        break;
      default:
        normX = rawX / bufW;
        normY = rawY / bufH;
    }

    if (camera.lensDirection == CameraLensDirection.front) {
      normX = 1.0 - normX;
    }

    return {'x': normX.clamp(0.0, 1.0), 'y': normY.clamp(0.0, 1.0)};
  }

  InputImage? _toInputImage(CameraImage image, CameraDescription camera) {
    final rotation = InputImageRotationValue.fromRawValue(
      camera.sensorOrientation,
    );
    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    if (rotation == null || format == null) return null;

    return InputImage.fromBytes(
      bytes: image.planes.first.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Adaptive 1€ Filter — much better than simple EMA for gaze smoothing.
// Reduces jitter at rest while preserving fast movements.
// Based on: Casiez et al., "1€ Filter", CHI 2012
// ═════════════════════════════════════════════════════════════════════════════

class _EyeSample {
  final Offset center;
  final double ratioX;
  final double ratioY;
  final double confidence;

  const _EyeSample({
    required this.center,
    required this.ratioX,
    required this.ratioY,
    required this.confidence,
  });
}

class _OneEuroFilter {
  final double _minCutoff;
  final double _beta;
  final double _dCutoff;

  double? _prevValue;
  double? _prevDerivative;
  int? _prevTimestampUs;

  _OneEuroFilter({
    double minCutoff = 1.0,
    double beta = 0.007,
    double dCutoff = 1.0,
  }) : _minCutoff = minCutoff,
       _beta = beta,
       _dCutoff = dCutoff;

  double filter(double value, int timestampUs) {
    if (_prevTimestampUs == null || _prevValue == null) {
      _prevValue = value;
      _prevDerivative = 0.0;
      _prevTimestampUs = timestampUs;
      return value;
    }

    final dtUs = timestampUs - _prevTimestampUs!;
    final dt = dtUs > 0 ? dtUs / 1e6 : 1.0 / 30.0; // default 30fps

    // Derivative (speed of change)
    final derivative = (value - _prevValue!) / dt;
    final alphaD = _smoothingAlpha(dt, _dCutoff);
    final smoothDerivative =
        alphaD * derivative + (1 - alphaD) * (_prevDerivative ?? 0);

    // Adaptive cutoff: increases with speed → less smoothing during fast moves
    final cutoff = _minCutoff + _beta * smoothDerivative.abs();
    final alpha = _smoothingAlpha(dt, cutoff);

    final result = alpha * value + (1 - alpha) * _prevValue!;

    _prevValue = result;
    _prevDerivative = smoothDerivative;
    _prevTimestampUs = timestampUs;

    return result;
  }

  double _smoothingAlpha(double dt, double cutoff) {
    final tau = 1.0 / (2 * math.pi * cutoff);
    return 1.0 / (1.0 + tau / dt);
  }

  void reset() {
    _prevValue = null;
    _prevDerivative = null;
    _prevTimestampUs = null;
  }
}

/// Adaptive gaze smoother using One-Euro filters for X and Y independently.
/// Much better than the old simple moving-average + EMA combination:
/// - Low jitter when the gaze is stationary
/// - Low latency when the gaze moves quickly
class GazeSmoother {
  final _OneEuroFilter _filterX;
  final _OneEuroFilter _filterY;

  // Kept for compatibility but not used internally
  final int bufferSize;

  GazeSmoother({this.bufferSize = 5})
    : _filterX = _OneEuroFilter(minCutoff: 1.2, beta: 0.5, dCutoff: 1.0),
      _filterY = _OneEuroFilter(minCutoff: 1.2, beta: 0.5, dCutoff: 1.0);

  Map<String, double> addPoint(double normX, double normY) {
    final now = DateTime.now().microsecondsSinceEpoch;
    return {'x': _filterX.filter(normX, now), 'y': _filterY.filter(normY, now)};
  }

  void reset() {
    _filterX.reset();
    _filterY.reset();
  }
}
