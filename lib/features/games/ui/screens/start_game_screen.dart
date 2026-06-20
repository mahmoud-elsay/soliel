import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StartGameScreen extends StatefulWidget {
  const StartGameScreen({super.key});

  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  bool _gameStarted = false;
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..loadRequest(
        Uri.parse(
          'https://6a1feb7c19cf6c2a1455f500--creative-travesseiro-55f452.netlify.app/',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _gameStarted ? _buildGameView() : _buildStartView());
  }

  Widget _buildGameView() {
    return Stack(
      children: [
        WebViewWidget(controller: _webViewController),
        // Back Button
        Positioned(
          top: 50.h,
          right: 20.w,
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  setState(() => _gameStarted = false);
                },
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStartView() {
    return Container(
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
                    Text(
                      'سوليّ',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.archivoBlack(
                        fontSize: 75.sp,
                        height: 0.8,
                        letterSpacing: 0.06 * 75.sp,
                        color: const Color(0xFFFFD54F),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 40.h),

                // بدء اللعب Button
                GestureDetector(
                  onTap: () {
                    setState(() => _gameStarted = true);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 15.h,
                    ),
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
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
