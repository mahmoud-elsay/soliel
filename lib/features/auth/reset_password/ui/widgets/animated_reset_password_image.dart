import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedResetPasswordImage extends StatelessWidget {
  final bool isEmailFieldFocused;

  const AnimatedResetPasswordImage({
    super.key,
    required this.isEmailFieldFocused,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutQuart,
      tween: Tween<double>(
        begin: isEmailFieldFocused ? 1.0 : 0.0,
        end: isEmailFieldFocused ? 0.0 : 1.0,
      ),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.5 + (value * 0.5), // Scale from 0.5 to 1.0
          child: Transform.translate(
            offset: Offset(0, -50 * (1 - value)), // Slide up while hiding
            child: Opacity(
              opacity: value,
              child: SizedBox(
                height: 250.h * value,
                child: value > 0.1
                    ? Image.asset(
                        'assets/images/reset_password_image.png',
                        height: 250.h,
                        fit: BoxFit.contain,
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        );
      },
    );
  }
}
