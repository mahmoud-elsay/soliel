import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';

class HomeGreetingRow extends StatelessWidget {
  const HomeGreetingRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          // Menu icon on the right (RTL leading)
          SvgPicture.asset(
            'assets/svgs/menu_icon.svg',
            width: 24.w,
            height: 24.h,
            colorFilter: const ColorFilter.mode(
              ColorsManager.black,
              BlendMode.srcIn,
            ),
          ),

          SizedBox(width: 12.w),

          // Greeting texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'مرحبا!عمرو محمد...',
                  textDirection: TextDirection.rtl,
                  style: TextStyles.font14BlackSemiBold,
                ),
                SizedBox(height: 2.h),
                Text(
                  'تابع حاله طفلك اليوم',
                  textDirection: TextDirection.rtl,
                  style: TextStyles.font14GreyMedium.copyWith(fontSize: 13.sp),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Avatar on the left (RTL trailing)
          CircleAvatar(
            radius: 22.r,
            backgroundImage: const AssetImage(
              'assets/images/parent_avatar.png',
            ),
          ),
        ],
      ),
    );
  }
}
