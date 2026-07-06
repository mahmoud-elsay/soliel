import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/app_validation.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/widgets/app_text_button.dart';
import 'package:soliel/core/widgets/custom_snack_bar.dart';
import 'package:soliel/core/widgets/solid_text_form_field.dart';
import 'package:soliel/features/auth/doctor_sign_up/logic/doctor_sign_up_cubit/doctor_sign_up_cubit.dart';
import 'package:soliel/features/auth/doctor_sign_up/ui/widgets/upload_image_container.dart';

class DoctorSignUpForm extends StatefulWidget {
  const DoctorSignUpForm({super.key});

  @override
  State<DoctorSignUpForm> createState() => _DoctorSignUpFormState();
}

class _DoctorSignUpFormState extends State<DoctorSignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _clinicPhoneController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _workingHoursController = TextEditingController();

  File? _graduationCertificate;
  File? _profileImage;
  bool _isObscureText = true;
  bool _isConfirmObscureText = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _clinicPhoneController.dispose();
    _nationalIdController.dispose();
    _experienceController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _educationController.dispose();
    _workingHoursController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  String? _validateExperienceYears(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'سنوات الخبرة مطلوبة';
    }

    final experienceYears = int.tryParse(value.trim());
    if (experienceYears == null || experienceYears < 0) {
      return 'يرجى إدخال عدد سنوات خبرة صحيح';
    }

    return null;
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final profileImage = _profileImage;
    if (profileImage == null) {
      CustomSnackBar.show(
        context,
        message: 'الصورة الشخصية مطلوبة',
        state: SnackBarState.error,
      );
      return;
    }

    final certificateImage = _graduationCertificate;
    if (certificateImage == null) {
      CustomSnackBar.show(
        context,
        message: 'صورة شهادة التخرج مطلوبة',
        state: SnackBarState.error,
      );
      return;
    }

    context.read<DoctorSignUpCubit>().emitDoctorSignUpStates(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      clinicPhone: _clinicPhoneController.text.trim(),
      nationalId: _nationalIdController.text.trim(),
      experienceYears: int.parse(_experienceController.text.trim()),
      city: _cityController.text.trim(),
      street: _streetController.text.trim(),
      building: _buildingController.text.trim(),
      education: _educationController.text.trim(),
      workingHours: _workingHoursController.text.trim(),
      certificateImage: certificateImage,
      profileImage: profileImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SolidTextFormField(
            hintText: 'الاسم الأول',
            controller: _firstNameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: validateName,
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'اسم العائلة',
            controller: _lastNameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: validateName,
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'البريد الإلكتروني',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: validateEmail,
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'كلمة المرور',
            controller: _passwordController,
            isObscureText: _isObscureText,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            validator: validatePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _isObscureText ? Icons.visibility_off : Icons.visibility,
                color: ColorsManager.grey,
              ),
              onPressed: () {
                setState(() {
                  _isObscureText = !_isObscureText;
                });
              },
            ),
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'تأكيد كلمة المرور',
            controller: _confirmPasswordController,
            isObscureText: _isConfirmObscureText,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            validator: (value) =>
                validateConfirmPassword(value, _passwordController.text),
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmObscureText ? Icons.visibility_off : Icons.visibility,
                color: ColorsManager.grey,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmObscureText = !_isConfirmObscureText;
                });
              },
            ),
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'رقم العيادة',
            controller: _clinicPhoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: (value) => _validateRequired(value, 'رقم العيادة مطلوب'),
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'الرقم القومي',
            controller: _nationalIdController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (value) =>
                _validateRequired(value, 'الرقم القومي مطلوب'),
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'سنوات الخبرة',
            controller: _experienceController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: _validateExperienceYears,
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'المدينة',
            controller: _cityController,
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.next,
            validator: (value) => _validateRequired(value, 'المدينة مطلوبة'),
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'الشارع',
            controller: _streetController,
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.next,
            validator: (value) => _validateRequired(value, 'الشارع مطلوب'),
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'المبنى',
            controller: _buildingController,
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.next,
            validator: (value) => _validateRequired(value, 'المبنى مطلوب'),
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'التعليم',
            controller: _educationController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            validator: (value) => _validateRequired(value, 'التعليم مطلوب'),
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'مواعيد العمل',
            controller: _workingHoursController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            validator: (value) =>
                _validateRequired(value, 'مواعيد العمل مطلوبة'),
          ),
          verticalSpace(24),
          UploadImageContainer(
            title: 'ارفع صورة شخصية',
            onImageSelected: (file) {
              setState(() {
                _profileImage = file;
              });
            },
          ),
          verticalSpace(16),
          UploadImageContainer(
            title: 'ارفع صورة شهادة التخرج',
            onImageSelected: (file) {
              setState(() {
                _graduationCertificate = file;
              });
            },
          ),
          verticalSpace(32),
          AppTextButton(
            onPressed: _submit,
            textButton: 'تأكيد',
            gradient: ColorsManager.primaryGradient,
            height: 56.h,
            borderRadius: 12.r,
          ),
        ],
      ),
    );
  }
}
