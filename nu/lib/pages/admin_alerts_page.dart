import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/admin_service.dart';
import '../session/user_session.dart';
import '../widgets/admin_bottom_nav.dart';

class AdminAlertsPage extends StatefulWidget {
  static const String routeName = '/admin-alerts';

  const AdminAlertsPage({super.key});

  @override
  State<AdminAlertsPage> createState() => _AdminAlertsPageState();
}

class _AdminAlertsPageState extends State<AdminAlertsPage> {
  final AdminService _adminService = AdminService();

  late Future<List<dynamic>> _notificationsFuture;

  static const Color bg = Color(0xFFF3F6F5);
  static const Color primary = Color(0xFF0D4C4A);

  @override
  void initState() {
    super.initState();
    _markNotificationsAsRead();
    _notificationsFuture = _fetchNotifications();
  }

  Future<List<dynamic>> _fetchNotifications() {
    return _adminService.getAdminReceivedNotifications(UserSession.userId!);
  }

  Future<void> _markNotificationsAsRead() async {
    try {
      await _adminService.markAllAdminNotificationsAsRead(UserSession.userId!);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _refreshNotifications() async {
    setState(() {
      _notificationsFuture = _fetchNotifications();
    });

    await _markNotificationsAsRead();
    await _notificationsFuture;
  }

  String _formatDate(dynamic value) {
    if (value == null) return 'No date';

    final text = value.toString();
    final date = DateTime.tryParse(text);

    if (date == null) return text;

    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$year-$month-$day  $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final adminName = UserSession.fullName ?? l10n.systemAdmin;

    return Scaffold(
      backgroundColor: bg,
      appBar: const _AdminAlertsAppBar(),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          color: primary,
          onRefresh: _refreshNotifications,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            children: [
              _AdminAlertsTopBlock(adminName: adminName),
              const SizedBox(height: 18),
              _SectionLabel(title: l10n.adminAlerts),
              const SizedBox(height: 12),
              _AdminAlertsList(
                notificationsFuture: _notificationsFuture,
                formatDate: _formatDate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminAlertsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AdminAlertsAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(58);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.6,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        surfaceTintColor: Colors.white,
        titleSpacing: 8,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/admin-dashboard');
          },
        ),
        title: const Row(
          children: [
            SizedBox(width: 4),
            Text(
              'NUSUQ',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminAlertsTopBlock extends StatelessWidget {
  final String adminName;

  const _AdminAlertsTopBlock({required this.adminName});

  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color gold = Color(0xFFF0E0C0);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              offset: const Offset(0, 14),
              color: Colors.black.withValues(alpha: 0.07),
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
                      color: Colors.white.withValues(alpha: 0.12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.26),
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
                        Text(
                          l10n.adminAlerts,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          adminName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.86),
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
                  color: mint.withValues(alpha: 0.12),
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
                  color: gold.withValues(alpha: 0.10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminAlertsList extends StatelessWidget {
  final Future<List<dynamic>> notificationsFuture;
  final String Function(dynamic value) formatDate;

  const _AdminAlertsList({
    required this.notificationsFuture,
    required this.formatDate,
  });

  static const Color primary = Color(0xFF0D4C4A);

  String _value(Map<String, dynamic> item, String key) {
    return item[key]?.toString().trim() ?? '';
  }

  String _firstValue(Map<String, dynamic> item, List<String> keys) {
    for (final key in keys) {
      final value = _value(item, key);
      if (value.isNotEmpty) return value;
    }
    return '';
  }

  Map<String, dynamic> _toMap(dynamic rawItem) {
    if (rawItem is Map<String, dynamic>) return rawItem;
    return Map<String, dynamic>.from(rawItem as Map);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return FutureBuilder<List<dynamic>>(
      future: notificationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 48),
            child: Center(child: CircularProgressIndicator(color: primary)),
          );
        }

        if (snapshot.hasError) {
          return _MessageBox(
            icon: Icons.error_outline_rounded,
            text: l10n.failedToLoadNotifications,
          );
        }

        final notifications = snapshot.data ?? [];

        if (notifications.isEmpty) {
          return _MessageBox(
            icon: Icons.notifications_none_rounded,
            text: l10n.noNotificationsYet,
          );
        }

        return Column(
          children: notifications.map((rawItem) {
            final item = _toMap(rawItem);

            final titleAr = _firstValue(item, [
              'title_ar',
              'titleAr',
            ]);

            final titleEn = _firstValue(item, [
              'title_en',
              'titleEn',
              'title',
            ]);

            final messageAr = _firstValue(item, [
              'messageContent_ar',
              'message_ar',
              'messageAr',
            ]);

            final messageEn = _firstValue(item, [
              'messageContent_en',
              'message_en',
              'messageEn',
              'messageContent',
              'message',
            ]);

            final title = isArabic
                ? (titleAr.isEmpty ? titleEn : titleAr)
                : (titleEn.isEmpty ? titleAr : titleEn);

            final message = isArabic
                ? (messageAr.isEmpty ? messageEn : messageAr)
                : (messageEn.isEmpty ? messageAr : messageEn);

            final timestampValue = item['timestamp'] ??
                item['createdAt'] ??
                item['created_at'] ??
                item['createdDate'];

            return _AdminAlertCard(
              title: title.isEmpty ? l10n.notification : title,
              message: message.isEmpty ? l10n.noMessage : message,
              type: _firstValue(item, ['notificationType', 'type']),
              sender: _firstValue(item, [
                'createdByAdminID',
                'created_by_admin_id',
                'senderID',
                'sender',
              ]),
              timestamp: formatDate(timestampValue),
            );
          }).toList(),
        );
      },
    );
  }
}

class _AdminAlertCard extends StatelessWidget {
  final String title;
  final String message;
  final String type;
  final String sender;
  final String timestamp;

  const _AdminAlertCard({
    required this.title,
    required this.message,
    required this.type,
    required this.sender,
    required this.timestamp,
  });

  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color softMint = Color(0xFFEAF5F2);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final senderText = sender.isEmpty
        ? l10n.admin
        : '${l10n.admin} • $sender';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: softMint,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.notifications_rounded,
              color: primary,
              size: 22,
            ),
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
                        timestamp,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: primaryDark,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.62),
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.8,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.people_alt_rounded,
                      size: 14,
                      color: Colors.black.withValues(alpha: 0.45),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        senderText,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                  ],
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

  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w900,
        color: Colors.black.withValues(alpha: 0.78),
      ),
    );
  }
}

class _MessageBox extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MessageBox({required this.icon, required this.text});

  static const Color primary = Color(0xFF0D4C4A);
  static const Color softMint = Color(0xFFEAF5F2);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: softMint,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}