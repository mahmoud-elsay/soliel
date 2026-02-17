import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_text_button.dart';
import 'package:soliel/core/widgets/app_text_form_field.dart';

class ResetPasswordForm extends StatelessWidget {
  final TextEditingController emailController;
  final FocusNode emailFocusNode;
  final bool isEmailFieldFocused;

  const ResetPasswordForm({
    super.key,
    required this.emailController,
    required this.emailFocusNode,
    required this.isEmailFieldFocused,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description Text with beautiful fade
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          tween: Tween<double>(
            begin: isEmailFieldFocused ? 1.0 : 0.6,
            end: isEmailFieldFocused ? 0.6 : 1.0,
          ),
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: 0.95 + (opacity * 0.05),
                child: child,
              ),
            );
          },
          child: Center(
            child: Text(
              'سنرسل إليك عبر البريد الإلكتروني رابطاً\nلإعادة تعيين كلمة مرورك.',
              style: TextStyles.font14BlackRegular,
              textAlign: TextAlign.center,
            ),
          ),
        ),

        verticalSpace(32),

        // Email Label
        Text('Email', style: TextStyles.font14BlackMedium),

        verticalSpace(8),

        // Email Field
        AppTextFormField(
          hintText: 'Samaa@gmail.com',
          controller: emailController,
          focusNode: emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
        ),

        verticalSpace(24),

        // Submit Button - Beautiful animated appearance
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack,
          tween: Tween<double>(
            begin: 0.0,
            end: isEmailFieldFocused ? 1.0 : 0.0,
          ),
          builder: (context, value, child) {
            if (value < 0.01) {
              return const SizedBox.shrink();
            }

            final clampedValue = value.clamp(0.0, 1.0);

            return Transform.scale(
              scale: 0.85 + (clampedValue * 0.15),
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - clampedValue)),
                child: Opacity(opacity: clampedValue, child: child),
              ),
            );
          },
          child: AppTextButton(
            onPressed: () {
              context.pushNamed(Routes.resetPasswordDoneScreen);
            },
            textButton: 'تسجيل',
            gradient: ColorsManager.primaryGradient,
            height: 56.h,
            borderRadius: 12.r,
            margin: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
