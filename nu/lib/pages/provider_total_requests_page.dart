import 'package:flutter/material.dart';
import '../widgets/provider_bottom_nav.dart';
import 'provider_home_screen.dart';
import 'provider_dashboard_page.dart';
import 'provider_notifications_page.dart';

class ProviderTotalRequestsPage extends StatefulWidget {
  static const String routeName = '/provider-total-requests';

  const ProviderTotalRequestsPage({super.key});

  @override
  State<ProviderTotalRequestsPage> createState() =>
      _ProviderTotalRequestsPageState();
}

class _ProviderTotalRequestsPageState extends State<ProviderTotalRequestsPage> {
  int _navIndex = 1;

  static const Color bg = Color(0xFFF1F6F4);
  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  final List<_TotalRequestItem> _items = const [
    _TotalRequestItem(mealName: "Chicken Kabsa", requests: "42 requests"),
    _TotalRequestItem(mealName: "Fish Rice Meal", requests: "31 requests"),
    _TotalRequestItem(mealName: "Cheese Omelette", requests: "18 requests"),
    _TotalRequestItem(mealName: "Shrimp Meal", requests: "27 requests"),
    _TotalRequestItem(mealName: "Vegetarian Bowl", requests: "15 requests"),
    _TotalRequestItem(mealName: "Grilled Chicken", requests: "36 requests"),
  ];

  void _openNotificationsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProviderNotificationsPage()),
    );
  }

  void _handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProviderHomeScreen()),
      );
    }
  }

  void _handleBottomNavTap(int i) {
    if (i == _navIndex) return;

    setState(() => _navIndex = i);

    if (i == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProviderHomeScreen()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: _TotalRequestsMainAppBar(
        onBack: _handleBack,
        onTapNotifications: _openNotificationsPage,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TotalRequestsHeaderCard(
                title: "Total Requests",
                badgeText: "${_items.length} meals",
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.00,
                ),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return _TotalRequestGridCard(
                    mealName: item.mealName,
                    requests: item.requests,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ProviderBottomNav(
        currentIndex: _navIndex,
        onTap: _handleBottomNavTap,
      ),
    );
  }
}

class _TotalRequestsMainAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBack;
  final VoidCallback onTapNotifications;

  const _TotalRequestsMainAppBar({
    required this.onBack,
    required this.onTapNotifications,
  });

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
      titleSpacing: 4,
      title: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
              size: 20,
            ),
          ),
          const SizedBox(width: 2),
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
        const SizedBox(width: 6),
      ],
    );
  }
}

class _TotalRequestsHeaderCard extends StatelessWidget {
  final String title;
  final String badgeText;

  const _TotalRequestsHeaderCard({
    required this.title,
    required this.badgeText,
  });

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryDark, primary, primaryMid],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            offset: const Offset(0, 14),
            color: primary.withOpacity(0.24),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.16)),
            ),
            child: const Icon(
              Icons.bar_chart_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: mint.withOpacity(0.20),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: mint.withOpacity(0.45)),
            ),
            child: Text(
              badgeText,
              style: const TextStyle(
                fontSize: 11.8,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalRequestGridCard extends StatelessWidget {
  final String mealName;
  final String requests;

  const _TotalRequestGridCard({required this.mealName, required this.requests});

  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primary.withOpacity(0.09)),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 8),
            color: primary.withOpacity(0.08),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mealName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: primary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [softMint, mint.withOpacity(0.34)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: mint.withOpacity(0.58)),
            ),
            child: Center(
              child: Icon(
                Icons.restaurant_menu_rounded,
                color: primaryMid.withOpacity(0.85),
                size: 36,
              ),
            ),
          ),
          const Spacer(),
          Text(
            requests,
            style: TextStyle(
              fontSize: 11.8,
              fontWeight: FontWeight.w800,
              color: Colors.black.withOpacity(0.62),
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalRequestItem {
  final String mealName;
  final String requests;

  const _TotalRequestItem({required this.mealName, required this.requests});
}
