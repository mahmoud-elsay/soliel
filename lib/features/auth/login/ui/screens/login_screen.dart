import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';
import 'package:soliel/core/widgets/or_divider.dart';
import 'package:soliel/core/widgets/social_media_buttons.dart';
import 'package:soliel/features/auth/login/ui/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white,
      appBar: AppBar(
        backgroundColor: ColorsManager.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            color: ColorsManager.primaryGradientStart,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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

                      // Welcome Title with Gradient - Aligned to the right
                      AppGradientText(
                        gradient: ColorsManager.primaryGradient,
                        child: Text(
                          'مرحبا بك! مره ثانيه....',
                          style: TextStyles.font30GradientBold,
                          textAlign: TextAlign.right,
                        ),
                      ),

                      verticalSpace(80),

                      // Login Form
                      const LoginForm(),

                      verticalSpace(40),

                      const OrDivider(),

                      verticalSpace(32),

                      const SocialMediaButtons(),

                      verticalSpace(24),
                    ],
                  ),
                ),
              ),

              // Sign up link at the bottom
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ليس لديك حساب؟ ', style: TextStyles.font15DarkBlueBold),
                  TextButton(
                    onPressed: () {
                      // Navigate to sign up
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: AppGradientText(
                      gradient: ColorsManager.primaryGradient,
                      child: Text(
                        'سجل الآن',
                        style: TextStyles.font15GradientBold,
                      ),
                    ),
                  ),
                ],
              ),

              verticalSpace(24),
            ],
          ),
        ),
      ),
    );
  }
}
