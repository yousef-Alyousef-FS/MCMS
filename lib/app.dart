import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_responsive/flutter_screen_responsive.dart'; 
import 'package:go_router/go_router.dart';
import 'package:medical_center/core/di/injection.dart' as di;
import 'package:medical_center/core/routing/app_router.dart';
import 'package:medical_center/core/theming/dark_theme.dart';
import 'package:medical_center/core/theming/light_theme.dart';
import 'package:medical_center/core/theming/theme_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GoRouter _router = AppRouter().router;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.getIt<ThemeManager>(),
      child: ResponsiveInit(
        breakpoints: const [
          Breakpoints(
            width: 600,
            deviceType: DeviceType.mobile,
            designSize: Size(375, 812), 
          ),
          Breakpoints(width: 900, deviceType: DeviceType.tabletSmall, designSize: Size(600, 960)),
          Breakpoints(width: 1200, deviceType: DeviceType.tablet, designSize: Size(834, 1194)),
          Breakpoints(
            width: double.infinity,
            deviceType: DeviceType.desktop,
            designSize: Size(1440, 1024),
            autoScale: false, 
          ),
        ],
        builder: (context, child) => BlocBuilder<ThemeManager, ThemeMode>(
          builder: (context, themeMode) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: context.locale.languageCode == 'ar' ? 'المركز الطبي' : 'Medical Center',
            routerConfig: _router,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
          ),
        ),
      ),
    );
  }
}
