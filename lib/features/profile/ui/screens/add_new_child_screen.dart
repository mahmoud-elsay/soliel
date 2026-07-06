import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';
import 'package:soliel/core/widgets/app_text_button.dart';
import 'package:soliel/core/widgets/app_text_form_field.dart';
import 'package:soliel/features/profile/data/models/add_child_request.dart';
import 'package:soliel/features/profile/logic/child_cubit/child_cubit.dart';
import 'package:soliel/features/profile/logic/child_cubit/child_state.dart';
import 'package:soliel/core/helpers/shared_pref_helper.dart';
import 'package:soliel/features/profile/ui/widgets/gender_selection.dart';
import 'package:soliel/features/profile/ui/widgets/profile_app_bar.dart';
import 'package:soliel/features/profile/ui/widgets/profile_greeting_row.dart';

class AddNewChildScreen extends StatefulWidget {
  const AddNewChildScreen({super.key});

  @override
  State<AddNewChildScreen> createState() => _AddNewChildScreenState();
}

class _AddNewChildScreenState extends State<AddNewChildScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  Gender selectedGender = Gender.boy;
  String _parentName = '';

  @override
  void initState() {
    super.initState();
    StorageHelper.getUserName().then((name) {
      if (mounted && name != null) {
        setState(() => _parentName = name);
      }
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final int ageInMonths = int.tryParse(ageController.text.trim()) ?? 0;
      final DateTime birthDate = DateTime.now().subtract(
        Duration(days: ageInMonths * 30),
      );

      context.read<ChildCubit>().addChild(
            AddChildRequest(
              name: nameController.text.trim(),
              birthDate: birthDate.toIso8601String(),
              gender: selectedGender == Gender.boy ? 'boy' : 'girl',
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white,
      body: SafeArea(
        child: BlocListener<ChildCubit, ChildState>(
          listener: (context, state) {
            state.whenOrNull(
              loading: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );
              },
              success: (response) {
                Navigator.pop(context); // dismiss loading
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(response.message),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context); // go back to previous screen
              },
              error: (error) {
                Navigator.pop(context); // dismiss loading
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error.message),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            );
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    verticalSpace(20),
                    const ProfileAppBar(title: 'حساب الطفل'),
                    verticalSpace(30),
                    ProfileGreetingRow(
                      name: _parentName.isNotEmpty
                          ? 'مرحبا! $_parentName'
                          : null,
                    ),
                    verticalSpace(30),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppGradientText(
                        gradient: ColorsManager.primaryGradient,
                        child: Text(
                          'اضافه طفل جديد',
                          style: TextStyles.font18GradientMedium.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    verticalSpace(24),
                    AppTextFormField(
                      hintText: 'الاسم',
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال الاسم';
                        }
                        return null;
                      },
                    ),
                    verticalSpace(16),
                    AppTextFormField(
                      hintText: 'السن بالشهور',
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال السن';
                        }
                        return null;
                      },
                    ),
                    verticalSpace(16),
                    GenderSelection(
                      onGenderChanged: (gender) {
                        setState(() {
                          selectedGender = gender;
                        });
                      },
                    ),
                    verticalSpace(40),
                    BlocBuilder<ChildCubit, ChildState>(
                      builder: (context, state) {
                        final isLoading =
                            state is ChildLoading;
                        return AppTextButton(
                          textButton: 'حفظ البيانات',
                          onPressed: isLoading ? null : _submit,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF1E4C7B),
                              Color(0xFF031629),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: 12.r,
                        );
                      },
                    ),
                    verticalSpace(20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }
}
