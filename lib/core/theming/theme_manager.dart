import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../storage/shared_preferences/shared_preferences_service.dart';

class ThemeManager extends Cubit<ThemeMode> {
  ThemeManager(SharedPreferencesService sharedPreferences)
      : _sharedPreferences = sharedPreferences,
        super(
          sharedPreferences.getBool(_themeKey) ?? false
              ? ThemeMode.dark
              : ThemeMode.light,
        );

  final SharedPreferencesService _sharedPreferences;
  static const String _themeKey = 'is_dark_mode';

  Future<void> toggleTheme() async {
    final nextMode =
        state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _sharedPreferences.setBool(_themeKey, nextMode == ThemeMode.dark);
    emit(nextMode);
  }
}
