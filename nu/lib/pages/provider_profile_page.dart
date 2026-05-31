import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../main.dart';
import 'provider_home_screen.dart';
import '../services/provider_service.dart';
import '../session/user_session.dart';
import '../models/provider_profile.dart';
import 'login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderProfilePage extends StatefulWidget {
  static const String routeName = '/provider-profile';

  const ProviderProfilePage({super.key});

  static const Color bg = Color(0xFFF3F6F5);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color softMint = Color(0xFFE8F6F1);
  static const Color gold = Color(0xFFF0E0C0);

  @override
  State<ProviderProfilePage> createState() => _ProviderProfilePageState();
}

class _ProviderProfilePageState extends State<ProviderProfilePage> {
  final ProviderService _providerService = ProviderService();
  bool _isProfileLoading = true;
  bool _isSummaryLoading = true;
  Map<String, dynamic>? _profileSummary;

  bool isEditingBasicInfo = false;
  bool notificationsEnabled = true;

  Future<void> _loadNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      notificationsEnabled =
          prefs.getBool('provider_notifications_enabled') ?? true;
    });
  }

  Future<void> _saveNotificationSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('provider_notifications_enabled', value);

    if (!mounted) return;

    setState(() {
      notificationsEnabled = value;
    });
  }

  String providerName = "";
  String providerId = "";
  String email = "";
  String phone = "";

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  final GlobalKey<FormState> _providerFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: providerName);
    emailController = TextEditingController(text: email);
    phoneController = TextEditingController(text: phone);

    _loadProviderProfile();
    _loadNotificationSetting();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadProviderProfile() async {
    final providerId = UserSession.userId;

    if (providerId == null || providerId.isEmpty) {
      setState(() {
        _isProfileLoading = false;
        _isSummaryLoading = false;
      });
      return;
    }

    try {
      final results = await Future.wait([
        _providerService.getProfile(providerId),
        _providerService.getProfileSummary(providerId),
      ]);

      final profile = results[0] as ProviderProfile;
      final summary = results[1] as Map<String, dynamic>;

      setState(() {
        providerName = profile.fullName;
        this.providerId = profile.providerID;
        email = profile.email;
        phone = profile.phoneNumber;

        nameController.text = providerName;
        emailController.text = email;
        phoneController.text = phone;

        _profileSummary = summary;

        _isProfileLoading = false;
        _isSummaryLoading = false;
      });
    } catch (e) {
      setState(() {
        _isProfileLoading = false;
        _isSummaryLoading = false;
      });
    }
  }

  String? _validateProviderName(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final text = (value ?? '').trim().replaceAll(RegExp(r'\s+'), ' ');

    if (text.isEmpty) return l10n.pleaseEnterFullName;
    if (text.length < 3) return l10n.fullNameTooShort;
    if (text.length > 50) return l10n.fullNameTooLong;

    if (RegExp(r'[0-9]').hasMatch(text)) {
      return l10n.fullNameNoNumbers;
    }

    if (RegExp(r'[^A-Za-z\u0600-\u06FF ]').hasMatch(text)) {
      return l10n.fullNameNoSymbols;
    }

    final isArabicOnly = RegExp(r'^[\u0600-\u06FF ]+$').hasMatch(text);
    final isEnglishOnly = RegExp(r'^[A-Za-z ]+$').hasMatch(text);

    if (!isArabicOnly && !isEnglishOnly) {
      return l10n.fullNameArabicOrEnglishOnly;
    }

    return null;
  }

  String? _validateProviderEmail(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final text = (value ?? '').trim();

    if (text.isEmpty) return l10n.pleaseEnterEmail;
    if (text.contains(' ')) return l10n.emailNoSpaces;
    if (text.length > 100) return l10n.emailTooLong;

    final emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );

    if (!emailRegex.hasMatch(text)) {
      return l10n.pleaseEnterValidEmail;
    }

    return null;
  }

  String? _validateProviderPhone(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final text = (value ?? '').trim();

    if (text.isEmpty) return l10n.pleaseEnterPhoneNumber;
    if (text.contains(' ')) return l10n.phoneNoSpaces;

    if (!RegExp(r'^\+?[0-9]+$').hasMatch(text)) {
      return l10n.phoneDigitsOnly;
    }

    final digitsOnly = text.replaceAll('+', '');

    if (digitsOnly.length < 8) {
      return l10n.phoneTooShort;
    }

    if (digitsOnly.length > 15) {
      return l10n.phoneTooLong;
    }

    return null;
  }

  Future<void> _toggleBasicInfoEdit() async {
    final l10n = AppLocalizations.of(context)!;

    if (isEditingBasicInfo) {
      final providerId = UserSession.userId;

      if (providerId == null || providerId.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.userSessionNotFound)));
        return;
      }

      if (!(_providerFormKey.currentState?.validate() ?? false)) {
        return;
      }
      try {
        final profile = ProviderProfile(
          providerID: providerId,
          fullName: nameController.text.trim(),
          email: emailController.text.trim(),
          phoneNumber: phoneController.text.trim(),
        );

        await _providerService.updateProfile(profile);

        setState(() {
          providerName = nameController.text.trim();
          email = emailController.text.trim();
          phone = phoneController.text.trim();
          isEditingBasicInfo = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.basicInformationUpdated)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${l10n.failedToUpdateProfile}: $e")),
        );
      }
    } else {
      nameController.text = providerName;
      emailController.text = email;
      phoneController.text = phone;

      setState(() {
        isEditingBasicInfo = true;
      });
    }
  }

  void _cancelBasicInfoEdit() {
    setState(() {
      nameController.text = providerName;
      emailController.text = email;
      phoneController.text = phone;
      isEditingBasicInfo = false;
    });
  }

  Future<void> _changeLanguage() async {
    final currentLocale = Localizations.localeOf(context).languageCode;

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        final sheetL10n = AppLocalizations.of(context)!;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      sheetL10n.chooseLanguage,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(sheetL10n.arabic),
                  trailing: currentLocale == "ar"
                      ? const Icon(
                          Icons.check,
                          color: ProviderProfilePage.primary,
                        )
                      : null,
                  onTap: () => Navigator.pop(context, "ar"),
                ),
                ListTile(
                  title: Text(sheetL10n.english),
                  trailing: currentLocale == "en"
                      ? const Icon(
                          Icons.check,
                          color: ProviderProfilePage.primary,
                        )
                      : null,
                  onTap: () => Navigator.pop(context, "en"),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      NusuqApp.of(context).setLocale(Locale(selected));
    }
  }

  Future<void> _logout() async {
    final l10n = AppLocalizations.of(context)!;

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(
          l10n.logOut,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.black87,
          ),
        ),
        content: Text(
          l10n.areYouSureLogout,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.cancel,
              style: const TextStyle(
                color: ProviderProfilePage.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.logOut,
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      UserSession.clear();

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginScreen.routeName,
        (route) => false,
      );
    }
  }

  String _currentLanguageName(AppLocalizations l10n) {
    final code = Localizations.localeOf(context).languageCode;
    return code == "ar" ? l10n.arabic : l10n.english;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: ProviderProfilePage.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.6,
        shadowColor: Colors.black.withOpacity(0.08),
        surfaceTintColor: Colors.white,
        centerTitle: false,
        title: Text(
          l10n.providerProfile,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProviderHomeScreen()),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProfileHeaderCard(
              providerName: providerName,
              providerId: providerId,
            ),
            const SizedBox(height: 16),

            _SectionTitle(title: l10n.basicInformation),
            const SizedBox(height: 10),
            if (_isProfileLoading)
              const Center(child: CircularProgressIndicator())
            else
              _InfoCard(
                formKey: _providerFormKey,
                isEditing: isEditingBasicInfo,
                providerName: providerName,
                providerId: providerId,
                email: email,
                phone: phone,
                nameController: nameController,
                emailController: emailController,
                phoneController: phoneController,
                nameValidator: _validateProviderName,
                emailValidator: _validateProviderEmail,
                phoneValidator: _validateProviderPhone,
                onEditTap: _toggleBasicInfoEdit,
                onCancelTap: _cancelBasicInfoEdit,
              ),
            const SizedBox(height: 16),

            _SectionTitle(title: l10n.ordersSummary),
            const SizedBox(height: 10),
            _isSummaryLoading
                ? const Center(child: CircularProgressIndicator())
                : _StatsGrid(summary: _profileSummary),
            const SizedBox(height: 16),

            _SectionTitle(title: l10n.linkedCampaigns),
            const SizedBox(height: 10),
            _CampaignsCard(
              campaigns: List<Map<String, dynamic>>.from(
                _profileSummary?['campaigns'] ?? const [],
              ),
            ),
            const SizedBox(height: 16),

            _SectionTitle(title: l10n.settings),
            const SizedBox(height: 10),
            _SettingsCard(
              notificationsEnabled: notificationsEnabled,
              language: _currentLanguageName(l10n),
              onNotificationsChanged: (value) async {
                await _saveNotificationSetting(value);
              },
              onLanguageTap: _changeLanguage,
            ),
            const SizedBox(height: 22),

            _LogoutButton(onTap: _logout),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: Colors.black.withOpacity(0.8),
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final String providerName;
  final String providerId;

  const _ProfileHeaderCard({
    required this.providerName,
    required this.providerId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ProviderProfilePage.primaryDark,
                  ProviderProfilePage.primary,
                  ProviderProfilePage.primaryMid,
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.14),
                    border: Border.all(color: Colors.white.withOpacity(0.25)),
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        providerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${l10n.providerId}: ${providerId.isEmpty ? l10n.notAvailable : providerId}",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.82),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: ProviderProfilePage.mint.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          l10n.verifiedAccount,
                          style: const TextStyle(
                            color: ProviderProfilePage.primaryDark,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
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
            top: -36,
            child: Container(
              width: 118,
              height: 118,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ProviderProfilePage.mint.withOpacity(0.10),
              ),
            ),
          ),
          Positioned(
            left: -28,
            bottom: -36,
            child: Container(
              width: 126,
              height: 126,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ProviderProfilePage.gold.withOpacity(0.08),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final bool isEditing;
  final String providerName;
  final String providerId;
  final String email;
  final String phone;

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  final VoidCallback onEditTap;
  final VoidCallback onCancelTap;

  final GlobalKey<FormState> formKey;
  final String? Function(String?) nameValidator;
  final String? Function(String?) emailValidator;
  final String? Function(String?) phoneValidator;

  const _InfoCard({
    required this.isEditing,
    required this.providerName,
    required this.providerId,
    required this.email,
    required this.phone,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.onEditTap,
    required this.onCancelTap,
    required this.formKey,
    required this.nameValidator,
    required this.emailValidator,
    required this.phoneValidator,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _WhiteCard(
      child: Column(
        children: [
          _CardHeader(
            title: l10n.providerDetails,
            actionText: isEditing ? l10n.save : l10n.edit,
            onActionTap: onEditTap,
            showCancel: isEditing,
            onCancelTap: onCancelTap,
          ),
          const SizedBox(height: 10),
          if (isEditing) ...[
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  _EditableField(
                    icon: Icons.storefront_outlined,
                    label: l10n.providerName,
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    validator: nameValidator,
                  ),
                  const SizedBox(height: 14),
                  _EditableField(
                    icon: Icons.email_outlined,
                    label: l10n.email,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  const SizedBox(height: 14),
                  _EditableField(
                    icon: Icons.phone_outlined,
                    label: l10n.phone,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: phoneValidator,
                  ),
                ],
              ),
            ),
          ] else ...[
            _InfoRow(
              icon: Icons.storefront_outlined,
              title: l10n.providerName,
              value: providerName,
            ),
            const Divider(height: 22),
            _InfoRow(
              icon: Icons.badge_outlined,
              title: l10n.providerId,
              value: providerId,
            ),
            const Divider(height: 22),
            _InfoRow(
              icon: Icons.email_outlined,
              title: l10n.email,
              value: email,
            ),
            const Divider(height: 22),
            _InfoRow(
              icon: Icons.phone_outlined,
              title: l10n.phone,
              value: phone,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: ProviderProfilePage.softMint,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: ProviderProfilePage.primary, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.black.withOpacity(0.55),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: valueColor ?? Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (onTap == null) return child;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: child,
      ),
    );
  }
}

class _EditableField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const _EditableField({
    required this.icon,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: ProviderProfilePage.softMint,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: ProviderProfilePage.primary, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            decoration: InputDecoration(
              labelText: label,
              isDense: true,
              filled: true,
              fillColor: const Color(0xFFF8FAFA),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              errorMaxLines: 2,
              errorStyle: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w700,
                fontSize: 11.8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(
                  color: ProviderProfilePage.primary,
                  width: 1.2,
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(color: Colors.redAccent, width: 1.3),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;
  final bool showCancel;
  final VoidCallback? onCancelTap;

  const _CardHeader({
    required this.title,
    this.actionText,
    this.onActionTap,
    this.showCancel = false,
    this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900),
        ),
        const Spacer(),
        if (showCancel)
          TextButton(
            onPressed: onCancelTap,
            child: Text(
              l10n.cancel,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        if (actionText != null)
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onActionTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: ProviderProfilePage.softMint,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                actionText!,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: ProviderProfilePage.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final Map<String, dynamic>? summary;

  const _StatsGrid({required this.summary});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: l10n.totalOrders,
                value: "${summary?['totalOrders'] ?? 0}",
                icon: Icons.receipt_long_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: l10n.accepted,
                value: "${summary?['acceptedOrders'] ?? 0}",
                icon: Icons.check_circle_outline_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: l10n.rejected,
                value: "${summary?['rejectedOrders'] ?? 0}",
                icon: Icons.cancel_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: l10n.campaigns,
                value: "${summary?['campaignsCount'] ?? 0}",
                icon: Icons.campaign_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ProviderProfilePage.primary, size: 24),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.black.withOpacity(0.6),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CampaignsCard extends StatelessWidget {
  final List<Map<String, dynamic>> campaigns;

  const _CampaignsCard({required this.campaigns});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (campaigns.isEmpty) {
      return _WhiteCard(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              l10n.noLinkedCampaigns,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black.withOpacity(0.55),
              ),
            ),
          ),
        ),
      );
    }

    return _WhiteCard(
      child: Column(
        children: List.generate(campaigns.length, (i) {
          final c = campaigns[i];

          return Padding(
            padding: EdgeInsets.only(
              bottom: i == campaigns.length - 1 ? 0 : 12,
            ),
            child: _CampaignTile(
              campaignID: "${c['campaignID'] ?? ''}",
              title: "${c['campaignName'] ?? ''}",
              campaignNumber: "${c['campaignNumber'] ?? ''}",
              pilgrimsCount: "${c['numberOfPilgrims'] ?? 0}",
              arrivalDetails: "${c['arrivalDetails'] ?? ''}",
              providerID: "${c['providerID'] ?? ''}",
            ),
          );
        }),
      ),
    );
  }
}

class _CampaignTile extends StatelessWidget {
  final String campaignID;
  final String title;
  final String campaignNumber;
  final String pilgrimsCount;
  final String arrivalDetails;
  final String providerID;

  const _CampaignTile({
    required this.campaignID,
    required this.title,
    required this.campaignNumber,
    required this.pilgrimsCount,
    required this.arrivalDetails,
    required this.providerID,
  });

  String _safe(String value, AppLocalizations l10n) {
    final text = value.trim();
    return text.isEmpty || text == 'null' ? l10n.notAvailable : text;
  }

  void _showCampaignDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 18),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  blurRadius: 30,
                  offset: const Offset(0, 18),
                  color: Colors.black.withOpacity(0.18),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: ProviderProfilePage.softMint,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.campaign_rounded,
                    color: ProviderProfilePage.primary,
                    size: 34,
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  _safe(title, l10n),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: ProviderProfilePage.primaryDark,
                  ),
                ),

                const SizedBox(height: 16),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    _DialogBadge(text: _safe(campaignNumber, l10n)),
                    _DialogBadge(text: "$pilgrimsCount ${l10n.pilgrims}"),
                  ],
                ),

                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAF8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: ProviderProfilePage.softMint),
                  ),
                  child: Column(
                    children: [
                      _DialogDetailRow(
                        icon: Icons.confirmation_number_outlined,
                        text: "Campaign ID: ${_safe(campaignID, l10n)}",
                      ),
                      const SizedBox(height: 12),
                      _DialogDetailRow(
                        icon: Icons.info_outline_rounded,
                        text: "Arrival Details: ${_safe(arrivalDetails, l10n)}",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: ProviderProfilePage.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      l10n.close,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () => _showCampaignDialog(context),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: ProviderProfilePage.softMint.withOpacity(0.55),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.groups_2_rounded,
                color: ProviderProfilePage.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _safe(title, l10n),
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}

class _DialogBadge extends StatelessWidget {
  final String text;

  const _DialogBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F4EE),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFBEDFD5)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF35695E),
        ),
      ),
    );
  }
}

class _DialogDetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DialogDetailRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF5F6F6A)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4F5C58),
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final bool notificationsEnabled;
  final String language;
  final ValueChanged<bool> onNotificationsChanged;
  final VoidCallback onLanguageTap;

  const _SettingsCard({
    required this.notificationsEnabled,
    required this.language,
    required this.onNotificationsChanged,
    required this.onLanguageTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _WhiteCard(
      child: Column(
        children: [
          _SwitchSettingRow(
            icon: Icons.notifications_none_rounded,
            title: l10n.notification,
            value: notificationsEnabled,
            onChanged: onNotificationsChanged,
          ),
          const Divider(height: 22),
          _SettingRow(
            icon: Icons.language_rounded,
            title: l10n.language,
            value: language,
            onTap: onLanguageTap,
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _SettingRow({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: ProviderProfilePage.softMint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: ProviderProfilePage.primary, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 12.6,
                color: Colors.black.withOpacity(0.58),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}

class _SwitchSettingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchSettingRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: ProviderProfilePage.softMint,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: ProviderProfilePage.primary, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14.2, fontWeight: FontWeight.w800),
          ),
        ),
        Transform.scale(
          scale: 0.82,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: ProviderProfilePage.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          side: BorderSide(color: Colors.red.withOpacity(0.22)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: Colors.white,
        ),
        icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
        label: Text(
          l10n.logOut,
          style: const TextStyle(
            color: Colors.redAccent,
            fontSize: 14.5,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _WhiteCard extends StatelessWidget {
  final Widget child;

  const _WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 12),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: child,
    );
  }
}
