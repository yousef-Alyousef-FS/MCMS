import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_center/core/storage/shared_preferences/shared_preferences_service.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/routing/routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  bool _isSaving = false;

  static const _pages = [
    _OnboardingPageData(
      icon: Icons.calendar_month_rounded,
      titleKey: 'onboarding.page_one_title',
      bodyKey: 'onboarding.page_one_body',
    ),
    _OnboardingPageData(
      icon: Icons.medical_information_rounded,
      titleKey: 'onboarding.page_two_title',
      bodyKey: 'onboarding.page_two_body',
    ),
    _OnboardingPageData(
      icon: Icons.science_rounded,
      titleKey: 'onboarding.page_three_title',
      bodyKey: 'onboarding.page_three_body',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      await getIt<SharedPreferencesService>().setBool('onboarding_completed', true);
      if (mounted) context.go(AppRoutes.home);
    } on Exception catch (error) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  void _next() {
    if (_currentPage == _pages.length - 1) {
      unawaited(_finish());
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.local_hospital_rounded, color: colorScheme.primary),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _isSaving ? null : _finish,
                    child: Text('onboarding.skip'.tr()),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) =>
                      _OnboardingPage(page: _pages[index], pageNumber: index + 1),
                ),
              ),
              Row(
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsetsDirectional.only(end: 7),
                    width: index == _currentPage ? 26 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == _currentPage
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving ? null : _next,
                  child: _isSaving
                      ? const SizedBox.square(
                          dimension: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          (_currentPage == _pages.length - 1
                                  ? 'onboarding.start'
                                  : 'onboarding.next')
                              .tr(),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.page, required this.pageNumber});

  final _OnboardingPageData page;
  final int pageNumber;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              SizedBox(
                height: constraints.maxHeight * 0.43,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 230,
                        height: 230,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(alpha: 0.55),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 166,
                        height: 166,
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(44),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 32,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Icon(page.icon, size: 76, color: colorScheme.primary),
                      ),
                      Positioned(
                        top: 16,
                        right: 22,
                        child: _DecorativeDot(color: colorScheme.tertiary),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 30,
                        child: _DecorativeDot(color: colorScheme.secondary),
                      ),
                      Positioned(
                        bottom: 18,
                        right: 38,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.07),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Text(
                            '0$pageNumber',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                page.titleKey.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800, height: 1.3),
              ),
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 340),
                child: Text(
                  page.bodyKey.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.7),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _DecorativeDot extends StatelessWidget {
  const _DecorativeDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({required this.icon, required this.titleKey, required this.bodyKey});

  final IconData icon;
  final String titleKey;
  final String bodyKey;
}
