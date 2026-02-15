import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/widgets/app_text_button.dart';
import 'package:soliel/core/widgets/solid_text_form_field.dart';

import 'package:soliel/features/auth/doctor_sign_up/ui/widgets/upload_image_container.dart';

class DoctorSignUpForm extends StatefulWidget {
  const DoctorSignUpForm({super.key});

  @override
  State<DoctorSignUpForm> createState() => _DoctorSignUpFormState();
}

class _DoctorSignUpFormState extends State<DoctorSignUpForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _secretNumberController = TextEditingController();
  final TextEditingController _confirmSecretNumberController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _clinicNumberController = TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _workingHoursController = TextEditingController();

  File? _graduationCertificate;
  File? _personalPhoto;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _secretNumberController.dispose();
    _confirmSecretNumberController.dispose();
    _phoneController.dispose();
    _clinicNumberController.dispose();
    _licenseNumberController.dispose();
    _experienceController.dispose();
    _addressController.dispose();
    _educationController.dispose();
    _workingHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // الاسم
        SolidTextFormField(
          hintText: 'الاسم',
          controller: _nameController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
        ),
        verticalSpace(16),

        // الايميل
        SolidTextFormField(
          hintText: 'الايميل',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        verticalSpace(16),

        // رقم سري
        SolidTextFormField(
          hintText: 'رقم سري',
          controller: _secretNumberController,
          isObscureText: true,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
        ),
        verticalSpace(16),

        // تأكيد الرقم السري
        SolidTextFormField(
          hintText: 'تأكيد الرقم السري',
          controller: _confirmSecretNumberController,
          isObscureText: true,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
        ),
        verticalSpace(16),

        // رقم تليفون
        SolidTextFormField(
          hintText: 'رقم تليفون',
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
        ),
        verticalSpace(16),

        // رقم العياده
        SolidTextFormField(
          hintText: 'رقم العياده',
          controller: _clinicNumberController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
        ),
        verticalSpace(16),

        // رقم البطاقه
        SolidTextFormField(
          hintText: 'رقم البطاقه',
          controller: _licenseNumberController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
        ),
        verticalSpace(16),

        // سنوات الخبره
        SolidTextFormField(
          hintText: 'سنوات الخبره',
          controller: _experienceController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
        ),
        verticalSpace(16),

        // عنوان العياده
        SolidTextFormField(
          hintText: 'عنوان العياده',
          controller: _addressController,
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.next,
        ),
        verticalSpace(16),

        // التعليم
        SolidTextFormField(
          hintText: 'التعليم',
          controller: _educationController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
        ),
        verticalSpace(16),

        // مواعيد العمل
        SolidTextFormField(
          hintText: 'مواعيد العمل',
          controller: _workingHoursController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
        ),
        verticalSpace(24),

        // ارفع صوره شهاده التخرج
        UploadImageContainer(
          title: 'ارفع صوره شهاده التخرج',
          onImageSelected: (file) {
            setState(() {
              _graduationCertificate = file;
            });
          },
        ),
        verticalSpace(16),

        UploadImageContainer(
          title: 'ارفع صوره صوره شخصيه',
          onImageSelected: (file) {
            setState(() {
              _personalPhoto = file;
            });
          },
        ),
        verticalSpace(32),

        AppTextButton(
          onPressed: () {
            // Handle sign up
          },
          textButton: 'تأكيد',
          gradient: ColorsManager.primaryGradient,
          height: 56.h,
          borderRadius: 12.r,
        ),
      ],
    );
  }
}
