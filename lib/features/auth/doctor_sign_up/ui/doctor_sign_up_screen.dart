import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';
import 'package:soliel/core/widgets/app_loading_indicator.dart';
import 'package:soliel/core/widgets/custom_snack_bar.dart';
import 'package:soliel/features/auth/doctor_sign_up/logic/doctor_sign_up_cubit/doctor_sign_up_cubit.dart';
import 'package:soliel/features/auth/doctor_sign_up/logic/doctor_sign_up_cubit/doctor_sign_up_state.dart';
import 'package:soliel/features/auth/doctor_sign_up/ui/widgets/doctor_sign_up_form.dart';

class DoctorSignUpScreen extends StatefulWidget {
  const DoctorSignUpScreen({super.key});

  @override
  State<DoctorSignUpScreen> createState() => _DoctorSignUpScreenState();
}

class _DoctorSignUpScreenState extends State<DoctorSignUpScreen> {
  bool _isLoadingDialogVisible = false;

  void _showLoadingDialog() {
    if (_isLoadingDialogVisible) return;

    _isLoadingDialogVisible = true;
    showAppLoading(context, 'جاري إنشاء الحساب...');
  }

  void _hideLoadingDialog() {
    if (!_isLoadingDialogVisible) return;
    Navigator.of(context, rootNavigator: true).pop();
    _isLoadingDialogVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DoctorSignUpCubit, DoctorSignUpState>(
      listener: (_, state) {
        state.whenOrNull(
          loading: _showLoadingDialog,
          success: (data) {
            _hideLoadingDialog();
            CustomSnackBar.show(
              context,
              message: data.message,
              state: SnackBarState.success,
            );
            if (!mounted) return;
            context.pushNamedAndRemoveUntil(
              Routes.loginScreen,
              predicate: (route) => false,
            );
          },
          error: (error) {
            _hideLoadingDialog();
            CustomSnackBar.show(
              context,
              message: error.message,
              state: SnackBarState.error,
            );
          },
        );
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            context.pushReplacementNamed(Routes.selectRoleScreen);
          }
        },
        child: Scaffold(
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
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  context.pushReplacementNamed(Routes.selectRoleScreen);
                }
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'بالفعل لديك اكونت؟ ',
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
    ),
  );
}
}
