// lib/theme/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Brand palette
  static const Color primary = Color(0xFF6B4423); // dark chocolate brown
  static const Color secondary = Color(0xFF7D5A3F); // medium brown
  static const Color darkBrown = Color(0xFF5B3E2E); // deep brown
  static const Color accent = Color(0xFF8B6F47); // lighter brown
  static const Color lightBrown = Color(0xFFC99A6E); // tan/golden
  static const Color cream = Color(0xFFF5EFE7); // light cream
  static const Color lighterCream = Color(0xFFFAF4EC); // off-white cream
  static const Color iconAccent = Color(0xFFD4A574); // golden brown
  static const Color textDark = Color(0xFF2D2318); // very dark brown

  // Semantic aliases
  static const Color background = lighterCream;
  static const Color surface = cream;
  static const Color surfaceStrong = Color(0xFFF0E5D8);
  static const Color border = Color(0xFFE3D4C1);
  static const Color textPrimary = textDark;
  static const Color textSecondary = darkBrown;
  static const Color onPrimary = Colors.white;
  static const Color onSurface = textDark;
  static const Color accent2 = lightBrown;
 
 

  // Status Colors
  static const Color success = Color(0xFF4E7A5A);
  static const Color warning = Color(0xFFB9833B);
  static const Color error = Color(0xFFB65046);
  static const Color info = Color(0xFF6E7F9D);
}