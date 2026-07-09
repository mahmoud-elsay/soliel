import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/styles.dart';

enum ReminderStatus { completed, notPassed }

class DomainReminderCard extends StatelessWidget {
  final String title;
  final double score;
  final String date;
  final ReminderStatus status;
  final VoidCallback onTap;

  const DomainReminderCard({
    super.key,
    required this.title,
    required this.score,
    required this.date,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPassed = status == ReminderStatus.completed;

    final Color iconBg =
        isPassed ? const Color(0xFFE6F7EF) : const Color(0xFFFFF0F0);
    final Color iconColor =
        isPassed ? const Color(0xFF00AA5B) : const Color(0xFFE53935);
    final Color labelColor =
        isPassed ? const Color(0xFF00AA5B) : const Color(0xFFE53935);
    final IconData icon =
        isPassed ? Icons.check_circle_outline : Icons.cancel_outlined;
    final String label = isPassed ? 'اجتازه' : 'لم يجتازه';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: isPassed
              ? const Color(0xFF00AA5B).withOpacity(0.25)
              : const Color(0xFFE53935).withOpacity(0.25),
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
          // ── Action / Status Label ──────────────────────────
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                label,
                style: TextStyles.font14BlackSemiBold.copyWith(
                  color: labelColor,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),

          const Spacer(),

          // ── Domain Title + Date + Score ────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyles.font16BlackSemiBold.copyWith(
                  fontSize: 16.sp,
                  color: const Color(0xFF1E232C),
                ),
              ),
              verticalSpace(4),
              Text(
                'تاريخ $date',
                style: TextStyles.font14GreyMedium.copyWith(
                  fontSize: 13.sp,
                  color: const Color(0xFF6A707C),
                ),
              ),
              verticalSpace(4),
              Text(
                'النسبة: ${score.toStringAsFixed(1)}%',
                style: TextStyles.font14GreyMedium.copyWith(
                  fontSize: 12.sp,
                  color: labelColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          horizontalSpace(12),

          // ── Status Icon ────────────────────────────────────
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 24.sp),
          ),
        ],
      ),
    );
  }
}
