import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';

class DoctorStatsCard extends StatelessWidget {
  const DoctorStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('التغذيه الراجعه', '٦ الاف'),
          _buildDivider(),
          _buildStatItem('الخبره', '٨ سنين'),
          _buildDivider(),
          _buildStatItem('المستشفى', 'المنصوره'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        AppGradientText(
          gradient: ColorsManager.primaryGradient,
          child: Text(
            title,
            style: TextStyles.font22GradientSemiBold,
            textAlign: TextAlign.center,
          ),
        ),
        verticalSpace(8),
        AppGradientText(
          gradient: ColorsManager.primaryGradient,
          child: Text(
            value,
            style: TextStyles.font14GradientRegularGrey,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 50.h,
      width: 1,
      color: ColorsManager.greyBorderColor,
    );
  }
}
