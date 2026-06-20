import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_text_button.dart';
import 'package:soliel/features/profile/ui/widgets/domain_reminder_card.dart';
import 'package:soliel/features/profile/ui/widgets/profile_greeting_row.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section with Dark Blue Background
            _buildTopSection(context),
            verticalSpace(10),
            // Domain Reminders Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'النسب في كل مجال',
                    style: TextStyles.font16BlackSemiBold.copyWith(
                      fontSize: 18.sp,
                      color: const Color(0xFF1E232C),
                    ),
                  ),
                  verticalSpace(16),
                  DomainReminderCard(
                    title: 'مجال التفاعل الاجتماعي',
                    date: '15/10',
                    time: '3:45',
                    status: ReminderStatus.completed,
                    onTap: () {},
                  ),
                  DomainReminderCard(
                    title: 'مجال التواصل',
                    date: '15/10',
                    time: '3:45',
                    status: ReminderStatus.play,
                    onTap: () {},
                  ),
                  DomainReminderCard(
                    title: 'مجال المهارات والسلوكيات',
                    date: '15/10',
                    time: '3:45',
                    status: ReminderStatus.completed,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            verticalSpace(30),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Stack(
      children: [
        // Background
        Container(
          height: 300.h,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E4F89), Color(0xFF081423)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  verticalSpace(20),
                  // App Bar (Custom style for dark background)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.settings_outlined,
                          color: Colors.white,
                          size: 28.sp,
                        ),
                      ),
                      Text(
                        'حساب الطفل',
                        style: TextStyles.font20BlackSemiBold.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 20.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(20),
                  // Greeting with white text
                  const ProfileGreetingRow(
                    name: 'مرحبا!عمرو محمد...',
                    subtitle: 'تابع حاله طفلك اليوم',
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
        // Floating Card
        Padding(
          padding: EdgeInsets.only(top: 210.h, left: 20.w, right: 20.w),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildUpcomingInfo('الاختبار القادم', 'تاريخ 4/2'),
                verticalSpace(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF2FA),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'لمده 8 دقائق',
                        style: TextStyles.font12PrimaryGradientStartSemiBold
                            .copyWith(color: const Color(0xFF1E4F89)),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'اللعبه المره القادمه',
                          style: TextStyles.font16BlackSemiBold.copyWith(
                            color: const Color(0xFF1E232C),
                          ),
                        ),
                        Text('تاريخ 4/2', style: TextStyles.font14GreyMedium),
                      ],
                    ),
                    horizontalSpace(12),
                    Icon(
                      Icons.videogame_asset,
                      color: const Color(0xFF1E4F89),
                      size: 32.sp,
                    ),
                  ],
                ),
                verticalSpace(24),
                AppTextButton(
                  textButton: 'بدء الاختبار',
                  onPressed: () {},
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E4F89), Color(0xFF081423)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: 15.r,
                  height: 54.h,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingInfo(String title, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: TextStyles.font14GreyMedium.copyWith(
                fontSize: 16.sp,
                color: const Color(0xFF6A707C),
              ),
            ),
            Text(
              date,
              style: TextStyles.font14GreyMedium.copyWith(fontSize: 14.sp),
            ),
          ],
        ),
      ],
    );
  }
}
