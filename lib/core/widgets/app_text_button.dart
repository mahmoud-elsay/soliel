import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/font_weight_helper.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';

import '../theming/styles.dart';

class AppTextButton extends StatelessWidget {
  final String textButton;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Gradient? textGradient; // New parameter for gradient text
  final Color? disabledBackgroundColor;
  final Color? disabledTextColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;

  const AppTextButton({
    super.key,
    required this.onPressed,
    required this.textButton,
    this.gradient,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.textGradient, // New parameter
    this.disabledBackgroundColor,
    this.disabledTextColor,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;

    return Padding(
      padding: margin ?? EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 56.h,
        decoration: BoxDecoration(
          gradient: isEnabled && gradient != null ? gradient : null,
          color: isEnabled
              ? backgroundColor
              : (disabledBackgroundColor ??
                    ColorsManager.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
          border: borderColor != null
              ? Border.all(
                  color: isEnabled ? borderColor! : Colors.transparent,
                  width: 1,
                )
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
            child: Container(
              padding: padding ?? EdgeInsets.symmetric(vertical: 16.h),
              alignment: Alignment.center,
              child: _buildText(isEnabled),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildText(bool isEnabled) {
    final textWidget = Text(
      textButton,
      style: TextStyles.font16WhiteSemiBold.copyWith(
        color: isEnabled
            ? (textGradient != null
                  ? null // No color when using gradient
                  : (textColor ?? ColorsManager.white))
            : (disabledTextColor ?? ColorsManager.white.withOpacity(0.5)),
        fontSize: fontSize ?? 16.sp,
        fontWeight: fontWeight ?? FontWeightHelper.semiBold,
      ),
      textAlign: TextAlign.center,
    );

    if (isEnabled && textGradient != null) {
      return AppGradientText(gradient: textGradient!, child: textWidget);
    }

    return textWidget;
  }
}
