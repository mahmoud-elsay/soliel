import 'dart:async';
import 'dart:math' as math;

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
import 'package:soliel/features/test/ui/utils/detect_eye.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  // ── Config ───────────────────────────────────────────────────────────────────
  static const int _sessionSeconds = 12;
  static const int _minPoints = 35;
  static const double _pointResolution = 1000.0;

  // ── Camera & Detectors ───────────────────────────────────────────────────────
  CameraController? _camera;
  final EyeDetector _eyeDetector = EyeDetector();
  final GazeSmoother _smoother = GazeSmoother();

  bool _isDetecting = false;

  // ── Recording State ─────────────────────────────────────────────────────────
  final List<ScanPoint> _gazePoints = [];
  int _pointIndex = 0;
  int? _lastTimestampMs;
  bool _isRecording = false;
  bool _recordingDone = false;
  int _secondsLeft = _sessionSeconds;
  Timer? _timer;

  bool _faceVisible = false;
  bool _loadingVisible = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _camera?.stopImageStream();
    _camera?.dispose();
    _eyeDetector.dispose();
    super.dispose();
  }

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
      ResolutionPreset.veryHigh,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21,
    );

    await _camera!.initialize();
    if (mounted) setState(() {});
  }

  // ── Recording Controls ───────────────────────────────────────────────────────
  void _startRecording() {
    setState(() {
      _gazePoints.clear();
      _pointIndex = 0;
      _lastTimestampMs = null;
      _smoother.reset();
      _isRecording = true;
      _recordingDone = false;
      _secondsLeft = _sessionSeconds;
    });

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

    _camera!.startImageStream(_onFrame);
  }

  void _stopRecording() {
    _timer?.cancel();
    _camera?.stopImageStream();
    if (mounted) {
      setState(() {
        _isRecording = false;
        _recordingDone = true;
      });
    }
  }

  // ── Main Frame Processing ───────────────────────────────────────────────────
  Future<void> _onFrame(CameraImage image) async {
    if (_isDetecting || !_isRecording) return;
    _isDetecting = true;

    try {
      final result = await _eyeDetector.detectGazePoint(
        image,
        _camera!.description,
      );

      if (result == null) {
        if (_faceVisible) setState(() => _faceVisible = false);
        return;
      }

      if (!_faceVisible) setState(() => _faceVisible = true);

      final smoothed = _smoother.addPoint(result['normX']!, result['normY']!);

      // ── Advanced Filters ───────────────────────────────────────────────────
      if (_gazePoints.isNotEmpty) {
        final last = _gazePoints.last;
        final prevX = last.x / _pointResolution;
        final prevY = last.y / _pointResolution;

        final jump = math.sqrt(
          math.pow(smoothed['x']! - prevX, 2) +
              math.pow(smoothed['y']! - prevY, 2),
        );

        if (jump > 0.085) return; // Reject sudden jumps
      }

      if (_gazePoints.isNotEmpty) {
        final last = _gazePoints.last;
        final prevX = last.x / _pointResolution;
        final prevY = last.y / _pointResolution;

        final dist = math.sqrt(
          math.pow(smoothed['x']! - prevX, 2) +
              math.pow(smoothed['y']! - prevY, 2),
        );

        if (dist < 0.0028) return; // Minimum movement
      }

      // ── Add Point ───────────────────────────────────────────────────────────
      final scaledX = (smoothed['x']! * _pointResolution).roundToDouble();
      final scaledY = (smoothed['y']! * _pointResolution).roundToDouble();

      final now = DateTime.now().millisecondsSinceEpoch;
      final duration = _lastTimestampMs == null
          ? 34
          : (now - _lastTimestampMs!).clamp(10, 500);
      _lastTimestampMs = now;

      setState(() {
        _gazePoints.add(
          ScanPoint(
            idx: _pointIndex++,
            x: scaledX,
            y: scaledY,
            duration: duration,
          ),
        );
      });
    } finally {
      _isDetecting = false;
    }
  }

  // ── Submit ───────────────────────────────────────────────────────────────────
  void _submit() {
    if (_gazePoints.length < _minPoints) {
      CustomSnackBar.show(
        context,
        message:
            'تم التقاط ${_gazePoints.length} نقطة فقط. نحتاج $_minPoints على الأقل.',
        state: SnackBarState.warning,
      );
      return;
    }

    context.read<EyeScanCubit>().analyzeEyeScan(
      childId: 1,
      notes: '',
      scanPath: List.unmodifiable(_gazePoints),
    );
  }

  void _showLoading() {
    if (_loadingVisible) return;
    _loadingVisible = true;
    showAppLoading(context, 'جاري تحليل مسار العين...');
  }

  void _hideLoading() {
    if (!_loadingVisible) return;
    Navigator.of(context, rootNavigator: true).pop();
    _loadingVisible = false;
  }

  // ── UI ───────────────────────────────────────────────────────────────────────
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
          backgroundColor: const Color(0xFF1A1A1A),
          body: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.white, size: 30.r),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'فحص تتبع العين',
                  style: TextStyles.font24GradientExtraBold.copyWith(
                    color: Colors.white,
                    fontSize: 28.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                _buildStatusBanner(),
                SizedBox(height: 15.h),
                _buildScanningArea(),
                const Spacer(),
                if (_isRecording || _recordingDone)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMiniStat(
                        'النقاط',
                        '${_gazePoints.length}',
                        _gazePoints.length >= _minPoints
                            ? Colors.greenAccent
                            : Colors.orangeAccent,
                      ),
                      _buildMiniStat(
                        'الثواني',
                        '${_secondsLeft}s',
                        Colors.blueAccent,
                      ),
                    ],
                  ),
                const Spacer(),
                _buildPrimaryButton(isSubmitting),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBanner() {
    String text;
    Color color;
    IconData icon;

    if (!_isRecording && !_recordingDone) {
      text = 'ضع وجه الطفل في الإطار واضغط ابدأ';
      color = Colors.white70;
      icon = Icons.info_outline;
    } else if (_isRecording) {
      if (_faceVisible) {
        text = 'يتم الالتقاط... حافظ على ثبات الطفل';
        color = Colors.greenAccent;
        icon = Icons.visibility;
      } else {
        text = 'وجه الطفل غير واضح! أعد التصويب';
        color = Colors.redAccent;
        icon = Icons.visibility_off;
      }
    } else {
      text = 'اكتملت البيانات. جاهز للتحليل';
      color = Colors.blueAccent;
      icon = Icons.check_circle;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18.r),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(color: color, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningArea() {
    return Container(
      width: 340.w,
      height: 280.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: _isRecording && !_faceVisible
              ? Colors.redAccent
              : Colors.blueAccent.withOpacity(0.6),
          width: 3,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_camera?.value.isInitialized == true)
              CameraPreview(_camera!)
            else
              const Center(child: CircularProgressIndicator()),

            if (_isRecording || _recordingDone)
              CustomPaint(
                painter: GazePathPainter(_gazePoints),
                size: Size.infinite,
              ),

            if (!_isRecording && !_recordingDone)
              Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                  child: Icon(
                    Icons.face_retouching_natural,
                    color: Colors.white38,
                    size: 90,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(bool loading) {
    VoidCallback? onPressed;
    String text;
    Color color = Colors.blueAccent;

    if (loading) {
      onPressed = null;
      text = 'جاري المعالجة...';
    } else if (_recordingDone) {
      onPressed = _submit;
      text = 'إرسال للتحليل';
      color = Colors.green;
    } else if (_isRecording) {
      onPressed = null;
      text = 'جاري التسجيل...';
      color = Colors.grey;
    } else {
      onPressed = _startRecording;
      text = 'ابدأ الفحص';
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 15.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        elevation: 5,
      ),
      child: Text(text, style: TextStyles.font16WhiteSemiBold),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.white54, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}

// ── Gaze Path Painter ─────────────────────────────────────────────────────────
class GazePathPainter extends CustomPainter {
  final List<ScanPoint> points;

  GazePathPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final linePaint = Paint()
      ..color = Colors.yellowAccent.withOpacity(0.75)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()..style = PaintingStyle.fill;

    Offset? prev;

    for (final point in points) {
      final px = (point.x / 1000) * size.width;
      final py = (point.y / 1000) * size.height;
      final offset = Offset(px, py);

      if (prev != null) canvas.drawLine(prev, offset, linePaint);

      final radius = (3.0 + point.duration / 100).clamp(3.0, 11.0);

      dotPaint.color = Colors.orangeAccent.withOpacity(0.7);
      canvas.drawCircle(offset, radius, dotPaint);

      dotPaint.color = Colors.white;
      canvas.drawCircle(offset, 1.8, dotPaint);

      prev = offset;
    }
  }

  @override
  bool shouldRepaint(covariant GazePathPainter oldDelegate) =>
      oldDelegate.points.length != points.length;
}
