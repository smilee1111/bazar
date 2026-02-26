import 'package:bazar/app/theme/colors.dart';
import 'package:flutter/material.dart';

class AppTextStyle {
  // ---------- Colors ----------
  static const Color lightTextColor = Colors.white;
  static const Color darkTextColor = AppColors.textPrimary;
  static const Color greyTextColor = AppColors.textSecondary;

  // ---------- Font Family ----------
  static const String fontFamily = "Poppins";

  // ---------- Headings ----------
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: darkTextColor,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: lightTextColor,
  );

  static const TextStyle inputBox = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: darkTextColor,
  );

  static const TextStyle minimalTexts = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: greyTextColor,
  );

  static const TextStyle bottomnav = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: lightTextColor,
  );

  static const TextStyle landingTexts = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: darkTextColor,
  );
  // ---------- Custom Color Override ----------
  static TextStyle color(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
}
