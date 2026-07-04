import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';
import 'package:soliel/features/games/ui/widgets/game_card.dart';
import 'package:soliel/features/home/ui/widgets/home_greeting_row.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Center(
                  child: AppGradientText(
                    gradient: ColorsManager.primaryGradient,
                    child: Text(
                      'الألعاب',
                      style: TextStyles.font20GradientSemiBold,
                    ),
                  ),
                ),
              ),
              const HomeGreetingRow(),

              verticalSpace(16),

              GameCard(
                imagePath: 'assets/images/skills_game_image.jpg',
                title: 'مجال المهارات والسلوكيات',
                onTap: () {
                  context.pushNamed(
                    Routes.startGameScreen,
                    arguments: 'https://ayat876.github.io/roro/',
                  );
                },
              ),

              GameCard(
                imagePath: 'assets/images/interaction_game_image.jpg',
                title: 'مجال التفاعل الاجتماعي',
                onTap: () {
                  context.pushNamed(
                    Routes.startGameScreen,
                    arguments: 'https://ayat876.github.io/thegame3334/',
                  );
                },
              ),

              GameCard(
                imagePath: 'assets/images/communication_game_image.jpg',
                title: 'مجال التواصل',
                onTap: () {
                  context.pushNamed(
                    Routes.startGameScreen,
                    arguments: 'https://ayat876.github.io/ayat/',
                  );
                },
              ),

              // Padding for bottom nav
              verticalSpace(100),
            ],
          ),
        ),
      ),
    );
  }
}
