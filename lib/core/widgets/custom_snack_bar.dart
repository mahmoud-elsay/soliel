import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';

enum SnackBarState { success, error, warning }

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    required SnackBarState state,
  }) {
    final backgroundColor = _getBackgroundColor(state);
    final icon = _getIcon(state);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: ColorsManager.white,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: TextStyles.font14BlackMedium.copyWith(
                  color: ColorsManager.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static Color _getBackgroundColor(SnackBarState state) {
    switch (state) {
      case SnackBarState.success:
        return ColorsManager.green;
      case SnackBarState.error:
        return ColorsManager.red;
      case SnackBarState.warning:
        return ColorsManager.skyBlue;
    }
  }

  static IconData _getIcon(SnackBarState state) {
    switch (state) {
      case SnackBarState.success:
        return Icons.check_circle_outline;
      case SnackBarState.error:
        return Icons.error_outline;
      case SnackBarState.warning:
        return Icons.warning_amber_outlined;
    }
  }
}
