import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';

class DoctorScheduleCard extends StatelessWidget {
  const DoctorScheduleCard({super.key});

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
        children: [
          // مواعيد العمل section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مواعيد العمل',
                  style: TextStyles.font16SolidDarkBlueMedium,
                ),
                verticalSpace(8),
                Text(
                  '٦ صباحاً - ٦ مساءاً',
                  style: TextStyles.font12MoreDarkGreyRegular,
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 50.h,
            width: 1,
            color: ColorsManager.greyBorderColor,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
          ),

          // رقم العياده section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رقم العياده',
                  style: TextStyles.font16SolidDarkBlueMedium,
                ),
                verticalSpace(8),
                Text(
                  '01093446559',
                  style: TextStyles.font12MoreDarkGreyRegular,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
