import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/widgets/app_text_button.dart';
import 'package:soliel/features/splash/widgets/curved_bottom_edge.dart';
import 'package:soliel/features/splash/widgets/expanding_circle_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _circleController;
  late Animation<double> _circleAnimation;
  late AnimationController _contentController;
  late Animation<Offset> _curveSlideAnimation;
  late Animation<Offset> _buttonSlideAnimation;
  late Animation<double> _buttonFadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimationSequence();
  }

  void _initAnimations() {
    // Circle expansion animation - 2 seconds
    _circleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _circleAnimation = CurvedAnimation(
      parent: _circleController,
      curve: Curves.easeInOutCubic,
    );

    // Content animations - 1.5 seconds
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Curve slides up from bottom
    _curveSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentController,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
          ),
        );

    // Button slide up from bottom
    _buttonSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 2.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    // Button fade in
    _buttonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );
  }

  void _startAnimationSequence() async {
    // Start circle expansion
    await _circleController.forward();

    // After circle fills screen, show curve and button
    await Future.delayed(const Duration(milliseconds: 200));
    _contentController.forward();
  }

  @override
  void dispose() {
    _circleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image (visible at start before circle expands)
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash_background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Expanding circle with logo - starts small, fills entire screen
          Positioned.fill(
            child: ExpandingCircleBackground(
              animation: _circleAnimation,
              child: SvgPicture.asset(
                'assets/svgs/app_tittle.svg',
                width: 131.w,
                height: 57.h,
                colorFilter: ColorFilter.mode(
                  ColorsManager.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          // Curved bottom edge - slides UP from bottom AFTER circle fills
          AnimatedBuilder(
            animation: _contentController,
            builder: (context, child) {
              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SlideTransition(
                  position: _curveSlideAnimation,
                  child: CurvedBottomEdge(child: SizedBox(height: 280.h)),
                ),
              );
            },
          ),

          // Button slides up from bottom AFTER curve appears
          AnimatedBuilder(
            animation: _contentController,
            builder: (context, child) {
              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  child: SlideTransition(
                    position: _buttonSlideAnimation,
                    child: FadeTransition(
                      opacity: _buttonFadeAnimation,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                        ).copyWith(bottom: 48.h),
                        child: AppTextButton(
                          textButton: 'استمر',
                          onPressed: () {
                            context.pushReplacementNamed(
                              Routes.onBoardingScreen,
                            );
                          },
                          gradient: ColorsManager.primaryGradient,
                          textColor: ColorsManager.white,
                          height: 52.h,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
