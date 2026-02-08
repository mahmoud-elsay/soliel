import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              thickness: 1.5,
              color: ColorsManager.greyBorderColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              "أو تسجيل الدخول ب",
              style: TextStyles.font14MoreDarkGreySemiBold,
            ),
          ),
          const Expanded(
            child: Divider(
              thickness: 1.5,
              color: ColorsManager.greyBorderColor,
            ),
          ),
        ],
      ),
    );
  }
}
