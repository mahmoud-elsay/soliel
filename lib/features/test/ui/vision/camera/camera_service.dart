import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soliel/features/test/ui/vision/debug/logger.dart';

class VisionCameraInitialization {
  final CameraController? controller;
  final bool permissionGranted;
  final String? errorMessage;

  const VisionCameraInitialization({
    required this.controller,
    required this.permissionGranted,
    this.errorMessage,
  });

  bool get isReady => controller != null && errorMessage == null;
}

class VisionCameraService {
  final VisionLogger _logger;

  CameraController? _controller;

  VisionCameraService({required VisionLogger logger}) : _logger = logger;

  CameraController? get controller => _controller;

  Future<VisionCameraInitialization> initialize() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      _logger.camera('permission_denied', const {});
      return const VisionCameraInitialization(
        controller: null,
        permissionGranted: false,
        errorMessage: 'لم يتم منح إذن الكاميرا.',
      );
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        return const VisionCameraInitialization(
          controller: null,
          permissionGranted: true,
          errorMessage: 'لا توجد كاميرا متاحة على هذا الجهاز.',
        );
      }

      final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        front,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await controller.initialize();
      _controller = controller;

      _logger.camera('initialized', <String, Object?>{
        'lens': front.lensDirection.name,
        'sensorOrientation': front.sensorOrientation,
        'previewWidth': controller.value.previewSize?.width,
        'previewHeight': controller.value.previewSize?.height,
      });

      return VisionCameraInitialization(
        controller: controller,
        permissionGranted: true,
      );
    } on CameraException catch (error) {
      _logger.camera('init_error', <String, Object?>{
        'code': error.code,
        'description': error.description,
      });
      return VisionCameraInitialization(
        controller: null,
        permissionGranted: true,
        errorMessage: error.description ?? 'تعذر تشغيل الكاميرا.',
      );
    }
  }

  Future<void> startStream(void Function(CameraImage image) onFrame) async {
    final camera = _controller;
    if (camera == null || !camera.value.isInitialized) {
      throw CameraException('not_initialized', 'Camera is not initialized.');
    }
    if (camera.value.isStreamingImages) return;

    await camera.startImageStream(onFrame);
    _logger.camera('stream_started', const {});
  }

  Future<void> stopStream() async {
    final camera = _controller;
    if (camera == null || !camera.value.isStreamingImages) return;

    try {
      await camera.stopImageStream();
      _logger.camera('stream_stopped', const {});
    } on CameraException catch (error) {
      _logger.camera('stream_stop_error', <String, Object?>{
        'code': error.code,
        'description': error.description,
      });
    }
  }

  Size? previewContentSize() {
    final previewSize = _controller?.value.previewSize;
    if (previewSize == null) return null;

    return Size(previewSize.height, previewSize.width);
  }

  Future<void> dispose() async {
    final camera = _controller;
    if (camera == null) return;

    if (camera.value.isStreamingImages) {
      try {
        await camera.stopImageStream();
      } on CameraException catch (error) {
        _logger.camera('stream_stop_error', <String, Object?>{
          'code': error.code,
          'description': error.description,
        });
      }
    }

    _controller = null;
    try {
      await camera.dispose();
      _logger.camera('disposed', const {});
    } on CameraException catch (error) {
      _logger.camera('dispose_error', <String, Object?>{
        'code': error.code,
        'description': error.description,
      });
    }
  }
}
