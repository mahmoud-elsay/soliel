import 'package:soliel/features/test/ui/vision/models/vision_frame.dart';

class VisionState {
  final bool isRunning;
  final bool faceVisible;
  final VisionFrame? lastFrame;
  final int framesProcessed;
  final int framesRejected;
  final int sampleCount;
  final int uniqueGazePoints;
  final int validDurationMs;
  final double averageConfidence;
  final double averageQuality;
  final double trackingScore;
  final double fps;
  final String? lastRejectedReason;
  final bool readyForUpload;

  const VisionState({
    required this.isRunning,
    required this.faceVisible,
    required this.lastFrame,
    required this.framesProcessed,
    required this.framesRejected,
    required this.sampleCount,
    required this.uniqueGazePoints,
    required this.validDurationMs,
    required this.averageConfidence,
    required this.averageQuality,
    required this.trackingScore,
    required this.fps,
    required this.lastRejectedReason,
    required this.readyForUpload,
  });

  factory VisionState.initial() {
    return const VisionState(
      isRunning: false,
      faceVisible: false,
      lastFrame: null,
      framesProcessed: 0,
      framesRejected: 0,
      sampleCount: 0,
      uniqueGazePoints: 0,
      validDurationMs: 0,
      averageConfidence: 0,
      averageQuality: 0,
      trackingScore: 0,
      fps: 0,
      lastRejectedReason: null,
      readyForUpload: false,
    );
  }

  VisionState copyWith({
    bool? isRunning,
    bool? faceVisible,
    VisionFrame? lastFrame,
    int? framesProcessed,
    int? framesRejected,
    int? sampleCount,
    int? uniqueGazePoints,
    int? validDurationMs,
    double? averageConfidence,
    double? averageQuality,
    double? trackingScore,
    double? fps,
    String? lastRejectedReason,
    bool? readyForUpload,
  }) {
    return VisionState(
      isRunning: isRunning ?? this.isRunning,
      faceVisible: faceVisible ?? this.faceVisible,
      lastFrame: lastFrame ?? this.lastFrame,
      framesProcessed: framesProcessed ?? this.framesProcessed,
      framesRejected: framesRejected ?? this.framesRejected,
      sampleCount: sampleCount ?? this.sampleCount,
      uniqueGazePoints: uniqueGazePoints ?? this.uniqueGazePoints,
      validDurationMs: validDurationMs ?? this.validDurationMs,
      averageConfidence: averageConfidence ?? this.averageConfidence,
      averageQuality: averageQuality ?? this.averageQuality,
      trackingScore: trackingScore ?? this.trackingScore,
      fps: fps ?? this.fps,
      lastRejectedReason: lastRejectedReason ?? this.lastRejectedReason,
      readyForUpload: readyForUpload ?? this.readyForUpload,
    );
  }
}
