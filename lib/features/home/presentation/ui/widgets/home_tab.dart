import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medical_center/core/localization/locale_manager.dart';
import 'package:medical_center/core/theming/theme_manager.dart';

import 'header_action.dart';
import 'rail_logo.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
            child: Row(
              children: [
                const RailLogo(),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'app.name'.tr(),
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                HeaderAction(
                  tooltip: 'home.toggle_language'.tr(),
                  icon: Icons.language_rounded,
                  onPressed: () async {
                    final next = context.locale.languageCode == 'ar'
                        ? const Locale('en')
                        : const Locale('ar');
                    await LocaleManager.setLocale(context, next);
                  },
                ),
                const SizedBox(width: 4),
                BlocBuilder<ThemeManager, ThemeMode>(
                  builder: (context, themeMode) => HeaderAction(
                    tooltip: 'home.toggle_theme'.tr(),
                    icon: themeMode == ThemeMode.dark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    onPressed: () async {
                      await context.read<ThemeManager>().toggleTheme();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Icon(
                        Icons.volunteer_activism_rounded,
                        size: 44,
                        color: scheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'home.greeting'.tr(),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 340),
                      child: Text(
                        'home.empty_state'.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
