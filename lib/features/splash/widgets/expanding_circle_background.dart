import 'dart:math';
import 'package:flutter/material.dart';
import 'package:soliel/core/theming/colors_manger.dart';

class ExpandingCircleBackground extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const ExpandingCircleBackground({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, childWidget) {
        final size = MediaQuery.of(context).size;

        // 0.0 → 1.0
        final t = animation.value.clamp(0.0, 1.0);

        // Base size = shortest side (so it starts as perfect circle)
        final baseSize = size.shortestSide;

        // How much we scale beyond the screen size
        // 1.0 = fits shortest side, >1.0 overflows to cover corners
        final minScale = 0.65; // starts reasonably small but visible
        final maxScale =
            (size.longestSide / baseSize) * 1.9 +
            0.3; // enough to fill + a bit more

        final scale = minScale + t * (maxScale - minScale);

        return SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              // Growing circle → becomes very large and overflows → fills screen
              Transform.scale(
                scale: scale,
                child: Container(
                  width: baseSize,
                  height: baseSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorsManager.primaryGradientEnd,
                        ColorsManager.primaryGradientStart,
                      ],
                    ),
                  ),
                ),
              ),

              // Logo / child stays centered and normal size
              Center(child: childWidget),
            ],
          ),
        );
      },
      child: child,
    );
  }
}
