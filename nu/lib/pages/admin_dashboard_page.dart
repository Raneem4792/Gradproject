import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../session/user_session.dart';
import '../widgets/admin_bottom_nav.dart';
import 'admin_manage_accounts_page.dart';
import 'admin_monitor_orders_page.dart';
import 'admin_notifications_page.dart';

class AdminDashboardPage extends StatefulWidget {
  static const String routeName = '/admin-dashboard';

  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  static const Color bg = Color(0xFFF1F7F4);

  void _openManageAccounts() {
    Navigator.pushNamed(context, AdminManageAccountsPage.routeName);
  }

  void _openMonitorOrders() {
    Navigator.pushNamed(context, AdminMonitorOrdersPage.routeName);
  }

  void _openNotifications() {
    Navigator.pushNamed(context, AdminNotificationsPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final adminName = UserSession.fullName ?? 'Admin';

    return Scaffold(
      backgroundColor: bg,
      appBar: _AdminMainAppBar(
        onTapNotifications: _openNotifications,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DashboardPageHeader(adminName: adminName),
              const SizedBox(height: 14),
              _AdminHeroCard(adminName: adminName),
              const SizedBox(height: 18),
              const _SectionLabel(title: 'Admin Services'),
              const SizedBox(height: 12),
              _ServiceListCard(
                title: 'Manage Accounts',
                subtitle: 'View and manage providers, pilgrims, and campaigns.',
                icon: Icons.manage_accounts_rounded,
                onTap: _openManageAccounts,
              ),
              const SizedBox(height: 12),
              _ServiceListCard(
                title: 'Monitor Orders',
                subtitle: 'Track all meal orders and review their current status.',
                icon: Icons.receipt_long_rounded,
                onTap: _openMonitorOrders,
              ),
              const SizedBox(height: 12),
              _ServiceListCard(
                title: 'Notifications',
                subtitle: 'Create and manage system notifications for users.',
                icon: Icons.notifications_active_rounded,
                onTap: _openNotifications,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
    );
  }
}

class _AdminMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTapNotifications;

  const _AdminMainAppBar({
    required this.onTapNotifications,
  });

  @override
  Size get preferredSize => const Size.fromHeight(58);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.6,
        shadowColor: Colors.black.withOpacity(0.08),
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: const Text(
          'NUSUQ',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.4,
          ),
        ),
        actions: [
          IconButton(
            onPressed: onTapNotifications,
            icon: const Icon(
              Icons.notifications,
              color: Colors.black87,
              size: 20,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}

class _DashboardPageHeader extends StatelessWidget {
  final String adminName;

  const _DashboardPageHeader({
    required this.adminName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Admin Dashboard',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                blurRadius: 16,
                offset: const Offset(0, 8),
                color: Colors.black.withOpacity(0.04),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.verified_user_rounded,
                size: 15,
                color: Colors.black.withOpacity(0.55),
              ),
              const SizedBox(width: 5),
              Text(
                'Admin',
                style: TextStyle(
                  fontSize: 11.8,
                  fontWeight: FontWeight.w800,
                  color: Colors.black.withOpacity(0.58),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AdminHeroCard extends StatelessWidget {
  final String adminName;

  const _AdminHeroCard({
    required this.adminName,
  });

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryDark, primary, primaryMid],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 12),
            color: primary.withOpacity(0.20),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.13),
              border: Border.all(
                color: Colors.white.withOpacity(0.22),
              ),
            ),
            child: const Icon(
              Icons.admin_panel_settings_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.82),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  adminName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class _SectionLabel extends StatelessWidget {
  final String title;

  const _SectionLabel({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w900,
        color: Colors.black.withOpacity(0.78),
      ),
    );
  }
}

class _ServiceListCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ServiceListCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              offset: const Offset(0, 12),
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: mint.withOpacity(0.45),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: primary,
                size: 25,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.35,
                      color: Colors.black.withOpacity(0.58),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: primary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}