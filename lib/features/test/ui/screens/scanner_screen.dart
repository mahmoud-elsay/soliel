import 'dart:async';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/shared_pref_helper.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_loading_indicator.dart';
import 'package:soliel/core/widgets/custom_snack_bar.dart';
import 'package:soliel/features/test/logic/eye_scan_cubit/eye_scan_cubit.dart';
import 'package:soliel/features/test/logic/eye_scan_cubit/eye_scan_state.dart';
import 'package:soliel/features/test/ui/vision/camera/camera_service.dart';
import 'package:soliel/features/test/ui/vision/debug/debug_overlay.dart';
import 'package:soliel/features/test/ui/vision/debug/logger.dart';
import 'package:soliel/features/test/ui/vision/models/vision_state.dart';
import 'package:soliel/features/test/ui/vision/processing/vision_scan_session.dart';

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
  static const int _sessionSeconds = 30;
  static const String _notes = '';

  late final VisionLogger _logger;
  late final VisionCameraService _cameraService;
  late final VisionScanSession _visionSession;
  late final AnimationController _stimulusController;

  // Resolved asynchronously from SharedPreferences
  int _childId = 1;

  VisionState _visionState = VisionState.initial();
  bool _isRecording = false;
  bool _recordingDone = false;
  bool _isHandlingFrame = false;
  bool _loadingVisible = false;
  bool _showDebugOverlay = kDebugMode;
  int _secondsLeft = _sessionSeconds;
  int _retryCount = 0;
  int? _recordingStartMs;
  Timer? _timer;

  CameraController? get _camera => _cameraService.controller;

  @override
  void initState() {
    super.initState();
    _logger = VisionLogger.debug();
    _cameraService = VisionCameraService(logger: _logger);
    _visionSession = VisionScanSession(logger: _logger);
    _stimulusController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _sessionSeconds),
    );
    unawaited(_loadChildIdAndInit());
  }

  Future<void> _loadChildIdAndInit() async {
    _childId = await StorageHelper.getChildId();
    await _initCamera();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _isRecording = false;
    unawaited(_cameraService.dispose());
    unawaited(_visionSession.dispose());
    _stimulusController.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    final result = await _cameraService.initialize();
    if (!mounted) return;

    if (!result.permissionGranted || result.errorMessage != null) {
      CustomSnackBar.show(
        context,
        message: result.errorMessage ?? 'يرجى السماح باستخدام الكاميرا.',
        state: SnackBarState.error,
      );
    }

    setState(() {});
  }

  Future<void> _startRecording() async {
    if (_camera == null || _camera?.value.isInitialized != true) {
      await _initCamera();
    }

    final camera = _camera;
    if (camera == null || !camera.value.isInitialized || !mounted) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    _timer?.cancel();
    _visionSession.start(now);
    _recordingStartMs = now;

    setState(() {
      _visionState = _visionSession.state;
      _isRecording = true;
      _recordingDone = false;
      _secondsLeft = _sessionSeconds;
    });

    _stimulusController.forward(from: 0);
    _timer = Timer.periodic(const Duration(seconds: 1), _onTimerTick);

    try {
      await _cameraService.startStream(_onFrame);
    } on CameraException catch (error) {
      _timer?.cancel();
      _stimulusController.stop();
      _visionSession.stop();
      if (!mounted) return;

      setState(() {
        _isRecording = false;
        _recordingDone = false;
        _visionState = _visionSession.state;
      });

      CustomSnackBar.show(
        context,
        message: error.description ?? 'تعذر تشغيل الكاميرا. حاول مرة أخرى.',
        state: SnackBarState.error,
      );
    }
  }

  void _onTimerTick(Timer timer) {
    if (!mounted) {
      timer.cancel();
      return;
    }

    setState(() {
      _secondsLeft = (_secondsLeft - 1).clamp(0, _sessionSeconds);
    });

    if (_secondsLeft <= 0) {
      timer.cancel();
      _stopRecording();
    }
  }

  void _retryRecording() {
    _retryCount++;
    unawaited(_startRecording());
  }

  void _stopRecording() {
    _timer?.cancel();
    unawaited(_cameraService.stopStream());
    _stimulusController.stop();
    final stoppedState = _visionSession.stop();

    if (!mounted) return;
    setState(() {
      _isRecording = false;
      _recordingDone = true;
      _visionState = stoppedState;
    });
  }

  Future<void> _onFrame(CameraImage image) async {
    if (_isHandlingFrame || !_isRecording) return;
    _isHandlingFrame = true;

    try {
      final camera = _camera;
      if (camera == null) return;

      final now = DateTime.now().millisecondsSinceEpoch;
      final state = await _visionSession.processFrame(
        image: image,
        camera: camera.description,
        deviceOrientation: camera.value.deviceOrientation,
        targetPoint: _stimulusPointAt(_recordingProgress(now)),
        nowMs: now,
      );

      if (state == null || !mounted || !_isRecording) return;
      setState(() => _visionState = state);
    } finally {
      _isHandlingFrame = false;
    }
  }

  double _recordingProgress(int nowMs) {
    final startMs = _recordingStartMs;
    if (startMs == null) return _stimulusController.value;

    return ((nowMs - startMs) / (_sessionSeconds * 1000)).clamp(0.0, 1.0);
  }

  /// Submit unconditionally after the session ends — even if data quality is
  /// below the preferred threshold. The backend will handle poor-quality data.
  void _submit() {
    final validation = _visionSession.validatePayload(
      childId: _childId,
      notes: _notes,
    );

    // Always send whatever was collected; only block if truly zero points.
    if (validation.scanPath.isEmpty) {
      CustomSnackBar.show(
        context,
        message: 'لم يتم التقاط أي بيانات. حاول مرة أخرى في إضاءة أفضل.',
        state: SnackBarState.warning,
      );
      return;
    }

    context.read<EyeScanCubit>().analyzeEyeScan(
      childId: _childId,
      notes: _notes,
      scanPath: validation.scanPath,
    );
  }

  void _showLoading() {
    if (_loadingVisible) return;
    _loadingVisible = true;
    showAppLoading(context, 'جاري تحليل مسار العين...');
  }

  void _hideLoading() {
    if (!_loadingVisible || !mounted) return;
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
    _loadingVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EyeScanCubit, EyeScanState>(
      listener: (context, state) {
        state.whenOrNull(
          loading: _showLoading,
          success: (response) {
            if (!mounted) return;
            _hideLoading();

            Navigator.pushNamed(
              context,
              Routes.scanResultScreen,
              arguments: response,
            );
          },
          error: (error) {
            if (!mounted) return;
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
          backgroundColor: const Color(0xFF0D1117),
          body: SafeArea(
            child: Column(
              children: [
                // ── Top bar ──────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: Colors.white70,
                          size: 26.r,
                        ),
                      ),
                      Text(
                        'فحص تتبع العين',
                        style: TextStyles.font24GradientExtraBold.copyWith(
                          color: Colors.white,
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(width: 48.w),
                    ],
                  ),
                ),

                // ── Instructions (idle only) ─────────────────────────
                if (!_isRecording && !_recordingDone)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 6.h,
                    ),
                    child: Text(
                      'ضع وجه الطفل في الإطار ثم اضغط ابدأ الفحص.\nسيتحرك هدف أصفر — اطلب من الطفل متابعته بعينيه.',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 13.sp,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // ── Status banner ────────────────────────────────────
                _buildStatusBanner(),
                SizedBox(height: 12.h),

                // ── Camera + progress ring ──────────────────────────
                _buildScanningArea(),

                SizedBox(height: 16.h),

                // ── Stats ───────────────────────────────────────────
                if (_isRecording || _recordingDone) _buildStatsRow(),

                const Spacer(),

                // ── Action button ────────────────────────────────────
                _buildPrimaryButton(isSubmitting),
                SizedBox(height: 36.h),
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
      if (_visionState.faceVisible) {
        text = 'يتم الالتقاط... اتبع النقطة الصفراء';
        color = Colors.greenAccent;
        icon = Icons.visibility;
      } else {
        text = 'وجه الطفل غير واضح. ضع الوجه داخل الإطار';
        color = Colors.redAccent;
        icon = Icons.visibility_off;
      }
    } else if (_visionState.readyForUpload) {
      text = 'اكتملت البيانات. جاهز للتحليل';
      color = Colors.greenAccent;
      icon = Icons.check_circle;
    } else if (_visionState.sampleCount > 0) {
      text = 'البيانات غير كافية. أعد الفحص بإضاءة أفضل';
      color = Colors.orangeAccent;
      icon = Icons.track_changes;
    } else {
      text = 'لم يتم التقاط مسار صالح. أعد الفحص';
      color = Colors.orangeAccent;
      icon = Icons.refresh;
    }

    return Container(
      constraints: BoxConstraints(maxWidth: 340.w),
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
          Flexible(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontSize: 13.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningArea() {
    final previewContentSize = _cameraService.previewContentSize();
    final borderColor = _isRecording && !_visionState.faceVisible
        ? Colors.redAccent
        : _isRecording
        ? Colors.greenAccent.withValues(alpha: 0.8)
        : Colors.blueAccent.withValues(alpha: 0.5);

    // Ring progress: counts down from 1.0 → 0.0
    final ringProgress = _isRecording
        ? _secondsLeft / _sessionSeconds
        : _recordingDone
        ? 0.0
        : 1.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Circular countdown ring
        if (_isRecording)
          SizedBox(
            width: 356.w,
            height: 296.h,
            child: CustomPaint(
              painter: _CountdownRingPainter(
                progress: ringProgress,
                color: _visionState.faceVisible
                    ? Colors.greenAccent
                    : Colors.redAccent,
              ),
            ),
          ),
        Container(
          width: 340.w,
          height: 280.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: borderColor, width: 2.5),
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
                              if (_isRecording)
                                IgnorePointer(
                                  child: VisionDebugOverlay(
                                    state: _visionState,
                                    show: _showDebugOverlay,
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

                // Idle overlay
                if (!_isRecording && !_recordingDone)
                  Container(
                    color: Colors.black.withValues(alpha: 0.45),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.face_retouching_natural,
                          color: Colors.white30,
                          size: 80.r,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'ضع الوجه هنا',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Countdown badge top-left
                if (_isRecording)
                  Positioned(
                    top: 10,
                    left: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '$_secondsLeft s',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Face indicator badge top-right
                if (_isRecording)
                  Positioned(
                    top: 10,
                    right: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: _visionState.faceVisible
                            ? Colors.greenAccent.withValues(alpha: 0.25)
                            : Colors.redAccent.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _visionState.faceVisible
                                ? Icons.face
                                : Icons.no_photography_outlined,
                            color: _visionState.faceVisible
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            size: 14.r,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _visionState.faceVisible ? 'وجه مكتشف' : 'لا وجه',
                            style: TextStyle(
                              color: _visionState.faceVisible
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (kDebugMode)
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: IconButton.filledTonal(
                      tooltip: 'Debug overlay',
                      onPressed: () {
                        setState(() => _showDebugOverlay = !_showDebugOverlay);
                      },
                      icon: Icon(
                        _showDebugOverlay
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    final confidence = (_visionState.averageConfidence * 100).round();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMiniStat(
          'النقاط',
          '${_visionState.sampleCount}',
          _visionState.readyForUpload
              ? Colors.greenAccent
              : Colors.orangeAccent,
        ),
        _buildMiniStat(
          'الثقة',
          '$confidence%',
          confidence >= 35 ? Colors.greenAccent : Colors.amberAccent,
        ),
        _buildMiniStat('الثواني', '${_secondsLeft}s', Colors.blueAccent),
      ],
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
      // Always show Send — the quality gate was removed.
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: _submit,
            style: _buttonStyle(const Color(0xFF2ECC71)),
            icon: const Icon(Icons.send_rounded, size: 20),
            label: Text('إرسال للتحليل', style: TextStyles.font16WhiteSemiBold),
          ),
          SizedBox(height: 10.h),
          TextButton.icon(
            onPressed: _retryRecording,
            icon: Icon(
              Icons.refresh_rounded,
              color: Colors.white60,
              size: 18.r,
            ),
            label: Text(
              _retryCount > 0
                  ? 'إعادة الفحص (${_retryCount + 1})'
                  : 'إعادة الفحص بإضاءة أفضل',
              style: TextStyle(color: Colors.white60, fontSize: 14.sp),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
      elevation: 5,
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Container(
      width: 96.w,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                color: color,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white54, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}

// ─── Countdown ring painter ──────────────────────────────────────────────────
class _CountdownRingPainter extends CustomPainter {
  final double progress; // 1.0 → full, 0.0 → empty
  final Color color;

  const _CountdownRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(4, 4, size.width - 8, size.height - 8);
    final bgPaint = Paint()
      ..color = Colors.white10
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final fgPaint = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawOval(rect, bgPaint);
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _CountdownRingPainter old) =>
      old.progress != progress || old.color != color;
}

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
  bool shouldRepaint(covariant StimulusTargetPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
