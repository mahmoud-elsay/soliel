import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';

class HorizontalDoctorCard extends StatelessWidget {
  final String name;
  final String distance;
  final String rating;
  final String imagePath;

  const HorizontalDoctorCard({
    super.key,
    required this.name,
    required this.distance,
    required this.rating,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                verticalSpace(12),
                Text(
                  name,
                  style: TextStyles.font16BlackSemiBold.copyWith(
                    fontSize: 18.sp,
                    color: ColorsManager.black,
                  ),
                ),
                verticalSpace(4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      distance,
                      style: TextStyles.font14GreyMedium.copyWith(
                        fontSize: 14.sp,
                        color: ColorsManager.lightGrey,
                      ),
                    ),
                    horizontalSpace(4),
                    Icon(
                      Icons.location_on,
                      color: ColorsManager.lightGrey,
                      size: 16.sp,
                    ),
                  ],
                ),
                verticalSpace(8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4EDF7), // light blue background
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        rating,
                        style: TextStyles.font14PrimaryGradientStartMedium.copyWith(
                          fontSize: 12.sp,
                          color: const Color(0xFF5D9EF6), // matching blue rating
                        ),
                      ),
                      horizontalSpace(4),
                      Icon(
                        Icons.star,
                        color: const Color(0xFF5D9EF6), // light blue star
                        size: 14.sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(16),
          // Doctor Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              imagePath,
              width: 100.w,
              height: 100.h,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
