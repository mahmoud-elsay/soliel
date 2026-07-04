import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show DeviceOrientation;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:soliel/features/test/ui/vision/debug/logger.dart';

class ConvertedCameraImage {
  final InputImage inputImage;
  final Uint8List lumaBytes;
  final int lumaRowStride;
  final int width;
  final int height;
  final InputImageRotation rotation;
  final InputImageFormat format;

  const ConvertedCameraImage({
    required this.inputImage,
    required this.lumaBytes,
    required this.lumaRowStride,
    required this.width,
    required this.height,
    required this.rotation,
    required this.format,
  });

  Size get size => Size(width.toDouble(), height.toDouble());
}

class CameraImageConverter {
  static const Map<DeviceOrientation, int> _orientationDegrees = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  final VisionLogger _logger;
  bool _loggedFormat = false;

  CameraImageConverter({required VisionLogger logger}) : _logger = logger;

  ConvertedCameraImage? convert({
    required CameraImage image,
    required CameraDescription camera,
    required DeviceOrientation deviceOrientation,
  }) {
    if (image.planes.isEmpty) {
      _logger.detection('rejected', const {'reason': 'no_image_planes'});
      return null;
    }

    final rotation = _rotationFor(camera, deviceOrientation);
    if (rotation == null) {
      _logger.detection('rejected', <String, Object?>{
        'reason': 'unsupported_rotation',
        'deviceOrientation': deviceOrientation.name,
        'sensorOrientation': camera.sensorOrientation,
      });
      return null;
    }

    final mlKitBytes = _bytesForMlKit(image);
    final format = _formatForMlKit(image);
    if (mlKitBytes == null || format == null) {
      _logger.detection('rejected', <String, Object?>{
        'reason': 'unsupported_image_format',
        'formatGroup': image.format.group.name,
        'formatRaw': image.format.raw,
        'planes': image.planes.length,
      });
      return null;
    }

    final lumaPlane = image.planes.first;
    final converted = ConvertedCameraImage(
      inputImage: InputImage.fromBytes(
        bytes: mlKitBytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: lumaPlane.bytesPerRow,
        ),
      ),
      lumaBytes: lumaPlane.bytes,
      lumaRowStride: lumaPlane.bytesPerRow,
      width: image.width,
      height: image.height,
      rotation: rotation,
      format: format,
    );

    if (!_loggedFormat) {
      _loggedFormat = true;
      _logger.camera('image_format', <String, Object?>{
        'planes': image.planes.length,
        'formatGroup': image.format.group.name,
        'formatRaw': image.format.raw,
        'mlKitFormat': format.name,
        'rotation': rotation.rawValue,
        'width': image.width,
        'height': image.height,
        'rowStride': lumaPlane.bytesPerRow,
      });
    }

    return converted;
  }

  Offset normalizeImagePoint(
    Offset point,
    ConvertedCameraImage image,
    CameraDescription camera,
  ) {
    final width = image.width.toDouble();
    final height = image.height.toDouble();

    double x;
    double y;

    switch (camera.sensorOrientation) {
      case 90:
        x = point.dy / height;
        y = 1.0 - point.dx / width;
        break;
      case 270:
        x = 1.0 - point.dy / height;
        y = point.dx / width;
        break;
      case 180:
        x = 1.0 - point.dx / width;
        y = 1.0 - point.dy / height;
        break;
      default:
        x = point.dx / width;
        y = point.dy / height;
    }

    if (camera.lensDirection == CameraLensDirection.front) {
      x = 1.0 - x;
    }

    return Offset(x.clamp(0.0, 1.0).toDouble(), y.clamp(0.0, 1.0).toDouble());
  }

  Rect normalizeImageRect(
    Rect rect,
    ConvertedCameraImage image,
    CameraDescription camera,
  ) {
    final corners = <Offset>[
      normalizeImagePoint(rect.topLeft, image, camera),
      normalizeImagePoint(rect.topRight, image, camera),
      normalizeImagePoint(rect.bottomLeft, image, camera),
      normalizeImagePoint(rect.bottomRight, image, camera),
    ];

    var minX = corners.first.dx;
    var maxX = corners.first.dx;
    var minY = corners.first.dy;
    var maxY = corners.first.dy;

    for (final point in corners.skip(1)) {
      if (point.dx < minX) minX = point.dx;
      if (point.dx > maxX) maxX = point.dx;
      if (point.dy < minY) minY = point.dy;
      if (point.dy > maxY) maxY = point.dy;
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  InputImageRotation? _rotationFor(
    CameraDescription camera,
    DeviceOrientation deviceOrientation,
  ) {
    if (Platform.isIOS) {
      return InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    }

    final deviceRotation = _orientationDegrees[deviceOrientation];
    if (deviceRotation == null) return null;

    final rotation = camera.lensDirection == CameraLensDirection.front
        ? (camera.sensorOrientation + deviceRotation) % 360
        : (camera.sensorOrientation - deviceRotation + 360) % 360;

    return InputImageRotationValue.fromRawValue(rotation);
  }

  InputImageFormat? _formatForMlKit(CameraImage image) {
    if (Platform.isAndroid) {
      if (image.format.group == ImageFormatGroup.nv21 ||
          image.format.group == ImageFormatGroup.yuv420) {
        return InputImageFormat.nv21;
      }
    }

    if (Platform.isIOS) {
      final format = InputImageFormatValue.fromRawValue(image.format.raw);
      return format == InputImageFormat.bgra8888 ? format : null;
    }

    return InputImageFormatValue.fromRawValue(image.format.raw);
  }

  Uint8List? _bytesForMlKit(CameraImage image) {
    if (Platform.isAndroid &&
        (image.format.group == ImageFormatGroup.nv21 ||
            image.format.group == ImageFormatGroup.yuv420)) {
      final WriteBuffer allBytes = WriteBuffer();
      for (final plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      return allBytes.done().buffer.asUint8List();
    }

    return image.planes.isNotEmpty ? image.planes.first.bytes : null;
  }
}
