import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';
import 'package:soliel/features/home/ui/widgets/home_greeting_row.dart';
import 'package:soliel/features/test/ui/widgets/test_card.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String? _capturedImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            const HomeGreetingRow(),
            SizedBox(height: 20.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: Column(
                  children: [
                    TestCard(
                      title: 'فحص العين',
                      imagePath: 'assets/images/eye_inspect_image.png',
                      capturedImagePath: _capturedImagePath,
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          Routes.scannerScreen,
                        );
                        if (result != null && result is String) {
                          setState(() {
                            _capturedImagePath = result;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 25.h),
                    TestCard(
                      title: 'استبيان مبدئي',
                      imagePath: 'assets/images/papers.png',
                      onTap: () {
                        // TODO: Implement questionnaire navigation
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Center(
        child: AppGradientText(
          gradient: ColorsManager.primaryGradient,
          child: Text(
            'الاختبار',
            style: TextStyles.font20GradientSemiBold,
          ),
        ),
      ),
    );
  }
}
