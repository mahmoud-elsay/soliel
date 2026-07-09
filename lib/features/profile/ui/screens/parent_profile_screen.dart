import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/helpers/shared_pref_helper.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/features/profile/data/models/latest_report_response.dart';
import 'package:soliel/features/profile/data/models/questionnaire_field_result_model.dart';
import 'package:soliel/features/profile/logic/progress_cubit/progress_cubit.dart';
import 'package:soliel/features/profile/logic/progress_cubit/progress_state.dart';
import 'package:soliel/features/profile/ui/widgets/profile_app_bar.dart';
import 'package:soliel/features/profile/ui/widgets/profile_greeting_row.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({super.key});

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
              success: (report) => _buildContent(context, report),
              error: (error) => Center(
                child: Text(error.message, style: TextStyles.font14GreyMedium),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, LatestReportResponse report) {
    final hasQuestionnaire =
        report.questionnaire != null && report.questionnaire!.isNotEmpty;
    // Average questionnaire score across all domains
    final double avgScore = !hasQuestionnaire
        ? 0.0
        : report.questionnaire!.map((q) => q.score).reduce((a, b) => a + b) /
              report.questionnaire!.length;
    final double avgProgress = (avgScore / 100.0).clamp(0.0, 1.0);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            verticalSpace(20),
            const ProfileAppBar(title: 'حساب ولي الامر'),
            verticalSpace(30),
            ValueListenableBuilder<String>(
              valueListenable: StorageHelper.childNameNotifier,
              builder: (context, childName, _) {
                final displayName = childName.isNotEmpty ? childName : report.childName;
                return ProfileGreetingRow(name: displayName);
              },
            ),
            verticalSpace(30),
            _buildChildTrackingSection(context, report, avgProgress),
            verticalSpace(30),
            Text(
              'مستوي طفلك في مجالات مختلفه',
              style: TextStyles.font16BlackSemiBold.copyWith(
                fontSize: 18.sp,
                color: Colors.black,
              ),
            ),
            verticalSpace(20),
            _buildDomainsGauges(report.questionnaire),
            verticalSpace(30),
            Text(
              'الالعاب المقترحه لطفلك',
              style: TextStyles.font16BlackSemiBold.copyWith(
                fontSize: 18.sp,
                color: Colors.black,
              ),
            ),
            verticalSpace(20),
            _buildSuggestedGameCard(context, report),
            verticalSpace(30),
          ],
        ),
      ),
    );
  }

  Widget _buildChildTrackingSection(
    BuildContext context,
    LatestReportResponse report,
    double avgProgress,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('تابع بيانات طفلك', style: TextStyles.font16BlackSemiBold),
              verticalSpace(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E4F89).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${(avgProgress * 100).toInt()}%',
                      style: TextStyles.font14BlackSemiBold.copyWith(
                        color: const Color(0xFF1E4F89),
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace(8),
              ValueListenableBuilder<String>(
                valueListenable: StorageHelper.childNameNotifier,
                builder: (context, childName, _) {
                  final displayName = childName.isNotEmpty ? childName : report.childName;
                  return Text(
                    displayName,
                    textAlign: TextAlign.end,
                    style: TextStyles.font20BlackSemiBold.copyWith(
                      fontSize: 22.sp,
                      height: 1.2,
                    ),
                  );
                },
              ),
              GestureDetector(
                onTap: () => context.pushNamed(Routes.editParentDataScreen),
                child: Text(
                  'Edit parent\'s details',
                  style: TextStyles.font14GreyMedium.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        horizontalSpace(20),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120.r,
              height: 120.r,
              child: CircularProgressIndicator(
                value: avgProgress,
                strokeWidth: 6,
                backgroundColor: const Color(0xFFE8ECF4),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF1E4F89),
                ),
              ),
            ),
            Container(
              width: 100.r,
              height: 100.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                image: const DecorationImage(
                  image: AssetImage('assets/images/child_profile_avatar.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 10.w,
              child: GestureDetector(
                onTap: () => context.pushNamed(Routes.editChildProfileScreen),
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E232C),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.edit, color: Colors.white, size: 14.sp),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDomainsGauges(List<QuestionnaireFieldResultModel>? domains) {
    if (domains == null || domains.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Text(
            'لا توجد نتائج استبيان حتى الآن',
            style: TextStyles.font14GreyMedium,
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: domains.map((domain) {
        final double progress = (domain.score / 100.0).clamp(0.0, 1.0);
        final Color color = domain.status == 'يحتاج متابعة'
            ? Colors.deepOrange
            : Colors.green;
        return _buildGauge(domain.fieldName, progress, color);
      }).toList(),
    );
  }

  Widget _buildGauge(String label, double progress, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 90.r,
              height: 90.r,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 10,
                backgroundColor: const Color(0xFFE8ECF4),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Column(
              children: [
                Text(
                  label,
                  style: TextStyles.font12GreyMedium.copyWith(fontSize: 10.sp),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyles.font14BlackSemiBold,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuggestedGameCard(BuildContext context, LatestReportResponse report) {
    final String? weakest = report.weakestField;
    // Map weakest field to a game label and description
    final Map<String, Map<String, String>> gameMap = {
      'التفاعل الاجتماعي': {
        'title': 'لعبة التفاعل',
        'desc': 'بتتحفز الطفل علي معرفه لغه التفاعل مع الأشخاص الاخرين',
        'url': 'https://ayat876.github.io/thegame3334/',
      },
      'التواصل': {
        'title': 'لعبة التواصل',
        'desc': 'تساعد الطفل على تطوير مهارات التواصل والتعبير عن نفسه',
        'url': 'https://ayat876.github.io/ayat/',
      },
      'المهارات والسلوكيات': {
        'title': 'لعبة المهارات',
        'desc': 'تعزز المهارات السلوكية والحركية لدى الطفل',
        'url': 'https://ayat876.github.io/roro/',
      },
    };

    final game =
        (weakest != null ? gameMap[weakest] : null) ??
        {
          'title': 'لعبة التفاعل',
          'desc': 'بتتحفز الطفل علي معرفه لغه التفاعل مع الأشخاص الاخرين',
          'url': 'https://ayat876.github.io/thegame3334/',
        };

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          Routes.startGameScreen,
          arguments: game['url'],
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFF00B060),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Text(
                'ابدأ',
                style: TextStyles.font14BlackSemiBold.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(game['title']!, style: TextStyles.font16BlackSemiBold),
                  Text(
                    game['desc']!,
                    textAlign: TextAlign.end,
                    style: TextStyles.font12GreyMedium.copyWith(fontSize: 13.sp),
                  ),
                ],
              ),
            ),
            horizontalSpace(16),
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/profile_results.png',
                  width: 50.r,
                  height: 50.r,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
