import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../pages/admin_dashboard_page.dart';
import '../pages/admin_manage_accounts_page.dart';
import '../pages/admin_notifications_page.dart';
import '../pages/admin_profile_page.dart';

class AdminBottomNav extends StatelessWidget {
  final int currentIndex;

  const AdminBottomNav({super.key, required this.currentIndex});

  static const Color primary = Color(0xFF0D4C4A);

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AdminDashboardPage.routeName);
        break;

      case 1:
        Navigator.pushReplacementNamed(
          context,
          AdminManageAccountsPage.routeName,
        );
        break;

      case 2:
        Navigator.pushReplacementNamed(
          context,
          AdminNotificationsPage.routeName,
        );
        break;

      case 3:
        Navigator.pushReplacementNamed(context, AdminProfilePage.routeName);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),
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
          icon: const Icon(Icons.manage_accounts_rounded),
          label: l10n.accounts,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.notifications_rounded),
          label: l10n.alerts,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: l10n.account,
        ),
      ],
    );
  }
}
