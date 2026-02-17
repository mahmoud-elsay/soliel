import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/font_weight_helper.dart';

class TextStyles {
  // Gradient Text Styles (use with AppGradientText widget)
  static TextStyle font30GradientBold = GoogleFonts.poppins(
    fontSize: 30.sp,
    fontWeight: FontWeightHelper.bold,
    color: Colors.white, // Color will be replaced by gradient
  );

  static TextStyle font24GradientExtraBold = GoogleFonts.poppins(
    fontSize: 24.sp,
    fontWeight: FontWeightHelper.extraBold,
    color: Colors.white, // Color will be replaced by gradient
  );

  static TextStyle font24GradientSemiBold = GoogleFonts.poppins(
    fontSize: 24.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: Colors.white, // Color will be replaced by gradient
  );

  static TextStyle font20GradientSemiBold = GoogleFonts.poppins(
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: Colors.white, // Color will be replaced by gradient
  );

  static TextStyle font18GradientMedium = GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white, // Color will be replaced by gradient
  );

  static TextStyle font16GradientMedium = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white, // Color will be replaced by gradient
  );

  static TextStyle font15GradientBold = GoogleFonts.poppins(
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.bold,
    color: Colors.white, // Color will be replaced by gradient
  );

  static TextStyle font14GradientMedium = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white, // Color will be replaced by gradient
  );

  static TextStyle font14GradientRegular = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    color: Colors.white, // Color will be replaced by gradient
  );

  static TextStyle font12GradientSemiBold = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: Colors.white, // Color will be replaced by gradient
  );

  // Primary Gradient Start Color Text Styles (solid color)
  static TextStyle font24PrimaryGradientStartSemiExtraBold =
      GoogleFonts.poppins(
        fontSize: 24.sp,
        fontWeight: FontWeightHelper.extraBold,
        color: ColorsManager.primaryGradientStart,
      );

  static TextStyle font24PrimaryGradientStartSemiBold = GoogleFonts.poppins(
    fontSize: 24.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.primaryGradientStart,
  );

  static TextStyle font20PrimaryGradientStartSemiBold = GoogleFonts.poppins(
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.primaryGradientStart,
  );

  static TextStyle font18PrimaryGradientStartMedium = GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.primaryGradientStart,
  );

  static TextStyle font16PrimaryGradientStartMedium = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.primaryGradientStart,
  );

  static TextStyle font14PrimaryGradientStartMedium = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.primaryGradientStart,
  );

  static TextStyle font14PrimaryGradientStartRegular = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.primaryGradientStart,
  );

  static TextStyle font12PrimaryGradientStartSemiBold = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.primaryGradientStart,
  );

  static TextStyle font12SkyBlueStartSemiBold = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.skyBlue,
  );

  // Black Text Styles
  static TextStyle font20BlackSemiBold = GoogleFonts.poppins(
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.black,
  );

  static TextStyle font18BlackMedium = GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.black,
  );

  static TextStyle font16BlackRegular = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.black,
  );

  static TextStyle font16BlackMedium = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.black,
  );

  static TextStyle font14BlackMedium = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.black,
  );

  static TextStyle font14BlackRegular = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.black,
  );

  static TextStyle font14BlackSemiBold = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.black,
  );

  static TextStyle font14BlackLight = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.light,
    color: ColorsManager.black,
  );

  static TextStyle font15DarkBlueBold = GoogleFonts.poppins(
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.darkBlue,
  );

  static TextStyle font12BlackMedium = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.black,
  );

  static TextStyle font12BlackRegular = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.black,
  );

  // Grey Text Styles
  static TextStyle font14GreyRegular = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.grey,
  );

  static TextStyle font12GreyMedium = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.grey,
  );

  static TextStyle font14GreyMedium = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.grey,
  );

  static TextStyle font12GreyLight = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.light,
    color: ColorsManager.grey,
  );

  static TextStyle font12LightGreyRegular = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.lightGrey,
  );
  static TextStyle font15DarkGreyMedium = GoogleFonts.poppins(
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.darkGrey,
  );

  static TextStyle font14MoreDarkGreySemiBold = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.moreDarkGrey,
  );

  static TextStyle font14MoreDarkGreyMedium = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.moreDarkGrey,
  );

  // White Text Styles
  static TextStyle font16WhiteSemiBold = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.white,
  );

  // Status Colors Text Styles
  static TextStyle font12GreenRegular = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.green,
  );

  static TextStyle font12RedRegular = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.red,
  );

  // Secondary Blue Text Styles
  static TextStyle font14SecondaryBlueRegular = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.secondaryBlue,
  );
}
