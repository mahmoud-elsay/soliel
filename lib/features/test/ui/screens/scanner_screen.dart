import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_loading_indicator.dart';
import 'package:soliel/core/widgets/custom_snack_bar.dart';
import 'package:soliel/features/test/data/models/scan_point.dart';
import 'package:soliel/features/test/logic/eye_scan_cubit/eye_scan_cubit.dart';
import 'package:soliel/features/test/logic/eye_scan_cubit/eye_scan_state.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  // ── Config ───────────────────────────────────────────────────────────────────
  static const int _sessionSeconds = 10; // how long to record
  static const int _minPoints = 15; // matches API minimum

  // ── Camera + ML Kit ──────────────────────────────────────────────────────────
  CameraController? _camera;
  FaceDetector? _faceDetector;
  bool _isDetecting = false;

  // ── Recording state ──────────────────────────────────────────────────────────
  final List<ScanPoint> _gazePoints = [];
  int _pointIndex = 0;
  int? _lastTimestampMs;
  bool _isRecording = false;
  bool _recordingDone = false;
  int _secondsLeft = _sessionSeconds;
  Timer? _timer;

  // ── Dialog guard ─────────────────────────────────────────────────────────────
  bool _loadingVisible = false;

  // ── Lifecycle ────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableLandmarks: true,
        performanceMode: FaceDetectorMode.fast,
        minFaceSize: 0.15,
      ),
    );
    _initCamera();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _camera?.stopImageStream();
    _camera?.dispose();
    _faceDetector?.close();
    super.dispose();
  }

  // ── Camera init ──────────────────────────────────────────────────────────────
  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted || !mounted) return;

    final cameras = await availableCameras();
    final front = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _camera = CameraController(
      front,
      ResolutionPreset.medium, // 640×480 — good fps, enough for ML Kit
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21, // required for ML Kit on Android
    );

    await _camera!.initialize();
    if (mounted) setState(() {});
  }

  // ── Recording ────────────────────────────────────────────────────────────────
  void _startRecording() {
    if (_camera == null || !_camera!.value.isInitialized) return;

    setState(() {
      _gazePoints.clear();
      _pointIndex = 0;
      _lastTimestampMs = null;
      _isRecording = true;
      _recordingDone = false;
      _secondsLeft = _sessionSeconds;
    });

    // Countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        t.cancel();
        _stopRecording();
      }
    });

    // Start frame stream
    _camera!.startImageStream(_onFrame);
  }

  void _stopRecording() {
    _timer?.cancel();
    _camera?.stopImageStream();
    if (!mounted) return;
    setState(() {
      _isRecording = false;
      _recordingDone = true;
    });
  }

  // ── Per-frame ML Kit processing ───────────────────────────────────────────────
  Future<void> _onFrame(CameraImage image) async {
    if (_isDetecting || !_isRecording) return;
    _isDetecting = true;

    try {
      final inputImage = _toInputImage(image);
      if (inputImage == null) return;

      final faces = await _faceDetector!.processImage(inputImage);
      if (faces.isEmpty || !mounted) return;

      final face = faces.first;
      final leftEye = face.landmarks[FaceLandmarkType.leftEye];
      final rightEye = face.landmarks[FaceLandmarkType.rightEye];

      if (leftEye == null && rightEye == null) return;

      // Average both eye positions → single gaze point
      final double gazeX;
      final double gazeY;
      if (leftEye != null && rightEye != null) {
        gazeX = (leftEye.position.x + rightEye.position.x) / 2.0;
        gazeY = (leftEye.position.y + rightEye.position.y) / 2.0;
      } else {
        final eye = leftEye ?? rightEye!;
        gazeX = eye.position.x.toDouble();
        gazeY = eye.position.y.toDouble();
      }

      // Real elapsed time since last point (ms) — this is the real duration
      final now = DateTime.now().millisecondsSinceEpoch;
      final duration =
          _lastTimestampMs == null ? 34 : (now - _lastTimestampMs!).clamp(10, 500);
      _lastTimestampMs = now;

      // Camera image is 640×480 → x: 0–640, y: 0–480
      // API example values: x≈550–666, y≈700–867
      // These are the same order of magnitude ✅
      if (mounted) {
        setState(() {
          _gazePoints.add(ScanPoint(
            idx: _pointIndex++,
            x: gazeX,
            y: gazeY,
            duration: duration,
          ));
        });
      }
    } finally {
      _isDetecting = false;
    }
  }

  InputImage? _toInputImage(CameraImage image) {
    final rotation = InputImageRotationValue.fromRawValue(
      _camera!.description.sensorOrientation,
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

  // ── Submit ────────────────────────────────────────────────────────────────────
  void _submit() {
    if (_gazePoints.length < _minPoints) {
      CustomSnackBar.show(
        context,
        message:
            'لم يتم التقاط نقاط كافية. تأكد أن وجه الطفل واضح أمام الكاميرا.',
        state: SnackBarState.warning,
      );
      return;
    }

    context.read<EyeScanCubit>().analyzeEyeScan(
          childId: 1, // TODO: replace with real childId from session/storage
          notes: '',
          scanPath: List.unmodifiable(_gazePoints),
        );
  }

  void _showLoading() {
    if (_loadingVisible) return;
    _loadingVisible = true;
    showAppLoading(context, 'جاري تحليل البيانات...');
  }

  void _hideLoading() {
    if (!_loadingVisible) return;
    Navigator.of(context, rootNavigator: true).pop();
    _loadingVisible = false;
  }

  // ── UI ────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EyeScanCubit, EyeScanState>(
      listener: (context, state) {
        state.whenOrNull(
          loading: _showLoading,
          success: (response) {
            _hideLoading();
            if (!mounted) return;
            Navigator.pushNamed(
              context,
              Routes.scanResultScreen,
              arguments: response,
            );
          },
          error: (error) {
            _hideLoading();
            CustomSnackBar.show(
              context,
              message: error.message,
              state: SnackBarState.error,
            );
          },
        );
      },
      builder: (context, state) {
        final isSubmitting = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return Scaffold(
          backgroundColor: const Color(0xFF3F3F3F),
          body: SafeArea(
            child: Column(
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.white, size: 30.r),
                  ),
                ),

                SizedBox(height: 10.h),

                Text(
                  'ابدأ المسح الآن',
                  style: TextStyles.font24GradientExtraBold.copyWith(
                    color: Colors.white,
                    fontSize: 30.sp,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 8.h),

                Text(
                  _isRecording
                      ? 'وجه الكاميرا نحو عيني الطفل'
                      : _recordingDone
                          ? 'اكتمل التسجيل — اضغط تأكيد للتحليل'
                          : 'وجه الكاميرا الأمامية نحو الطفل واضغط ابدأ',
                  style: TextStyles.font14GreyMedium.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 20.h),

                // Camera preview — same position as the old image overlay
                _buildCameraPreview(),

                const Spacer(),

                // Stats row (shown once recording starts)
                if (_isRecording || _recordingDone)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildChip(
                        label: 'النقاط',
                        value: '${_gazePoints.length}',
                        color: _gazePoints.length >= _minPoints
                            ? Colors.greenAccent
                            : Colors.orangeAccent,
                      ),
                      if (_isRecording) ...[
                        SizedBox(width: 20.w),
                        _buildChip(
                          label: 'الوقت',
                          value: '${_secondsLeft}s',
                          color: Colors.blueAccent,
                        ),
                      ],
                    ],
                  ),

                const Spacer(),

                // Action button
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : _recordingDone
                          ? _submit
                          : _isRecording
                              ? null
                              : _startRecording,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _recordingDone ? Colors.blue : Colors.blueAccent,
                    disabledBackgroundColor: Colors.blue.withOpacity(0.4),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 12.h,
                    ),
                  ),
                  child: Text(
                    _isRecording
                        ? 'جاري التسجيل...'
                        : _recordingDone
                            ? 'تأكيد'
                            : 'ابدأ',
                    style: TextStyles.font16WhiteSemiBold,
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCameraPreview() {
    // Same size as the old overlay box
    return Container(
      width: 330.w,
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: (_camera == null || !_camera!.value.isInitialized)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Colors.white54),
                    SizedBox(height: 8.h),
                    Text(
                      'جاري تهيئة الكاميرا...',
                      style: TextStyles.font12BlackRegular
                          .copyWith(color: Colors.white54),
                    ),
                  ],
                ),
              )
            : CameraPreview(_camera!),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.white54, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}
