import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';

class HomeDoctorCard extends StatelessWidget {
  const HomeDoctorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 12.w),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(8.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Row: big image on the right + two stacked image boxes on the left
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column: two stacked image boxes
              Column(
                children: [
                  _ImageBox(),
                  SizedBox(height: 8.h),
                  _ImageBox(),
                ],
              ),

              SizedBox(width: 8.w),

              // Right: large doctor image
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.asset(
                  'assets/images/doctor_container_image.jpg',
                  width: 160.w,
                  height: 143.h,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // Doctor name below both columns
          Text(
            'دكتور ياسمين خالد',
            textDirection: TextDirection.rtl,
            style: TextStyles.font17DarkForestSemiBold,
          ),
        ],
      ),
    );
  }
}

class _ImageBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Image.asset(
        'assets/images/doctor_container_image.jpg',
        width: 130.w,
        height: 67.5.h,
        fit: BoxFit.cover,
      ),
    );
  }
}
