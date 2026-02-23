import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/features/home/ui/widgets/home_carousel_slider.dart';
import 'package:soliel/features/home/ui/widgets/home_doctors_section.dart';
import 'package:soliel/features/home/ui/widgets/home_games_section.dart';
import 'package:soliel/features/home/ui/widgets/home_greeting_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false, // bottom nav bar handles its own safe area
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 8.h),

              // Greeting row: menu icon | name + subtitle | avatar
              const HomeGreetingRow(),

              SizedBox(height: 16.h),

              // Carousel with background image, text, and capsule dots
              const HomeCarouselSlider(),

              SizedBox(height: 24.h),

              // Doctors section: gradient title + horizontal card list
              const HomeDoctorsSection(),

              SizedBox(height: 24.h),

              // Games section: gradient title + horizontal image list
              const HomeGamesSection(),

              // Extra bottom padding so content clears the nav bar
              SizedBox(height: 90.h),
            ],
          ),
        ),
      ),
    );
  }
}
