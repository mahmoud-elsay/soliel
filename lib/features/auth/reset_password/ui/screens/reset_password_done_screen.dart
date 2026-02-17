import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';
import 'package:soliel/core/widgets/app_text_button.dart';

import 'package:soliel/features/auth/reset_password/ui/widgets/terms_and_privacy_text.dart';

class ResetPasswordDoneScreen extends StatelessWidget {
  const ResetPasswordDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: ColorsManager.primaryGradientStart,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpace(20),

                      // Title with Gradient
                      AppGradientText(
                        gradient: ColorsManager.primaryGradient,
                        child: Text(
                          'إعادة تعيين كلمة المرور',
                          style: TextStyles.font30GradientBold,
                          textAlign: TextAlign.start,
                        ),
                      ),

                      verticalSpace(60),

                      // Success Image
                      Center(
                        child: Image.asset(
                          'assets/images/reset_password_done_image.png',
                          height: 200.h,
                          fit: BoxFit.contain,
                        ),
                      ),

                      verticalSpace(60),

                      // Success Message
                      Center(
                        child: Text(
                          'لقد أرسلنا بريداً إلكترونياً إلى samaa@gmail.com\nيتضمن تعليمات لإعادة تعيين كلمة المرور الخاصة بك.',
                          style: TextStyles.font14BlackRegular,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      verticalSpace(40),

                      // Back to Login Button
                      AppTextButton(
                        onPressed: () {
                          // Navigate back to login
                          Navigator.pop(context);
                        },
                        textButton: 'ارجع الى التسجيل',
                        gradient: ColorsManager.primaryGradient,
                        height: 56.h,
                        borderRadius: 12.r,
                      ),

                      verticalSpace(24),
                    ],
                  ),
                ),
              ),

              // Terms and Privacy Policy at bottom
              const TermsAndPrivacyText(),

              verticalSpace(24),
            ],
          ),
        ),
      ),
    );
  }
}
