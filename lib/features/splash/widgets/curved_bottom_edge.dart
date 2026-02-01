import 'package:flutter/material.dart';

class CurvedBottomEdge extends StatelessWidget {
  final Widget child;

  const CurvedBottomEdge({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _CurveClipper(),
      child: Container(color: const Color(0xFFE8EDF5), child: child),
    );
  }
}

class _CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top-left with curve
    path.moveTo(0, size.height * 0.15);

    // Create smooth curve at the top
    path.quadraticBezierTo(
      size.width * 0.5, // Control point x (middle)
      0, // Control point y (top)
      size.width, // End point x (right)
      size.height * 0.15, // End point y
    );

    // Draw right edge
    path.lineTo(size.width, size.height);

    // Draw bottom edge
    path.lineTo(0, size.height);

    // Close path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
