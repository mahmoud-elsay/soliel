import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_text_button.dart';
import 'package:soliel/features/doctor_profile/ui/widgets/doctor_info_card.dart';
import 'package:soliel/features/doctor_profile/ui/widgets/doctor_profile_header.dart';
import 'package:soliel/features/doctor_profile/ui/widgets/doctor_schedule_card.dart';
import 'package:soliel/features/doctor_profile/ui/widgets/doctor_stats_card.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: ColorsManager.solidLightBlue,
        appBar: AppBar(
          backgroundColor: ColorsManager.solidLightBlue,
          elevation: 0,
          centerTitle: true,
          title: Text('حساب الدكتور', style: TextStyles.font18BlackSemiBold),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: ColorsManager.black),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
            },
          ),
        ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            const DoctorProfileHeader(),

            verticalSpace(16),

            const DoctorStatsCard(),

            verticalSpace(16),

            const DoctorInfoCard(
              title: 'نبذه تعريفيه',
              content:
                  'الدكتورة ياسمين خالد - استشارية تخاطب وتواصل\nمتخصصة في تطوير مهارات التواصل للأطفال ذوي التوحد باستخدام أحدث التقنيات المساعدة، حاصلة على شهادات دولية في تحليل السلوك التطبيقي (ABA) وتصميم البرامج الفردية.',
            ),

            verticalSpace(16),

            const DoctorInfoCard(
              title: 'التعليم',
              content:
                  'بكالوريوس التربية الخاصة جامعة الإسكندرية - كلية التربية\n2010-2014\nتقدير جيد جداً',
              hasIcon: true,
            ),

            verticalSpace(16),

            const DoctorScheduleCard(),

            verticalSpace(24),

            AppTextButton(
              onPressed: () {
                context.pushNamed(Routes.editProfileScreen);
              },
              textButton: 'تعديل الملف الشخصي',
              gradient: ColorsManager.primaryGradient,
              height: 56.h,
              borderRadius: 12.r,
              margin: EdgeInsets.zero,
            ),

            verticalSpace(16),

            AppTextButton(
              onPressed: () {
                // Handle logout
              },
              textButton: 'تسجيل خروج',
              backgroundColor: ColorsManager.lightBlue,
              textColor: ColorsManager.black,
              height: 56.h,
              borderRadius: 12.r,
              margin: EdgeInsets.zero,
            ),

            verticalSpace(24),
          ],
        ),
      ),
    ),
  );
}
}
