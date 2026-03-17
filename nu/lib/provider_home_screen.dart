import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'incoming_meal_requests_page.dart';
import 'provider_dashboard_page.dart';
import 'provider_history_screen.dart';
import 'provider_manage_meals_screen.dart';
import 'provider_mangae_campaign_screen.dart';
import 'provider_notifications_page.dart';
import 'provider_bottom_nav.dart';

class ProviderHomeScreen extends StatefulWidget {
  static const String routeName = '/provider-home';

  const ProviderHomeScreen({super.key});

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

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

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  int _navIndex = 0;

  static const Color bg = Color(0xFFF3F6F5);

  void _tapNav(int i) {
    if (i == _navIndex) return;

    HapticFeedback.selectionClick();
    setState(() => _navIndex = i);

    if (i == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IncomingMealRequestsPage()),
      );
    } else if (i == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProviderDashboardPage()),
      );
    } else if (i == 3) {
      Navigator.pushReplacementNamed(context, '/providerProfile');
    }
  }

  void _openNotificationsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProviderNotificationsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,

      appBar: _ProviderMainAppBar(onTapNotifications: _openNotificationsPage),

      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _ProviderTopBlock(providerName: "Provider Name"),
              SizedBox(height: 14),

              _RequestsCard(
                newRequestsCount: 3,
                orderText: "Order #xxxx",
                onTapViewAll: _noop,
                onTapCard: _noop,
              ),
              SizedBox(height: 18),

              _SectionLabel(title: "Services"),
              SizedBox(height: 12),

              ProviderServicesList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ProviderBottomNav(
        currentIndex: _navIndex,
        onTap: _tapNav,
      ),
    );
  }

  static void _noop() {}
}

/// =======================
/// APP BAR
/// =======================
class _ProviderMainAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onTapNotifications;

  const _ProviderMainAppBar({required this.onTapNotifications});

  static const Color primary = Color(0xFF0D4C4A);

  @override
  Size get preferredSize => const Size.fromHeight(58);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.6,
      shadowColor: Colors.black.withOpacity(0.08),
      surfaceTintColor: Colors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 8,
      title: Row(
        children: [
          IconButton(
            onPressed: () {
              // TODO: open drawer / menu
            },
            icon: const Icon(Icons.menu_rounded, color: Colors.black87),
          ),
          const SizedBox(width: 4),
          const Text(
            "NUSUQ",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
        ],
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
    );
  }
}

/// =======================
/// HEADER CARD
/// =======================
class _ProviderTopBlock extends StatelessWidget {
  final String providerName;

  const _ProviderTopBlock({required this.providerName});

  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color gold = Color(0xFFF0E0C0);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              offset: const Offset(0, 14),
              color: Colors.black.withOpacity(0.07),
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryDark, primary, primaryMid],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.12),
                      border: Border.all(color: Colors.white.withOpacity(0.26)),
                    ),
                    child: const Icon(Icons.storefront, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          providerName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Welcome back",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.86),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: -30,
              top: -40,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: mint.withOpacity(0.12),
                ),
              ),
            ),
            Positioned(
              left: -40,
              bottom: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: gold.withOpacity(0.10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =======================
/// REQUESTS CARD
/// =======================
class _RequestsCard extends StatelessWidget {
  final int newRequestsCount;
  final String orderText;
  final VoidCallback onTapViewAll;
  final VoidCallback onTapCard;

  const _RequestsCard({
    required this.newRequestsCount,
    required this.orderText,
    required this.onTapViewAll,
    required this.onTapCard,
  });

  static const Color primary = Color(0xFF0D4C4A);
  static const Color mint = Color(0xFF9FE5C9);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapCard,
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
            Icon(Icons.inbox_rounded, color: primary, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Requests list",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: mint.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          "$newRequestsCount new",
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                            color: primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$newRequestsCount new requests",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    orderText,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.55),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: primary,
                textStyle: const TextStyle(fontWeight: FontWeight.w900),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const IncomingMealRequestsPage(),
                  ),
                );
              },
              child: const Text("View All"),
            ),
          ],
        ),
      ),
    );
  }
}

/// =======================
/// SERVICES LIST
/// =======================
class ProviderServicesList extends StatelessWidget {
  const ProviderServicesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ServiceListCard(
          title: "Order History",
          subtitle: "Review previous orders",
          icon: Icons.history,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProviderHistoryScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _ServiceListCard(
          title: "Performance & Reports",
          subtitle: "Track stats and insights",
          icon: Icons.bar_chart_rounded,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProviderDashboardPage()),
            );
          },
        ),
        const SizedBox(height: 12),
        _ServiceListCard(
          title: "Manage Meal",
          subtitle: "Add / edit your meals",
          icon: Icons.restaurant_menu,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProviderMealManagementScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _ServiceListCard(
          title: "Manage Campaign",
          subtitle: "Update campaign settings",
          icon: Icons.campaign,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProviderCampaignManagementScreen(),
              ),
            );
          },
        ),
      ],
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

  static const Color primary = Color(0xFF0D4C4A);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: primary, size: 26),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
