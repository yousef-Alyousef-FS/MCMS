import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/storage/shared_preferences/shared_preferences_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? _errorMessage;
  bool _navigationStarted = false;

  void _startNavigation(Duration delay) {
    if (_navigationStarted) return;
    _navigationStarted = true;
    unawaited(_openNextScreen(delay));
  }

  Future<void> _openNextScreen(Duration delay) async {
    try {
      await Future<void>.delayed(delay);
      final hasSeenOnboarding =
          getIt<SharedPreferencesService>().getBool('onboarding_completed') ??
              false;
      if (!mounted) return;
      context.go(hasSeenOnboarding ? AppRoutes.home : AppRoutes.onboarding);
    } on Exception catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/animations/logo.json',
                  width: 240,
                  height: 240,
                  fit: BoxFit.contain,
                  onLoaded: (composition) {
                    _startNavigation(composition.duration);
                  },
                  errorBuilder: (context, error, stackTrace) {
                    _startNavigation(const Duration(seconds: 3));
                    return Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.28),
                        ),
                      ),
                      child: const Icon(
                        Icons.people_alt_rounded,
                        color: Colors.white,
                        size: 48,
                      ),
                    );
                  },
                ),
                if (_errorMessage case final message?) ...[
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      setState(() => _errorMessage = null);
                      _navigationStarted = false;
                      _startNavigation(const Duration(seconds: 0));
                    },
                    child: Text(
                      'common.retry'.tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
