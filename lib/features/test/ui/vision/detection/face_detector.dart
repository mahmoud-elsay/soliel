import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:soliel/features/test/ui/vision/camera/image_converter.dart';
import 'package:soliel/features/test/ui/vision/debug/logger.dart';

class FaceDetectionResult {
  final List<Face> faces;
  final Face? primaryFace;
  final String? error;

  const FaceDetectionResult({
    required this.faces,
    required this.primaryFace,
    this.error,
  });

  factory FaceDetectionResult.empty() {
    return const FaceDetectionResult(faces: [], primaryFace: null);
  }

  factory FaceDetectionResult.failure(String error) {
    return FaceDetectionResult(
      faces: const [],
      primaryFace: null,
      error: error,
    );
  }
}

class MobileFaceDetector {
  final VisionLogger _logger;
  final FaceDetector _detector;

  MobileFaceDetector({required VisionLogger logger})
    : _logger = logger,
      _detector = FaceDetector(
        options: FaceDetectorOptions(
          enableClassification: true,
          enableContours: true,
          enableLandmarks: true,
          enableTracking: true,
          minFaceSize: 0.08,
          performanceMode: FaceDetectorMode.accurate,
        ),
      );

  Future<FaceDetectionResult> detect(ConvertedCameraImage image) async {
    try {
      final faces = await _detector.processImage(image.inputImage);
      if (faces.isEmpty) {
        _logger.detection('face_lost', const {'reason': 'no_face'});
        return FaceDetectionResult.empty();
      }

      final face = _pickPrimaryFace(faces);
      _logger.detection('face_detected', <String, Object?>{
        'faceCount': faces.length,
        'trackingId': face.trackingId,
        'boxLeft': face.boundingBox.left.round(),
        'boxTop': face.boundingBox.top.round(),
        'boxWidth': face.boundingBox.width.round(),
        'boxHeight': face.boundingBox.height.round(),
      });

      return FaceDetectionResult(faces: faces, primaryFace: face);
    } catch (error) {
      _logger.detection('detector_error', {'error': error.toString()});
      return FaceDetectionResult.failure(error.toString());
    }
  }

  Future<void> dispose() => _detector.close();

  Face _pickPrimaryFace(List<Face> faces) {
    return faces.reduce((current, next) {
      final currentArea =
          current.boundingBox.width.abs() * current.boundingBox.height.abs();
      final nextArea =
          next.boundingBox.width.abs() * next.boundingBox.height.abs();
      return currentArea >= nextArea ? current : next;
    });
  }
}
