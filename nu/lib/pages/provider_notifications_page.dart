import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/meal_service.dart';
import '../models/notification_model.dart';

class ProviderNotificationsPage extends StatefulWidget {
  static const String routeName = '/provider-notifications';

  const ProviderNotificationsPage({super.key});

  @override
  State<ProviderNotificationsPage> createState() =>
      _ProviderNotificationsPageState();
}

class _ProviderNotificationsPageState extends State<ProviderNotificationsPage> {
  static const Color bg = Color(0xFFF3F6F5);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color gold = Color(0xFFF0E0C0);

  final MealService _mealService = MealService();
  late Future<List<AppNotification>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    // جلب بيانات مقدم الخدمة (استخدمنا المعرف 1123456 من الداتابيس الخاصة بك)
    _notificationsFuture = _mealService.getNotifications("1123456", "provider");
  }

  void _refreshNotifications() {
    setState(() {
      _notificationsFuture = _mealService.getNotifications("1123456", "provider");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: const _ProviderNotificationsAppBar(),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<AppNotification>>(
          future: _notificationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: primary));
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error loading notifications"));
            }

            final notifications = snapshot.data ?? [];
            final unreadCount = notifications.where((item) => item.isUnread).length;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProviderNotificationsTopBlock(
                    unreadCount: unreadCount,
                    onMarkAllRead: _refreshNotifications,
                  ),
                  const SizedBox(height: 18),
                  const _NotificationsSectionLabel(title: "Recent Notifications"),
                  const SizedBox(height: 12),
                  
                  if (notifications.isEmpty)
                    const _EmptyProviderNotificationsState()
                  else
                    ...notifications.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ProviderNotificationCard(
                          title: item.title,
                          message: item.message,
                          time: DateFormat('MMM dd · hh:mm a').format(item.timestamp),
                          icon: item.icon,
                          isUnread: item.isUnread,
                          tone: item.type,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// --- تصميم الـ Widgets الفرعية (نفس الشكل المطلوب تماماً) ---

class _ProviderNotificationsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ProviderNotificationsAppBar();
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
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          ),
          const SizedBox(width: 2),
          const Text("Notifications", style: TextStyle(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.w900, letterSpacing: 0.2)),
        ],
      ),
    );
  }
}

class _ProviderNotificationsTopBlock extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onMarkAllRead;
  const _ProviderNotificationsTopBlock({required this.unreadCount, required this.onMarkAllRead});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [BoxShadow(blurRadius: 22, offset: const Offset(0, 12), color: Colors.black.withOpacity(0.06))],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [Color(0xFF062C26), Color(0xFF0D4C4A), Color(0xFF1A6B66)],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46, height: 46,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.12), border: Border.all(color: Colors.white.withOpacity(0.26))),
                    child: const Icon(Icons.notifications_active_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Provider Notifications", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text(unreadCount == 0 ? "You are all caught up" : "$unreadCount unread notifications",
                            style: TextStyle(color: Colors.white.withOpacity(0.82), fontSize: 12.5, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: onMarkAllRead,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(color: const Color(0xFFF8FAFA), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withOpacity(0.06))),
              child: const Row(
                children: [
                  Icon(Icons.done_all_rounded, size: 18, color: Color(0xFF0D4C4A)),
                  SizedBox(width: 10),
                  Expanded(child: Text("Mark all notifications as read", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13))),
                  Icon(Icons.arrow_forward_ios_rounded, size: 15, color: Color(0xFF0D4C4A)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderNotificationCard extends StatelessWidget {
  final String title, message, time, tone;
  final IconData icon;
  final bool isUnread;

  const _ProviderNotificationCard({required this.title, required this.message, required this.time, required this.icon, required this.isUnread, required this.tone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(blurRadius: 20, offset: const Offset(0, 12), color: Colors.black.withOpacity(0.05))],
        border: Border.all(color: isUnread ? const Color(0xFF9FE5C9) : Colors.black.withOpacity(0.05), width: isUnread ? 1.2 : 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54, height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: tone == "success" ? const Color(0xFFE9F7F2) : (tone == "gold" ? const Color(0xFFFBF5E8) : const Color(0xFFEAF4F2)),
              border: Border.all(color: const Color(0xFF0D4C4A).withOpacity(0.08)),
            ),
            child: Icon(icon, color: tone == "gold" ? const Color(0xFFC28B18) : const Color(0xFF0D4C4A).withOpacity(0.90), size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900))),
                    if (isUnread) Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF9FE5C9), shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(message, style: TextStyle(fontSize: 13, height: 1.4, color: Colors.black.withOpacity(0.62), fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Text(time, style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.52), fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsSectionLabel extends StatelessWidget {
  final String title;
  const _NotificationsSectionLabel({required this.title});
  @override
  Widget build(BuildContext context) => Text(title, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: Colors.black.withOpacity(0.78)));
}

class _EmptyProviderNotificationsState extends StatelessWidget {
  const _EmptyProviderNotificationsState();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.black.withOpacity(0.05))),
      child: Column(
        children: [
          Icon(Icons.notifications_off_rounded, size: 34, color: const Color(0xFF0D4C4A).withOpacity(0.75)),
          const SizedBox(height: 10),
          const Text("No notifications yet", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
          const SizedBox(height: 6),
          Text("New provider alerts and updates will appear here.", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.58))),
        ],
      ),
    );
  }
}