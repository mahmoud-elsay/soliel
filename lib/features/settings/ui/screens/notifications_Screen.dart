import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';
import 'package:soliel/core/widgets/app_text_button.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _exerciseNotifications = false;
  bool _generalNotifications = true;
  bool _testNotifications = true;

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
              _buildNotificationItem(
                'اشعارآت التمارين',
                _exerciseNotifications,
                (value) => setState(() => _exerciseNotifications = value),
              ),
              SizedBox(height: 16.h),
              _buildNotificationItem(
                'اشعارات عامه',
                _generalNotifications,
                (value) => setState(() => _generalNotifications = value),
              ),
              SizedBox(height: 16.h),
              _buildNotificationItem(
                'اشعارات الاختبارات',
                _testNotifications,
                (value) => setState(() => _testNotifications = value),
              ),
              const Spacer(),
              AppTextButton(
                onPressed: () {
                  // Implement save notifications logic
                },
                textButton: 'حفظ البيانات',
                gradient: ColorsManager.primaryGradient,
              ),
              SizedBox(height: 20.h),
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
        AppGradientText(
          gradient: ColorsManager.primaryGradient,
          child: Text(
            'اعدادات واشعارات',
            style: TextStyles.font24GradientSemiBold,
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

  Widget _buildNotificationItem(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: ColorsManager.primaryGradientStart,
          ),
          Text(
            title,
            style: TextStyles.font14RobotoGrey400Regular,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
