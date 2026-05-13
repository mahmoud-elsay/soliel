import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soliel/core/theming/colors_manger.dart';

class StartGameScreen extends StatelessWidget {
  const StartGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/game_enter_background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Bottom left puzzle image
            Positioned(
              bottom: 20.h,
              left: 20.w,
              child: Image.asset(
                'assets/images/bottom_left_puzzle.png',
                width: 250.w,
                fit: BoxFit.contain,
              ),
            ),

            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // سوليّ Text with Outline
                  Stack(
                    children: [
                      // Outline
                      Text(
                        'سوليّ',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.archivoBlack(
                          fontSize: 75.sp,
                          height: 0.8,
                          letterSpacing: 0.06 * 75.sp,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = Colors.white,
                        ),
                      ),
                      // Fill
                      Text(
                        'سوليّ',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.archivoBlack(
                          fontSize: 75.sp,
                          height: 0.8,
                          letterSpacing: 0.06 * 75.sp,
                          color: const Color(0xFFFFD54F), // Yellow color
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 40.h),

                  // بدء اللعب Button
                  GestureDetector(
                    onTap: () {
                      // Action for starting game
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
                      decoration: BoxDecoration(
                        gradient: ColorsManager.primaryGradient,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: const Color(0xFFFFD54F),
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Outline for button text
                          Text(
                            'بدء اللعب',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.archivoBlack(
                              fontSize: 40.sp,
                              height: 0.8,
                              letterSpacing: 0.06 * 40.sp,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 3
                                ..color = const Color(0xFFFFD54F),
                            ),
                          ),
                          // Fill for button text
                          Text(
                            'بدء اللعب',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.archivoBlack(
                              fontSize: 40.sp,
                              height: 0.8,
                              letterSpacing: 0.06 * 40.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Back Button
            Positioned(
              top: 50.h,
              right: 20.w,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
