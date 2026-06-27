import 'dart:async';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_loading_indicator.dart';
import 'package:soliel/core/widgets/custom_snack_bar.dart';
import 'package:soliel/features/test/data/models/scan_point.dart';
import 'package:soliel/features/test/logic/eye_scan_cubit/eye_scan_cubit.dart';
import 'package:soliel/features/test/logic/eye_scan_cubit/eye_scan_state.dart';
import 'package:soliel/features/test/ui/utils/detect_eye.dart';

const List<Offset> _stimulusWaypoints = [
  Offset(0.50, 0.50),
  Offset(0.18, 0.22),
  Offset(0.82, 0.22),
  Offset(0.82, 0.78),
  Offset(0.18, 0.78),
  Offset(0.50, 0.50),
  Offset(0.18, 0.50),
  Offset(0.82, 0.50),
  Offset(0.50, 0.22),
  Offset(0.50, 0.78),
  Offset(0.50, 0.50),
];

Offset _stimulusPointAt(double progress) {
  final clampedProgress = progress.clamp(0.0, 1.0);
  final scaledProgress = clampedProgress * (_stimulusWaypoints.length - 1);
  final index = scaledProgress.floor().clamp(0, _stimulusWaypoints.length - 2);
  final localProgress = Curves.easeInOut.transform(scaledProgress - index);

  return Offset.lerp(
    _stimulusWaypoints[index],
    _stimulusWaypoints[index + 1],
    localProgress,
  )!;
}

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  // ── Config ───────────────────────────────────────────────────────────────────
  static const int _sessionSeconds = 12;
  static const int _minPoints = 15;
  static const double _pointResolution = 1000.0;
  static const int _minSampleGapMs = 90;
  static const double _maxJumpDistance = 0.30;
  static const double _minMoveDistance = 0.0005;
  static const double _minFrameQuality = 0.45;
  static const double _minResponseSpread = 0.02;
  static const double _minTrackingQuality = 0.50;
  static const int _warmupMs = 1500;

  // ── Camera & Detectors ───────────────────────────────────────────────────────
  CameraController? _camera;
  final EyeDetector _eyeDetector = EyeDetector();
  final GazeSmoother _smoother = GazeSmoother();
  final GazeSmoother _previewSmoother = GazeSmoother();
  late final AnimationController _stimulusController;

  bool _isDetecting = false;

  // ── Recording State ─────────────────────────────────────────────────────────
  final List<ScanPoint> _gazePoints = [];
  final List<ScanPoint> _previewPoints = [];
  final List<Offset> _targetPoints = [];
  final List<double> _frameQualitySamples = [];
  int _pointIndex = 0;
  int? _lastTimestampMs;
  int? _recordingStartMs;
  bool _isRecording = false;
  bool _recordingDone = false;
  int _secondsLeft = _sessionSeconds;
  Timer? _timer;
  int _retryCount = 0;

  bool _faceVisible = false;
  bool _loadingVisible = false;

  @override
  void initState() {
    super.initState();
    _stimulusController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _sessionSeconds),
    );
    _initCamera();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _camera?.stopImageStream();
    _camera?.dispose();
    _stimulusController.dispose();
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
      ResolutionPreset.high,
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
      _previewPoints.clear();
      _targetPoints.clear();
      _frameQualitySamples.clear();
      _pointIndex = 0;
      _lastTimestampMs = null;
      _recordingStartMs = DateTime.now().millisecondsSinceEpoch;
      _smoother.reset();
      _previewSmoother.reset();
      _isRecording = true;
      _recordingDone = false;
      _secondsLeft = _sessionSeconds;
      _faceVisible = false;
    });

    _stimulusController.forward(from: 0);
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

  void _retryRecording() {
    _retryCount++;
    _startRecording();
  }

  void _stopRecording() {
    _timer?.cancel();
    _camera?.stopImageStream();
    _stimulusController.stop();
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
      if (!mounted || !_isRecording) return;

      if (result == null) {
        if (_faceVisible) setState(() => _faceVisible = false);
        return;
      }

      final frameQuality = result['quality'] ?? 0.0;
      if (frameQuality < _minFrameQuality) {
        // Still mark face visible if quality is above a minimal threshold
        // so the child doesn't get confused by face-lost warnings
        if (frameQuality > 0.25) {
          if (!_faceVisible) setState(() => _faceVisible = true);
        } else {
          if (_faceVisible) setState(() => _faceVisible = false);
        }
        return;
      }

      if (!_faceVisible) setState(() => _faceVisible = true);

      final now = DateTime.now().millisecondsSinceEpoch;

      // Discard warm-up period — early frames are noisy
      final elapsedSinceStart = now - (_recordingStartMs ?? now);
      if (elapsedSinceStart < _warmupMs) return;

      final smoothed = _smoother.addPoint(result['normX']!, result['normY']!);
      final previewSmoothed = _previewSmoother.addPoint(
        result['previewX']!,
        result['previewY']!,
      );

      if (_gazePoints.isNotEmpty) {
        final last = _gazePoints.last;
        final prevX = last.x / _pointResolution;
        final prevY = last.y / _pointResolution;

        final movement = math.sqrt(
          math.pow(smoothed['x']! - prevX, 2) +
              math.pow(smoothed['y']! - prevY, 2),
        );

        if (movement > _maxJumpDistance) return;

        final elapsedMs = _lastTimestampMs == null
            ? _minSampleGapMs
            : now - _lastTimestampMs!;

        if (elapsedMs < _minSampleGapMs && movement < _minMoveDistance) {
          return;
        }
      }

      final scaledX = (smoothed['x']! * _pointResolution).roundToDouble();
      final scaledY = (smoothed['y']! * _pointResolution).roundToDouble();
      final previewScaledX = (previewSmoothed['x']! * _pointResolution)
          .roundToDouble();
      final previewScaledY = (previewSmoothed['y']! * _pointResolution)
          .roundToDouble();
      final targetPoint = _stimulusPointAt(_recordingProgress(now));

      final duration = _lastTimestampMs == null
          ? _minSampleGapMs
          : (now - _lastTimestampMs!).clamp(16, 500);
      _lastTimestampMs = now;

      setState(() {
        final pointIdx = _pointIndex++;
        _gazePoints.add(
          ScanPoint(idx: pointIdx, x: scaledX, y: scaledY, duration: duration),
        );
        _previewPoints.add(
          ScanPoint(
            idx: pointIdx,
            x: previewScaledX,
            y: previewScaledY,
            duration: duration,
          ),
        );
        _targetPoints.add(targetPoint);
        _frameQualitySamples.add(frameQuality);
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
            'تم التقاط ${_gazePoints.length} نقطة فقط. نحتاج $_minPoints على الأقل.\nتأكد من إضاءة جيدة ووجه الطفل واضح.',
        state: SnackBarState.warning,
      );
      return;
    }

    final trackingQuality = _trackingQuality();
    if (trackingQuality < _minTrackingQuality) {
      final qualityPercent = (trackingQuality * 100).round();
      final tip = _retryCount == 0
          ? 'تأكد من:\n• إضاءة جيدة على وجه الطفل\n• الطفل يتبع النقطة الصفراء بعينيه\n• المسافة مناسبة (30-50 سم)'
          : _retryCount == 1
              ? 'حاول:\n• تقليل الإضاءة الخلفية\n• إمساك الهاتف بثبات\n• جعل الطفل ينظر للشاشة مباشرة'
              : 'نصيحة: ضع الهاتف على سطح ثابت واجعل الطفل ينظر للشاشة من مسافة ذراع.';
      CustomSnackBar.show(
        context,
        message: 'جودة الفحص $qualityPercent%.\n$tip',
        state: SnackBarState.warning,
      );
      return;
    }

    context.read<EyeScanCubit>().analyzeEyeScan(
      childId: 1,
      notes: '',
      scanPath: List.unmodifiable(_scanPathForAnalysis()),
    );
  }

  List<ScanPoint> _scanPathForAnalysis() {
    if (_gazePoints.isEmpty) return const [];

    return _gazePoints
        .map(
          (point) => ScanPoint(
            idx: point.idx,
            x: point.x.clamp(0.0, _pointResolution).toDouble(),
            y: point.y.clamp(0.0, _pointResolution).toDouble(),
            duration: point.duration,
          ),
        )
        .toList(growable: false);
  }

  double _trackingQuality() {
    if (_gazePoints.length < _minPoints ||
        _targetPoints.length != _gazePoints.length) {
      return 0.0;
    }

    final responsePoints = _gazePoints
        .map(
          (point) =>
              Offset(point.x / _pointResolution, point.y / _pointResolution),
        )
        .toList(growable: false);
    final responseSpread = _dominantSpreadOf(responsePoints);
    if (responseSpread < _minResponseSpread) return 0.0;

    // Correlation — useful but unreliable on mobile, so soft-fail
    final corrX = _axisCorrelation(
      responsePoints,
      _targetPoints,
      (p) => p.dx,
    );
    final corrY = _axisCorrelation(
      responsePoints,
      _targetPoints,
      (p) => p.dy,
    );
    // On mobile, correlation can be 0 or slightly negative due to noise.
    // Use max(0, corr) instead of hard-failing.
    final trackingScore = math.max(corrX, 0.0) * 0.5 + math.max(corrY, 0.0) * 0.5;

    final frameQualityScore = _averageOf(_frameQualitySamples);

    // Spatial spread — most reliable indicator on mobile
    final spreadScore = (responseSpread / 0.15).clamp(0.0, 1.0).toDouble();

    // Point density — enough samples means face was tracked well
    final sampleScore = (_gazePoints.length / (_minPoints * 2.0))
        .clamp(0.0, 1.0)
        .toDouble();

    // Total duration covered
    final totalDurationMs = _gazePoints.fold<int>(0, (sum, p) => sum + p.duration);
    final durationCoverageScore = (totalDurationMs / ((_sessionSeconds - 2) * 1000))
        .clamp(0.0, 1.0)
        .toDouble();

    // Mobile-tuned weights: spread and density matter most
    return spreadScore * 0.30 +
        sampleScore * 0.25 +
        frameQualityScore * 0.20 +
        trackingScore * 0.15 +
        durationCoverageScore * 0.10;
  }

  double _recordingProgress(int nowMs) {
    final startMs = _recordingStartMs;
    if (startMs == null) return _stimulusController.value;

    final elapsedMs = nowMs - startMs;
    final durationMs = _sessionSeconds * 1000;
    return (elapsedMs / durationMs).clamp(0.0, 1.0);
  }

  double _dominantSpreadOf(List<Offset> points) {
    if (points.length < 2) return 0.0;

    var minX = points.first.dx;
    var maxX = points.first.dx;
    var minY = points.first.dy;
    var maxY = points.first.dy;

    for (final point in points.skip(1)) {
      minX = math.min(minX, point.dx);
      maxX = math.max(maxX, point.dx);
      minY = math.min(minY, point.dy);
      maxY = math.max(maxY, point.dy);
    }

    return math.max(maxX - minX, maxY - minY);
  }

  double _axisCorrelation(
    List<Offset> responsePoints,
    List<Offset> targetPoints,
    double Function(Offset point) axis,
  ) {
    final count = math.min(responsePoints.length, targetPoints.length);
    if (count < 3) return 0.0;

    final responseMean =
        responsePoints.take(count).fold<double>(0, (sum, p) => sum + axis(p)) /
        count;
    final targetMean =
        targetPoints.take(count).fold<double>(0, (sum, p) => sum + axis(p)) /
        count;

    var covariance = 0.0;
    var responseVariance = 0.0;
    var targetVariance = 0.0;

    for (var index = 0; index < count; index++) {
      final responseDelta = axis(responsePoints[index]) - responseMean;
      final targetDelta = axis(targetPoints[index]) - targetMean;
      covariance += responseDelta * targetDelta;
      responseVariance += responseDelta * responseDelta;
      targetVariance += targetDelta * targetDelta;
    }

    final denominator = math.sqrt(responseVariance * targetVariance);
    if (denominator == 0) return 0.0;

    return covariance / denominator;
  }

  double _averageOf(List<double> values) {
    if (values.isEmpty) return 0.0;
    return values.fold<double>(0, (sum, value) => sum + value) / values.length;
  }

  Size? _previewContentSize() {
    final previewSize = _camera?.value.previewSize;
    if (previewSize == null) return null;
    return Size(previewSize.height, previewSize.width);
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
        text = 'يتم الالتقاط... اتبع النقطة الصفراء';
        color = Colors.greenAccent;
        icon = Icons.visibility;
      } else {
        text = 'وجه الطفل غير واضح! ضع الوجه داخل الإطار';
        color = Colors.redAccent;
        icon = Icons.visibility_off;
      }
    } else {
      final hasEnoughPoints = _gazePoints.length >= _minPoints;
      final quality = _trackingQuality();
      final hasGoodTracking = quality >= _minTrackingQuality;

      if (hasEnoughPoints && hasGoodTracking) {
        text = 'اكتملت البيانات. جاهز للتحليل ✓';
        color = Colors.greenAccent;
        icon = Icons.check_circle;
      } else if (hasEnoughPoints && quality >= _minTrackingQuality * 0.6) {
        text = 'جودة مقبولة. يمكن الإرسال أو إعادة الفحص';
        color = Colors.blueAccent;
        icon = Icons.check_circle_outline;
      } else if (hasEnoughPoints) {
        text = 'التتبع غير واضح. أعد الفحص مع إضاءة أفضل';
        color = Colors.orangeAccent;
        icon = Icons.track_changes;
      } else {
        text = 'البيانات غير كافية. أعد الفحص';
        color = Colors.orangeAccent;
        icon = Icons.refresh;
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
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
    final previewContentSize = _previewContentSize();

    return Container(
      width: 340.w,
      height: 280.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: _isRecording && !_faceVisible
              ? Colors.redAccent
              : Colors.blueAccent.withValues(alpha: 0.6),
          width: 3,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_camera?.value.isInitialized == true)
              if (previewContentSize != null)
                Center(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: previewContentSize.width,
                      height: previewContentSize.height,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CameraPreview(_camera!),
                          if (_isRecording)
                            IgnorePointer(
                              child: AnimatedBuilder(
                                animation: _stimulusController,
                                builder: (context, _) => CustomPaint(
                                  painter: StimulusTargetPainter(
                                    progress: _stimulusController.value,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                CameraPreview(_camera!)
            else
              const Center(child: CircularProgressIndicator()),

            if (!_isRecording && !_recordingDone)
              Container(
                color: Colors.black.withValues(alpha: 0.4),
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
    if (loading) {
      return ElevatedButton(
        onPressed: null,
        style: _buttonStyle(Colors.blueAccent),
        child: Text('جاري المعالجة...', style: TextStyles.font16WhiteSemiBold),
      );
    }

    if (_isRecording) {
      return ElevatedButton(
        onPressed: null,
        style: _buttonStyle(Colors.grey),
        child: Text('جاري التسجيل...', style: TextStyles.font16WhiteSemiBold),
      );
    }

    if (_recordingDone) {
      final quality = _trackingQuality();
      final canSubmit = _gazePoints.length >= _minPoints && quality >= _minTrackingQuality;
      final canRetry = !canSubmit || quality < _minTrackingQuality * 0.8;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (canSubmit)
            ElevatedButton(
              onPressed: _submit,
              style: _buttonStyle(Colors.green),
              child: Text('إرسال للتحليل', style: TextStyles.font16WhiteSemiBold),
            ),
          if (canSubmit && canRetry) SizedBox(height: 10.h),
          if (canRetry)
            ElevatedButton(
              onPressed: _retryRecording,
              style: _buttonStyle(Colors.orangeAccent),
              child: Text(
                _retryCount > 0 ? 'إعادة الفحص (${_retryCount + 1})' : 'إعادة الفحص',
                style: TextStyles.font16WhiteSemiBold,
              ),
            ),
        ],
      );
    }

    return ElevatedButton(
      onPressed: _startRecording,
      style: _buttonStyle(Colors.blueAccent),
      child: Text('ابدأ الفحص', style: TextStyles.font16WhiteSemiBold),
    );
  }

  ButtonStyle _buttonStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 15.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.r),
      ),
      elevation: 5,
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
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

// ── Stimulus Target Painter ───────────────────────────────────────────────────
class StimulusTargetPainter extends CustomPainter {
  final double progress;

  StimulusTargetPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final target = _stimulusPointAt(progress);
    final center = Offset(target.dx * size.width, target.dy * size.height);

    final outerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.yellowAccent.withValues(alpha: 0.9);
    final innerPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.orangeAccent;
    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.yellowAccent.withValues(alpha: 0.18);

    canvas.drawCircle(center, 22, glowPaint);
    canvas.drawCircle(center, 13, outerPaint);
    canvas.drawCircle(center, 5, innerPaint);
  }

  @override
  bool shouldRepaint(covariant StimulusTargetPainter oldDelegate) =>
      oldDelegate.progress != progress;
}


