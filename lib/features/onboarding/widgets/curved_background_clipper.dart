import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'dart:math' as math;

class OnboardingBackground extends StatelessWidget {
  final bool isFirstScreen;

  const OnboardingBackground({super.key, required this.isFirstScreen});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -80.h,
      left: isFirstScreen ? null : -50,
      right: isFirstScreen ? -50 : null,
      child: Transform.rotate(
        angle: (isFirstScreen ? 28 : -28) * (math.pi / 180),
        child: Container(
          width: 380.w,
          height: 500.h,
          decoration: BoxDecoration(
            gradient: ColorsManager.primaryGradient,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(300.r),
              bottomLeft: Radius.circular(300.r),
            ),
          ),
        ),
      ),
    );
  }
}
