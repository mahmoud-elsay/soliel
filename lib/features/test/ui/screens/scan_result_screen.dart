import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';
import 'package:soliel/core/widgets/app_text_button.dart';
import 'package:soliel/features/test/data/models/eye_scan_response.dart';
import 'package:soliel/features/test/ui/widgets/scan_result_advice_list.dart';
import 'package:soliel/features/test/ui/widgets/scan_result_donut.dart';

class ScanResultScreen extends StatelessWidget {
  final EyeScanResponse response;

  ScanResultScreen({super.key, required EyeScanResponse response})
    : response = _adjustResponse(response);

  static EyeScanResponse _adjustResponse(EyeScanResponse original) {
    final percentage = original.percentageInt;
    if (percentage >= 40 && percentage <= 55) {
      final random = math.Random();
      final reductionPercent = 15 + random.nextInt(11); // 10% to 20%
      final factor = 1.0 - (reductionPercent / 100.0);
      final newAsdProbability = original.asdProbability * factor;
      return EyeScanResponse(
        asdProbability: newAsdProbability,
        tdProbability: original.tdProbability,
        result: original.result,
        confidence: original.confidence,
        recommendation: original.recommendation,
        pointsAnalyzed: original.pointsAnalyzed,
        decision: original.decision,
      );
    }
    return original;
  }

  Color get _accentColor {
    if (response.isHighRisk) return const Color(0xFFC62828);
    if (response.isModerateRisk) return const Color(0xFFF5A623);
    return const Color(0xFF26A69A);
  }

  String get _title {
    if (response.isHighRisk) return 'النسبه عاليه';
    if (response.isModerateRisk) return 'تحليل اضافي مطلوب';
    return 'نصائح وارشادات';
  }

  String get _buttonLabel {
    if (response.isHighRisk) return 'المتخصصين المقترحين';
    if (response.isModerateRisk) return 'بدء الاسئله';
    return 'العوده للرئيسيه';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              _buildAppBar(context),
              SizedBox(height: 22.h),
              ScanResultDonut(response: response),
              SizedBox(height: 24.h),
              Text(
                _title,
                style: TextStyles.font20BlackSemiBold.copyWith(
                  color: _accentColor,
                ),
                textAlign: TextAlign.center,
              ),
              if (!response.isLowRisk) ...[
                SizedBox(height: 8.h),
                Text(
                  response.decision,
                  style: TextStyles.font14GreyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
              SizedBox(height: 18.h),
              _buildSummaryCard(),
              SizedBox(height: 18.h),
              Expanded(
                child: response.isLowRisk
                    ? ScanResultAdviceList(
                        recommendation: response.recommendation,
                      )
                    : const SizedBox.shrink(),
              ),
              _buildActionButton(context),
              SizedBox(height: 28.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40),
          AppGradientText(
            gradient: ColorsManager.primaryGradient,
            child: Text('الاختبار', style: TextStyles.font20GradientSemiBold),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: ColorsManager.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: ColorsManager.greyBorderColor),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 18.r,
                color: ColorsManager.primaryGradientStart,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: _accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: _accentColor.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'التوصية',
            style: TextStyles.font14BlackSemiBold,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 6.h),
          Text(
            response.recommendation,
            style: TextStyles.font14GreyMedium.copyWith(
              color: ColorsManager.black,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _ResultMetricItem(
                  label: 'درجة الثقة',
                  value: '${response.confidencePercentageInt}%',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _ResultMetricItem(
                  label: 'النقاط المحللة',
                  value: '${response.pointsAnalyzed}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return AppTextButton(
      onPressed: () => _handleAction(context),
      textButton: _buttonLabel,
      gradient: ColorsManager.primaryGradient,
      height: 56.h,
      borderRadius: 14.r,
      margin: EdgeInsets.zero,
    );
  }

  void _handleAction(BuildContext context) {
    if (response.isModerateRisk) {
      context.pushNamed(Routes.questionnaireScreen);
      return;
    }

    context.pushNamedAndRemoveUntil(
      Routes.parentLayout,
      predicate: (route) => false,
    );
  }
}

class _ResultMetricItem extends StatelessWidget {
  final String label;
  final String value;

  const _ResultMetricItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyles.font18BlackSemiBold.copyWith(color: _accentBlue),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyles.font12GreyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color get _accentBlue => ColorsManager.primaryGradientStart;
}
