import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/app_role.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';
import 'package:soliel/core/widgets/or_divider.dart';
import 'package:soliel/core/widgets/social_media_buttons.dart';
import 'package:soliel/core/widgets/custom_snack_bar.dart';
import 'package:soliel/core/widgets/app_loading_indicator.dart';
import 'package:soliel/features/auth/login/logic/login_cubit/login_cubit.dart';
import 'package:soliel/features/auth/login/logic/login_cubit/login_state.dart';
import 'package:soliel/features/auth/login/ui/widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoadingDialogVisible = false;

  void _showLoadingDialog() {
    if (_isLoadingDialogVisible) return;

    _isLoadingDialogVisible = true;
    showAppLoading(context, 'جاري تسجيل الدخول...');
  }

  void _hideLoadingDialog() {
    if (!_isLoadingDialogVisible) return;
    Navigator.of(context, rootNavigator: true).pop();
    _isLoadingDialogVisible = false;
  }

  Future<void> _openSignUpForSelectedRole() async {
    final currentRole = await AppRoleFactory.getCurrentRole();
    final routeName = currentRole is ParentRole
        ? Routes.parentSignUpScreen
        : Routes.doctorSignUpScreen;

    if (!mounted) return;
    context.pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (_, state) async {
        state.whenOrNull(
          loading: _showLoadingDialog,
          success: (data) async {
            _hideLoadingDialog();

            final role =
                AppRoleFactory.fromStorageKey(data.role) ??
                await AppRoleFactory.getCurrentRole();
            final routeName = role?.initialRouteAfterLogin ?? Routes.homeScreen;

            if (!mounted) return;
            this.context.pushNamedAndRemoveUntil(
              routeName,
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
              Navigator.pop(context);
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
                            'مرحبا بك! مره ثانيه....',
                            style: TextStyles.font30GradientBold,
                            textAlign: TextAlign.right,
                          ),
                        ),

                        verticalSpace(80),

                        const LoginForm(),

                        verticalSpace(40),

                        const OrDivider(),

                        verticalSpace(32),

                        const SocialMediaButtons(),

                        verticalSpace(24),
                      ],
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ليس لديك حساب؟ ',
                      style: TextStyles.font15DarkBlueBold,
                    ),
                    TextButton(
                      onPressed: _openSignUpForSelectedRole,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: AppGradientText(
                        gradient: ColorsManager.primaryGradient,
                        child: Text(
                          'سجل الآن',
                          style: TextStyles.font15GradientBold,
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
