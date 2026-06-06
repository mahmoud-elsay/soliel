import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';

class ProfileAppBar extends StatelessWidget {
  final String title;
  const ProfileAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            context.pushNamed(Routes.settingsScreen);
          },
          icon: Icon(
            Icons.settings_outlined,
            color: ColorsManager.primaryGradientStart,
            size: 28.sp,
          ),
        ),
        Text(
          title,
          style: TextStyles.font20BlackSemiBold.copyWith(
            color: const Color(0xFF1E232C),
          ),
        ),
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              border: Border.all(color: ColorsManager.greyBorderColor),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 20.sp,
              color: ColorsManager.primaryGradientStart,
            ),
          ),
        ),
      ],
    );
  }
}
