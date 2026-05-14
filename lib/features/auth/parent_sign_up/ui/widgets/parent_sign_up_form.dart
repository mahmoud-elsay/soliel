import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/app_validation.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/widgets/app_text_button.dart';
import 'package:soliel/core/widgets/solid_text_form_field.dart';
import 'package:soliel/features/auth/parent_sign_up/logic/parent_sign_up_cubit/parent_sign_up_cubit.dart';

class ParentSignUpForm extends StatefulWidget {
  const ParentSignUpForm({super.key});

  @override
  State<ParentSignUpForm> createState() => _ParentSignUpFormState();
}

class _ParentSignUpFormState extends State<ParentSignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  bool _isObscureText = true;
  bool _isConfirmObscureText = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _relationController.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    context.read<ParentSignUpCubit>().emitParentSignUpStates(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      relation: _relationController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SolidTextFormField(
            hintText: 'الاسم الأول',
            controller: _firstNameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: validateName,
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'اسم العائلة',
            controller: _lastNameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: validateName,
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'البريد الإلكتروني',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: validateEmail,
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'صلة القرابة',
            controller: _relationController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'صلة القرابة مطلوبة';
              }
              return null;
            },
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'كلمة المرور',
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            isObscureText: _isObscureText,
            validator: validatePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _isObscureText ? Icons.visibility_off : Icons.visibility,
                color: ColorsManager.grey,
              ),
              onPressed: () {
                setState(() {
                  _isObscureText = !_isObscureText;
                });
              },
            ),
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'تأكيد كلمة المرور',
            controller: _confirmPasswordController,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            isObscureText: _isConfirmObscureText,
            validator: (value) =>
                validateConfirmPassword(value, _passwordController.text),
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmObscureText ? Icons.visibility_off : Icons.visibility,
                color: ColorsManager.grey,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmObscureText = !_isConfirmObscureText;
                });
              },
            ),
          ),
          verticalSpace(32),
          AppTextButton(
            onPressed: _submit,
            textButton: 'إنشاء الحساب',
            gradient: ColorsManager.primaryGradient,
            height: 56.h,
            borderRadius: 12.r,
          ),
        ],
      ),
    );
  }
}
