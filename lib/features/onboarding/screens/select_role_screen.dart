import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soliel/core/helpers/app_role.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/widgets/app_text_button.dart';
import 'package:soliel/core/widgets/custom_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectRoleScreen extends StatelessWidget {
  const SelectRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/select_roles_background_image.jpeg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              SvgPicture.asset('assets/svgs/blue_app_logo.svg', height: 120.h),
              const Spacer(flex: 3),

              AppTextButton(
                onPressed: () async {
                  await AppRoleFactory.saveRole(const DoctorRole());
                  if (context.mounted) {
                    context.pushNamed(Routes.loginScreen);
                  }
                },
                textButton: const DoctorRole().displayNameArabic,
                gradient: ColorsManager.primaryGradient,
                height: 56.h,
                borderRadius: 12.r,
              ),

              verticalSpace(16),

              AppTextButton(
                onPressed: () async {
                  await AppRoleFactory.saveRole(const ParentRole());
                  if (context.mounted) {
                    context.pushNamed(Routes.loginScreen);
                  }
                },
                textButton: const ParentRole().displayNameArabic,
                backgroundColor: ColorsManager.lightBlue,
                textGradient: ColorsManager.primaryGradient,
                height: 56.h,
                borderRadius: 12.r,
              ),

              verticalSpace(40),

              AppTextButton(
                onPressed: () async {
                  await AppRoleFactory.saveRole(const WebsiteRole());
                  final uri = Uri.parse('https://knada621.github.io/soleil/');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    if (context.mounted) {
                      CustomSnackBar.show(
                        context,
                        message: 'تعذر فتح الموقع الإلكتروني',
                        state: SnackBarState.error,
                      );
                    }
                  }
                },
                textButton: const WebsiteRole().displayNameArabic,
                backgroundColor: ColorsManager.lightBlue,
                textGradient: ColorsManager.primaryGradient,
                height: 56.h,
                borderRadius: 12.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
