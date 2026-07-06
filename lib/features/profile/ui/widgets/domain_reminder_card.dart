import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';

enum ReminderStatus { completed, play }

class DomainReminderCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final ReminderStatus status;
  final VoidCallback onTap;

  const DomainReminderCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: ColorsManager.greyBorderColor.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Action Text
          GestureDetector(
            onTap: onTap,
            child: Text(
              status == ReminderStatus.completed ? 'اجتازه' : 'لعب',
              style: TextStyles.font14BlackSemiBold.copyWith(
                color: status == ReminderStatus.completed
                    ? const Color(0xFF00AA5B)
                    : Colors.black,
              ),
            ),
          ),
          const Spacer(),
          // Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyles.font16BlackSemiBold.copyWith(
                  fontSize: 18.sp,
                  color: const Color(0xFF1E232C),
                ),
              ),
              verticalSpace(4),
              Text(
                time.isNotEmpty ? 'تاريخ $date الساعه $time' : 'تاريخ $date',
                style: TextStyles.font14GreyMedium.copyWith(
                  fontSize: 14.sp,
                  color: const Color(0xFF6A707C),
                ),
              ),
            ],
          ),
          horizontalSpace(12),
          // Icon
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: status == ReminderStatus.completed
                  ? const Color(0xFFE6F7EF)
                  : const Color(0xFFEBF2FA),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              status == ReminderStatus.completed
                  ? Icons.check_circle_outline
                  : Icons.videogame_asset_outlined,
              color: status == ReminderStatus.completed
                  ? const Color(0xFF00AA5B)
                  : const Color(0xFF1E4F89),
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }
}
