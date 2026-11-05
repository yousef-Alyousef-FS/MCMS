// core/theming/dark.dart
import 'package:flutter/material.dart';
import 'package:medical_center/core/theming/styles.dart';

ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
    surface: AppColors.surfaceDark,
  ),
  scaffoldBackgroundColor: AppColors.backgroundDark,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.backgroundDark,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    color: AppColors.surfaceDark,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: const BorderSide(color: Color(0xFF334649)),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size(0, 54),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
);
