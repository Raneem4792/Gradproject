import 'package:flutter/material.dart';
import 'pilgrim_meals_page.dart';
import 'pilgrim_order_history_page.dart';
import 'pilgrim_profile_page.dart';
import 'pilgrim_ai_chat_page.dart';
import 'pilgrim_bottom_nav.dart';
import 'pilgrim_notifications_page.dart';

class PilgrimHomeScreen extends StatefulWidget {
  static const String routeName = '/pilgrim-home';

  const PilgrimHomeScreen({super.key});

  @override
  State<PilgrimHomeScreen> createState() => _PilgrimHomeScreenState();
}

class _PilgrimHomeScreenState extends State<PilgrimHomeScreen> {
  int _navIndex = 0;

  static const Color bg = Color(0xFFF3F6F5);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color gold = Color(0xFFF0E0C0);

  void _openMealsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PilgrimMealsPage()),
    );
  }

  void _openOrderHistoryPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PilgrimOrderHistoryPage()),
    );
  }

  void _handleBottomNavTap(int i) {
    if (i == _navIndex) return;

    setState(() => _navIndex = i);

    if (i == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PilgrimMealsPage()),
      );
    } else if (i == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PilgrimOrderHistoryPage()),
      );
    } else if (i == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PilgrimProfilePage()),
      );
    }
  }

  void _openAIChatPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PilgrimAIChatPage()),
    );
  }

  void _openNotificationsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PilgrimNotificationsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: _PilgrimMainAppBar(onTapNotifications: _openNotificationsPage),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopCombinedBlock(userName: "Ahmed", onTapAskAI: _openAIChatPage),
              const SizedBox(height: 18),

              const _SectionHeader(title: "Order Now"),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _OrderNowCard(
                      title: "Meals",
                      subtitle: "Browse daily meals",
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFEAF7F2), Color(0xFFDCEFE8)],
                      ),
                      onEnter: _openMealsPage,
                      icon: Icons.restaurant_menu_rounded,
                      chipColor: mint,
                      buttonText: "Start Order",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _OrderNowCard(
                      title: "Buffet",
                      subtitle: "Explore buffet options",
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFAF1DF), Color(0xFFF3ECE2)],
                      ),
                      onEnter: _noop,
                      icon: Icons.local_dining_rounded,
                      chipColor: gold,
                      buttonText: "View Options",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              const _SectionHeader(title: "Order History"),
              const SizedBox(height: 10),

              _OrderHistoryCard(
                title: "Grilled Shrimp with White Rice",
                metaLine: "12 Dhul Hijjah · Lunch",
                kcalLine: "450 Protein · 40g Carbs · 600 kcal",
                badgeText: "Tap to view previous orders",
                onTap: _openOrderHistoryPage,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PilgrimBottomNav(
        currentIndex: _navIndex,
        onTap: _handleBottomNavTap,
      ),
    );
  }

  static void _noop() {}
}

class _PilgrimMainAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onTapNotifications;

  const _PilgrimMainAppBar({required this.onTapNotifications});

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
              // TODO: open menu / drawer
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
/// TOP BLOCK
/// =======================
class _TopCombinedBlock extends StatelessWidget {
  final String userName;
  final VoidCallback onTapAskAI;

  const _TopCombinedBlock({required this.userName, required this.onTapAskAI});

  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color gold = Color(0xFFF0E0C0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 12),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
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
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.26),
                          ),
                        ),
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Assalamu Alaikum ,",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.86),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: -28,
                  top: -30,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: mint.withOpacity(0.12),
                    ),
                  ),
                ),
                Positioned(
                  left: -26,
                  bottom: -34,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: gold.withOpacity(0.10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withOpacity(0.06)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 18,
                      color: primary.withOpacity(0.90),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Today’s Meals",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: mint,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _mealLine("Breakfast", "7:30 AM"),
                const SizedBox(height: 8),
                _mealLine("Lunch", "1:00 PM"),
                const SizedBox(height: 8),
                _mealLine("Dinner", "8:00 PM"),
                const SizedBox(height: 10),
                Text(
                  "*Meal times are scheduled by your campaign*",
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.black.withOpacity(0.45),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: onTapAskAI,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryDark, primary, primaryMid.withOpacity(0.95)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    offset: const Offset(0, 12),
                    color: primary.withOpacity(0.18),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.14)),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Ask Your AI Assistance",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: gold.withOpacity(0.95)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _mealLine(String title, String time) {
    return Text(
      "– $title – $time",
      style: TextStyle(
        color: Colors.black.withOpacity(0.74),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

/// =======================
/// SECTION HEADER
/// =======================
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900),
    );
  }
}

/// =======================
/// ORDER NOW CARD
/// =======================
class _OrderNowCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onEnter;
  final IconData icon;
  final Color chipColor;
  final String buttonText;

  const _OrderNowCard({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onEnter,
    required this.icon,
    required this.chipColor,
    required this.buttonText,
  });

  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryDark = Color(0xFF062C26);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 12),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(decoration: BoxDecoration(gradient: gradient)),
                  Positioned(
                    right: -22,
                    top: -18,
                    child: Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    top: 14,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.72),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: 23,
                        color: primaryDark.withOpacity(0.92),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    top: 74,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: chipColor.withOpacity(0.28),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        title == "Meals" ? "Recommended" : "Group Service",
                        style: TextStyle(
                          fontSize: 11.2,
                          fontWeight: FontWeight.w800,
                          color: primaryDark.withOpacity(0.85),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: primaryDark.withOpacity(0.96),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            height: 1.3,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: primaryDark.withOpacity(0.67),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: SizedBox(
              height: 42,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onEnter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// =======================
/// ORDER HISTORY CARD
/// =======================
class _OrderHistoryCard extends StatelessWidget {
  final String title;
  final String metaLine;
  final String kcalLine;
  final String badgeText;
  final VoidCallback onTap;

  const _OrderHistoryCard({
    required this.title,
    required this.metaLine,
    required this.kcalLine,
    required this.badgeText,
    required this.onTap,
  });

  static const Color primary = Color(0xFF0D4C4A);
  static const Color mint = Color(0xFF9FE5C9);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              blurRadius: 22,
              offset: const Offset(0, 12),
              color: Colors.black.withOpacity(0.06),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFEAF4F2),
                border: Border.all(color: primary.withOpacity(0.10)),
              ),
              child: Icon(
                Icons.restaurant,
                size: 26,
                color: primary.withOpacity(0.86),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    metaLine,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.60),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kcalLine,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.55),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9F7F2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: mint.withOpacity(0.55)),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: primary.withOpacity(0.95),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
