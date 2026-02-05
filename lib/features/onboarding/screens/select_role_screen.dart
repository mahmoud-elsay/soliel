import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/widgets/app_text_button.dart';

class SelectRoleScreen extends StatelessWidget {
  const SelectRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/select_roles_background_image.jpeg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo with سوليل text
              SvgPicture.asset('assets/svgs/blue_app_logo.svg', height: 120.h),
              const Spacer(flex: 3),
              // Doctor Button
              AppTextButton(
                onPressed: () {
                  // Navigate to doctor flow
                },
                textButton: 'دكتور',
                gradient: ColorsManager.primaryGradient,
                height: 56.h,
                borderRadius: 12.r,
              ),
              verticalSpace(16),
              // Parent/Guardian Button with Gradient Text
              AppTextButton(
                onPressed: () {
                  // Navigate to parent flow
                },
                textButton: 'ولي الامر',
                backgroundColor: ColorsManager.lightBlue,
                textGradient: ColorsManager.primaryGradient,
                height: 56.h,
                borderRadius: 12.r,
              ),
              verticalSpace(40),
            ],
          ),
        ),
      ),
    );
  }
}
