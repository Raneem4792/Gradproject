import 'package:flutter/material.dart';

class PilgrimHomeScreen extends StatefulWidget {
  static const String routeName = '/pilgrim-home';

  const PilgrimHomeScreen({super.key});

  @override
  State<PilgrimHomeScreen> createState() => _PilgrimHomeScreenState();
}


class _PilgrimHomeScreenState extends State<PilgrimHomeScreen> {
  int _navIndex = 0;

  // ✅ NUSUQ Premium Palette (نفس ألوانك)
  static const Color bg = Color(0xFFF3F6F5);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color gold = Color(0xFFF0E0C0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TopCombinedBlock(
                userName: "Ahmed",
                onTapNotification: _noop,
                onTapAskAI: _noop,
              ),
              const SizedBox(height: 18),

              const _SectionHeader(
                title: "Order Now",
                onTapArrow: _noop,
              ),
              const SizedBox(height: 10),

              // ✅ بدل السحب: ثنتين جنب بعض بشكل أفخم
              Row(
                children: const [
                  Expanded(
                    child: _OrderNowCard(
                      title: "Meals",
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFEEF7F3),
                          Color(0xFFE9EFEF),
                        ],
                      ),
                      onEnter: _noop,
                      icon: Icons.restaurant_menu,
                      chipColor: mint,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _OrderNowCard(
                      title: "buffet",
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFF5EEDC),
                          Color(0xFFF1F4F4),
                        ],
                      ),
                      onEnter: _noop,
                      icon: Icons.local_dining,
                      chipColor: gold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              const _SectionHeader(
                title: "Order History",
                onTapArrow: _noop,
              ),
              const SizedBox(height: 10),

              const _OrderHistoryCard(
                title: "Grilled Shrimp with White Rice",
                metaLine: "12 Dhul Hijjah · Lunch",
                kcalLine: "450 Protein · 40g Carbs · 600 kcal",
                badgeText: "Matched based on your dietary profile",
                onTap: _noop,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }

  static void _noop() {}
}

/// =======================
/// TOP BLOCK (Header + Today’s Meals + Ask AI)
/// =======================
class _TopCombinedBlock extends StatelessWidget {
  final String userName;
  final VoidCallback onTapNotification;
  final VoidCallback onTapAskAI;

  const _TopCombinedBlock({
    required this.userName,
    required this.onTapNotification,
    required this.onTapAskAI,
  });

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
          // ✅ Header card with subtle decorative blobs
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primaryDark, primary, primaryMid],
                    ),
                  ),
                  child: Row(
                    children: [
                      // Avatar
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

                      // Greeting + name
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

                      // Notification
                      InkWell(
                        onTap: onTapNotification,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withOpacity(0.16)),
                          ),
                          child: Icon(
                            Icons.notifications_none,
                            color: Colors.white.withOpacity(0.96),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Decorative blobs (بدون محتوى جديد)
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

          // Today's meals card
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
                    Icon(Icons.access_time, size: 18, color: primary.withOpacity(0.90)),
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
                      decoration: const BoxDecoration(color: mint, shape: BoxShape.circle),
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

          // Ask AI button
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
                  colors: [
                    primaryDark,
                    primary,
                    primaryMid.withOpacity(0.95),
                  ],
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
  final VoidCallback onTapArrow;

  const _SectionHeader({required this.title, required this.onTapArrow});

  static const Color primary = Color(0xFF0D4C4A);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900),
        ),
        const Spacer(),
        InkWell(
          onTap: onTapArrow,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black.withOpacity(0.06)),
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: primary.withOpacity(0.70),
            ),
          ),
        ),
      ],
    );
  }
}

/// =======================
/// ORDER NOW CARD (Improved while keeping same content)
/// =======================
class _OrderNowCard extends StatelessWidget {
  final String title;
  final Gradient gradient;
  final VoidCallback onEnter;

  // ✅ ديكور فقط (بدون تغيير المحتوى)
  final IconData icon;
  final Color chipColor;

  const _OrderNowCard({
    required this.title,
    required this.gradient,
    required this.onEnter,
    required this.icon,
    required this.chipColor,
  });

  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryDark = Color(0xFF062C26);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
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
      child: Column(
        children: [
          // Top area (gradient) + icon chip
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(decoration: BoxDecoration(gradient: gradient)),
                  ),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.68),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.black.withOpacity(0.06)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: chipColor.withOpacity(0.95),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(icon, size: 16, color: primaryDark.withOpacity(0.88)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    bottom: 10,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13.5,
                        color: primaryDark.withOpacity(0.95),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: SizedBox(
              height: 34,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onEnter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                child: const Text(
                  "enter",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
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
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFEAF4F2),
                border: Border.all(color: primary.withOpacity(0.10)),
              ),
              child: Icon(Icons.restaurant, size: 26, color: primary.withOpacity(0.86)),
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
                    style: const TextStyle(fontWeight: FontWeight.w900),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
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

/// =======================
/// BOTTOM NAV
/// =======================
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  static const Color primary = Color(0xFF0D4C4A);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: primary,
      unselectedItemColor: Colors.black.withOpacity(0.42),
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: "Meals"),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
      ],
    );
  }
}