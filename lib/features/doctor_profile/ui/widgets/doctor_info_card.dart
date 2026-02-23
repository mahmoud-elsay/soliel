import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';

class DoctorInfoCard extends StatelessWidget {
  final String title;
  final String content;
  final bool hasIcon;

  const DoctorInfoCard({
    super.key,
    required this.title,
    required this.content,
    this.hasIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyles.font16SolidDarkBlueMedium),
          verticalSpace(12),
          if (hasIcon)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🎓 ', style: TextStyle(fontSize: 12.sp)),
                Expanded(
                  child: Text(
                    content,
                    style: TextStyles.font12MoreDarkGreyRegular,
                  ),
                ),
              ],
            )
          else
            Text(content, style: TextStyles.font12MoreDarkGreyRegular),
        ],
      ),
    );
  }
}
