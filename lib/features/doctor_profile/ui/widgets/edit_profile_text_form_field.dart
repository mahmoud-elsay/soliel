import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';

class EditProfileTextField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String hintText;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? backgroundColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? autoFocus;
  final bool? enabled;
  final bool? autoCorrect;
  final bool? enableSuggestions;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final Iterable<String>? autofillHints;
  final int? maxLines;
  final int? minLines;
  final double? height;

  const EditProfileTextField({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    required this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.prefixIcon,
    this.backgroundColor,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.controller,
    this.focusNode,
    this.autoFocus,
    this.enabled,
    this.autoCorrect,
    this.enableSuggestions,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
    this.onSaved,
    this.autofillHints,
    this.maxLines,
    this.minLines,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 331.w,
      height: height ?? 56.h,
      child: TextFormField(
        cursorColor: ColorsManager.primaryGradientStart,
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        validator: validator,
        autofocus: autoFocus ?? false,
        enabled: enabled ?? true,
        obscureText: isObscureText ?? false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autocorrect: autoCorrect ?? true,
        enableSuggestions: enableSuggestions ?? true,
        initialValue: initialValue,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        onSaved: onSaved,
        maxLines: maxLines ?? 1,
        minLines: minLines ?? 1,
        style: inputTextStyle ?? TextStyles.font15MoreDarkGreyMedium,
        autofillHints: autofillHints,
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              contentPadding ??
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          enabledBorder:
              enabledBorder ??
              buildOutlineInputBorder(color: ColorsManager.greyBorderColor),
          focusedBorder:
              focusedBorder ??
              buildOutlineInputBorder(
                color: ColorsManager.primaryGradientStart,
              ),
          focusedErrorBorder: buildOutlineInputBorder(color: ColorsManager.red),
          errorBorder: buildOutlineInputBorder(color: ColorsManager.red),
          hintStyle: hintStyle ?? TextStyles.font15MoreDarkGreyMedium,
          hintText: hintText,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: prefixIcon,
                )
              : null,
          fillColor: backgroundColor ?? ColorsManager.white,
          filled: true,
        ),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder({required Color color}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1),
      borderRadius: BorderRadius.circular(8.r),
    );
  }
}
