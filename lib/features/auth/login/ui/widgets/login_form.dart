import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/app_validation.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_text_button.dart';
import 'package:soliel/core/widgets/solid_text_form_field.dart';
import 'package:soliel/features/auth/login/logic/login_cubit/login_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    context.read<LoginCubit>().emitLoginStates(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SolidTextFormField(
            hintText: 'الايميل',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: validateEmail,
            autofillHints: const [AutofillHints.username, AutofillHints.email],
          ),
          verticalSpace(16),

          SolidTextFormField(
            hintText: 'كلمه السر',
            controller: _passwordController,
            isObscureText: _isObscureText,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            validator: validatePassword,
            autofillHints: const [AutofillHints.password],
            suffixIcon: IconButton(
              icon: Icon(
                _isObscureText ? Icons.visibility_off : Icons.visibility,
                color: ColorsManager.grey,
              ),
              onPressed: () => setState(
                () => _isObscureText = !_isObscureText,
              ),
            ),
          ),
          verticalSpace(8),

          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: TextButton(
                onPressed: () => Navigator.of(
                  context,
                ).pushNamed(Routes.resetPasswordScreen),
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
            textButton: 'تسجيل الدخول',
            gradient: ColorsManager.primaryGradient,
            height: 56.h,
            borderRadius: 12.r,
          ),
        ],
      ),
    );
  }
}
