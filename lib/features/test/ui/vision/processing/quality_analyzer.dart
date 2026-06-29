import 'dart:math' as math;
import 'dart:ui';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FrameQuality {
  final double quality;
  final double faceConfidence;
  final double poseConfidence;
  final double eyeOpenConfidence;
  final double contourConfidence;
  final double landmarkConfidence;

  const FrameQuality({
    required this.quality,
    required this.faceConfidence,
    required this.poseConfidence,
    required this.eyeOpenConfidence,
    required this.contourConfidence,
    required this.landmarkConfidence,
  });

  bool get isObviouslyUnusable => false;
}

class FrameQualityAnalyzer {
  static const double _minUsableFaceAreaRatio = 0.006;
  static const double _idealFaceAreaRatio = 0.16;
  static const double _maxYaw = 80;
  static const double _maxPitch = 70;
  static const double _maxRoll = 70;

  FrameQuality analyze({
    required Face face,
    required Size imageSize,
    required int leftEyeContourPoints,
    required int rightEyeContourPoints,
  }) {
    final imageArea = imageSize.width * imageSize.height;
    final faceArea =
        face.boundingBox.width.abs() * face.boundingBox.height.abs();
    final areaRatio = imageArea <= 0 ? 0.0 : faceArea / imageArea;

    final yaw = (face.headEulerAngleY ?? 0).abs().toDouble();
    final pitch = (face.headEulerAngleX ?? 0).abs().toDouble();
    final roll = (face.headEulerAngleZ ?? 0).abs().toDouble();

    final leftEyeOpen = face.leftEyeOpenProbability;
    final rightEyeOpen = face.rightEyeOpenProbability;
    final bothEyesClearlyClosed =
        leftEyeOpen != null &&
        rightEyeOpen != null &&
        leftEyeOpen < 0.08 &&
        rightEyeOpen < 0.08;


    if (areaRatio < _minUsableFaceAreaRatio) {
      // Soft penalty instead of rejection
    } else if (yaw > _maxYaw || pitch > _maxPitch || roll > _maxRoll) {
      // Soft penalty instead of rejection
    } else if (bothEyesClearlyClosed) {
      // Soft penalty instead of rejection
    }

    final faceConfidence = (areaRatio / _idealFaceAreaRatio)
        .clamp(0.0, 1.0)
        .toDouble();
    final yawScore = _angleScore(yaw, _maxYaw);
    final pitchScore = _angleScore(pitch, _maxPitch);
    final rollScore = _angleScore(roll, _maxRoll);
    final poseConfidence =
        ((yawScore * 0.45) + (pitchScore * 0.40) + (rollScore * 0.15))
            .clamp(0.0, 1.0)
            .toDouble();

    final eyeOpenConfidence = _eyeOpenScore(leftEyeOpen, rightEyeOpen);
    final contourConfidence =
        ((math.min(leftEyeContourPoints, 16) / 16) * 0.5 +
                (math.min(rightEyeContourPoints, 16) / 16) * 0.5)
            .clamp(0.0, 1.0)
            .toDouble();
    final landmarkConfidence = _landmarkScore(face);

    final quality =
        (faceConfidence * 0.24 +
                poseConfidence * 0.28 +
                eyeOpenConfidence * 0.18 +
                contourConfidence * 0.18 +
                landmarkConfidence * 0.12)
            .clamp(0.0, 1.0)
            .toDouble();

    return FrameQuality(
      quality: quality.clamp(0.0, 1.0).toDouble(),
      faceConfidence: faceConfidence,
      poseConfidence: poseConfidence,
      eyeOpenConfidence: eyeOpenConfidence,
      contourConfidence: contourConfidence,
      landmarkConfidence: landmarkConfidence,
    );
  }

  double _angleScore(double value, double maxValue) {
    return math.pow(1.0 - (value / maxValue).clamp(0.0, 1.0), 1.4).toDouble();
  }

  double _eyeOpenScore(double? leftEyeOpen, double? rightEyeOpen) {
    if (leftEyeOpen == null && rightEyeOpen == null) return 0.55;
    if (leftEyeOpen == null) return rightEyeOpen!.clamp(0.0, 1.0);
    if (rightEyeOpen == null) return leftEyeOpen.clamp(0.0, 1.0);

    return ((leftEyeOpen + rightEyeOpen) / 2).clamp(0.0, 1.0).toDouble();
  }

  double _landmarkScore(Face face) {
    final hasLeft = face.landmarks[FaceLandmarkType.leftEye] != null;
    final hasRight = face.landmarks[FaceLandmarkType.rightEye] != null;
    final hasNose = face.landmarks[FaceLandmarkType.noseBase] != null;

    return ((hasLeft ? 0.35 : 0.0) +
            (hasRight ? 0.35 : 0.0) +
            (hasNose ? 0.30 : 0.0))
        .clamp(0.0, 1.0)
        .toDouble();
  }
}
