import 'dart:ui';

class HeadPose {
  final double? yaw;
  final double? pitch;
  final double? roll;

  const HeadPose({this.yaw, this.pitch, this.roll});

  bool get hasAny => yaw != null || pitch != null || roll != null;
}

class VisionFrame {
  final int timestampMs;
  final bool hasFace;
  final Offset? gaze;
  final Offset? previewPoint;
  final double confidence;
  final double quality;
  final double faceConfidence;
  final double headPoseConfidence;
  final double landmarkConfidence;
  final double contourConfidence;
  final double pupilConfidence;
  final int faceCount;
  final int leftEyeContourPoints;
  final int rightEyeContourPoints;
  final bool usedHeadPose;
  final bool usedLandmarks;
  final bool usedContours;
  final bool usedHistory;
  final HeadPose headPose;
  final Rect? faceRect;
  final List<Offset> leftEyeContour;
  final List<Offset> rightEyeContour;
  final Offset? leftEyeCenter;
  final Offset? rightEyeCenter;
  final Offset? leftPupil;
  final Offset? rightPupil;
  final String? rejectionReason;

  const VisionFrame({
    required this.timestampMs,
    required this.hasFace,
    required this.gaze,
    required this.previewPoint,
    required this.confidence,
    required this.quality,
    required this.faceConfidence,
    required this.headPoseConfidence,
    required this.landmarkConfidence,
    required this.contourConfidence,
    required this.pupilConfidence,
    required this.faceCount,
    required this.leftEyeContourPoints,
    required this.rightEyeContourPoints,
    required this.usedHeadPose,
    required this.usedLandmarks,
    required this.usedContours,
    required this.usedHistory,
    required this.headPose,
    required this.faceRect,
    required this.leftEyeContour,
    required this.rightEyeContour,
    required this.leftEyeCenter,
    required this.rightEyeCenter,
    required this.leftPupil,
    required this.rightPupil,
    required this.rejectionReason,
  });

  factory VisionFrame.rejected({
    required int timestampMs,
    required String reason,
    bool hasFace = false,
    int faceCount = 0,
    double quality = 0,
    double confidence = 0,
    Rect? faceRect,
  }) {
    return VisionFrame(
      timestampMs: timestampMs,
      hasFace: hasFace,
      gaze: null,
      previewPoint: null,
      confidence: confidence,
      quality: quality,
      faceConfidence: hasFace ? confidence : 0,
      headPoseConfidence: 0,
      landmarkConfidence: 0,
      contourConfidence: 0,
      pupilConfidence: 0,
      faceCount: faceCount,
      leftEyeContourPoints: 0,
      rightEyeContourPoints: 0,
      usedHeadPose: false,
      usedLandmarks: false,
      usedContours: false,
      usedHistory: false,
      headPose: const HeadPose(),
      faceRect: faceRect,
      leftEyeContour: const [],
      rightEyeContour: const [],
      leftEyeCenter: null,
      rightEyeCenter: null,
      leftPupil: null,
      rightPupil: null,
      rejectionReason: reason,
    );
  }

  bool get isUsable => gaze != null && rejectionReason == null;

  VisionFrame copyWith({
    Offset? gaze,
    Offset? previewPoint,
    double? confidence,
    double? quality,
    double? faceConfidence,
    double? headPoseConfidence,
    double? landmarkConfidence,
    double? contourConfidence,
    double? pupilConfidence,
    bool? usedHistory,
    HeadPose? headPose,
    String? rejectionReason,
  }) {
    return VisionFrame(
      timestampMs: timestampMs,
      hasFace: hasFace,
      gaze: gaze ?? this.gaze,
      previewPoint: previewPoint ?? this.previewPoint,
      confidence: confidence ?? this.confidence,
      quality: quality ?? this.quality,
      faceConfidence: faceConfidence ?? this.faceConfidence,
      headPoseConfidence: headPoseConfidence ?? this.headPoseConfidence,
      landmarkConfidence: landmarkConfidence ?? this.landmarkConfidence,
      contourConfidence: contourConfidence ?? this.contourConfidence,
      pupilConfidence: pupilConfidence ?? this.pupilConfidence,
      faceCount: faceCount,
      leftEyeContourPoints: leftEyeContourPoints,
      rightEyeContourPoints: rightEyeContourPoints,
      usedHeadPose: usedHeadPose,
      usedLandmarks: usedLandmarks,
      usedContours: usedContours,
      usedHistory: usedHistory ?? this.usedHistory,
      headPose: headPose ?? this.headPose,
      faceRect: faceRect,
      leftEyeContour: leftEyeContour,
      rightEyeContour: rightEyeContour,
      leftEyeCenter: leftEyeCenter,
      rightEyeCenter: rightEyeCenter,
      leftPupil: leftPupil,
      rightPupil: rightPupil,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}
