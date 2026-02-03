import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
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
    } else {}
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
                Container(
                  width: double.infinity,
                  height: 52.h,
                  decoration: BoxDecoration(
                    gradient: ColorsManager.primaryGradient,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      _currentPage == OnboardingModel.onboardingPages.length - 1
                          ? 'يلا نبدأ'
                          : 'استمر',
                      style: TextStyles.font16WhiteSemiBold,
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Skip Button
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: TextButton(
                    onPressed: _skipOnboarding,
                    style: TextButton.styleFrom(
                      backgroundColor: ColorsManager.lightPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text('تخطي', style: TextStyles.font14BlackMedium),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
