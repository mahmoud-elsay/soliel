import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/features/profile/ui/widgets/profile_app_bar.dart';
import 'package:soliel/features/profile/ui/widgets/profile_greeting_row.dart';
import 'package:soliel/features/profile/ui/widgets/result_card.dart';

class ProfileResultsScreen extends StatelessWidget {
  const ProfileResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                verticalSpace(20),
                const ProfileAppBar(title: 'حساب الطفل'),
                verticalSpace(30),
                const ProfileGreetingRow(),
                verticalSpace(30),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'النتائج السابقه',
                    style: TextStyles.font18BlackSemiBold.copyWith(
                      fontSize: 18.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
                verticalSpace(20),
                // Results List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return const ResultCard(
                      title: 'فحص شامل',
                      date: '12/12',
                      percentage: '68%',
                      imagePath: 'assets/images/profile_results.png',
                    );
                  },
                ),
                verticalSpace(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
