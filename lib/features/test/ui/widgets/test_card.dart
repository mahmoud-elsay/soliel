import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';

class TestCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;
  final Border? border;
  final double? customWidth;

  const TestCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
    this.border,
    this.customWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: customWidth?.w ?? 333.w,
        height: 143.h,
        decoration: BoxDecoration(
          color: ColorsManager.lightBlue,
          borderRadius: BorderRadius.circular(15.r),
          border: border,
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
            PositionedDirectional(
              end: 15.w,
              top: 15.h,
              bottom: 15.h,
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
            Center(
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: 10.w, end: 100.w), // Space for image on the left (end)
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
