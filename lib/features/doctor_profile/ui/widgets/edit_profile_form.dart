import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/widgets/app_text_button.dart';
import 'package:soliel/features/doctor_profile/ui/widgets/edit_profile_text_form_field.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _hospitalController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EditProfileTextField(
          hintText: 'الاسم',
          controller: _nameController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
        ),

        verticalSpace(16),

        EditProfileTextField(
          hintText: 'المستشفى',
          controller: _hospitalController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
        ),

        verticalSpace(16),

        EditProfileTextField(
          hintText: 'نبذه معينه',
          controller: _bioController,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: 5,
          minLines: 5,
          height: 117.h,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),

        verticalSpace(32),

        AppTextButton(
          onPressed: () {
            // Handle save profile
          },
          textButton: 'حفظ البيانات',
          gradient: ColorsManager.primaryGradient,
          height: 56.h,
          borderRadius: 12.r,
          margin: EdgeInsets.zero,
        ),

        verticalSpace(16),

        // الغاء التعديلات Button
        AppTextButton(
          onPressed: () {
            // Handle cancel
            Navigator.pop(context);
          },
          textButton: 'الغاء التعديلات',
          backgroundColor: ColorsManager.lightBlue,
          textColor: ColorsManager.black,
          height: 56.h,
          borderRadius: 12.r,
          margin: EdgeInsets.zero,
        ),
      ],
    );
  }
}
