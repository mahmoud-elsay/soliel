import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/shared_pref_helper.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/features/profile/logic/progress_cubit/progress_cubit.dart';
import 'package:soliel/features/profile/logic/progress_cubit/progress_state.dart';
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
        child: BlocBuilder<ProgressCubit, ProgressState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error) => _buildShell(
                greeting: const ProfileGreetingRow(),
                body: Center(
                  child: Text(
                    error.message,
                    style: TextStyles.font14GreyMedium,
                  ),
                ),
              ),
              success: (report) {
                final hasEyeScan = report.eyeScan != null;
                final hasQuestionnaire =
                    report.questionnaire != null && report.questionnaire!.isNotEmpty;

                if (!hasEyeScan && !hasQuestionnaire) {
                  return _buildShell(
                    greeting: ValueListenableBuilder<String>(
                      valueListenable: StorageHelper.childNameNotifier,
                      builder: (context, childName, _) {
                        final displayName = childName.isNotEmpty ? childName : report.childName;
                        return ProfileGreetingRow(name: displayName);
                      },
                    ),
                    body: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Text(
                          'لا توجد نتائج سابقة حتى الآن',
                          style: TextStyles.font14GreyMedium,
                        ),
                      ),
                    ),
                  );
                }

                final dateStr = report.lastUpdated.length >= 10
                    ? report.lastUpdated.substring(0, 10)
                    : report.lastUpdated;

                final eyeDate = (hasEyeScan && report.eyeScan!.date.length >= 10)
                    ? report.eyeScan!.date.substring(0, 10)
                    : (report.eyeScan?.date ?? '');

                return _buildShell(
                  greeting: ValueListenableBuilder<String>(
                    valueListenable: StorageHelper.childNameNotifier,
                    builder: (context, childName, _) {
                      final displayName = childName.isNotEmpty ? childName : report.childName;
                      return ProfileGreetingRow(name: displayName);
                    },
                  ),
                  body: Column(
                    children: [
                      // Eye scan card
                      if (hasEyeScan)
                        ResultCard(
                          title: 'فحص العين',
                          date: eyeDate,
                          percentage:
                              '${(report.eyeScan!.asdProbability * 100).toStringAsFixed(1)}%',
                          imagePath: 'assets/images/profile_results.png',
                        ),
                      // One card per questionnaire domain
                      if (hasQuestionnaire)
                        ...report.questionnaire!.map(
                          (q) => ResultCard(
                            title: q.fieldName,
                            date: dateStr,
                            percentage: '${q.score.toStringAsFixed(0)}%',
                            imagePath: 'assets/images/profile_results.png',
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildShell({
    required Widget greeting,
    required Widget body,
  }) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            verticalSpace(20),
            const ProfileAppBar(title: 'حساب الطفل'),
            verticalSpace(30),
            greeting,
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
            body,
            verticalSpace(20),
          ],
        ),
      ),
    );
  }
}
