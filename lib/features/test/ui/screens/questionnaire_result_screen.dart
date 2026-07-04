import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/helpers/shared_pref_helper.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';

/// Result for a single questionnaire domain (e.g. "مجال التواصل الاجتماعي").
class DomainResult {
  final String title;
  final double percentage; // 0.0 - 1.0
  final String iconAsset;

  const DomainResult({
    required this.title,
    required this.percentage,
    required this.iconAsset,
  });
}

class QuestionnaireResultScreen extends StatefulWidget {
  /// Results for every domain the parent completed. If empty, saved data or
  /// demo defaults are shown.
  final List<DomainResult> results;

  const QuestionnaireResultScreen({super.key, this.results = const []});

  @override
  State<QuestionnaireResultScreen> createState() => _QuestionnaireResultScreenState();
}

class _QuestionnaireResultScreenState extends State<QuestionnaireResultScreen> {
  List<DomainResult> _allResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAndMergeResults();
  }

  Future<void> _loadAndMergeResults() async {
    // 1. Get saved scores or use demo defaults
    double scoreCom = await StorageHelper.getDouble('domain_score_com') ?? 0.85;
    double scoreInt = await StorageHelper.getDouble('domain_score_int') ?? 0.80;
    double scoreSki = await StorageHelper.getDouble('domain_score_ski') ?? 0.30;

    // 2. Clear old state and merge with new results if present
    for (final newResult in widget.results) {
      final title = newResult.title.replaceAll('\n', ' ');
      if (title.contains('تواصل')) {
        scoreCom = newResult.percentage;
        await StorageHelper.setValue<double>('domain_score_com', scoreCom);
      } else if (title.contains('تفاعل')) {
        scoreInt = newResult.percentage;
        await StorageHelper.setValue<double>('domain_score_int', scoreInt);
      } else {
        scoreSki = newResult.percentage;
        await StorageHelper.setValue<double>('domain_score_ski', scoreSki);
      }
    }

    // 3. Update the state list representing all 3 domains
    if (mounted) {
      setState(() {
        _allResults = [
          DomainResult(
            title: 'مجال التواصل الاجتماعي',
            percentage: scoreCom,
            iconAsset: 'assets/svgs/social_result_icon.svg',
          ),
          DomainResult(
            title: 'مجال التفاعل الاجتماعي',
            percentage: scoreInt,
            iconAsset: 'assets/svgs/interact_result_icon.svg',
          ),
          DomainResult(
            title: 'مجال المهارات والسلوكيات',
            percentage: scoreSki,
            iconAsset: 'assets/svgs/skills_result.svg',
          ),
        ];
        _isLoading = false;
      });
    }
  }

  DomainResult _weakestDomain(List<DomainResult> list) =>
      list.reduce((a, b) => a.percentage <= b.percentage ? a : b);

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: ColorsManager.white,
        body: Center(
          child: CircularProgressIndicator(
            color: ColorsManager.primaryGradientStart,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: ColorsManager.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    verticalSpace(36),
                    ..._allResults.map(
                      (result) => Padding(
                        padding: EdgeInsets.only(bottom: 32.h),
                        child: _DomainResultCard(result: result),
                      ),
                    ),
                    verticalSpace(12),
                    Text(
                      'اللعبه المناسبه لاضعف مجال',
                      style: TextStyles.font18BlackSemiBold,
                    ),
                    verticalSpace(20),
                    _buildStartGameButton(context, _allResults),
                    verticalSpace(100), // clears bottom nav bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ClipPath(
      clipper: _CurvedHeaderClipper(),
      child: Container(
        width: double.infinity,
        height: 240.h,
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 0),
        decoration: const BoxDecoration(
          gradient: ColorsManager.primaryGradient,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button (rightmost under RTL)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: ColorsManager.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 20.r,
                  color: ColorsManager.primaryGradientStart,
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Center(
                  child: Text(
                    'نتيجه الاستبيان',
                    style: TextStyles.font22GradientSemiBold,
                  ),
                ),
              ),
            ),

            // Decorative communication icon (leftmost under RTL)
            Image.asset(
              'assets/images/communication_image.png',
              width: 64.w,
              height: 64.h,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartGameButton(BuildContext context, List<DomainResult> list) {
    return Container(
      width: double.infinity,
      height: 54.h,
      decoration: BoxDecoration(
        gradient: ColorsManager.primaryGradient,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ElevatedButton(
        onPressed: () {
          final weakest = _weakestDomain(list);
          String gameUrl = 'https://ayat876.github.io/roro/'; // default to skills
          final normalizedTitle = weakest.title.replaceAll('\n', ' ');
          if (normalizedTitle.contains('تواصل')) {
            gameUrl = 'https://ayat876.github.io/ayat/';
          } else if (normalizedTitle.contains('تفاعل')) {
            gameUrl = 'https://ayat876.github.io/thegame3334/';
          }

          Navigator.pushNamed(
            context,
            Routes.startGameScreen,
            arguments: gameUrl,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text('بدء اللعب', style: TextStyles.font16WhiteSemiBold),
      ),
    );
  }
}

class _DomainResultCard extends StatelessWidget {
  final DomainResult result;

  const _DomainResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 48.w,
          child: Text(
            '${(result.percentage * 100).round()}%',
            style: TextStyles.font14GreyMedium,
          ),
        ),
        horizontalSpace(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                result.title,
                textDirection: TextDirection.rtl,
                style: TextStyles.font18BlackSemiBold,
              ),
              verticalSpace(10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: LinearProgressIndicator(
                  value: result.percentage,
                  minHeight: 10.h,
                  backgroundColor: ColorsManager.greyBorderColor,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    ColorsManager.primaryGradientStart,
                  ),
                ),
              ),
            ],
          ),
        ),
        horizontalSpace(16),
        Container(
          width: 68.w,
          height: 68.w,
          padding: EdgeInsets.all(16.r),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: ColorsManager.primaryGradient,
          ),
          child: SvgPicture.asset(
            result.iconAsset,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }
}

/// Produces a bottom edge that arcs UP toward the center (a "hill"), so the
/// white content area appears to rise into the header at the middle and dip
/// down at the edges — matching the reference mock.
class _CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double edgeDrop = 40; // how far down the edges sit vs. center
    const double curveDepth = 70; // how far up the center peak rises

    final path = Path()
      ..lineTo(0, size.height - edgeDrop)
      ..quadraticBezierTo(
          size.width / 2,
          size.height - edgeDrop - curveDepth,
          size.width,
          size.height - edgeDrop,
      )
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
