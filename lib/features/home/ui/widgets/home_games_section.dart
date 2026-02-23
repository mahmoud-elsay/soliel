import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';

class HomeGamesSection extends StatelessWidget {
  const HomeGamesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: AppGradientText(
            gradient: ColorsManager.primaryGradient,
            child: Text(
              'بعض الصور من الالعاب',
              textDirection: TextDirection.rtl,
              style: TextStyles.font20GradientSemiBold,
            ),
          ),
        ),

        SizedBox(height: 14.h),

        // Horizontal game image list
        SizedBox(
          height: 160.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true, // RTL ordering
            padding: EdgeInsets.only(right: 20.w, left: 8.w),
            itemCount: 5,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.only(left: 12.w),
              width: 160.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.asset(
                  'assets/images/game_image.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
