import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
              SizedBox(height: 20.h),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // App name highlight
                      Center(
                        child: AppGradientText(
                          gradient: ColorsManager.primaryGradient,
                          child: Text(
                            'سُولَيّ',
                            style: TextStyles.font24GradientSemiBold.copyWith(
                              fontSize: 36.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // App description
                      _buildSection(
                        'نبذة مختصرة:',
                        [
                          'تطبيق مخصص لمساعدة أولياء الأمور على متابعة تطور أطفالهم من خلال اختبارات مبدئية وألعاب تفاعلية تهدف إلى تنمية مهارات الطفل وملاحظة أي مؤشرات مبكرة.',
                        ],
                      ),

                      // Features
                      _buildBulletSection(
                        'مميزات التطبيق',
                        [
                          'اختبارات مبدئية سهلة الاستخدام',
                          'ألعاب تعليمية تفاعلية',
                          'متابعة نتائج الطفل',
                          'اقتراحات ذكية بناءً على الأداء',
                          'توجيه المختصين عند الحاجة',
                        ],
                      ),

                      // Target audience
                      _buildBulletSection(
                        'الفئة المستهدفة',
                        [
                          'أولياء الأمور',
                          'الأطفال (تحت إشراف ولي الأمر)',
                        ],
                      ),

                      // Disclaimer
                      SizedBox(height: 8.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E7),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFFFFD54F),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '⚠️ تنويه مهم\nالتطبيق أداة مساعدة فقط، ولا يُغني عن استشارة الطبيب المختص.',
                          style: TextStyles.font14RobotoGreySemiBold.copyWith(
                            height: 1.6,
                            color: const Color(0xFF7A5800),
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(height: 30.h),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 44),
        AppGradientText(
          gradient: ColorsManager.primaryGradient,
          child: Text(
            'عن التطبيق',
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

  Widget _buildSection(String title, List<String> bodies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: 16.h),
        Text(
          title,
          style: TextStyles.font18RobotoBlackSemiBold,
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 8.h),
        ...bodies.map(
          (body) => Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Text(
              body,
              style: TextStyles.font14RobotoGreySemiBold.copyWith(height: 1.6),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  Widget _buildBulletSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: 16.h),
        Text(
          title,
          style: TextStyles.font18RobotoBlackSemiBold,
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 8.h),
        ...items.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  item,
                  style: TextStyles.font14RobotoGreySemiBold.copyWith(height: 1.5),
                  textAlign: TextAlign.right,
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 6.w,
                  height: 6.h,
                  decoration: const BoxDecoration(
                    color: ColorsManager.primaryGradientStart,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}
