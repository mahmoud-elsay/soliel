import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';
import 'package:soliel/features/auth/reset_password/ui/widgets/animated_reset_password_image.dart';
import 'package:soliel/features/auth/reset_password/ui/widgets/reset_password_form.dart';
import 'package:soliel/features/auth/reset_password/ui/widgets/terms_and_privacy_text.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isEmailFieldFocused = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFieldFocused = _emailFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
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

                  verticalSpace(40),

                  // Animated Image
                  AnimatedResetPasswordImage(
                    isEmailFieldFocused: _isEmailFieldFocused,
                  ),

                  if (!_isEmailFieldFocused) verticalSpace(40),

                  // Reset Password Form
                  ResetPasswordForm(
                    emailController: _emailController,
                    emailFocusNode: _emailFocusNode,
                    isEmailFieldFocused: _isEmailFieldFocused,
                  ),

                  if (!_isEmailFieldFocused) ...[
                    verticalSpace(60),

                    // Terms and Privacy Policy with beautiful fade and scale
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutQuart,
                      tween: Tween<double>(
                        begin: _isEmailFieldFocused ? 1.0 : 0.0,
                        end: _isEmailFieldFocused ? 0.0 : 1.0,
                      ),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 0.9 + (value * 0.1),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: const TermsAndPrivacyText(),
                    ),
                  ],

                  verticalSpace(40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
