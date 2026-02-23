import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/features/doctor_profile/ui/widgets/doctor_profile_header.dart';
import 'package:soliel/features/doctor_profile/ui/widgets/edit_profile_form.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.solidLightBlue,
      appBar: AppBar(
        backgroundColor: ColorsManager.solidLightBlue,
        elevation: 0,
        centerTitle: true,
        title: Text('حساب الدكتور', style: TextStyles.font18BlackSemiBold),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: ColorsManager.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Doctor Profile Header (same as profile screen)
            const DoctorProfileHeader(),

            verticalSpace(24),

            // Edit Profile Form
            const EditProfileForm(),

            verticalSpace(24),
          ],
        ),
      ),
    );
  }
}
