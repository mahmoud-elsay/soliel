import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/features/profile/ui/widgets/profile_app_bar.dart';
import 'package:soliel/features/profile/ui/widgets/profile_greeting_row.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                verticalSpace(20),
                const ProfileAppBar(title: 'حساب ولي الامر'),
                verticalSpace(30),
                const ProfileGreetingRow(),
                verticalSpace(30),
                _buildChildTrackingSection(context),
                verticalSpace(30),
                Text(
                  'مستوي طفلك في مجالات مختلفه',
                  style: TextStyles.font16BlackSemiBold.copyWith(
                    fontSize: 18.sp,
                    color: Colors.black,
                  ),
                ),
                verticalSpace(20),
                _buildDomainsGauges(),
                verticalSpace(30),
                Text(
                  'الالعاب المقترحه لطفلك',
                  style: TextStyles.font16BlackSemiBold.copyWith(
                    fontSize: 18.sp,
                    color: Colors.black,
                  ),
                ),
                verticalSpace(20),
                _buildSuggestedGameCard(),
                verticalSpace(30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChildTrackingSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('تابع بيانات طفلك', style: TextStyles.font16BlackSemiBold),
              verticalSpace(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E4F89).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '68%',
                      style: TextStyles.font14BlackSemiBold.copyWith(
                        color: const Color(0xFF1E4F89),
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace(8),
              Text(
                'Aseel\nAmr',
                textAlign: TextAlign.end,
                style: TextStyles.font20BlackSemiBold.copyWith(
                  fontSize: 22.sp,
                  height: 1.2,
                ),
              ),
              GestureDetector(
                onTap: () => context.pushNamed(Routes.editParentDataScreen),
                child: Text(
                  'Edit paren’s details',
                  style: TextStyles.font14GreyMedium.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        horizontalSpace(20),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120.r,
              height: 120.r,
              child: CircularProgressIndicator(
                value: 0.68,
                strokeWidth: 6,
                backgroundColor: const Color(0xFFE8ECF4),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF1E4F89),
                ),
              ),
            ),
            Container(
              width: 100.r,
              height: 100.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                image: const DecorationImage(
                  image: AssetImage('assets/images/child_profile_avatar.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 10.w,
              child: GestureDetector(
                onTap: () => context.pushNamed(Routes.editChildProfileScreen),
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E232C),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.edit, color: Colors.white, size: 14.sp),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDomainsGauges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildGauge('التفاعل', 0.68, Colors.red),
        _buildGauge('التواصل', 0.68, Colors.orange),
        _buildGauge('المهارات', 0.68, Colors.green),
      ],
    );
  }

  Widget _buildGauge(String label, double progress, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 90.r,
              height: 90.r,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 10,
                backgroundColor: const Color(0xFFE8ECF4),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Column(
              children: [
                Text(
                  label,
                  style: TextStyles.font12GreyMedium.copyWith(fontSize: 14.sp),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyles.font14BlackSemiBold,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuggestedGameCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFF00B060),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Text(
              'ابدأ',
              style: TextStyles.font14BlackSemiBold.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('لعبة التفاعل', style: TextStyles.font16BlackSemiBold),
                Text(
                  'بتتحفز الطفل علي معرفه لغه التفاعل مع الأشخاص الاخرين',
                  textAlign: TextAlign.end,
                  style: TextStyles.font12GreyMedium.copyWith(fontSize: 13.sp),
                ),
              ],
            ),
          ),
          horizontalSpace(16),
          Container(
            width: 80.r,
            height: 80.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: const LinearGradient(
                colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/profile_results.png', // Reusing placeholder icon or similar
                width: 50.r,
                height: 50.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
