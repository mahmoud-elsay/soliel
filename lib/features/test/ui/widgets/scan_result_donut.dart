import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/features/test/data/models/eye_scan_response.dart';

class ScanResultDonut extends StatelessWidget {
  final EyeScanResponse response;

  const ScanResultDonut({super.key, required this.response});

  Color get _fillColor {
    if (response.isHighRisk) return const Color(0xFFC62828);
    if (response.isModerateRisk) return const Color(0xFFF5A623);
    return const Color(0xFF26A69A);
  }

  Color get _bgColor {
    if (response.isHighRisk) return const Color(0xFFFFCDD2);
    if (response.isModerateRisk) return const Color(0xFFF5F5F5);
    return const Color(0xFFE0F2F1);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190.r,
      height: 190.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 190.r,
            height: 190.r,
            child: CircularProgressIndicator(
              value: response.normalizedAsdProbability,
              strokeWidth: 18.r,
              backgroundColor: _bgColor,
              valueColor: AlwaysStoppedAnimation<Color>(_fillColor),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${response.percentageInt}%',
                style: TextStyles.font30GradientBold.copyWith(
                  color: ColorsManager.black,
                ),
              ),
              SizedBox(height: 4.h),
              Text('احتمالية التوحد', style: TextStyles.font12GreyMedium),
            ],
          ),
        ],
      ),
    );
  }
}
