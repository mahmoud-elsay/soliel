import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/styles.dart';

class ResultCard extends StatelessWidget {
  final String title;
  final String date;
  final String percentage;
  final String imagePath;

  const ResultCard({
    super.key,
    required this.title,
    required this.date,
    required this.percentage,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Progress Indicator
          _buildCircularProgress(),
          horizontalSpace(16),
          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyles.font18BlackSemiBold.copyWith(
                    fontSize: 20.sp,
                    color: const Color(0xFF1E232C),
                  ),
                ),
                verticalSpace(4),
                Text(
                  'تاريخ $date',
                  style: TextStyles.font14GreyMedium.copyWith(
                    fontSize: 16.sp,
                    color: const Color(0xFF8391A1),
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(12),
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              imagePath,
              width: 80.w,
              height: 80.h,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularProgress() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 70.r,
          height: 70.r,
          child: CircularProgressIndicator(
            value: 0.68, // Fixed value for now as per image
            strokeWidth: 8,
            backgroundColor: const Color(0xFFE8ECF4),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF03314B)),
          ),
        ),
        Text(
          percentage,
          style: TextStyles.font14BlackSemiBold.copyWith(
            fontSize: 14.sp,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
