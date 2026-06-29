import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:soliel/features/test/ui/vision/models/vision_frame.dart';
import 'package:soliel/features/test/ui/vision/models/vision_state.dart';

class VisionDebugOverlay extends StatelessWidget {
  final VisionState state;
  final bool show;

  const VisionDebugOverlay({
    super.key,
    required this.state,
    this.show = kDebugMode,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();

    return CustomPaint(
      painter: _VisionDebugPainter(state),
      child: const SizedBox.expand(),
    );
  }
}

class _VisionDebugPainter extends CustomPainter {
  final VisionState state;

  _VisionDebugPainter(this.state);

  @override
  void paint(Canvas canvas, Size size) {
    final frame = state.lastFrame;
    if (frame != null) {
      _drawFace(canvas, size, frame);
      _drawEyes(canvas, size, frame);
      _drawGaze(canvas, size, frame);
    }
    _drawStats(canvas, size, frame);
  }

  void _drawFace(Canvas canvas, Size size, VisionFrame frame) {
    final rect = frame.faceRect;
    if (rect == null) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.lightGreenAccent;
    canvas.drawRect(
      Rect.fromLTRB(
        rect.left * size.width,
        rect.top * size.height,
        rect.right * size.width,
        rect.bottom * size.height,
      ),
      paint,
    );
  }

  void _drawEyes(Canvas canvas, Size size, VisionFrame frame) {
    final contourPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = Colors.cyanAccent;
    final pupilPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.deepOrangeAccent;

    _drawContour(canvas, size, frame.leftEyeContour, contourPaint);
    _drawContour(canvas, size, frame.rightEyeContour, contourPaint);

    for (final point in <Offset?>[frame.leftPupil, frame.rightPupil]) {
      if (point == null) continue;
      canvas.drawCircle(
        Offset(point.dx * size.width, point.dy * size.height),
        4,
        pupilPaint,
      );
    }
  }

  void _drawContour(
    Canvas canvas,
    Size size,
    List<Offset> points,
    Paint paint,
  ) {
    if (points.length < 2) return;

    final path = Path()
      ..moveTo(points.first.dx * size.width, points.first.dy * size.height);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx * size.width, point.dy * size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawGaze(Canvas canvas, Size size, VisionFrame frame) {
    final gaze = frame.gaze;
    if (gaze == null) return;

    final center = Offset(gaze.dx * size.width, gaze.dy * size.height);
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.yellowAccent;
    final dot = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.orangeAccent;

    canvas.drawCircle(center, 11, ring);
    canvas.drawCircle(center, 4, dot);
  }

  void _drawStats(Canvas canvas, Size size, VisionFrame? frame) {
    final lines = <String>[
      'fps ${state.fps.toStringAsFixed(1)}',
      'samples ${state.sampleCount}',
      'conf ${(state.averageConfidence * 100).round()}%',
      'quality ${(state.averageQuality * 100).round()}%',
      if (frame != null)
        'signals H${frame.usedHeadPose ? 1 : 0} L${frame.usedLandmarks ? 1 : 0} C${frame.usedContours ? 1 : 0} T${frame.usedHistory ? 1 : 0}',
      if (state.lastRejectedReason != null)
        'reject ${state.lastRejectedReason}',
    ];

    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 10,
      height: 1.18,
    );
    final painter = TextPainter(
      text: TextSpan(text: lines.join('\n'), style: textStyle),
      textDirection: TextDirection.ltr,
      maxLines: 7,
    )..layout(maxWidth: size.width - 16);

    final panel = Rect.fromLTWH(6, 6, painter.width + 12, painter.height + 10);
    final background = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black.withValues(alpha: 0.58);

    canvas.drawRRect(
      RRect.fromRectAndRadius(panel, const Radius.circular(6)),
      background,
    );
    painter.paint(canvas, const Offset(12, 11));
  }

  @override
  bool shouldRepaint(covariant _VisionDebugPainter oldDelegate) {
    return oldDelegate.state != state;
  }
}
