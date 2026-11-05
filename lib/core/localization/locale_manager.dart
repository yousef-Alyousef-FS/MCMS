import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

abstract final class LocaleManager {
  static const supportedLocales = [Locale('en'), Locale('ar')];
  static const fallbackLocale = Locale('en');

  static Future<void> setLocale(BuildContext context, Locale locale) async {
    if (!supportedLocales.contains(locale)) {
      throw ArgumentError.value(locale, 'locale', 'Locale is not supported');
    }

    await context.setLocale(locale);
  }
}
