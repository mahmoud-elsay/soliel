import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';
import 'package:soliel/features/home/ui/widgets/home_greeting_row.dart';
import 'package:soliel/features/test/ui/screens/questions_screen.dart';
import 'package:soliel/features/test/ui/widgets/test_card.dart';

class QuestionnaireScreen extends StatelessWidget {
  const QuestionnaireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildAppBar(context),
              const HomeGreetingRow(),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  children: [
                    TestCard(
                      customWidth: 325,
                      title: 'مجال التفاعل\nالاجتماعي',
                      imagePath: 'assets/images/interaction_image.png',
                      border: Border.all(
                        color: ColorsManager.primaryGradientStart.withOpacity(0.5),
                        width: 1.w,
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.questionsScreen,
                          arguments: QuestionsArgs(
                            title: 'مجال التفاعل الاجتماعي',
                            imagePath: 'assets/images/interaction_image.png',
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                    TestCard(
                      customWidth: 325,
                      title: 'مجال المهارات\nوالسلوكيات',
                      imagePath: 'assets/images/behavior_image.png',
                      border: Border.all(
                        color: ColorsManager.primaryGradientStart.withOpacity(0.5),
                        width: 1.w,
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.questionsScreen,
                          arguments: QuestionsArgs(
                            title: 'مجال المهارات والسلوكيات',
                            imagePath: 'assets/images/behavior_image.png',
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                    TestCard(
                      customWidth: 325,
                      title: 'مجال التواصل',
                      imagePath: 'assets/images/communication_image.png',
                      border: Border.all(
                        color: ColorsManager.primaryGradientStart.withOpacity(0.5),
                        width: 1.w,
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.questionsScreen,
                          arguments: QuestionsArgs(
                            title: 'مجال التواصل',
                            imagePath: 'assets/images/communication_image.png',
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 100.h), // Bottom nav space
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: ColorsManager.greyBorderColor),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 18.r,
                color: ColorsManager.primaryGradientStart,
              ),
            ),
          ),
          AppGradientText(
            gradient: ColorsManager.primaryGradient,
            child: Text(
              'الاختبار',
              style: TextStyles.font20GradientSemiBold,
            ),
          ),
          SizedBox(width: 48.w), // Spacer to balance the back button
        ],
      ),
    );
  }
}
