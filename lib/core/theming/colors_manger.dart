import 'package:flutter/material.dart';

class ColorsManager {
  // Primary Colors (Gradient)
  static const Color primaryGradientStart = Color(0xFF1F4F89);
  static const Color primaryGradientEnd = Color(0xFF081423);

  // Secondary Colors
  static const Color secondaryBlue = Color(0xFFCADCF0);
  static const Color lightPurple = Color(0xFFFDF1EF);
  static const Color lightBlue = Color(0xFFE4EDF7);
  static const Color solidLightBlue = Color(0xFFF7F8F9);

  // Basic Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF27252E);
  static const Color grey = Color(0xFF6D6D6D);
  static const Color darkGrey = Color(0xFF8391A1);
  static const Color greyBorderColor = Color(0xFFE8ECF4);

  // Status Colors
  static const Color red = Color(0xFFB30303);
  static const Color green = Color(0xFF00B060);

  // Primary Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryGradientStart, primaryGradientEnd],
  );

  static const LinearGradient primaryGradientExplicit = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 1.0],
    colors: [Color(0xFF1F4F89), Color(0xFF081423)],
  );
}
