import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/app_validation.dart';
import 'package:soliel/core/helpers/shared_pref_helper.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_text_button.dart';
import 'package:soliel/core/widgets/solid_text_form_field.dart';

class EditParentDataForm extends StatefulWidget {
  const EditParentDataForm({super.key});

  @override
  State<EditParentDataForm> createState() => _EditParentDataFormState();
}

class _EditParentDataFormState extends State<EditParentDataForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isObscureText = true;
  bool _isConfirmObscureText = true;
  String _selectedRole = 'اب'; // Default to Father

  @override
  void initState() {
    super.initState();
    _loadParentData();
  }

  Future<void> _loadParentData() async {
    final name = await StorageHelper.getUserName() ?? '';
    final email = await StorageHelper.getEmail() ?? '';
    final phone = await StorageHelper.getString('parent_phone') ?? '';
    final relation = await StorageHelper.getString('parent_relation') ?? '';
    final role = await StorageHelper.getString('parent_role') ?? 'اب';
    final password = await StorageHelper.getSecureString('parent_password') ?? '';

    if (mounted) {
      setState(() {
        _nameController.text = name;
        _emailController.text = email;
        _phoneController.text = phone;
        _relationController.text = relation;
        _selectedRole = role;
        _passwordController.text = password;
        _confirmPasswordController.text = password;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _relationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SolidTextFormField(
            hintText: 'الاسم',
            controller: _nameController,
            keyboardType: TextInputType.name,
            validator: validateName,
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'الايميل',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: validateEmail,
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'كلمه المرور',
            controller: _passwordController,
            isObscureText: _isObscureText,
            suffixIcon: IconButton(
              icon: Icon(
                _isObscureText ? Icons.visibility_off : Icons.visibility,
                color: ColorsManager.grey,
              ),
              onPressed: () => setState(() => _isObscureText = !_isObscureText),
            ),
            validator: validatePassword,
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'تأكيد كلمه المرور',
            controller: _confirmPasswordController,
            isObscureText: _isConfirmObscureText,
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmObscureText ? Icons.visibility_off : Icons.visibility,
                color: ColorsManager.grey,
              ),
              onPressed: () =>
                  setState(() => _isConfirmObscureText = !_isConfirmObscureText),
            ),
            validator: (value) =>
                validateConfirmPassword(value, _passwordController.text),
          ),
          verticalSpace(16),
          SolidTextFormField(
            hintText: 'صله القرابه',
            controller: _relationController,
            validator: (value) =>
                value!.isEmpty ? 'يرجى إدخال صلة القرابة' : null,
          ),
          verticalSpace(20),
          _buildRoleSelection(),
          verticalSpace(20),
          SolidTextFormField(
            hintText: 'رقم التليفون',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) =>
                value!.isEmpty ? 'يرجى إدخال رقم التليفون' : null,
          ),
          verticalSpace(32),
          AppTextButton(
            textButton: 'تأكيد',
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await StorageHelper.saveUserName(_nameController.text);
                await StorageHelper.saveEmail(_emailController.text);
                await StorageHelper.setValue('parent_phone', _phoneController.text);
                await StorageHelper.setValue('parent_relation', _relationController.text);
                await StorageHelper.setValue('parent_role', _selectedRole);
                if (_passwordController.text.isNotEmpty) {
                  await StorageHelper.setSecureString('parent_password', _passwordController.text);
                }
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم حفظ تعديلات ولي الأمر بنجاح')),
                  );
                  Navigator.pop(context);
                }
              }
            },
            gradient: ColorsManager.primaryGradient,
            height: 56.h,
            borderRadius: 15.r,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildRoleRadioButton('ام'),
        horizontalSpace(20),
        _buildRoleRadioButton('اب'),
      ],
    );
  }

  Widget _buildRoleRadioButton(String role) {
    bool isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            role,
            style: TextStyles.font14GreyMedium.copyWith(
              color: Colors.black,
              fontSize: 16.sp,
            ),
          ),
          horizontalSpace(8),
          Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF1E4F89),
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 14.w,
                      height: 14.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF03314B),
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
