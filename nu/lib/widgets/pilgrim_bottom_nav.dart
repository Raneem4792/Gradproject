import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class PilgrimBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const PilgrimBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const Color primary = Color(0xFF0D4C4A);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: primary,
      unselectedItemColor: Colors.black54,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_filled),
          label: l10n.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.restaurant_menu),
          label: l10n.meals,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.history),
          label: l10n.history,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: l10n.account,
        ),
      ],
    );
  }
}