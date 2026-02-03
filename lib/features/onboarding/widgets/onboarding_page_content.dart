import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';
import 'package:soliel/features/onboarding/model/onboarding_model.dart';
import 'package:soliel/features/onboarding/widgets/curved_background_clipper.dart';

class OnboardingPageContent extends StatelessWidget {
  final OnboardingModel model;
  final int pageIndex;

  const OnboardingPageContent({
    super.key,
    required this.model,
    this.pageIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Curved background
        OnboardingBackground(isFirstScreen: model.isCurveRight),

        // Content
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                // Image section - Fixed height for all pages
                SizedBox(
                  height: 340.h,
                  child: Column(
                    children: [
                      verticalSpace(40),
                      Expanded(
                        child: Center(
                          child: Image.asset(model.image, fit: BoxFit.contain),
                        ),
                      ),
                    ],
                  ),
                ),

                verticalSpace(45),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        AppGradientText(
                          gradient: ColorsManager.primaryGradient,
                          child: Text(
                            model.title,
                            style:
                                TextStyles.font24PrimaryGradientStartSemiBold,
                          ),
                        ),

                        verticalSpace(12),

                        // Subtitle
                        Text(
                          model.subtitle,
                          style: TextStyles.font16BlackRegular,
                        ),

                        verticalSpace(24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
