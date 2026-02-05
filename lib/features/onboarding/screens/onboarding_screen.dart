import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/widgets/app_text_button.dart';
import 'package:soliel/features/onboarding/model/onboarding_model.dart';
import 'package:soliel/features/onboarding/widgets/onboarding_indicator.dart';
import 'package:soliel/features/onboarding/widgets/onboarding_page_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < OnboardingModel.onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.pushReplacementNamed(Routes.selectRoleScreen);
    }
  }

  void _skipOnboarding() {
    _pageController.jumpToPage(OnboardingModel.onboardingPages.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: OnboardingModel.onboardingPages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return OnboardingPageContent(
                  model: OnboardingModel.onboardingPages[index],
                  pageIndex: index,
                );
              },
            ),
          ),

          // Bottom Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              children: [
                // Indicator
                OnboardingIndicator(
                  pageCount: OnboardingModel.onboardingPages.length,
                  currentPage: _currentPage,
                ),

                SizedBox(height: 32.h),

                // Continue / Start Button
                AppTextButton(
                  onPressed: _nextPage,
                  textButton:
                      _currentPage == OnboardingModel.onboardingPages.length - 1
                      ? 'يلا نبدأ'
                      : 'استمر',
                  gradient: ColorsManager.primaryGradient,
                  height: 52.h,
                  borderRadius: 12.r,
                  margin: EdgeInsets.zero,
                ),

                SizedBox(height: 16.h),

                // Skip Button
                AppTextButton(
                  onPressed: _skipOnboarding,
                  textButton: 'تخطي',
                  backgroundColor: ColorsManager.lightPurple,
                  textColor: ColorsManager.black,
                  height: 52.h,
                  borderRadius: 12.r,
                  margin: EdgeInsets.zero,
                  fontSize: 14.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
