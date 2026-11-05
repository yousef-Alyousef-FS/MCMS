// core/theming/styles.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color.fromARGB(255, 50, 232, 135);
  static const Color primaryDark = Color.fromARGB(255, 16, 138, 30);
  static const Color backgroundLight = Color(0xFFFAF8F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF141517);
  static const Color surfaceDark = Color(0xFF1F2124);
  static const Color ink = Color(0xFF1F2029);
  static const Color muted = Color(0xFF6E7281);
}

class AppTextStyles {
  static const TextStyle font24Bold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headline = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
}
