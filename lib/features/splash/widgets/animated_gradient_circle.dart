import 'package:flutter/material.dart';
import 'package:soliel/core/theming/colors_manger.dart';

class AnimatedGradientCircle extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const AnimatedGradientCircle({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, childWidget) {
        final screenSize = MediaQuery.of(context).size;
        // Calculate max size to fill entire screen
        final maxDimension = screenSize.height > screenSize.width
            ? screenSize.height
            : screenSize.width;
        final maxSize = maxDimension * 3.0;

        // Start with a small circle (responsive), expand to fill screen
        // Use 70% of screen width as initial size to match reference
        final minSize = screenSize.width * 0.7;
        final currentSize = minSize + (animation.value * (maxSize - minSize));

        // Dynamic gradient stops to ensure the visible area matches the screen gradient
        // At start (val=0): stops [0, 1] -> Full gradient visible on small circle
        // At end (val=1): stops [0.33, 0.67] -> Visible screen area (middle 1/3 of huge circle) shows full gradient
        final stop1 = 0.33 * animation.value;
        final stop2 = 1.0 - (0.33 * animation.value);

        return Center(
          child: Container(
            width: currentSize,
            height: currentSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorsManager.primaryGradientEnd,
                  ColorsManager.primaryGradientStart,
                ],
                stops: [stop1, stop2],
              ),
            ),
            // Logo is always visible and centered from the start
            child: Center(child: childWidget),
          ),
        );
      },
      // Pass child to AnimatedBuilder to avoid rebuilding it
      child: child,
    );
  }
}
