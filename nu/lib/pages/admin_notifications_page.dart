import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../session/user_session.dart';
import '../widgets/admin_bottom_nav.dart';

class AdminNotificationsPage extends StatefulWidget {
  static const String routeName = '/admin-notifications';

  const AdminNotificationsPage({super.key});

  @override
  State<AdminNotificationsPage> createState() =>
      _AdminNotificationsPageState();
}

class _AdminNotificationsPageState extends State<AdminNotificationsPage> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final messageController = TextEditingController();
  final recipientIdController = TextEditingController();

  bool isLoading = false;
  int selectedTab = 0;

  late Future<List<dynamic>> _notificationsFuture;

  String selectedNotificationType = 'alert';
  String selectedRecipientType = 'all_pilgrims';

  static const Color bg = Color(0xFFF1F7F4);
  static const Color primary = Color(0xFF0B4A40);

  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    }
    return 'http://10.0.2.2:3000/api';
  }

  bool get requiresRecipientId =>
      selectedRecipientType == 'pilgrim' ||
      selectedRecipientType == 'provider';

  @override
  void initState() {
    super.initState();
    _notificationsFuture = fetchNotifications();
  }

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    recipientIdController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> fetchNotifications() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/notifications'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load notifications');
  }

  Future<void> _refreshNotifications() async {
    setState(() {
      _notificationsFuture = fetchNotifications();
    });

    await _notificationsFuture;
  }

  Future<void> sendNotification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/admin/notifications'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': titleController.text.trim(),
          'notificationType': selectedNotificationType,
          'messageContent': messageController.text.trim(),
          'recipientType': selectedRecipientType,
          'recipientUserID': recipientIdController.text.trim(),
          'createdByAdminID': UserSession.userId,
        }),
      );

      if (response.statusCode == 201) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification sent successfully'),
          ),
        );

        titleController.clear();
        messageController.clear();
        recipientIdController.clear();

        setState(() {
          selectedNotificationType = 'alert';
          selectedRecipientType = 'all_pilgrims';
          selectedTab = 1;
          _notificationsFuture = fetchNotifications();
        });
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send notification'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
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
    return Scaffold(
      backgroundColor: bg,
      appBar: const _NotificationsAppBar(),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 3),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _TopBlock(),
                  const SizedBox(height: 16),
                  _TabSwitch(
                    selectedIndex: selectedTab,
                    onChanged: (index) {
                      setState(() {
                        selectedTab = index;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: IndexedStack(
                index: selectedTab,
                children: [
                  _CreateNotificationTab(
                    formKey: _formKey,
                    titleController: titleController,
                    messageController: messageController,
                    recipientIdController: recipientIdController,
                    selectedNotificationType: selectedNotificationType,
                    selectedRecipientType: selectedRecipientType,
                    requiresRecipientId: requiresRecipientId,
                    isLoading: isLoading,
                    onNotificationTypeChanged: (value) {
                      setState(() {
                        selectedNotificationType = value!;
                      });
                    },
                    onRecipientTypeChanged: (value) {
                      setState(() {
                        selectedRecipientType = value!;
                        recipientIdController.clear();
                      });
                    },
                    onSend: sendNotification,
                  ),
                  _SentNotificationsTab(
                    notificationsFuture: _notificationsFuture,
                    onRefresh: _refreshNotifications,
                    formatDate: _formatDate,
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

class _NotificationsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _NotificationsAppBar();

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
      ),
    );
  }
}

class _TopBlock extends StatelessWidget {
  const _TopBlock();

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryDark, primary, primaryMid],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.notifications_active_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -30,
            top: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mint.withOpacity(0.12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabSwitch extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _TabSwitch({
    required this.selectedIndex,
    required this.onChanged,
  });

  static const Color primary = Color(0xFF0B4A40);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
          _TabButton(
            title: 'Create',
            icon: Icons.add_alert_rounded,
            selected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
          const SizedBox(width: 6),
          _TabButton(
            title: 'Sent',
            icon: Icons.mark_email_read_rounded,
            selected: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  static const Color primary = Color(0xFF0B4A40);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? Colors.white : primary,
              ),
              const SizedBox(width: 7),
              Text(
                title,
                style: TextStyle(
                  color: selected ? Colors.white : primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateNotificationTab extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController messageController;
  final TextEditingController recipientIdController;
  final String selectedNotificationType;
  final String selectedRecipientType;
  final bool requiresRecipientId;
  final bool isLoading;
  final void Function(String?) onNotificationTypeChanged;
  final void Function(String?) onRecipientTypeChanged;
  final VoidCallback onSend;

  const _CreateNotificationTab({
    required this.formKey,
    required this.titleController,
    required this.messageController,
    required this.recipientIdController,
    required this.selectedNotificationType,
    required this.selectedRecipientType,
    required this.requiresRecipientId,
    required this.isLoading,
    required this.onNotificationTypeChanged,
    required this.onRecipientTypeChanged,
    required this.onSend,
  });

  static const Color primary = Color(0xFF0B4A40);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionLabel(title: 'Create Notification'),
            const SizedBox(height: 12),
            _InputField(
              controller: titleController,
              label: 'Title',
              icon: Icons.title_rounded,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter notification title';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            _DropdownField(
              label: 'Notification Type',
              value: selectedNotificationType,
              items: const [
                DropdownMenuItem(
                  value: 'alert',
                  child: Text('Alert'),
                ),
                DropdownMenuItem(
                  value: 'announcement',
                  child: Text('Announcement'),
                ),
                DropdownMenuItem(
                  value: 'reminder',
                  child: Text('Reminder'),
                ),
              ],
              onChanged: onNotificationTypeChanged,
            ),
            const SizedBox(height: 14),
            _DropdownField(
              label: 'Recipients',
              value: selectedRecipientType,
              items: const [
                DropdownMenuItem(
                  value: 'all_pilgrims',
                  child: Text('All Pilgrims'),
                ),
                DropdownMenuItem(
                  value: 'all_providers',
                  child: Text('All Providers'),
                ),
                DropdownMenuItem(
                  value: 'pilgrim',
                  child: Text('Specific Pilgrim'),
                ),
                DropdownMenuItem(
                  value: 'provider',
                  child: Text('Specific Provider'),
                ),
              ],
              onChanged: onRecipientTypeChanged,
            ),
            if (requiresRecipientId) ...[
              const SizedBox(height: 14),
              _InputField(
                controller: recipientIdController,
                label: 'Recipient ID',
                icon: Icons.badge_rounded,
                validator: (value) {
                  if (!requiresRecipientId) return null;

                  if (value == null || value.trim().isEmpty) {
                    return 'Enter recipient ID';
                  }

                  return null;
                },
              ),
            ],
            const SizedBox(height: 14),
            _MessageField(controller: messageController),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : onSend,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded),
                label: Text(isLoading ? 'Sending...' : 'Send Notification'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SentNotificationsTab extends StatelessWidget {
  final Future<List<dynamic>> notificationsFuture;
  final Future<void> Function() onRefresh;
  final String Function(dynamic value) formatDate;

  const _SentNotificationsTab({
    required this.notificationsFuture,
    required this.onRefresh,
    required this.formatDate,
  });

  static const Color primary = Color(0xFF0B4A40);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: notificationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 80, 16, 24),
            children: const [
              Center(
                child: CircularProgressIndicator(color: primary),
              ),
            ],
          );
        }

        if (snapshot.hasError) {
          return RefreshIndicator(
            color: primary,
            onRefresh: onRefresh,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: const [
                _MessageBox(
                  icon: Icons.error_outline_rounded,
                  text: 'Failed to load notifications',
                ),
              ],
            ),
          );
        }

        final notifications = snapshot.data ?? [];

        if (notifications.isEmpty) {
          return RefreshIndicator(
            color: primary,
            onRefresh: onRefresh,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: const [
                _MessageBox(
                  icon: Icons.notifications_none_rounded,
                  text: 'No notifications yet',
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: primary,
          onRefresh: onRefresh,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              const _SectionLabel(title: 'Sent Notifications'),
              const SizedBox(height: 12),
              ...notifications.map((item) {
                return _SentNotificationCard(
                  title: item['title']?.toString() ?? 'No title',
                  message: item['messageContent']?.toString() ?? '',
                  type: item['notificationType']?.toString() ?? '',
                  recipientType: item['recipientType']?.toString() ?? '',
                  recipientUserID: item['recipientUserID']?.toString() ?? '',
                  timestamp: formatDate(item['timestamp']),
                );
              }),
            ],
          ),
        );
      },
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

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
  });

  static const Color primary = Color(0xFF0B4A40);
  static const Color softMint = Color(0xFFE8F3F1);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: softMint),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: softMint),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<DropdownMenuItem<String>> items;
  final void Function(String?) onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  static const Color primary = Color(0xFF0B4A40);
  static const Color softMint = Color(0xFFE8F3F1);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: softMint),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: softMint),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class _MessageField extends StatelessWidget {
  final TextEditingController controller;

  const _MessageField({
    required this.controller,
  });

  static const Color primary = Color(0xFF0B4A40);
  static const Color softMint = Color(0xFFE8F3F1);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 5,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Enter message content';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Message',
        alignLabelWithHint: true,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: softMint),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: softMint),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class _SentNotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String type;
  final String recipientType;
  final String recipientUserID;
  final String timestamp;

  const _SentNotificationCard({
    required this.title,
    required this.message,
    required this.type,
    required this.recipientType,
    required this.recipientUserID,
    required this.timestamp,
  });

  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryDark = Color(0xFF052720);
  static const Color softMint = Color(0xFFE8F3F1);

  @override
  Widget build(BuildContext context) {
    final recipientText = recipientUserID.isEmpty
        ? recipientType
        : '$recipientType • $recipientUserID';

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
            color: Colors.black.withOpacity(0.05),
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
                    _MiniChip(text: type),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        timestamp,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.45),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
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
                    color: Colors.black.withOpacity(0.62),
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
                      color: Colors.black.withOpacity(0.45),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        recipientText,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.48),
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

class _MiniChip extends StatelessWidget {
  final String text;

  const _MiniChip({required this.text});

  static const Color primary = Color(0xFF0B4A40);
  static const Color softMint = Color(0xFFE8F3F1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: softMint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: primary,
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _MessageBox extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MessageBox({
    required this.icon,
    required this.text,
  });

  static const Color primary = Color(0xFF0B4A40);
  static const Color softMint = Color(0xFFE8F3F1);

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