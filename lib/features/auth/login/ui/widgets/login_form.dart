import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/app_role.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_text_button.dart';
import 'package:soliel/core/widgets/solid_text_form_field.dart';
import 'package:soliel/core/theming/colors_manger.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscureText = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    // TODO: Add real authentication logic here
    // Example: call API → validate → save token → handle errors

    // Simulated delay (remove in real implementation)
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final role = await AppRoleFactory.getCurrentRole();

    if (role != null) {
      context.pushNamedAndRemoveUntil(
        role.initialRouteAfterLogin,
        predicate: (route) => false,
      );
    } else {
      // Fallback when no role is selected (should be rare)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى اختيار نوع المستخدم من جديد')),
        );
        context.pushNamedAndRemoveUntil(
          Routes.selectRoleScreen,
          predicate: (route) => false,
        );
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SolidTextFormField(
          hintText: 'الايميل',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        verticalSpace(16),

        SolidTextFormField(
          hintText: 'كلمه السر',
          controller: _passwordController,
          isObscureText: _isObscureText,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          suffixIcon: IconButton(
            icon: Icon(
              _isObscureText ? Icons.visibility_off : Icons.visibility,
              color: ColorsManager.grey,
            ),
            onPressed: () => setState(() => _isObscureText = !_isObscureText),
          ),
        ),
        verticalSpace(8),

        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: TextButton(
              onPressed: () => context.pushNamed(Routes.resetPasswordScreen),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'نسيت كلمه السر؟',
                style: TextStyles.font14BlackRegular,
              ),
            ),
          ),
        ),
        verticalSpace(24),

        AppTextButton(
          onPressed: _onLoginPressed,
          textButton: _isLoading ? 'جاري التسجيل...' : 'تسجيل',
          gradient: ColorsManager.primaryGradient,
          height: 56.h,
          borderRadius: 12.r,
        ),
      ],
    );
  }
}
