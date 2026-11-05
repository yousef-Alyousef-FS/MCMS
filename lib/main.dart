import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medical_center/app.dart';
import 'package:medical_center/core/di/injection.dart' as di;
import 'package:medical_center/core/localization/locale_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await di.init();
  runApp(
    EasyLocalization(
      supportedLocales: LocaleManager.supportedLocales,
      path: 'assets/i18n',
      fallbackLocale: LocaleManager.fallbackLocale,
      child: const MyApp(),
    ),
  );
}
