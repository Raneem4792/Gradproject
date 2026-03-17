import 'package:flutter/material.dart';

class PilgrimNotificationsPage extends StatefulWidget {
  static const String routeName = '/pilgrim-notifications';

  const PilgrimNotificationsPage({super.key});

  @override
  State<PilgrimNotificationsPage> createState() =>
      _PilgrimNotificationsPageState();
}

class _PilgrimNotificationsPageState extends State<PilgrimNotificationsPage> {
  static const Color bg = Color(0xFFF3F6F5);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color gold = Color(0xFFF0E0C0);

  final List<Map<String, dynamic>> notifications = [
    {
      "title": "Your meal request has been approved",
      "message":
          "Grilled Chicken Salad is confirmed and will be prepared by your provider.",
      "time": "Today · 9:40 AM",
      "icon": Icons.check_circle_rounded,
      "isUnread": true,
      "tone": "success",
    },
    {
      "title": "Meal schedule reminder",
      "message":
          "Lunch starts at 1:00 PM today. Please submit your request before the deadline.",
      "time": "Yesterday · 6:30 PM",
      "icon": Icons.access_time_filled_rounded,
      "isUnread": false,
      "tone": "info",
    },
    {
      "title": "Your previous order was rated",
      "message":
          "Thank you for reviewing Baked Fish with Rice. Your feedback helps improve service quality.",
      "time": "Yesterday · 11:20 AM",
      "icon": Icons.star_rounded,
      "isUnread": false,
      "tone": "gold",
    },
  ];

  void _markAllAsRead() {
    setState(() {
      for (final item in notifications) {
        item["isUnread"] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications
        .where((item) => item["isUnread"] == true)
        .length;

    return Scaffold(
      backgroundColor: bg,
      appBar: const _PilgrimNotificationsAppBar(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NotificationsHeroCard(
                unreadCount: unreadCount,
                onMarkAllRead: _markAllAsRead,
              ),
              const SizedBox(height: 18),

              const _NotificationsSectionHeader(title: "Recent Notifications"),
              const SizedBox(height: 10),

              if (notifications.isEmpty)
                const _EmptyNotificationsState()
              else
                ...notifications.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _NotificationCard(
                      title: item["title"],
                      message: item["message"],
                      time: item["time"],
                      icon: item["icon"],
                      isUnread: item["isUnread"],
                      tone: item["tone"],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PilgrimNotificationsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _PilgrimNotificationsAppBar();

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
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
              size: 20,
            ),
          ),
          const SizedBox(width: 2),
          const Text(
            "Notifications",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
      actions: const [SizedBox(width: 6)],
    );
  }
}

class _NotificationsHeroCard extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onMarkAllRead;

  const _NotificationsHeroCard({
    required this.unreadCount,
    required this.onMarkAllRead,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
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
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.26),
                          ),
                        ),
                        child: const Icon(
                          Icons.notifications_active_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Your Notifications",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              unreadCount == 0
                                  ? "You are all caught up"
                                  : "$unreadCount unread notifications",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.82),
                                fontSize: 12.5,
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
          InkWell(
            onTap: onMarkAllRead,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withOpacity(0.06)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.done_all_rounded,
                    size: 18,
                    color: primary.withOpacity(0.92),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Mark all notifications as read",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: primary.withOpacity(0.70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsSectionHeader extends StatelessWidget {
  final String title;

  const _NotificationsSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final bool isUnread;
  final String tone;

  const _NotificationCard({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.isUnread,
    required this.tone,
  });

  static const Color primary = Color(0xFF0D4C4A);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color gold = Color(0xFFF0E0C0);

  Color _iconBg() {
    if (tone == "success") return const Color(0xFFE9F7F2);
    if (tone == "gold") return const Color(0xFFFBF5E8);
    if (tone == "highlight") return mint.withOpacity(0.28);
    return const Color(0xFFEAF4F2);
  }

  Color _iconColor() {
    if (tone == "gold") return const Color(0xFFC28B18);
    return primary.withOpacity(0.90);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isUnread
              ? mint.withOpacity(0.85)
              : Colors.black.withOpacity(0.05),
          width: isUnread ? 1.2 : 1,
        ),
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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: _iconBg(),
              border: Border.all(color: primary.withOpacity(0.08)),
            ),
            child: Icon(icon, size: 26, color: _iconColor()),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (isUnread)
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
                const SizedBox(height: 6),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12.3,
                    height: 1.45,
                    color: Colors.black.withOpacity(0.65),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11.8,
                    color: Colors.black.withOpacity(0.50),
                    fontWeight: FontWeight.w700,
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

class _EmptyNotificationsState extends StatelessWidget {
  const _EmptyNotificationsState();

  static const Color primary = Color(0xFF0D4C4A);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.notifications_off_rounded,
            size: 34,
            color: primary.withOpacity(0.75),
          ),
          const SizedBox(height: 10),
          const Text(
            "No notifications yet",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            "New alerts and updates will appear here.",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.58),
            ),
          ),
        ],
      ),
    );
  }
}
