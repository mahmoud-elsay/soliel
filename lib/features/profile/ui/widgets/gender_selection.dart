import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';

enum Gender { boy, girl }

class GenderSelection extends StatefulWidget {
  final Function(Gender) onGenderChanged;
  const GenderSelection({super.key, required this.onGenderChanged});

  @override
  State<GenderSelection> createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  Gender selectedGender = Gender.boy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'النوع',
          style: TextStyles.font14GreyMedium.copyWith(fontSize: 14.sp),
        ),
        verticalSpace(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildRadioButton(
              label: 'بنت',
              value: Gender.girl,
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() {
                  selectedGender = value!;
                });
                widget.onGenderChanged(selectedGender);
              },
            ),
            horizontalSpace(20),
            _buildRadioButton(
              label: 'ولد',
              value: Gender.boy,
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() {
                  selectedGender = value!;
                });
                widget.onGenderChanged(selectedGender);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioButton({
    required String label,
    required Gender value,
    required Gender groupValue,
    required ValueChanged<Gender?> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyles.font14GreyMedium.copyWith(
              color: Colors.black,
              fontSize: 14.sp,
            ),
          ),
          horizontalSpace(8),
          Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorsManager.primaryGradientStart,
                width: 2,
              ),
            ),
            child: value == groupValue
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
