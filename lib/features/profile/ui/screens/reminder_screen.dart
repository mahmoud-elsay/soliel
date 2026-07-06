import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/features/profile/data/models/latest_report_response.dart';
import 'package:soliel/features/profile/logic/progress_cubit/progress_cubit.dart';
import 'package:soliel/features/profile/logic/progress_cubit/progress_state.dart';
import 'package:soliel/features/profile/ui/widgets/domain_reminder_card.dart';
import 'package:soliel/features/profile/ui/widgets/profile_app_bar.dart';
import 'package:soliel/features/profile/ui/widgets/profile_greeting_row.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

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
              error: (error) => _buildErrorState(context, error.message),
              success: (report) => _buildContent(context, report),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage,
              style: TextStyles.font14GreyMedium,
              textAlign: TextAlign.center,
            ),
            verticalSpace(16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('رجوع'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, LatestReportResponse report) {
    final hasQuestionnaire =
        report.questionnaire != null && report.questionnaire!.isNotEmpty;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            verticalSpace(20),
            const ProfileAppBar(title: 'التذكير بالتمارين'),
            verticalSpace(30),
            ProfileGreetingRow(name: report.childName),
            verticalSpace(30),
            Text(
              'النسب في كل مجال',
              style: TextStyles.font16BlackSemiBold.copyWith(
                fontSize: 18.sp,
                color: const Color(0xFF1E232C),
              ),
            ),
            verticalSpace(16),
            if (!hasQuestionnaire)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Text(
                    'لا توجد نتائج استبيان حتى الآن',
                    style: TextStyles.font14GreyMedium,
                  ),
                ),
              )
            else
              ...report.questionnaire!.map((q) {
                final isDone = q.status != 'يحتاج متابعة';
                final dateStr = report.lastUpdated.length >= 10
                    ? report.lastUpdated.substring(0, 10)
                    : report.lastUpdated;
                return DomainReminderCard(
                  title: q.fieldName,
                  date: dateStr,
                  time: '', // No scheduled time from backend
                  status: isDone ? ReminderStatus.completed : ReminderStatus.play,
                  onTap: () {
                    String? gameUrl;
                    if (q.fieldName.contains('تفاعل') || q.fieldName.contains('اجتماعي')) {
                      gameUrl = 'https://ayat876.github.io/thegame3334/';
                    } else if (q.fieldName.contains('تواصل')) {
                      gameUrl = 'https://ayat876.github.io/ayat/';
                    } else if (q.fieldName.contains('مهارات') || q.fieldName.contains('سلوك')) {
                      gameUrl = 'https://ayat876.github.io/roro/';
                    }
                    if (gameUrl != null) {
                      context.pushNamed(
                        Routes.startGameScreen,
                        arguments: gameUrl,
                      );
                    }
                  },
                );
              }),
            verticalSpace(30),
          ],
        ),
      ),
    );
  }
}
