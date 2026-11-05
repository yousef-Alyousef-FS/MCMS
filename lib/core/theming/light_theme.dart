// core/theming/light.dart
import 'package:flutter/material.dart';
import 'package:medical_center/core/theming/styles.dart';

ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    surface: AppColors.surfaceLight,
  ),
  scaffoldBackgroundColor: AppColors.backgroundLight,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.backgroundLight,
    foregroundColor: AppColors.ink,
    elevation: 0,
    centerTitle: false,
  ),
  cardTheme: CardThemeData(
    color: AppColors.surfaceLight,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: const BorderSide(color: Color(0xFFE3E3EF)),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size(0, 54),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: AppColors.ink,
    displayColor: AppColors.ink,
  ),
);
