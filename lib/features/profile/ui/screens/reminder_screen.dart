import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/helpers/shared_pref_helper.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_text_button.dart';
import 'package:soliel/features/profile/data/models/latest_report_response.dart';
import 'package:soliel/features/profile/data/models/questionnaire_field_result_model.dart';
import 'package:soliel/features/profile/logic/progress_cubit/progress_cubit.dart';
import 'package:soliel/features/profile/logic/progress_cubit/progress_state.dart';
import 'package:soliel/features/profile/ui/widgets/domain_reminder_card.dart';
import 'package:soliel/features/profile/ui/widgets/profile_greeting_row.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  // Maps a domain field name to its game URL
  static String? _gameUrlForField(String fieldName) {
    if (fieldName.contains('تفاعل') || fieldName.contains('اجتماعي')) {
      return 'https://ayat876.github.io/thegame3334/';
    } else if (fieldName.contains('تواصل')) {
      return 'https://ayat876.github.io/ayat/';
    } else if (fieldName.contains('مهارات') || fieldName.contains('سلوك')) {
      return 'https://ayat876.github.io/roro/';
    }
    return null;
  }

  // The 3 standard domains that should ALWAYS appear
  static const List<String> _allDomains = [
    'التفاعل الاجتماعي',
    'التواصل',
    'المهارات والسلوكيات',
  ];

  // Fuzzy-match API field names against our standard domain names
  static bool _domainsMatch(String apiName, String standardName) {
    final a = apiName.replaceAll(' ', '').replaceAll('مجال', '');
    final b = standardName.replaceAll(' ', '').replaceAll('مجال', '');
    return a.contains(b) || b.contains(a);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white,
      body: BlocBuilder<ProgressCubit, ProgressState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error) => _buildErrorState(context, error.message),
            success: (report) => _buildContent(context, report),
          );
        },
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

    // Date string from lastUpdated
    final dateStr = report.lastUpdated.length >= 10
        ? report.lastUpdated.substring(0, 10)
        : report.lastUpdated;

    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Dark Gradient Top Section ─────────────────────────
          _buildTopSection(context, report, dateStr),

          verticalSpace(10),

          // ── Domain Cards ──────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'النسب في كل مجال',
                  style: TextStyles.font16BlackSemiBold.copyWith(
                    fontSize: 18.sp,
                    color: const Color(0xFF1E232C),
                  ),
                ),
                verticalSpace(16),
                // Always show all 3 domains. Domains not yet answered
                // by the API are shown as لم يجتازه with score 0.
                ..._allDomains.map((domainName) {
                  final apiResult = report.questionnaire?.firstWhere(
                    (q) => _domainsMatch(q.fieldName, domainName),
                    orElse: () => QuestionnaireFieldResultModel(
                      fieldName: domainName,
                      score: 0,
                      status: 'يحتاج متابعة',
                    ),
                  ) ?? QuestionnaireFieldResultModel(
                    fieldName: domainName,
                    score: 0,
                    status: 'يحتاج متابعة',
                  );
                  return _buildDomainCard(context, apiResult, dateStr);
                }),
                verticalSpace(30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDomainCard(
    BuildContext context,
    QuestionnaireFieldResultModel q,
    String dateStr,
  ) {
    // API: 'يحتاج متابعة' → لم يجتازه (play), otherwise → اجتازه (completed)
    final isPassed = q.status != 'يحتاج متابعة';
    final status =
        isPassed ? ReminderStatus.completed : ReminderStatus.notPassed;

    return DomainReminderCard(
      title: q.fieldName,
      score: q.score,
      date: dateStr,
      status: status,
      onTap: () {
        final gameUrl = _gameUrlForField(q.fieldName);
        if (gameUrl != null) {
          context.pushNamed(Routes.startGameScreen, arguments: gameUrl);
        }
      },
    );
  }

  Widget _buildTopSection(
    BuildContext context,
    LatestReportResponse report,
    String dateStr,
  ) {
    return Stack(
      children: [
        // ── Dark gradient background ──────────────────────────
        Container(
          height: 300.h,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E4F89), Color(0xFF081423)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  verticalSpace(20),

                  // App Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Settings placeholder (keeps layout balanced)
                      const SizedBox(width: 44),

                      Text(
                        'التذكير بالتمارين',
                        style: TextStyles.font20BlackSemiBold.copyWith(
                          color: Colors.white,
                        ),
                      ),

                      // Back button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 20.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  verticalSpace(20),

                  // Greeting row (white text on dark bg)
                  ValueListenableBuilder<String>(
                    valueListenable: StorageHelper.childNameNotifier,
                    builder: (context, childName, _) {
                      final displayName = childName.isNotEmpty ? childName : report.childName;
                      return ProfileGreetingRow(
                        name: displayName,
                        subtitle: 'تابع حاله طفلك اليوم',
                        textColor: Colors.white,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Floating white info card ──────────────────────────
        Padding(
          padding: EdgeInsets.only(top: 210.h, left: 20.w, right: 20.w),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Last updated date
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'آخر تحديث للبيانات',
                          style: TextStyles.font14GreyMedium.copyWith(
                            fontSize: 16.sp,
                            color: const Color(0xFF6A707C),
                          ),
                        ),
                        Text(
                          dateStr,
                          style: TextStyles.font14GreyMedium.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                verticalSpace(20),

                // Suggested game row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF2FA),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        report.suggestedGame ?? 'مقترح',
                        style:
                            TextStyles.font12PrimaryGradientStartSemiBold
                                .copyWith(color: const Color(0xFF1E4F89)),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'اللعبة المقترحة',
                          style: TextStyles.font16BlackSemiBold.copyWith(
                            color: const Color(0xFF1E232C),
                          ),
                        ),
                        Text(
                          dateStr,
                          style: TextStyles.font14GreyMedium,
                        ),
                      ],
                    ),
                    horizontalSpace(12),
                    Icon(
                      Icons.videogame_asset,
                      color: const Color(0xFF1E4F89),
                      size: 32.sp,
                    ),
                  ],
                ),

                verticalSpace(24),

                // Start game button — navigates to weakest field game
                AppTextButton(
                  textButton: 'بدء اللعبة',
                  onPressed: () {
                    final gameUrl = _gameUrlForField(
                      report.weakestField ?? '',
                    );
                    if (gameUrl != null) {
                      context.pushNamed(
                        Routes.startGameScreen,
                        arguments: gameUrl,
                      );
                    }
                  },
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E4F89), Color(0xFF081423)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: 15.r,
                  height: 54.h,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
