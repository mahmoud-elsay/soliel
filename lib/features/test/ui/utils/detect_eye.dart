import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class EyeDetector {
  final FaceDetector _faceDetector;

  EyeDetector()
    : _faceDetector = FaceDetector(
        options: FaceDetectorOptions(
          enableLandmarks: true,
          enableClassification: true,
          performanceMode: FaceDetectorMode.accurate,
          minFaceSize: 0.2,
        ),
      );

  Future<Map<String, dynamic>?> detectGazePoint(
    CameraImage image,
    CameraDescription camera,
  ) async {
    try {
      final inputImage = _toInputImage(image, camera);
      if (inputImage == null) return null;

      final faces = await _faceDetector.processImage(inputImage);
      if (faces.isEmpty) return null;

      final face = faces.first;

      // Very strict quality filter
      if ((face.headEulerAngleY ?? 0).abs() > 18 ||
          (face.headEulerAngleX ?? 0).abs() > 15) {
        return null;
      }
      if ((face.leftEyeOpenProbability ?? 1.0) < 0.55 ||
          (face.rightEyeOpenProbability ?? 1.0) < 0.55) {
        return null;
      }

      // Try to get better point using eyes + nose bridge if available
      final leftEye = face.landmarks[FaceLandmarkType.leftEye];
      final rightEye = face.landmarks[FaceLandmarkType.rightEye];
      final noseBase = face.landmarks[FaceLandmarkType.noseBase];

      if (leftEye == null && rightEye == null) return null;

      double rawX, rawY;

      if (leftEye != null && rightEye != null) {
        rawX = (leftEye.position.x + rightEye.position.x) / 2;
        rawY = (leftEye.position.y + rightEye.position.y) / 2;

        // Pull slightly toward nose base for better center
        if (noseBase != null) {
          rawX = rawX * 0.7 + noseBase.position.x * 0.3;
          rawY = rawY * 0.75 + noseBase.position.y * 0.25;
        }
      } else {
        final eye = leftEye ?? rightEye!;
        rawX = eye.position.x.toDouble();
        rawY = eye.position.y.toDouble();
      }

      final norm = _normalizeCoordinates(rawX, rawY, image, camera);

      return {'normX': norm['x'], 'normY': norm['y']};
    } catch (e) {
      return null;
    }
  }

  Map<String, double> _normalizeCoordinates(
    double rawX,
    double rawY,
    CameraImage image,
    CameraDescription camera,
  ) {
    final bufW = image.width.toDouble();
    final bufH = image.height.toDouble();
    final sensorAngle = camera.sensorOrientation;

    double normX, normY;

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

    normX = (1.0 - normX).clamp(0.0, 1.0);
    normY = normY.clamp(0.0, 1.0);

    return {'x': normX, 'y': normY};
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

  void dispose() {
    _faceDetector.close();
  }
}

// Smoother
class GazeSmoother {
  final List<double> _xBuffer = [];
  final List<double> _yBuffer = [];
  final int bufferSize;

  double _smoothX = 0.5;
  double _smoothY = 0.5;
  bool _initialized = false;

  GazeSmoother({this.bufferSize = 8});

  Map<String, double> addPoint(double normX, double normY) {
    _xBuffer.add(normX);
    _yBuffer.add(normY);

    if (_xBuffer.length > bufferSize) {
      _xBuffer.removeAt(0);
      _yBuffer.removeAt(0);
    }

    final avgX = _xBuffer.reduce((a, b) => a + b) / _xBuffer.length;
    final avgY = _yBuffer.reduce((a, b) => a + b) / _yBuffer.length;

    if (!_initialized) {
      _smoothX = avgX;
      _smoothY = avgY;
      _initialized = true;
    } else {
      const emaAlpha = 0.22;
      _smoothX = emaAlpha * avgX + (1 - emaAlpha) * _smoothX;
      _smoothY = emaAlpha * avgY + (1 - emaAlpha) * _smoothY;
    }

    return {'x': _smoothX, 'y': _smoothY};
  }

  void reset() {
    _xBuffer.clear();
    _yBuffer.clear();
    _initialized = false;
  }
}
