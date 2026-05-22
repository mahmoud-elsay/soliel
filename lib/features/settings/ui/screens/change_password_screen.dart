import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';
import 'package:soliel/core/widgets/app_text_button.dart';
import 'package:soliel/core/widgets/app_text_form_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  _buildHeader(context),
                  SizedBox(height: 40.h),
                  AppTextFormField(
                    controller: _currentPasswordController,
                    hintText: 'كلمه المرور الحاليه',
                    isObscureText: true,
                    backgroundColor: ColorsManager.lightBlueBackground,
                  ),
                  SizedBox(height: 16.h),
                  AppTextFormField(
                    controller: _newPasswordController,
                    hintText: 'كلمه المرور الجديده',
                    isObscureText: true,
                    backgroundColor: ColorsManager.lightBlueBackground,
                  ),
                  SizedBox(height: 16.h),
                  AppTextFormField(
                    controller: _confirmPasswordController,
                    hintText: 'تأكيد كلمه المرور الجديده',
                    isObscureText: true,
                    backgroundColor: ColorsManager.lightBlueBackground,
                  ),
                  SizedBox(height: 40.h),
                  AppTextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Implement password change logic
                      }
                    },
                    textButton: 'حفظ البيانات',
                    gradient: ColorsManager.primaryGradient,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 44), // To balance the back button
        AppGradientText(
          gradient: ColorsManager.primaryGradient,
          child: Text(
            'تغيير كلمه المرور',
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
}
