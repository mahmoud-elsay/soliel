import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

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
                  child: Column(
                    children: [
                      _buildSection(
                        'يهدف التطبيق إلى مساعدة أولياء الأمور على:',
                        [
                          'متابعة حالة أطفالهم',
                          'إجراء اختبارات مبدئية',
                          'استخدام الألعاب التفاعلية المقترحة',
                          'الحصول على توجيه مبدئي للحالة',
                          '⚠️ التطبيق لا يُعد بديلاً عن التشخيص الطبي.',
                        ],
                      ),
                      _buildSection(
                        'يتتحمل المستخدم مسؤولية صحة البيانات المدخلة.',
                        [
                          'يجب الحفاظ على سرية بيانات الدخول.',
                          'يحق لإدارة التطبيق إيقاف أي حساب في حال إساءة الاستخدام.',
                        ],
                      ),
                      _buildSection(
                        'نتائج الاختبارات تقديرية ومبدئية فقط.',
                        [
                          'لا يجب الاعتماد على النتائج لاتخاذ قرارات طبية نهائية.',
                          'في بعض الحالات يتم توجيه المستخدم لمراجعة طبيب مختص.',
                        ],
                      ),
                      _buildSection(
                        'الألعاب مقدمة لأغراض تعليمية وتفاعلية فقط.',
                        [
                          'يجب استخدام الألعاب تحت إشراف ولي الأمر.',
                        ],
                      ),
                      _buildSection(
                        'لا يتحمل التطبيق أو القائمون عليه أي مسؤولية قانونية عن:',
                        [
                          'قرارات يتم اتخاذها بناءً على نتائج التطبيق',
                          'سوء استخدام الخدمات',
                        ],
                      ),
                      _buildSection(
                        'يتم التعامل مع بيانات المستخدم والطفل بسرية تامة.',
                        [
                          'لا يتم مشاركة البيانات مع أي طرف ثالث بدون موافقة المستخدم.',
                        ],
                      ),
                      _buildSection(
                        'يحق لإدارة التطبيق تعديل الشروط والأحكام في أي وقت، ويتم إخطار المستخدم عند التحديث.',
                        [
                          'لأي استفسار بخصوص الشروط والأحكام، يمكن التواصل عبر صفحة الدعم.',
                        ],
                      ),
                      Text(
                        'الإجراءات',
                        style: TextStyles.font18RobotoBlackSemiBold,
                      ),
                      SizedBox(height: 20.h),
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
        const SizedBox(width: 44), // To balance the back button
        AppGradientText(
          gradient: ColorsManager.primaryGradient,
          child: Text(
            'سياسه الخصوصيه\nوشروط الاحكام',
            style: TextStyles.font24GradientSemiBold.copyWith(height: 1.2),
            textAlign: TextAlign.center,
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
      children: [
        SizedBox(height: 16.h),
        Text(
          title,
          style: TextStyles.font18RobotoBlackSemiBold.copyWith(height: 1.5),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        ...bodies.map(
          (body) => Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                body,
                style: TextStyles.font14RobotoGreySemiBold.copyWith(height: 1.5),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
