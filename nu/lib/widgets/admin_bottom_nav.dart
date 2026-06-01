import 'package:flutter/material.dart';

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
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: primary,
      unselectedItemColor: Colors.black54,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.manage_accounts_rounded),
          label: 'Accounts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_rounded),
          label: 'Alerts',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
      ],
    );
  }
}
