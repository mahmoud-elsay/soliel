import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/features/doctor_profile/ui/screens/doctor_profile_screen.dart';
import 'package:soliel/features/home/ui/screens/home_screen.dart';
import 'package:soliel/features/games/ui/screens/games_screen.dart';
import 'package:soliel/features/test/ui/screens/test_screen.dart';

class ParentLayout extends StatefulWidget {
  const ParentLayout({super.key});

  @override
  State<ParentLayout> createState() => _ParentLayoutState();
}

class _ParentLayoutState extends State<ParentLayout> {
  int selectedIndex = 0;

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> screens = [
    const HomeScreen(),
    const GamesScreen(),
    const TestScreen(),
    const DoctorProfileScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> get _iconItems => [
    SvgPicture.asset(
      'assets/svgs/home_icon.svg',
      width: 28.w,
      height: 28.h,
      colorFilter: const ColorFilter.mode(ColorsManager.white, BlendMode.srcIn),
    ),
    SvgPicture.asset(
      'assets/svgs/game_icon.svg',
      width: 28.w,
      height: 28.h,
      colorFilter: const ColorFilter.mode(ColorsManager.white, BlendMode.srcIn),
    ),
    SvgPicture.asset(
      'assets/svgs/test_icon.svg',
      width: 28.w,
      height: 28.h,
      colorFilter: const ColorFilter.mode(ColorsManager.white, BlendMode.srcIn),
    ),
    SvgPicture.asset(
      'assets/svgs/profile_icon.svg',
      width: 28.w,
      height: 28.h,
      colorFilter: const ColorFilter.mode(ColorsManager.white, BlendMode.srcIn),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: selectedIndex, children: screens),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) =>
                ColorsManager.primaryGradient.createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: CurvedNavigationBar(
              index: selectedIndex,
              height: 65.h,
              color: Colors.white,
              buttonBackgroundColor: Colors.white,
              backgroundColor: Colors.transparent,
              animationCurve: Curves.easeInOutCubic,
              animationDuration: const Duration(milliseconds: 400),
              onTap: (_) {}, // interaction is handled by layer 2
              letIndexChange: (_) => true,

              items: List.generate(
                4,
                (_) => SizedBox(width: 28.w, height: 28.h),
              ),
            ),
          ),

          CurvedNavigationBar(
            key: _bottomNavigationKey,
            index: selectedIndex,
            height: 65.h,
            color: Colors.transparent,
            buttonBackgroundColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            animationCurve: Curves.easeInOutCubic,
            animationDuration: const Duration(milliseconds: 400),
            onTap: onItemTapped,
            letIndexChange: (_) => true,
            items: _iconItems,
          ),
        ],
      ),
    );
  }
}
