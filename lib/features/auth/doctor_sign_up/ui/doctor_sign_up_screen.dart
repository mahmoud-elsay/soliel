import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';
import 'package:soliel/features/auth/doctor_sign_up/ui/widgets/doctor_sign_up_form.dart';

class DoctorSignUpScreen extends StatelessWidget {
  const DoctorSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white,
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

                      AppGradientText(
                        gradient: ColorsManager.primaryGradient,
                        child: Text(
                          'مرحبا، سجل الآن للبدء',
                          style: TextStyles.font30GradientBold,
                          textAlign: TextAlign.start,
                        ),
                      ),

                      verticalSpace(40),

                      const DoctorSignUpForm(),

                      verticalSpace(24),
                    ],
                  ),
                ),
              ),

              // Login link at the bottom
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'بالفعل لديك اكونت؟ ',
                    style: TextStyles.font14BlackRegular,
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to login
                      Navigator.pop(context);
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
                        style: TextStyles.font14GradientMedium,
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
