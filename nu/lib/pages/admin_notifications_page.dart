import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../session/user_session.dart';
import '../widgets/admin_bottom_nav.dart';

class AdminNotificationsPage extends StatefulWidget {
  static const String routeName = '/admin-notifications';

  const AdminNotificationsPage({super.key});

  @override
  State<AdminNotificationsPage> createState() => _AdminNotificationsPageState();
}

class _AdminNotificationsPageState extends State<AdminNotificationsPage> {
  final _formKey = GlobalKey<FormState>();
  final AdminService _adminService = AdminService();

  final titleArController = TextEditingController();
  final titleEnController = TextEditingController();
  final messageArController = TextEditingController();
  final messageEnController = TextEditingController();
  final recipientIdController = TextEditingController();

  bool isLoading = false;
  int selectedTab = 0;

  late Future<List<dynamic>> _notificationsFuture;

  String selectedNotificationType = 'alert';
  String selectedRecipientType = 'all_pilgrims';

  static const Color bg = Color(0xFFF3F6F5);
  static const Color primary = Color(0xFF0D4C4A);

  bool get requiresRecipientId =>
      selectedRecipientType == 'pilgrim' || selectedRecipientType == 'provider';

@override
void initState() {
  super.initState();

  _markNotificationsAsRead();
  _notificationsFuture = fetchNotifications();
}

  @override
  void dispose() {
    titleArController.dispose();
    titleEnController.dispose();
    messageArController.dispose();
    messageEnController.dispose();
    recipientIdController.dispose();
    super.dispose();
  }

Future<List<dynamic>> fetchNotifications() {
  return _adminService.getAdminReceivedNotifications(
    UserSession.userId!,
  );
}

Future<void> _markNotificationsAsRead() async {
  try {
    await _adminService.markAllAdminNotificationsAsRead(
      UserSession.userId!,
    );
  } catch (e) {
    debugPrint(e.toString());
  }
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
      await _adminService.createNotification(
        titleAr: titleArController.text,
        titleEn: titleEnController.text,
        messageAr: messageArController.text,
        messageEn: messageEnController.text,
        notificationType: selectedNotificationType,
        recipientType: selectedRecipientType,
        recipientUserID: recipientIdController.text,
        createdByAdminID: UserSession.userId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification sent successfully')),
      );

      titleArController.clear();
      titleEnController.clear();
      messageArController.clear();
      messageEnController.clear();
      recipientIdController.clear();

      setState(() {
        selectedNotificationType = 'alert';
        selectedRecipientType = 'all_pilgrims';
        selectedTab = 0;
        _notificationsFuture = fetchNotifications();
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
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
  _SentNotificationsTab(
    notificationsFuture: _notificationsFuture,
    onRefresh: _refreshNotifications,
    formatDate: _formatDate,
  ),

  _CreateNotificationTab(
    formKey: _formKey,
    titleArController: titleArController,
    titleEnController: titleEnController,
    messageArController: messageArController,
    messageEnController: messageEnController,
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
        titleSpacing: 8,
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

  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color mint = Color(0xFF9FE5C9);

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

  const _TabSwitch({required this.selectedIndex, required this.onChanged});

  static const Color primary = Color(0xFF0D4C4A);

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
            title: 'Admin Alerts',
            icon: Icons.notifications_active_rounded,
            selected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
          const SizedBox(width: 6),
          _TabButton(
            title: 'Send Notifications',
            icon: Icons.send_rounded,
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

  static const Color primary = Color(0xFF0D4C4A);

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
              Icon(icon, size: 18, color: selected ? Colors.white : primary),
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
  final TextEditingController titleArController;
  final TextEditingController titleEnController;
  final TextEditingController messageArController;
  final TextEditingController messageEnController;
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
    required this.titleArController,
    required this.titleEnController,
    required this.messageArController,
    required this.messageEnController,
    required this.recipientIdController,
    required this.selectedNotificationType,
    required this.selectedRecipientType,
    required this.requiresRecipientId,
    required this.isLoading,
    required this.onNotificationTypeChanged,
    required this.onRecipientTypeChanged,
    required this.onSend,
  });

  static const Color primary = Color(0xFF0D4C4A);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionLabel(title: 'Create Bulk Notification'),
            const SizedBox(height: 12),
            _InputField(
              controller: titleArController,
              label: 'Arabic Title',
              icon: Icons.title_rounded,
              textDirection: TextDirection.rtl,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter Arabic title';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            _InputField(
              controller: titleEnController,
              label: 'English Title',
              icon: Icons.title_rounded,
              textDirection: TextDirection.ltr,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter English title';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            _DropdownField(
              label: 'Notification Type',
              value: selectedNotificationType,
              items: const [
                DropdownMenuItem(value: 'alert', child: Text('Alert')),
                DropdownMenuItem(
                  value: 'announcement',
                  child: Text('Announcement'),
                ),
                DropdownMenuItem(value: 'reminder', child: Text('Reminder')),
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
              ],
              onChanged: onRecipientTypeChanged,
            ),
            const SizedBox(height: 8),
            const _FormHint(
              text:
                  'For a specific pilgrim or provider, send the notification directly from Manage Accounts.',
            ),
            const SizedBox(height: 14),
            _MessageField(
              controller: messageArController,
              label: 'Arabic Message',
              textDirection: TextDirection.rtl,
              validatorMessage: 'Enter Arabic message',
            ),
            const SizedBox(height: 14),
            _MessageField(
              controller: messageEnController,
              label: 'English Message',
              textDirection: TextDirection.ltr,
              validatorMessage: 'Enter English message',
            ),
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
                label: Text(
                  isLoading ? 'Sending...' : 'Send Bulk Notification',
                ),
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

class _FormHint extends StatelessWidget {
  final String text;

  const _FormHint({required this.text});

  static const Color primary = Color(0xFF0D4C4A);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F6F4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: primary,
                fontSize: 12.3,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
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

  static const Color primary = Color(0xFF0D4C4A);

  String _value(Map<String, dynamic> item, String key) {
    return item[key]?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: notificationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 80, 16, 24),
            children: const [
              Center(child: CircularProgressIndicator(color: primary)),
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
              const _SectionLabel(title: 'Admin Alerts'),
              const SizedBox(height: 12),
              ...notifications.map((rawItem) {
                final item = rawItem is Map<String, dynamic>
                    ? rawItem
                    : Map<String, dynamic>.from(rawItem as Map);

                final titleAr = _value(item, 'title_ar').isNotEmpty
                    ? _value(item, 'title_ar')
                    : _value(item, 'title');

                final titleEn = _value(item, 'title_en').isNotEmpty
                    ? _value(item, 'title_en')
                    : _value(item, 'title');

                final messageAr = _value(item, 'messageContent_ar').isNotEmpty
                    ? _value(item, 'messageContent_ar')
                    : _value(item, 'messageContent');

                final messageEn = _value(item, 'messageContent_en').isNotEmpty
                    ? _value(item, 'messageContent_en')
                    : _value(item, 'messageContent');

                return _SentNotificationCard(
                  titleAr: titleAr,
                  titleEn: titleEn,
                  messageAr: messageAr,
                  messageEn: messageEn,
                  type: _value(item, 'notificationType'),
                  recipientType: _value(item, 'recipientType'),
                  recipientUserID: _value(item, 'recipientUserID'),
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

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextDirection? textDirection;

  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.textDirection,
  });

  static const Color primary = Color(0xFF0D4C4A);
  static const Color softMint = Color(0xFFEAF5F2);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      textDirection: textDirection,
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
          borderSide: const BorderSide(color: primary, width: 1.5),
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

  static const Color primary = Color(0xFF0D4C4A);
  static const Color softMint = Color(0xFFEAF5F2);

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
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
    );
  }
}

class _MessageField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String validatorMessage;
  final TextDirection textDirection;

  const _MessageField({
    required this.controller,
    required this.label,
    required this.validatorMessage,
    required this.textDirection,
  });

  static const Color primary = Color(0xFF0D4C4A);
  static const Color softMint = Color(0xFFEAF5F2);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 5,
      textDirection: textDirection,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return validatorMessage;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
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
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
    );
  }
}

class _SentNotificationCard extends StatelessWidget {
  final String titleAr;
  final String titleEn;
  final String messageAr;
  final String messageEn;
  final String type;
  final String recipientType;
  final String recipientUserID;
  final String timestamp;

  const _SentNotificationCard({
    required this.titleAr,
    required this.titleEn,
    required this.messageAr,
    required this.messageEn,
    required this.type,
    required this.recipientType,
    required this.recipientUserID,
    required this.timestamp,
  });

  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color softMint = Color(0xFFEAF5F2);

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
                    _MiniChip(text: type.isEmpty ? 'notification' : type),
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
                  titleAr.isEmpty ? 'No Arabic title' : titleAr,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: primaryDark,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  messageAr.isEmpty ? 'No Arabic message' : messageAr,
                  textDirection: TextDirection.rtl,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.62),
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.8,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  titleEn.isEmpty ? 'No English title' : titleEn,
                  style: const TextStyle(
                    color: primaryDark,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  messageEn.isEmpty ? 'No English message' : messageEn,
                  maxLines: 2,
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

  static const Color primary = Color(0xFF0D4C4A);
  static const Color softMint = Color(0xFFEAF5F2);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
