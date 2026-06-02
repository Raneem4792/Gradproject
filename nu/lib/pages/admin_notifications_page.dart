import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/admin_service.dart';
import '../session/user_session.dart';
import '../widgets/admin_bottom_nav.dart';
import 'admin_dashboard_page.dart';

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

  static const Color bg = Color(0xFFF3F6F5);

  String selectedNotificationType = 'alert';
  String selectedRecipientType = 'all_pilgrims';

  @override
  void dispose() {
    titleArController.dispose();
    titleEnController.dispose();
    messageArController.dispose();
    messageEnController.dispose();
    recipientIdController.dispose();
    super.dispose();
  }

  Future<void> sendNotification() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await _adminService.createNotification(
        titleAr: titleArController.text.trim(),
        titleEn: titleEnController.text.trim(),
        messageAr: messageArController.text.trim(),
        messageEn: messageEnController.text.trim(),
        notificationType: selectedNotificationType,
        recipientType: selectedRecipientType,
        recipientUserID: '',
        createdByAdminID: UserSession.userId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.notificationSentSuccessfully)),
      );

      titleArController.clear();
      titleEnController.clear();
      messageArController.clear();
      messageEnController.clear();

      setState(() {
        selectedNotificationType = 'alert';
        final formKey = GlobalKey<FormState>();
        selectedRecipientType = 'all_pilgrims';
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: bg,
      appBar: const _NotificationsAppBar(),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 2),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TopBlock(),
              const SizedBox(height: 18),
              _SectionLabel(title: l10n.createNotification),
              const SizedBox(height: 12),
              _FormCard(
                formKey: _formKey,
                titleArController: titleArController,
                titleEnController: titleEnController,
                messageArController: messageArController,
                messageEnController: messageEnController,
                selectedNotificationType: selectedNotificationType,
                selectedRecipientType: selectedRecipientType,
                isLoading: isLoading,
                onNotificationTypeChanged: (value) {
                  setState(() => selectedNotificationType = value!);
                },
                onRecipientTypeChanged: (value) {
                  setState(() => selectedRecipientType = value!);
                },
                onSend: sendNotification,
              ),
            ],
          ),
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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AdminDashboardPage.routeName,
              (route) => false,
            );
          },
        ),
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
              color: Colors.black.withOpacity(0.07),
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
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
                          l10n.sendNotifications,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.createAlertsForPilgrimsAndProviders,
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

class _FormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleArController;
  final TextEditingController titleEnController;
  final TextEditingController messageArController;
  final TextEditingController messageEnController;
  final String selectedNotificationType;
  final String selectedRecipientType;
  final bool isLoading;
  final void Function(String?) onNotificationTypeChanged;
  final void Function(String?) onRecipientTypeChanged;
  final VoidCallback onSend;

  const _FormCard({
    required this.formKey,
    required this.titleArController,
    required this.titleEnController,
    required this.messageArController,
    required this.messageEnController,
    required this.selectedNotificationType,
    required this.selectedRecipientType,
    required this.isLoading,
    required this.onNotificationTypeChanged,
    required this.onRecipientTypeChanged,
    required this.onSend,
  });

  static const Color primary = Color(0xFF0D4C4A);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _InputField(
              controller: titleArController,
              label: l10n.arabicTitle,
              icon: Icons.title_rounded,
              textDirection: TextDirection.rtl,
              validator: (value) => value == null || value.trim().isEmpty
                  ? l10n.enterArabicTitle
                  : null,
            ),
            const SizedBox(height: 14),
            _InputField(
              controller: titleEnController,
              label: l10n.englishTitle,
              icon: Icons.title_rounded,
              textDirection: TextDirection.ltr,
              validator: (value) => value == null || value.trim().isEmpty
                  ? l10n.enterEnglishTitle
                  : null,
            ),
            const SizedBox(height: 14),
            _DropdownField(
              label: l10n.notificationType,
              value: selectedNotificationType,
              items: [
                DropdownMenuItem(value: 'alert', child: Text(l10n.alert)),
                DropdownMenuItem(
                  value: 'announcement',
                  child: Text(l10n.announcement),
                ),
                DropdownMenuItem(value: 'reminder', child: Text(l10n.reminder)),
              ],
              onChanged: onNotificationTypeChanged,
            ),
            const SizedBox(height: 14),
            _DropdownField(
              label: l10n.recipients,
              value: selectedRecipientType,
              items: [
                DropdownMenuItem(
                  value: 'all_pilgrims',
                  child: Text(l10n.allPilgrims),
                ),
                DropdownMenuItem(
                  value: 'all_providers',
                  child: Text(l10n.allProviders),
                ),
              ],
              onChanged: onRecipientTypeChanged,
            ),
            const SizedBox(height: 12),
            _FormHint(
              text: l10n.specificNotificationHint,
            ),
            const SizedBox(height: 14),
            _MessageField(
              controller: messageArController,
              label: l10n.arabicMessage,
              textDirection: TextDirection.rtl,
              validatorMessage: l10n.enterArabicMessage,
            ),
            const SizedBox(height: 14),
            _MessageField(
              controller: messageEnController,
              label: l10n.englishMessage,
              textDirection: TextDirection.ltr,
              validatorMessage: l10n.enterEnglishMessage,
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
                  isLoading ? l10n.sending : l10n.sendNotification,
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
        fillColor: const Color(0xFFFAFCFB),
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
        fillColor: const Color(0xFFFAFCFB),
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
      validator: (value) =>
          value == null || value.trim().isEmpty ? validatorMessage : null,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        filled: true,
        fillColor: const Color(0xFFFAFCFB),
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