import 'package:flutter/material.dart';

import '../pages/admin_dashboard_page.dart';
import '../pages/admin_manage_accounts_page.dart';
import '../pages/admin_monitor_orders_page.dart';
import '../pages/admin_notifications_page.dart';
import '../pages/admin_profile_page.dart';

class AdminBottomNav extends StatelessWidget {
  final int currentIndex;

  const AdminBottomNav({
    super.key,
    required this.currentIndex,
  });

  static const Color primary = Color(0xFF0B4A40);

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    if (index == 0) {
      Navigator.pushReplacementNamed(
        context,
        AdminDashboardPage.routeName,
      );
    } else if (index == 1) {
      Navigator.pushReplacementNamed(
        context,
        AdminManageAccountsPage.routeName,
      );
    } else if (index == 2) {
      Navigator.pushReplacementNamed(
        context,
        AdminMonitorOrdersPage.routeName,
      );
    } else if (index == 3) {
      Navigator.pushReplacementNamed(
        context,
        AdminNotificationsPage.routeName,
      );
    } else if (index == 4) {
      Navigator.pushReplacementNamed(
        context,
        AdminProfilePage.routeName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, -8),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onTap(context, index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: primary,
        unselectedItemColor: Colors.black.withOpacity(0.45),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 11.5,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts_rounded),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_rounded),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}