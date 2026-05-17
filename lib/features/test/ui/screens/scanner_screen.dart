import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
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
  static const int _minimumRequiredPoints = 15;
  static const int _targetPointCount = 20;
  static const List<int> _dwellPattern = [
    50,
    34,
    42,
    38,
    34,
    46,
    34,
    52,
    38,
    34,
    44,
    34,
    48,
    36,
    34,
    40,
    34,
    54,
    34,
    38,
  ];

  final ImagePicker _picker = ImagePicker();
  final GlobalKey _overlayKey = GlobalKey();

  String? _pickedImagePath;
  bool _isLoadingDialogVisible = false;
  List<ScanPoint> _generatedScanPath = const [];

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null || !mounted) {
      return;
    }

    setState(() {
      _pickedImagePath = image.path;
      _generatedScanPath = const [];
    });
  }

  void _showLoadingDialog() {
    if (_isLoadingDialogVisible) {
      return;
    }

    _isLoadingDialogVisible = true;
    showAppLoading(context, 'جاري تحليل الصورة...');
  }

  void _hideLoadingDialog() {
    if (!_isLoadingDialogVisible) {
      return;
    }

    Navigator.of(context, rootNavigator: true).pop();
    _isLoadingDialogVisible = false;
  }

  Future<void> _submitScan() async {
    if (_pickedImagePath == null) {
      CustomSnackBar.show(
        context,
        message: 'التقط صورة أو ارفع صورة أولاً.',
        state: SnackBarState.warning,
      );
      return;
    }

    final scanPath = _generatedScanPath.isEmpty
        ? await _buildAutomaticScanPath()
        : _generatedScanPath;

    if (!mounted) {
      return;
    }

    if (scanPath.length < _minimumRequiredPoints) {
      CustomSnackBar.show(
        context,
        message: 'تعذر تجهيز مسار التحليل. حاول إعادة التقاط الصورة.',
        state: SnackBarState.error,
      );
      return;
    }

    setState(() {
      _generatedScanPath = scanPath;
    });

    context.read<EyeScanCubit>().analyzeEyeScan(
      childId: 1,
      notes: '',
      scanPath: scanPath,
    );
  }

  Future<List<ScanPoint>> _buildAutomaticScanPath() async {
    await WidgetsBinding.instance.endOfFrame;

    final renderObject = _overlayKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || _pickedImagePath == null) {
      return const [];
    }

    final overlayOrigin = renderObject.localToGlobal(Offset.zero);
    final overlaySize = renderObject.size;
    final anchors = await _extractAnchorsFromImage(overlaySize);
    final denseLocalPath = _buildDensePath(
      anchors.isEmpty ? _fallbackAnchors(overlaySize) : anchors,
      overlaySize,
    );

    return List<ScanPoint>.generate(denseLocalPath.length, (index) {
      final point = denseLocalPath[index];
      return ScanPoint(
        idx: index,
        x: (overlayOrigin.dx + point.dx).roundToDouble(),
        y: (overlayOrigin.dy + point.dy).roundToDouble(),
        duration: _dwellPattern[index % _dwellPattern.length],
      );
    });
  }

  Future<List<Offset>> _extractAnchorsFromImage(Size overlaySize) async {
    final decoded = await _decodeImage(_pickedImagePath!);
    if (decoded == null) {
      return const [];
    }

    const int columns = 6;
    const int rows = 4;
    final candidates = <_CellCandidate>[];

    for (var row = 0; row < rows; row++) {
      for (var column = 0; column < columns; column++) {
        final startX = (decoded.width * column / columns).floor();
        final endX = (decoded.width * (column + 1) / columns).floor();
        final startY = (decoded.height * row / rows).floor();
        final endY = (decoded.height * (row + 1) / rows).floor();

        final score = _scoreCell(
          decoded.bytes,
          decoded.width,
          startX,
          endX,
          startY,
          endY,
        );

        final normalizedX = (column + 0.5) / columns;
        final normalizedY = (row + 0.5) / rows;
        final centerBias =
            1 -
            (((normalizedX - 0.5).abs() * 0.8) +
                ((normalizedY - 0.38).abs() * 1.1));

        candidates.add(
          _CellCandidate(
            point: Offset(
              overlaySize.width * normalizedX,
              overlaySize.height * normalizedY,
            ),
            score: score * (0.85 + math.max(0, centerBias)),
          ),
        );
      }
    }

    candidates.sort((a, b) => b.score.compareTo(a.score));
    final selected = candidates.take(8).map((candidate) => candidate.point);

    final start = Offset(overlaySize.width * 0.5, overlaySize.height * 0.24);
    final orderedAnchors = <Offset>[start];
    final remaining = selected.toList();
    var current = start;

    while (remaining.isNotEmpty) {
      remaining.sort(
        (a, b) => _distanceSquared(
          current,
          a,
        ).compareTo(_distanceSquared(current, b)),
      );

      final next = remaining.removeAt(0);
      if (_distanceSquared(current, next) > 400) {
        orderedAnchors.add(next);
        current = next;
      }
    }

    orderedAnchors.add(
      Offset(overlaySize.width * 0.5, overlaySize.height * 0.62),
    );

    return orderedAnchors;
  }

  Future<_DecodedImageData?> _decodeImage(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: 120,
        targetHeight: 120,
      );

      try {
        final frame = await codec.getNextFrame();
        final image = frame.image;

        try {
          final byteData = await image.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          );

          if (byteData == null) {
            return null;
          }

          return _DecodedImageData(
            bytes: byteData.buffer.asUint8List(),
            width: image.width,
            height: image.height,
          );
        } finally {
          image.dispose();
        }
      } finally {
        codec.dispose();
      }
    } catch (_) {
      return null;
    }
  }

  double _scoreCell(
    Uint8List bytes,
    int width,
    int startX,
    int endX,
    int startY,
    int endY,
  ) {
    double sum = 0;
    double sumSquares = 0;
    double edges = 0;
    int count = 0;

    for (var y = startY; y < endY; y += 2) {
      for (var x = startX; x < endX; x += 2) {
        final luminance = _luminanceAt(bytes, width, x, y);
        sum += luminance;
        sumSquares += luminance * luminance;
        count++;

        if (x + 1 < endX) {
          edges += (luminance - _luminanceAt(bytes, width, x + 1, y)).abs();
        }
        if (y + 1 < endY) {
          edges += (luminance - _luminanceAt(bytes, width, x, y + 1)).abs();
        }
      }
    }

    if (count == 0) {
      return 0;
    }

    final mean = sum / count;
    final variance = (sumSquares / count) - (mean * mean);

    return variance + (edges / count);
  }

  double _luminanceAt(Uint8List bytes, int width, int x, int y) {
    final index = ((y * width) + x) * 4;
    final red = bytes[index];
    final green = bytes[index + 1];
    final blue = bytes[index + 2];
    return (0.299 * red) + (0.587 * green) + (0.114 * blue);
  }

  List<Offset> _buildDensePath(List<Offset> anchors, Size overlaySize) {
    final safeAnchors = anchors.isEmpty
        ? _fallbackAnchors(overlaySize)
        : anchors;
    final densePoints = <Offset>[safeAnchors.first];

    for (var index = 0; index < safeAnchors.length - 1; index++) {
      final start = safeAnchors[index];
      final end = safeAnchors[index + 1];

      densePoints.add(Offset.lerp(start, end, 0.33)!);
      densePoints.add(Offset.lerp(start, end, 0.66)!);
      densePoints.add(end);
    }

    while (densePoints.length < _targetPointCount) {
      final seed = densePoints.length;
      final base = safeAnchors[seed % safeAnchors.length];
      final xJitter = ((seed % 5) - 2) * 8.0;
      final yJitter = ((seed % 3) - 1) * 6.0;

      densePoints.add(
        Offset(
          (base.dx + (xJitter == 0 ? 5.0 : xJitter)).clamp(
            0.0,
            overlaySize.width,
          ),
          (base.dy + (yJitter == 0 ? 4.0 : yJitter)).clamp(
            0.0,
            overlaySize.height,
          ),
        ),
      );
    }

    return densePoints.take(_targetPointCount).toList();
  }

  List<Offset> _fallbackAnchors(Size overlaySize) {
    return [
      Offset(overlaySize.width * 0.50, overlaySize.height * 0.24),
      Offset(overlaySize.width * 0.36, overlaySize.height * 0.28),
      Offset(overlaySize.width * 0.64, overlaySize.height * 0.28),
      Offset(overlaySize.width * 0.30, overlaySize.height * 0.38),
      Offset(overlaySize.width * 0.70, overlaySize.height * 0.38),
      Offset(overlaySize.width * 0.44, overlaySize.height * 0.48),
      Offset(overlaySize.width * 0.56, overlaySize.height * 0.48),
      Offset(overlaySize.width * 0.50, overlaySize.height * 0.62),
    ];
  }

  double _distanceSquared(Offset a, Offset b) {
    final dx = a.dx - b.dx;
    final dy = a.dy - b.dy;
    return (dx * dx) + (dy * dy);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EyeScanCubit, EyeScanState>(
      listener: (context, state) {
        state.whenOrNull(
          loading: _showLoadingDialog,
          success: (response) {
            _hideLoadingDialog();
            if (!mounted) {
              return;
            }

            Navigator.pushNamed(
              context,
              Routes.scanResultScreen,
              arguments: response,
            );
          },
          error: (error) {
            _hideLoadingDialog();
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
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.white, size: 30.r),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'ابدأ المسح الآن',
                  style: TextStyles.font24GradientExtraBold.copyWith(
                    color: Colors.white,
                    fontSize: 30.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                Text(
                  'وجه الكاميرا نحو الطفل أو اختر صورة واضحة، وسيتم تجهيز مسار التحليل تلقائياً.',
                  style: TextStyles.font14GreyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.h),
                _buildScannerOverlay(),
                const Spacer(),
                if (_pickedImagePath != null)
                  ElevatedButton(
                    onPressed: isSubmitting ? null : _submitScan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      disabledBackgroundColor: Colors.blue.withValues(
                        alpha: 0.4,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.w,
                        vertical: 12.h,
                      ),
                    ),
                    child: Text('تأكيد', style: TextStyles.font16WhiteSemiBold),
                  )
                else
                  _buildLoadingIndicator(),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildUploadOption(),
                    SizedBox(width: 40.w),
                    _buildCaptureOption(),
                  ],
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScannerOverlay() {
    return Container(
      key: _overlayKey,
      width: 330.w,
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Stack(
        children: [
          if (_pickedImagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: Image.file(
                File(_pickedImagePath!),
                width: 330.w,
                height: 200.h,
                fit: BoxFit.cover,
              ),
            )
          else
            Center(
              child: Container(width: 310.w, height: 2.h, color: Colors.orange),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        SizedBox(
          width: 80.r,
          height: 80.r,
          child: CircularProgressIndicator(
            value: 0.7,
            strokeWidth: 8.r,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          'التقط صورة لبدء التحليل',
          style: TextStyles.font20BlackSemiBold.copyWith(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildUploadOption() {
    return Column(
      children: [
        IconButton(
          onPressed: () => _pickImage(ImageSource.gallery),
          icon: Icon(Icons.cloud_upload, color: Colors.white, size: 40.r),
        ),
        Text(
          'رفع صورة',
          style: TextStyles.font12BlackRegular.copyWith(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildCaptureOption() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _pickImage(ImageSource.camera),
          child: Container(
            width: 80.r,
            height: 80.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Center(
              child: Container(
                width: 60.r,
                height: 60.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'التقاط',
          style: TextStyles.font12BlackRegular.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}

class _DecodedImageData {
  final Uint8List bytes;
  final int width;
  final int height;

  const _DecodedImageData({
    required this.bytes,
    required this.width,
    required this.height,
  });
}

class _CellCandidate {
  final Offset point;
  final double score;

  const _CellCandidate({required this.point, required this.score});
}
