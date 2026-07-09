import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/shared_pref_helper.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';
import 'package:soliel/core/widgets/app_text_button.dart';
import 'package:soliel/core/widgets/app_text_form_field.dart';
import 'package:soliel/features/profile/ui/widgets/gender_selection.dart';
import 'package:soliel/features/profile/ui/widgets/profile_app_bar.dart';
import 'package:soliel/features/profile/ui/widgets/profile_greeting_row.dart';

class EditChildProfileScreen extends StatefulWidget {
  const EditChildProfileScreen({super.key});

  @override
  State<EditChildProfileScreen> createState() => _EditChildProfileScreenState();
}

class _EditChildProfileScreenState extends State<EditChildProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  Gender selectedGender = Gender.boy;

  @override
  void initState() {
    super.initState();
    _loadChildData();
  }

  Future<void> _loadChildData() async {
    final name = await StorageHelper.getString('child_name') ?? '';
    final age = await StorageHelper.getString('child_age') ?? '';
    final genderStr = await StorageHelper.getString('child_gender') ?? 'boy';
    if (mounted) {
      setState(() {
        nameController.text = name;
        ageController.text = age;
        selectedGender = genderStr == 'girl' ? Gender.girl : Gender.boy;
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  verticalSpace(20),

                  const ProfileAppBar(title: 'حساب الطفل'),

                  verticalSpace(30),

                  const ProfileGreetingRow(),

                  verticalSpace(30),

                  Align(
                    alignment: Alignment.centerRight,
                    child: AppGradientText(
                      gradient: ColorsManager.primaryGradient,
                      child: Text(
                        'تعديل بيانات الطفل',
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
                    initialGender: selectedGender,
                    onGenderChanged: (gender) {
                      setState(() {
                        selectedGender = gender;
                      });
                    },
                  ),

                  verticalSpace(40),

                  AppTextButton(
                    textButton: 'حفظ التعديلات',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await StorageHelper.setValue('child_name', nameController.text);
                        await StorageHelper.setValue('child_age', ageController.text);
                        await StorageHelper.setValue('child_gender', selectedGender == Gender.girl ? 'girl' : 'boy');
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم حفظ تعديلات الطفل بنجاح')),
                          );
                          Navigator.pop(context);
                        }
                      }
                    },
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E4C7B), Color(0xFF031629)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: 12.r,
                  ),

                  verticalSpace(20),
                ],
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
