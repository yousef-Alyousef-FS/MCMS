import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'home_tab.dart';
import 'placeholder_tab.dart';
import 'rail_logo.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static const double _railBreakpoint = 720;

  static const List<AppDestination> _destinations = [
    AppDestination(
      labelKey: 'nav.home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    AppDestination(
      labelKey: 'nav.appointments',
      icon: Icons.calendar_month_outlined,
      selectedIcon: Icons.calendar_month_rounded,
    ),
    AppDestination(
      labelKey: 'nav.records',
      icon: Icons.folder_shared_outlined,
      selectedIcon: Icons.folder_shared_rounded,
    ),
    AppDestination(
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
    final content = HomeContent(selectedIndex: _selectedIndex);

    if (useRail) {
      return WideShell(
        destinations: _destinations,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        child: content,
      );
    }

    return CompactShell(
      destinations: _destinations,
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onDestinationSelected,
      child: content,
    );
  }
}

class CompactShell extends StatelessWidget {
  const CompactShell({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
    super.key,
  });

  final List<AppDestination> destinations;
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
          for (final destination in destinations)
            NavigationDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: destination.labelKey.tr(),
            ),
        ],
      ),
    );
  }
}

class WideShell extends StatelessWidget {
  const WideShell({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
    super.key,
  });

  final List<AppDestination> destinations;
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
              leading: const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: RailLogo(),
              ),
              destinations: [
                for (final destination in destinations)
                  NavigationRailDestination(
                    icon: Icon(destination.icon),
                    selectedIcon: Icon(destination.selectedIcon),
                    label: Text(destination.labelKey.tr()),
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

class HomeContent extends StatelessWidget {
  const HomeContent({required this.selectedIndex, super.key});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: selectedIndex,
      children: const [
        HomeTab(),
        PlaceholderTab(
          titleKey: 'nav.appointments',
          icon: Icons.calendar_month_rounded,
        ),
        PlaceholderTab(
          titleKey: 'nav.records',
          icon: Icons.folder_shared_rounded,
        ),
        PlaceholderTab(titleKey: 'nav.profile', icon: Icons.person_rounded),
      ],
    );
  }
}

class AppDestination {
  const AppDestination({
    required this.labelKey,
    required this.icon,
    required this.selectedIcon,
  });

  final String labelKey;
  final IconData icon;
  final IconData selectedIcon;
}
