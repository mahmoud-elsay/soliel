import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/features/profile/ui/widgets/edit_parent_data_form.dart';
import 'package:soliel/features/profile/ui/widgets/profile_app_bar.dart';

class EditParentDataScreen extends StatelessWidget {
  const EditParentDataScreen({super.key});

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
                const ProfileAppBar(title: 'حساب ولي الامر'),
                verticalSpace(30),
                _buildAvatarSection(),
                verticalSpace(30),
                const EditParentDataForm(),
                verticalSpace(30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Stack(
      children: [
        Container(
          width: 140.r,
          height: 140.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFEBF2FA),
            image: const DecorationImage(
              image: AssetImage('assets/images/parent_profile_avatar.png'),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: Colors.white, width: 4),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: Color(0xFF1E232C),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.edit,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }
}
