import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';

class HomeGreetingRow extends StatelessWidget {
  const HomeGreetingRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
          // Avatar on the right (RTL start)
          CircleAvatar(
            radius: 22.r,
            backgroundImage: const AssetImage(
              'assets/images/parent_avatar.png',
            ),
          ),

          SizedBox(width: 12.w),

          // Greeting texts (Centered/Expanded)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحبا!عمرو محمد...',
                  style: TextStyles.font14BlackSemiBold,
                ),
                SizedBox(height: 2.h),
                Text(
                  'تابع حاله طفلك اليوم',
                  style: TextStyles.font14GreyMedium.copyWith(fontSize: 13.sp),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Menu icon on the left (RTL end)
          GestureDetector(
            onTap: () => {context.pushNamed(Routes.settingsScreen)},
            child: SvgPicture.asset(
              'assets/svgs/menu_icon.svg',
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                ColorsManager.black,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
