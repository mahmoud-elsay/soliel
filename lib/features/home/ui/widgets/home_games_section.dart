import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';

class HomeGamesSection extends StatelessWidget {
  const HomeGamesSection({super.key});

  static const List<Map<String, String>> _games = [
    {
      'title': 'مجال المهارات والسلوكيات',
      'imagePath': 'assets/images/skills_game_image.jpg',
      'url': 'https://ayat876.github.io/roro/',
    },
    {
      'title': 'مجال التفاعل الاجتماعي',
      'imagePath': 'assets/images/interaction_game_image.jpg',
      'url': 'https://ayat876.github.io/thegame3334/',
    },
    {
      'title': 'مجال التواصل',
      'imagePath': 'assets/images/communication_game_image.jpg',
      'url': 'https://ayat876.github.io/ayat/',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: AppGradientText(
            gradient: ColorsManager.primaryGradient,
            child: Text(
              'بعض الصور من الالعاب',
              textDirection: TextDirection.rtl,
              style: TextStyles.font20GradientSemiBold,
            ),
          ),
        ),

        SizedBox(height: 14.h),

        // Horizontal game image list
        SizedBox(
          height: 160.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true, // RTL ordering
            padding: EdgeInsets.only(right: 20.w, left: 8.w),
            itemCount: _games.length,
            itemBuilder: (context, index) {
              final game = _games[index];
              return GestureDetector(
                onTap: () {
                  context.pushNamed(
                    Routes.startGameScreen,
                    arguments: game['url'],
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 12.w),
                  width: 160.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          game['imagePath']!,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black87],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.all(8.r),
                            child: Text(
                              game['title']!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
