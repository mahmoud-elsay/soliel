import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              _buildHeader(context),
              SizedBox(height: 40.h),
              _buildSettingsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 44), // To balance the back button
        Text(
          'الإعدادات',
          style: TextStyles.font20PrimaryGradientStartSemiBold.copyWith(
            fontSize: 24.sp,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ColorsManager.greyBorderColor),
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: ColorsManager.primaryGradientStart,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsList() {
    final List<Map<String, String>> settings = [
      {'title': 'الملف الشخصي', 'icon': 'assets/svgs/profile_setting_icon.svg'},
      {
        'title': 'تغيير كلمه المرور',
        'icon': 'assets/svgs/change_password_icon.svg',
      },
      {'title': 'اداره الطفل', 'icon': 'assets/svgs/manage_baby_icon.svg'},
      {
        'title': 'سياسه الخصوصيه وشروط الاحكام',
        'icon': 'assets/svgs/password_icon .svg',
      },
      {
        'title': 'اعدادات واشعارات',
        'icon': 'assets/svgs/notifications_icon.svg',
      },
      {'title': 'تواصل معانا', 'icon': 'assets/svgs/chat_icon.svg'},
      {'title': 'عن التطبيق', 'icon': 'assets/svgs/about_app.svg'},
    ];

    return Column(
      children: settings
          .map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildSettingsItem(item['title']!, item['icon']!),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSettingsItem(String title, String iconPath) {
    return Container(
      width: 344.w,
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: ColorsManager.lightBlueBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorsManager.greyBorderColor, width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: ColorsManager.primaryGradientStart,
          ),
          Row(
            children: [
              Text(
                title,
                style: TextStyles.font14RobotoGrey400Regular,
                textAlign: TextAlign.right,
              ),
              SizedBox(width: 12.w),
              SvgPicture.asset(
                iconPath,
                width: 24.w,
                height: 24.h,
                colorFilter: const ColorFilter.mode(
                  ColorsManager.primaryGradientStart,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
