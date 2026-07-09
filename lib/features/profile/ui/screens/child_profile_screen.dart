import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/helpers/shared_pref_helper.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';
import 'package:soliel/features/profile/ui/widgets/profile_greeting_row.dart';

class ChildProfileScreen extends StatefulWidget {
  const ChildProfileScreen({super.key});

  @override
  State<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends State<ChildProfileScreen> {
  String _parentName = '';
  int _childId = 1;

  @override
  void initState() {
    super.initState();
    _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    final name = await StorageHelper.getUserName();
    final childId = await StorageHelper.getChildId();
    if (mounted) {
      setState(() {
        _parentName = name ?? '';
        _childId = childId;
      });
    }
  }

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
                _buildHeader(context),
                verticalSpace(30),
                ValueListenableBuilder<String>(
                  valueListenable: StorageHelper.userNameNotifier,
                  builder: (context, userName, _) {
                    final displayName = userName.isNotEmpty ? userName : _parentName;
                    return ProfileGreetingRow(
                      name: displayName.isNotEmpty ? 'مرحبا! $displayName' : null,
                      subtitle: 'تابع حاله طفلك اليوم',
                      imagePath: 'assets/images/child_profile_avatar.png',
                    );
                  },
                ),
                verticalSpace(40),
                _buildCardsGrid(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            context.pushNamed(Routes.settingsScreen);
          },
          icon: Icon(
            Icons.settings_outlined,
            color: ColorsManager.primaryGradientStart,
            size: 28.sp,
          ),
        ),
        Text(
          'حساب الطفل',
          style: TextStyles.font20BlackSemiBold.copyWith(
            color: const Color(0xFF1E232C),
          ),
        ),
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              border: Border.all(color: ColorsManager.greyBorderColor),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 20.sp,
              color: ColorsManager.primaryGradientStart,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardsGrid(BuildContext context) {
    return Wrap(
      spacing: 15.w,
      runSpacing: 20.h,
      children: [
        _buildActionCard(
          context: context,
          label: 'النتائج السابقة',
          iconPath: 'assets/svgs/past_results.svg',
          onTap: () {
            context.pushNamed(
              Routes.profileResultsScreen,
              arguments: _childId,
            );
          },
        ),
        _buildActionCard(
          context: context,
          label: 'التذكير بالتمارين',
          iconPath: 'assets/svgs/reminder.svg',
          onTap: () {
            context.pushNamed(
              Routes.reminderScreen,
              arguments: _childId,
            );
          },
        ),
        _buildActionCard(
          context: context,
          label: 'تعديل بيانات الطفل',
          iconPath: 'assets/svgs/edit_baby.svg',
          onTap: () {
            context.pushNamed(Routes.editChildProfileScreen);
          },
        ),
        _buildActionCard(
          context: context,
          label: 'اضافه طفل جديد',
          iconPath: 'assets/svgs/add_new_baby.svg',
          onTap: () {
            context.pushNamed(Routes.addNewChildScreen);
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String label,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160.w,
        height: 127.h,
        decoration: BoxDecoration(
          color: ColorsManager.lightBlue,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 40.w,
              height: 40.h,
              colorFilter: const ColorFilter.mode(
                ColorsManager.primaryGradientStart,
                BlendMode.srcIn,
              ),
            ),
            verticalSpace(12),
            AppGradientText(
              gradient: ColorsManager.primaryGradient,
              child: Text(
                label,
                style: TextStyles.font16GradientSemiBold,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
