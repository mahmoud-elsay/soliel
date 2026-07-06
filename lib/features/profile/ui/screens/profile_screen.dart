import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/helpers/shared_pref_helper.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.lightCream,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              verticalSpace(20),
              _buildHeader(context),
              verticalSpace(40),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildProfileCard(
                        context: context,
                        title: 'ولي الامر',
                        backgroundColor: ColorsManager.mainPurple,
                        imagePath: 'assets/images/parent_profile_avatar.png',
                        onTap: () async {
                          final childId = await StorageHelper.getChildId();
                          if (context.mounted) {
                            context.pushNamed(
                              Routes.parentProfileScreen,
                              arguments: childId,
                            );
                          }
                        },
                      ),
                      verticalSpace(30),
                      _buildProfileCard(
                        context: context,
                        title: 'الطفل',
                        backgroundColor: ColorsManager.coralRed,
                        imagePath: 'assets/images/child_profile_avatar.png',
                        onTap: () {
                          context.pushNamed(Routes.childProfileScreen);
                        },
                      ),
                      verticalSpace(20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final canPop = Navigator.canPop(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (canPop)
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                border: Border.all(color: ColorsManager.greyBorderColor),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 20.sp,
                color: ColorsManager.primaryGradientStart,
              ),
            ),
          )
        else
          SizedBox(width: 44.w),
        Text(
          'الحساب الشخصي',
          style: TextStyles.font20BlackSemiBold.copyWith(
            color: const Color(0xFF1E232C),
          ),
        ),
        SizedBox(width: 44.w), // To balance the back button
      ],
    );
  }

  Widget _buildProfileCard({
    required BuildContext context,
    required String title,
    required Color backgroundColor,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Stack(
          children: [
            // Decorative Circles
            Positioned(
              top: -50.h,
              left: -30.w,
              child: Container(
                width: 150.w,
                height: 150.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -20.h,
              right: 20.w,
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 40.h,
              right: 10.w,
              child: Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 60.h,
              left: 40.w,
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 76.w,
                    height: 76.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorsManager.white, width: 2),
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  verticalSpace(16),
                  Text(
                    title,
                    style: TextStyles.font20BlackSemiBold.copyWith(
                      color: ColorsManager.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
