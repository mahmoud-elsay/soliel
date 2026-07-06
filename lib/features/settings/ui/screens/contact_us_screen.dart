import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

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
              SizedBox(height: 32.h),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildContactCard(
                        context,
                        icon: Icons.email_outlined,
                        label: 'البريد الالكتروني:',
                        value: 'support@soleil-app.com',
                        onTap: () => _launchEmail('support@soleil-app.com'),
                      ),
                      SizedBox(height: 16.h),
                      _buildContactCard(
                        context,
                        icon: Icons.phone_outlined,
                        label: 'رقم دعم:',
                        value: '+20 100 000 0000',
                        onTap: () => _launchPhone('+201000000000'),
                      ),
                      SizedBox(height: 16.h),
                      _buildContactCard(
                        context,
                        icon: Icons.language_outlined,
                        label: 'الموقع الالكتروني:',
                        value: 'https://knada621.github.io/soleil/',
                        onTap: () => _launchUrl('https://knada621.github.io/soleil/'),
                      ),
                      SizedBox(height: 32.h),

                      // Divider with label
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Text(
                              'نبذة مختصرة',
                              style: TextStyles.font14RobotoGrey400Regular,
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // Short about text
                      Text(
                        'تطبيق مخصص لمساعدة أولياء الأمور على متابعة تطور أطفالهم من خلال اختبارات مبدئية وألعاب تفاعلية تهدف إلى تنمية مهارات الطفل وملاحظة أي مؤشرات مبكرة.',
                        style: TextStyles.font14RobotoGreySemiBold.copyWith(height: 1.6),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 16.h),

                      _buildBulletRow('اختبارات مبدئية سهلة الاستخدام'),
                      _buildBulletRow('ألعاب تعليمية تفاعلية'),
                      _buildBulletRow('متابعة نتائج الطفل'),
                      _buildBulletRow('اقتراحات ذكية بناءً على الأداء'),
                      _buildBulletRow('توجيه المختصين عند الحاجة'),

                      SizedBox(height: 8.h),
                      Text(
                        'الفئة المستهدفة',
                        style: TextStyles.font18RobotoBlackSemiBold,
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 8.h),
                      _buildBulletRow('أولياء الأمور'),
                      _buildBulletRow('الأطفال (تحت إشراف ولي الأمر)'),

                      SizedBox(height: 16.h),
                      Text(
                        'تنويه مهم',
                        style: TextStyles.font18RobotoBlackSemiBold,
                        textAlign: TextAlign.right,
                      ),
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
                          '⚠️ التطبيق أداة مساعدة فقط، ولا يُغني عن استشارة الطبيب المختص.',
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
            'تواصل معانا',
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

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: value));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم النسخ: $value', textDirection: TextDirection.rtl),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: ColorsManager.lightBlueBackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: ColorsManager.greyBorderColor, width: 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: ColorsManager.primaryGradientStart,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    label,
                    style: TextStyles.font14RobotoGrey400Regular,
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: TextStyles.font14RobotoGreySemiBold.copyWith(
                      color: ColorsManager.primaryGradientStart,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                gradient: ColorsManager.primaryGradient,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: Colors.white, size: 20.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletRow(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text,
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
    );
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
