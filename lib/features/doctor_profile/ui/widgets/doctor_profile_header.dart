import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';

class DoctorProfileHeader extends StatelessWidget {
  const DoctorProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Avatar (Right side in RTL)
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  'assets/images/doctor_avatar.jpg',
                  width: 80.w,
                  height: 80.h,
                  fit: BoxFit.cover,
                ),
              ),

              horizontalSpace(12),

              // Doctor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'دكتورة ياسمين خالد',
                      style: TextStyles.font18BlackSemiBold,
                    ),
                    verticalSpace(4),
                    Row(
                      children: [
                        Text('🎓 ', style: TextStyle(fontSize: 12.sp)),
                        Expanded(
                          child: Text(
                            'بكالوريوس التربية الخاصة جامعة الإسكندرية',
                            style: TextStyles.font12MoreDarkGreyRegular,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(8),
                    // Rating
                    Row(
                      children: [
                        ...List.generate(
                          4,
                          (index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16.sp,
                          ),
                        ),
                        Icon(Icons.star_half, color: Colors.amber, size: 16.sp),
                        horizontalSpace(4),
                        Text('4.5 Star', style: TextStyles.font12GreyMedium),
                      ],
                    ),
                  ],
                ),
              ),

              horizontalSpace(12),

              Icon(Icons.verified, color: ColorsManager.green, size: 24.sp),
            ],
          ),

          Positioned(
            left: 0,
            bottom: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('01093446559', style: TextStyles.font12GreyMedium),
                horizontalSpace(8),
                Container(
                  height: 40.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    gradient: ColorsManager.primaryGradient,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Handle call action
                      },
                      borderRadius: BorderRadius.circular(8.r),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.phone,
                            color: ColorsManager.white,
                            size: 18.sp,
                          ),
                          horizontalSpace(6),
                          Text(
                            'اتصال ',
                            style: TextStyles.font14BlackMedium.copyWith(
                              color: ColorsManager.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
