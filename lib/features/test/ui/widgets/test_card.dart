import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';

class TestCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String? capturedImagePath;
  final VoidCallback onTap;

  const TestCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.capturedImagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 333.w,
        height: 143.h,
        decoration: BoxDecoration(
          color: ColorsManager.lightBlue,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 15.w,
              top: 15.h,
              bottom: 15.h,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 100.w), // Space for image
                child: AppGradientText(
                  gradient: ColorsManager.primaryGradient,
                  child: Text(
                    title,
                    style: TextStyles.font20GradientSemiBold,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
