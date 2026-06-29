import 'dart:math' as math;
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:soliel/features/test/ui/vision/camera/image_converter.dart';
import 'package:soliel/features/test/ui/vision/models/vision_frame.dart';
import 'package:soliel/features/test/ui/vision/processing/quality_analyzer.dart';

class GazeEstimator {
  static const int _minEyeContourPoints = 6;
  static const double _yawRangeDeg = 24;
  static const double _pitchRangeDeg = 20;
  static const double _pupilHorizontalGain = 1.6;
  static const double _pupilVerticalGain = 1.35;

  final CameraImageConverter _converter;
  final FrameQualityAnalyzer _qualityAnalyzer;

  GazeEstimator({
    required CameraImageConverter converter,
    required FrameQualityAnalyzer qualityAnalyzer,
  }) : _converter = converter,
       _qualityAnalyzer = qualityAnalyzer;

  VisionFrame estimate({
    required Face face,
    required int faceCount,
    required ConvertedCameraImage image,
    required CameraDescription camera,
    required int timestampMs,
    VisionFrame? previousFrame,
  }) {
    final leftContour = face.contours[FaceContourType.leftEye];
    final rightContour = face.contours[FaceContourType.rightEye];
    final leftContourPoints = leftContour?.points.length ?? 0;
    final rightContourPoints = rightContour?.points.length ?? 0;
    final quality = _qualityAnalyzer.analyze(
      face: face,
      imageSize: image.size,
      leftEyeContourPoints: leftContourPoints,
      rightEyeContourPoints: rightContourPoints,
    );

    final normalizedFaceRect = _converter.normalizeImageRect(
      face.boundingBox,
      image,
      camera,
    );

    final headSignal = _headPoseSignal(face);
    final landmarkSignal = _landmarkSignal(face, image, camera);
    final leftPupil = _pupilSample(leftContour, image);
    final rightPupil = _pupilSample(rightContour, image);
    final pupilConfidence = _combinedPupilConfidence(leftPupil, rightPupil);
    final pupilSignal = _pupilSignal(leftPupil, rightPupil, pupilConfidence);
    final contourSignal = _contourSignal(leftContour, rightContour);
    final historySignal = _historySignal(previousFrame, timestampMs);

    final signals = <_GazeSignal>[
      if (headSignal != null)
        headSignal.weighted(0.56 * quality.poseConfidence),
      if (landmarkSignal != null)
        landmarkSignal.weighted(
          headSignal == null
              ? 0.34 * quality.landmarkConfidence
              : 0.14 * quality.landmarkConfidence,
        ),
      if (pupilSignal != null)
        pupilSignal.weighted(
          (headSignal == null ? 0.38 : 0.24) * pupilConfidence,
        ),
      if (contourSignal != null)
        contourSignal.weighted(
          (headSignal == null && pupilSignal == null ? 0.22 : 0.08) *
              quality.contourConfidence,
        ),
      if (historySignal != null) historySignal.weighted(0.12),
    ].where((signal) => signal.weight > 0).toList(growable: false);

    if (signals.isEmpty) {
      final faceCenter = _converter.normalizeImagePoint(
        Offset(face.boundingBox.center.dx, face.boundingBox.center.dy),
        image,
        camera,
      );
      signals.add(_GazeSignal(point: faceCenter, weight: 0.1));
    }

    final fused = _fuse(signals);
    var gazeX = fused.dx;
    var gazeY = fused.dy;
    if (camera.lensDirection == CameraLensDirection.front) {
      gazeX = 1.0 - gazeX;
    }

    final leftEyeCenter = _landmarkPoint(face, FaceLandmarkType.leftEye);
    final rightEyeCenter = _landmarkPoint(face, FaceLandmarkType.rightEye);
    final previewPoint = _previewPoint(
      landmarkSignal: landmarkSignal,
      leftPupil: leftPupil,
      rightPupil: rightPupil,
      image: image,
      camera: camera,
      fallback: Offset(gazeX, gazeY),
    );

    final confidence =
        (quality.quality * 0.48 +
                quality.poseConfidence * (headSignal == null ? 0.0 : 0.22) +
                quality.landmarkConfidence *
                    (landmarkSignal == null ? 0.0 : 0.12) +
                pupilConfidence * (pupilSignal == null ? 0.0 : 0.18))
            .clamp(0.05, 1.0)
            .toDouble();

    return VisionFrame(
      timestampMs: timestampMs,
      hasFace: true,
      gaze: Offset(
        gazeX.clamp(0.0, 1.0).toDouble(),
        gazeY.clamp(0.0, 1.0).toDouble(),
      ),
      previewPoint: previewPoint,
      confidence: confidence,
      quality: quality.quality,
      faceConfidence: quality.faceConfidence,
      headPoseConfidence: quality.poseConfidence,
      landmarkConfidence: quality.landmarkConfidence,
      contourConfidence: quality.contourConfidence,
      pupilConfidence: pupilConfidence,
      faceCount: faceCount,
      leftEyeContourPoints: leftContourPoints,
      rightEyeContourPoints: rightContourPoints,
      usedHeadPose: headSignal != null,
      usedLandmarks: landmarkSignal != null,
      usedContours: pupilSignal != null || contourSignal != null,
      usedHistory: historySignal != null,
      headPose: HeadPose(
        yaw: face.headEulerAngleY,
        pitch: face.headEulerAngleX,
        roll: face.headEulerAngleZ,
      ),
      faceRect: normalizedFaceRect,
      leftEyeContour: _normalizeContour(leftContour, image, camera),
      rightEyeContour: _normalizeContour(rightContour, image, camera),
      leftEyeCenter: leftEyeCenter == null
          ? null
          : _converter.normalizeImagePoint(leftEyeCenter, image, camera),
      rightEyeCenter: rightEyeCenter == null
          ? null
          : _converter.normalizeImagePoint(rightEyeCenter, image, camera),
      leftPupil: leftPupil == null
          ? null
          : _converter.normalizeImagePoint(leftPupil.center, image, camera),
      rightPupil: rightPupil == null
          ? null
          : _converter.normalizeImagePoint(rightPupil.center, image, camera),
      rejectionReason: null,
    );
  }

  _GazeSignal? _headPoseSignal(Face face) {
    final yaw = face.headEulerAngleY;
    final pitch = face.headEulerAngleX;
    if (yaw == null || pitch == null) return null;

    return _GazeSignal(
      point: Offset(
        (0.5 + (yaw / _yawRangeDeg) * 0.5).clamp(0.0, 1.0).toDouble(),
        (0.5 - (pitch / _pitchRangeDeg) * 0.5).clamp(0.0, 1.0).toDouble(),
      ),
      weight: 1,
    );
  }

  _GazeSignal? _landmarkSignal(
    Face face,
    ConvertedCameraImage image,
    CameraDescription camera,
  ) {
    final leftEye = _landmarkPoint(face, FaceLandmarkType.leftEye);
    final rightEye = _landmarkPoint(face, FaceLandmarkType.rightEye);
    if (leftEye == null && rightEye == null) return null;

    final eyeCenter = _averagePoints(leftEye, rightEye)!;
    final normalized = _converter.normalizeImagePoint(eyeCenter, image, camera);

    return _GazeSignal(point: normalized, weight: 1);
  }

  _GazeSignal? _pupilSignal(
    _EyeSample? leftPupil,
    _EyeSample? rightPupil,
    double pupilConfidence,
  ) {
    if (pupilConfidence <= 0) return null;

    final samples = <_EyeSample>[
      if (leftPupil != null) leftPupil,
      if (rightPupil != null) rightPupil,
    ];
    if (samples.isEmpty) return null;

    var total = 0.0;
    var x = 0.0;
    var y = 0.0;
    for (final sample in samples) {
      final weight = math.max(sample.confidence, 0.01);
      total += weight;
      x += sample.ratioX * weight;
      y += sample.ratioY * weight;
    }
    if (total <= 0) return null;

    final ratioX = x / total;
    final ratioY = y / total;

    return _GazeSignal(
      point: Offset(
        (0.5 + (ratioX - 0.5) * _pupilHorizontalGain)
            .clamp(0.0, 1.0)
            .toDouble(),
        (0.5 + (ratioY - 0.5) * _pupilVerticalGain).clamp(0.0, 1.0).toDouble(),
      ),
      weight: 1,
    );
  }

  _GazeSignal? _contourSignal(
    FaceContour? leftContour,
    FaceContour? rightContour,
  ) {
    final leftRatio = _contourCenterRatio(leftContour);
    final rightRatio = _contourCenterRatio(rightContour);
    if (leftRatio == null && rightRatio == null) return null;

    final ratio = _averageOffsets(leftRatio, rightRatio)!;
    return _GazeSignal(
      point: Offset(
        (0.5 + (ratio.dx - 0.5) * 0.9).clamp(0.0, 1.0).toDouble(),
        (0.5 + (ratio.dy - 0.5) * 0.8).clamp(0.0, 1.0).toDouble(),
      ),
      weight: 1,
    );
  }

  _GazeSignal? _historySignal(VisionFrame? previousFrame, int timestampMs) {
    if (previousFrame?.gaze == null) return null;
    final ageMs = timestampMs - previousFrame!.timestampMs;
    if (ageMs < 0 || ageMs > 450) return null;

    final confidence = previousFrame.confidence * (1.0 - ageMs / 550);
    if (confidence <= 0.05) return null;
    return _GazeSignal(point: previousFrame.gaze!, weight: confidence);
  }

  Offset _fuse(List<_GazeSignal> signals) {
    var total = 0.0;
    var x = 0.0;
    var y = 0.0;

    for (final signal in signals) {
      total += signal.weight;
      x += signal.point.dx * signal.weight;
      y += signal.point.dy * signal.weight;
    }

    if (total <= 0) return const Offset(0.5, 0.5);
    return Offset(x / total, y / total);
  }

  Offset _previewPoint({
    required _GazeSignal? landmarkSignal,
    required _EyeSample? leftPupil,
    required _EyeSample? rightPupil,
    required ConvertedCameraImage image,
    required CameraDescription camera,
    required Offset fallback,
  }) {
    final pupilCenter = _averagePoints(leftPupil?.center, rightPupil?.center);
    if (pupilCenter != null) {
      return _converter.normalizeImagePoint(pupilCenter, image, camera);
    }

    return landmarkSignal?.point ?? fallback;
  }

  _EyeSample? _pupilSample(FaceContour? contour, ConvertedCameraImage image) {
    final bounds = _eyeContourBounds(contour);
    if (bounds == null) return null;

    final minX = math.max(0, bounds.left.floor());
    final maxX = math.min(image.width - 1, bounds.right.ceil());
    final minY = math.max(0, bounds.top.floor());
    final maxY = math.min(image.height - 1, bounds.bottom.ceil());

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
        final radius = dx * dx + dy * dy;
        if (radius > 1.0 || dy.abs() > 0.86) continue;

        final byteIndex = y * image.lumaRowStride + x;
        if (byteIndex < 0 || byteIndex >= image.lumaBytes.length) continue;

        final value = image.lumaBytes[byteIndex].toDouble();
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
        final radius = dx * dx + dy * dy;
        if (radius > 1.0 || dy.abs() > 0.86) continue;

        final byteIndex = y * image.lumaRowStride + x;
        if (byteIndex < 0 || byteIndex >= image.lumaBytes.length) continue;

        final darkness = meanLuma - image.lumaBytes[byteIndex].toDouble();
        if (darkness <= 3.5) continue;

        final weight =
            darkness * darkness * (1.0 - radius * 0.30).clamp(0.50, 1.0);
        weightSum += weight;
        weightedX += x * weight;
        weightedY += y * weight;
      }
    }

    if (weightSum <= 0) return null;

    final pupilX = weightedX / weightSum;
    final pupilY = weightedY / weightSum;
    final contrast = ((meanLuma - minLuma) / 48.0).clamp(0.0, 1.0).toDouble();
    final support = (sampleCount / 70.0).clamp(0.0, 1.0).toDouble();

    return _EyeSample(
      center: Offset(pupilX, pupilY),
      ratioX: ((pupilX - minX) / eyeWidth).clamp(0.0, 1.0).toDouble(),
      ratioY: ((pupilY - minY) / eyeHeight).clamp(0.0, 1.0).toDouble(),
      confidence: (contrast * 0.82 + support * 0.18).clamp(0.0, 1.0).toDouble(),
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
      final x = point.x.toDouble();
      final y = point.y.toDouble();
      minX = math.min(minX, x);
      maxX = math.max(maxX, x);
      minY = math.min(minY, y);
      maxY = math.max(maxY, y);
    }

    if (maxX - minX < 4 || maxY - minY < 2) return null;
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  Offset? _contourCenterRatio(FaceContour? contour) {
    final bounds = _eyeContourBounds(contour);
    if (bounds == null || contour == null) return null;

    var x = 0.0;
    var y = 0.0;
    for (final point in contour.points) {
      x += point.x;
      y += point.y;
    }
    final center = Offset(x / contour.points.length, y / contour.points.length);
    return Offset(
      ((center.dx - bounds.left) / bounds.width).clamp(0.0, 1.0).toDouble(),
      ((center.dy - bounds.top) / bounds.height).clamp(0.0, 1.0).toDouble(),
    );
  }

  List<Offset> _normalizeContour(
    FaceContour? contour,
    ConvertedCameraImage image,
    CameraDescription camera,
  ) {
    if (contour == null || contour.points.isEmpty) return const [];

    return contour.points
        .map(
          (point) => _converter.normalizeImagePoint(
            Offset(point.x.toDouble(), point.y.toDouble()),
            image,
            camera,
          ),
        )
        .toList(growable: false);
  }

  Offset? _landmarkPoint(Face face, FaceLandmarkType type) {
    final landmark = face.landmarks[type];
    if (landmark == null) return null;
    return Offset(
      landmark.position.x.toDouble(),
      landmark.position.y.toDouble(),
    );
  }

  Offset? _averagePoints(Offset? a, Offset? b) {
    if (a != null && b != null) {
      return Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
    }
    return a ?? b;
  }

  Offset? _averageOffsets(Offset? a, Offset? b) {
    if (a != null && b != null) {
      return Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
    }
    return a ?? b;
  }

  double _combinedPupilConfidence(_EyeSample? left, _EyeSample? right) {
    final samples = <_EyeSample>[
      if (left != null) left,
      if (right != null) right,
    ];
    if (samples.isEmpty) return 0.0;

    return (samples.fold<double>(0, (sum, sample) => sum + sample.confidence) /
            samples.length)
        .clamp(0.0, 1.0)
        .toDouble();
  }
}

class _GazeSignal {
  final Offset point;
  final double weight;

  const _GazeSignal({required this.point, required this.weight});

  _GazeSignal weighted(double newWeight) {
    return _GazeSignal(point: point, weight: weight * newWeight);
  }
}

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
