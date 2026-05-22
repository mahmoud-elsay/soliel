import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class EyeDetector {
  static const double _maxYaw = 22;
  static const double _maxPitch = 18;
  static const double _minEyeOpenProbability = 0.5;

  final FaceDetector _faceDetector;

  EyeDetector()
    : _faceDetector = FaceDetector(
        options: FaceDetectorOptions(
          enableContours: true,
          enableClassification: true,
          performanceMode: FaceDetectorMode.accurate,
          minFaceSize: 0.18,
        ),
      );

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

      if (!_passesQualityFilters(face)) return null;

      final leftEyeCenter = _contourCenter(
        face.contours[FaceContourType.leftEye],
      );
      final rightEyeCenter = _contourCenter(
        face.contours[FaceContourType.rightEye],
      );

      if (leftEyeCenter == null && rightEyeCenter == null) return null;

      final eyeCenter = _resolveEyeCenter(leftEyeCenter, rightEyeCenter);

      final norm = _normalizeCoordinates(
        eyeCenter.dx,
        eyeCenter.dy,
        image,
        camera,
      );

      return {'normX': norm['x']!, 'normY': norm['y']!};
    } catch (e) {
      return null;
    }
  }

  Face _pickPrimaryFace(List<Face> faces) {
    return faces.reduce((current, next) {
      final currentArea =
          current.boundingBox.width.abs() * current.boundingBox.height.abs();
      final nextArea =
          next.boundingBox.width.abs() * next.boundingBox.height.abs();
      return currentArea >= nextArea ? current : next;
    });
  }

  bool _passesQualityFilters(Face face) {
    if ((face.headEulerAngleY ?? 0).abs() > _maxYaw ||
        (face.headEulerAngleX ?? 0).abs() > _maxPitch) {
      return false;
    }

    if ((face.leftEyeOpenProbability ?? 1.0) < _minEyeOpenProbability ||
        (face.rightEyeOpenProbability ?? 1.0) < _minEyeOpenProbability) {
      return false;
    }

    return true;
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

  Offset _resolveEyeCenter(Offset? leftEyeCenter, Offset? rightEyeCenter) {
    if (leftEyeCenter != null && rightEyeCenter != null) {
      return Offset(
        (leftEyeCenter.dx + rightEyeCenter.dx) / 2,
        (leftEyeCenter.dy + rightEyeCenter.dy) / 2,
      );
    }

    return leftEyeCenter ?? rightEyeCenter!;
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

  GazeSmoother({this.bufferSize = 5});

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
      const emaAlpha = 0.38;
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
