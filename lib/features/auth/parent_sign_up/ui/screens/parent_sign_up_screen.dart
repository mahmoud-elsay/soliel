import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';
import 'package:soliel/features/auth/parent_sign_up/logic/parent_sign_up_cubit/parent_sign_up_cubit.dart';
import 'package:soliel/features/auth/parent_sign_up/logic/parent_sign_up_cubit/parent_sign_up_state.dart';
import 'package:soliel/features/auth/parent_sign_up/ui/widgets/parent_sign_up_form.dart';

class ParentSignUpScreen extends StatefulWidget {
  const ParentSignUpScreen({super.key});

  @override
  State<ParentSignUpScreen> createState() => _ParentSignUpScreenState();
}

class _ParentSignUpScreenState extends State<ParentSignUpScreen> {
  bool _isLoadingDialogVisible = false;

  void _showLoadingDialog() {
    if (_isLoadingDialogVisible) return;

    _isLoadingDialogVisible = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Flexible(child: Text('جاري إنشاء الحساب...')),
            ],
          ),
        ),
      ),
    ).then((_) {
      _isLoadingDialogVisible = false;
    });
  }

  void _hideLoadingDialog() {
    if (!_isLoadingDialogVisible) return;
    Navigator.of(context, rootNavigator: true).pop();
    _isLoadingDialogVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ParentSignUpCubit, ParentSignUpState>(
      listener: (_, state) async {
        state.whenOrNull(
          loading: _showLoadingDialog,
          success: (data) async {
            _hideLoadingDialog();

            await showDialog<void>(
              context: this.context,
              builder: (_) => AlertDialog(
                title: const Text('تم إنشاء الحساب'),
                content: Text(data.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(this.context).pop(),
                    child: const Text('حسناً'),
                  ),
                ],
              ),
            );

            if (!mounted) return;
            this.context.pushNamedAndRemoveUntil(
              Routes.loginScreen,
              predicate: (route) => false,
            );
          },
          error: (error) {
            _hideLoadingDialog();
            ScaffoldMessenger.of(this.context).showSnackBar(
              SnackBar(content: Text(error.message)),
            );
          },
        );
      },
      child: Scaffold(
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
                            'أنشئ حساب ولي الأمر',
                            style: TextStyles.font30GradientBold,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        verticalSpace(40),
                        const ParentSignUpForm(),
                        verticalSpace(24),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'بالفعل لديك حساب؟ ',
                      style: TextStyles.font14BlackRegular,
                    ),
                    TextButton(
                      onPressed: () {
                        context.pushReplacementNamed(Routes.loginScreen);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: AppGradientText(
                        gradient: ColorsManager.primaryGradient,
                        child: Text(
                          'سجل الدخول',
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
      ),
    );
  }
}
