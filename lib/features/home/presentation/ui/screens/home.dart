import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medical_center/core/localization/locale_manager.dart';
import 'package:medical_center/core/theming/theme_manager.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => const _AppShell();
}

// ---------------------------------------------------------------------------
// Shell — owns navigation state only.
// ---------------------------------------------------------------------------

class _AppShell extends StatefulWidget {
  const _AppShell();

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  static const double _railBreakpoint = 720;

  static const List<_AppDestination> _destinations = [
    _AppDestination(
      labelKey: 'nav.home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    _AppDestination(
      labelKey: 'nav.appointments',
      icon: Icons.calendar_month_outlined,
      selectedIcon: Icons.calendar_month_rounded,
    ),
    _AppDestination(
      labelKey: 'nav.records',
      icon: Icons.folder_shared_outlined,
      selectedIcon: Icons.folder_shared_rounded,
    ),
    _AppDestination(
      labelKey: 'nav.profile',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
    ),
  ];

  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final useRail = MediaQuery.sizeOf(context).width >= _railBreakpoint;
    final content = _HomeContent(selectedIndex: _selectedIndex);

    if (useRail) {
      return _WideShell(
        destinations: _destinations,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        child: content,
      );
    }

    return _CompactShell(
      destinations: _destinations,
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onDestinationSelected,
      child: content,
    );
  }
}

// ---------------------------------------------------------------------------
// Layouts — presentation of navigation only.
// ---------------------------------------------------------------------------

class _CompactShell extends StatelessWidget {
  const _CompactShell({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  final List<_AppDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: [
          for (final d in destinations)
            NavigationDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selectedIcon),
              label: d.labelKey.tr(),
            ),
        ],
      ),
    );
  }
}

class _WideShell extends StatelessWidget {
  const _WideShell({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  final List<_AppDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              labelType: NavigationRailLabelType.all,
              backgroundColor: scheme.surfaceContainerLow,
              leading: const Padding(padding: EdgeInsets.only(bottom: 20), child: _RailLogo()),
              destinations: [
                for (final d in destinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.labelKey.tr()),
                  ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Content — one widget per tab. Add new tabs by adding a case here.
// ---------------------------------------------------------------------------

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    // IndexedStack preserves each tab's scroll/state when switching.
    return IndexedStack(
      index: selectedIndex,
      children: const [
        _HomeTab(),
        _PlaceholderTab(titleKey: 'nav.appointments', icon: Icons.calendar_month_rounded),
        _PlaceholderTab(titleKey: 'nav.records', icon: Icons.folder_shared_rounded),
        _PlaceholderTab(titleKey: 'nav.profile', icon: Icons.person_rounded),
      ],
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

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
                const _RailLogo(),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'app.name'.tr(),
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                _HeaderAction(
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
                  builder: (context, themeMode) => _HeaderAction(
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
                        style: Theme.of(context).textTheme.bodyLarge
                            ?.copyWith(color: scheme.onSurfaceVariant, height: 1.6),
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

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.titleKey, required this.icon});

  final String titleKey;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: scheme.primary),
            const SizedBox(height: 16),
            Text(
              titleKey.tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'common.coming_soon'.tr(),
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared small widgets.
// ---------------------------------------------------------------------------

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({required this.tooltip, required this.icon, required this.onPressed});

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }
}

class _RailLogo extends StatelessWidget {
  const _RailLogo();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(Icons.local_hospital_rounded, color: scheme.primary),
    );
  }
}

// ---------------------------------------------------------------------------
// Model.
// ---------------------------------------------------------------------------

class _AppDestination {
  const _AppDestination({required this.labelKey, required this.icon, required this.selectedIcon});

  final String labelKey;
  final IconData icon;
  final IconData selectedIcon;
}
