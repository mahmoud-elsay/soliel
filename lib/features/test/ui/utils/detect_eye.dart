import 'dart:math' as math;
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

/// Multi-signal gaze estimator designed for mobile ML Kit.
///
/// Combines three independent gaze signals:
///   1. **Head Pose** (primary) — yaw/pitch from ML Kit Euler angles
///   2. **Iris Position** — contour centroid position relative to eye corners
///   3. **Eye Asymmetry** — difference between left/right eye iris ratios
///
/// This approach mirrors how research gaze-estimation models (e.g. GazeCapture,
/// iTracker) decompose the problem, adapted for ML Kit's available signals.
class EyeDetector {
  // ── Quality gate thresholds ────────────────────────────────────────────────
  static const double _maxYaw = 35;
  static const double _maxPitch = 30;
  static const double _minEyeOpenProbability = 0.30;
  static const int _minEyeContourPoints = 4;

  // ── Gaze model signal weights ──────────────────────────────────────────────
  /// Head pose is the dominant signal on mobile — children turn toward stimuli.
  static const double _headPoseWeight = 0.55;

  /// Iris-in-aperture position is the secondary signal.
  static const double _irisPositionWeight = 0.30;

  /// Left/right eye asymmetry captures lateral gaze shifts.
  static const double _eyeAsymmetryWeight = 0.15;

  // ── Head-pose → gaze mapping ───────────────────────────────────────────────
  /// The full angular range mapped to [0..1] gaze.
  /// Yaw range of ±25° maps to full horizontal gaze.
  static const double _yawRangeDeg = 25.0;

  /// Pitch range of ±20° maps to full vertical gaze.
  static const double _pitchRangeDeg = 20.0;

  // ── Iris position scaling ──────────────────────────────────────────────────
  /// How much to amplify small iris-ratio deviations from center.
  /// Higher = more sensitive to small eye movements.
  static const double _irisHorizontalGain = 2.5;
  static const double _irisVerticalGain = 2.0;

  final FaceDetector _faceDetector;

  EyeDetector()
    : _faceDetector = FaceDetector(
        options: FaceDetectorOptions(
          enableContours: true,
          enableClassification: true,
          enableLandmarks: true,
          enableTracking: true,
          performanceMode: FaceDetectorMode.accurate,
          minFaceSize: 0.15,
        ),
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // Public API
  // ═══════════════════════════════════════════════════════════════════════════

  Future<Map<String, double>?> detectGazePoint(
    CameraImage image,
    CameraDescription camera,
  ) async {
    try {
      final inputImage = _toInputImage(image, camera);
      if (inputImage == null) return null;

      final faces = await _faceDetector.processImage(inputImage);
      if (faces.isEmpty) return null;

      final face = _pickPrimaryFace(faces);

      // Soft quality: compute quality but only gate on extreme failures
      final quality = _computeFrameQuality(face);
      if (quality <= 0.05) return null;

      final leftContour = face.contours[FaceContourType.leftEye];
      final rightContour = face.contours[FaceContourType.rightEye];

      // Must have at least one eye with enough contour points
      final hasLeft = _hasEnoughContourPoints(leftContour);
      final hasRight = _hasEnoughContourPoints(rightContour);
      if (!hasLeft && !hasRight) return null;

      // ── Compute the three gaze signals ───────────────────────────────────
      final headGaze = _headPoseGaze(face);
      final irisGaze = _irisPositionGaze(leftContour, rightContour, face);
      final asymmetryGaze = _eyeAsymmetryGaze(leftContour, rightContour);

      // ── Weighted fusion ──────────────────────────────────────────────────
      double totalWeight = 0;
      double gazeX = 0;
      double gazeY = 0;

      if (headGaze != null) {
        gazeX += headGaze['x']! * _headPoseWeight;
        gazeY += headGaze['y']! * _headPoseWeight;
        totalWeight += _headPoseWeight;
      }

      if (irisGaze != null) {
        gazeX += irisGaze['x']! * _irisPositionWeight;
        gazeY += irisGaze['y']! * _irisPositionWeight;
        totalWeight += _irisPositionWeight;
      }

      if (asymmetryGaze != null) {
        gazeX += asymmetryGaze['x']! * _eyeAsymmetryWeight;
        gazeY += asymmetryGaze['y']! * _eyeAsymmetryWeight;
        totalWeight += _eyeAsymmetryWeight;
      }

      if (totalWeight <= 0) return null;
      gazeX /= totalWeight;
      gazeY /= totalWeight;

      // Front camera mirror correction
      if (camera.lensDirection == CameraLensDirection.front) {
        gazeX = 1.0 - gazeX;
      }

      gazeX = gazeX.clamp(0.0, 1.0);
      gazeY = gazeY.clamp(0.0, 1.0);

      // Preview coordinates for scan path visualization
      final eyeCenter = _resolveEyeCenter(
        _contourCenter(leftContour),
        _contourCenter(rightContour),
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
  // Signal 2: Iris Position within Eye Aperture
  // ═══════════════════════════════════════════════════════════════════════════

  /// Estimates gaze from the position of the contour centroid (iris proxy)
  /// relative to the eye corners (aperture boundaries).
  ///
  /// When looking left, the iris shifts toward the left eye corner,
  /// changing the centroid-to-corner ratio.
  Map<String, double>? _irisPositionGaze(
    FaceContour? leftContour,
    FaceContour? rightContour,
    Face face,
  ) {
    final leftRatio = _irisRatioInEye(leftContour);
    final rightRatio = _irisRatioInEye(rightContour);

    if (leftRatio == null && rightRatio == null) return null;

    double irisRatioX;
    double irisRatioY;

    if (leftRatio != null && rightRatio != null) {
      // Average both eyes for stability
      irisRatioX = (leftRatio['x']! + rightRatio['x']!) / 2;
      irisRatioY = (leftRatio['y']! + rightRatio['y']!) / 2;
    } else {
      final r = leftRatio ?? rightRatio!;
      irisRatioX = r['x']!;
      irisRatioY = r['y']!;
    }

    // The ratio is 0..1 where 0.5 = centered. Amplify deviations.
    final gazeX = 0.5 + (irisRatioX - 0.5) * _irisHorizontalGain;
    final gazeY = 0.5 + (irisRatioY - 0.5) * _irisVerticalGain;

    return {'x': gazeX.clamp(0.0, 1.0), 'y': gazeY.clamp(0.0, 1.0)};
  }

  /// Computes the iris position ratio within a single eye's aperture.
  /// Returns {'x': 0..1, 'y': 0..1} where 0.5 means centered.
  Map<String, double>? _irisRatioInEye(FaceContour? contour) {
    if (contour == null || contour.points.length < _minEyeContourPoints) {
      return null;
    }

    final points = contour.points;

    // Find bounding extremes of the eye contour
    double minX = points.first.x.toDouble();
    double maxX = minX;
    double minY = points.first.y.toDouble();
    double maxY = minY;

    double sumX = 0;
    double sumY = 0;

    for (final p in points) {
      final px = p.x.toDouble();
      final py = p.y.toDouble();
      if (px < minX) minX = px;
      if (px > maxX) maxX = px;
      if (py < minY) minY = py;
      if (py > maxY) maxY = py;
      sumX += px;
      sumY += py;
    }

    final width = maxX - minX;
    final height = maxY - minY;
    if (width < 2 || height < 1) return null;

    // Centroid of the contour ≈ visible center of the eye opening ≈ iris proxy
    final centroidX = sumX / points.length;
    final centroidY = sumY / points.length;

    // Where is the centroid within the bounding box?
    final ratioX = (centroidX - minX) / width;
    final ratioY = (centroidY - minY) / height;

    return {'x': ratioX, 'y': ratioY};
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Signal 3: Eye Asymmetry (lateral gaze)
  // ═══════════════════════════════════════════════════════════════════════════

  /// When looking left, the left eye's iris shifts more toward its nasal
  /// corner than the right eye's, creating a measurable asymmetry.
  /// This signal only contributes to horizontal gaze.
  Map<String, double>? _eyeAsymmetryGaze(
    FaceContour? leftContour,
    FaceContour? rightContour,
  ) {
    final leftRatio = _irisRatioInEye(leftContour);
    final rightRatio = _irisRatioInEye(rightContour);

    if (leftRatio == null || rightRatio == null) return null;

    // Asymmetry: if both eyes look the same direction, their ratios diverge
    // (one iris shifts nasal, the other temporal).
    // The difference captures pure gaze shift independent of head pose.
    final asymmetry = leftRatio['x']! - rightRatio['x']!;

    // Amplify and map to [0,1]
    final gazeX = 0.5 + asymmetry * 3.0;

    // Vertical asymmetry is less useful, center it
    final vertAsymmetry = (leftRatio['y']! + rightRatio['y']!) / 2;
    final gazeY = 0.5 + (vertAsymmetry - 0.5) * 1.5;

    return {'x': gazeX.clamp(0.0, 1.0), 'y': gazeY.clamp(0.0, 1.0)};
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Quality Estimation
  // ═══════════════════════════════════════════════════════════════════════════

  double _computeFrameQuality(Face face) {
    // 1. Head pose stability — better quality when more frontal
    final yaw = (face.headEulerAngleY ?? 0).abs().toDouble();
    final pitch = (face.headEulerAngleX ?? 0).abs().toDouble();

    // Quadratic falloff: severe angles penalized more
    final yawScore = math.pow(1.0 - (yaw / _maxYaw).clamp(0.0, 1.0), 1.5);
    final pitchScore = math.pow(1.0 - (pitch / _maxPitch).clamp(0.0, 1.0), 1.5);
    final poseScore = (yawScore + pitchScore) / 2;

    // 2. Eye visibility
    final leftOpen = face.leftEyeOpenProbability ?? 0.5;
    final rightOpen = face.rightEyeOpenProbability ?? 0.5;
    if (leftOpen < _minEyeOpenProbability &&
        rightOpen < _minEyeOpenProbability) {
      return 0.0;
    }
    final eyeOpenScore = ((leftOpen + rightOpen) / 2).clamp(0.0, 1.0);

    // 3. Face size — larger face = closer = better data
    final faceArea = face.boundingBox.width * face.boundingBox.height;
    // Assume 150×150 px is minimum useful, 400×400 is ideal
    final faceSizeScore = (faceArea / (300 * 300)).clamp(0.0, 1.0);

    // 4. Contour availability bonus
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

    return (poseScore * 0.30 +
            eyeOpenScore * 0.30 +
            faceSizeScore * 0.20 +
            contourScore * 0.20)
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

  Offset? _contourCenter(FaceContour? contour) {
    if (contour == null || contour.points.isEmpty) return null;

    var sumX = 0.0;
    var sumY = 0.0;
    for (final point in contour.points) {
      sumX += point.x.toDouble();
      sumY += point.y.toDouble();
    }
    return Offset(sumX / contour.points.length, sumY / contour.points.length);
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
