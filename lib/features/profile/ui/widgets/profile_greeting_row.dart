import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';

class ProfileGreetingRow extends StatelessWidget {
  final String? imagePath;
  final String? name;
  final String? subtitle;
  final Color? textColor;

  const ProfileGreetingRow({
    super.key,
    this.imagePath,
    this.name,
    this.subtitle,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 26.r,
          backgroundImage: AssetImage(
            imagePath ?? 'assets/images/parent_profile_avatar.png',
          ),
        ),
        horizontalSpace(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name ?? 'مرحبا!عمرو محمد...',
                style: TextStyles.font14BlackSemiBold.copyWith(
                  fontSize: 16.sp,
                  color: textColor ?? ColorsManager.black,
                ),
              ),
              verticalSpace(4),
              Text(
                subtitle ?? 'تابع حاله طفلك اليوم',
                style: TextStyles.font14GreyMedium.copyWith(
                  fontSize: 14.sp,
                  color: textColor ?? ColorsManager.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
