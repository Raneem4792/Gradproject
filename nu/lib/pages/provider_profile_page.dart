import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'provider_home_screen.dart';
import '../services/provider_service.dart';
import '../session/user_session.dart';
import '../models/provider_profile.dart';

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

  bool isEditingBasicInfo = false;
  bool isChangingPassword = false;
  bool notificationsEnabled = true;
  String language = "English";

  String providerName = "";
  String providerId = "";
  String email = "";
  String phone = "";
  String location = "Makkah";
  String serviceType = "Meal Provider";

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  late final TextEditingController currentPasswordController;
  late final TextEditingController newPasswordController;
  late final TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: providerName);
    emailController = TextEditingController(text: email);
    phoneController = TextEditingController(text: phone);

    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    _loadProviderProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadProviderProfile() async {
    final providerId = UserSession.userId;

    if (providerId == null || providerId.isEmpty) {
      setState(() => _isProfileLoading = false);
      return;
    }

    try {
      final profile = await _providerService.getProfile(providerId);

      setState(() {
        providerName = profile.fullName;
        this.providerId = profile.providerID;
        email = profile.email;
        phone = profile.phoneNumber;

        nameController.text = providerName;
        emailController.text = email;
        phoneController.text = phone;

        _isProfileLoading = false;
      });
    } catch (e) {
      setState(() => _isProfileLoading = false);
    }
  }

  Future<void> _toggleBasicInfoEdit() async {
    if (isEditingBasicInfo) {
      final providerId = UserSession.userId;

      if (providerId == null || providerId.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("User session not found")));
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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Basic information updated")),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to update profile: $e")));
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

  void _changePassword() {
    setState(() {
      isChangingPassword = !isChangingPassword;
      if (!isChangingPassword) {
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      }
    });
  }

  void _savePassword() {
    final current = currentPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all password fields")),
      );
      return;
    }

    if (newPass.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("New password must be at least 8 characters"),
        ),
      );
      return;
    }

    if (newPass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("New password and confirm password do not match"),
        ),
      );
      return;
    }

    setState(() {
      isChangingPassword = false;
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password changed successfully")),
    );
  }

  Future<void> _changeLanguage() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(18, 8, 18, 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Choose Language",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: const Text("العربية"),
                  trailing: language == "العربية"
                      ? const Icon(
                          Icons.check,
                          color: ProviderProfilePage.primary,
                        )
                      : null,
                  onTap: () => Navigator.pop(context, "العربية"),
                ),
                ListTile(
                  title: const Text("English"),
                  trailing: language == "English"
                      ? const Icon(
                          Icons.check,
                          color: ProviderProfilePage.primary,
                        )
                      : null,
                  onTap: () => Navigator.pop(context, "English"),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        language = selected;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Language changed to $selected")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProviderProfilePage.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.6,
        shadowColor: Colors.black.withOpacity(0.08),
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Provider Profile',
          style: TextStyle(
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
              serviceType: serviceType,
            ),
            const SizedBox(height: 16),

            const _SectionTitle(title: "Basic Information"),
            const SizedBox(height: 10),
            if (_isProfileLoading)
              const Center(child: CircularProgressIndicator())
            else
              _InfoCard(
                isEditing: isEditingBasicInfo,
                providerName: providerName,
                providerId: providerId,
                email: email,
                phone: phone,
                location: location,
                serviceType: serviceType,
                nameController: nameController,
                emailController: emailController,
                phoneController: phoneController,
                onEditTap: _toggleBasicInfoEdit,
                onCancelTap: _cancelBasicInfoEdit,
                onChangePassword: _changePassword,
                isChangingPassword: isChangingPassword,
                currentPasswordController: currentPasswordController,
                newPasswordController: newPasswordController,
                confirmPasswordController: confirmPasswordController,
                onSavePassword: _savePassword,
              ),
            const SizedBox(height: 16),

            const _SectionTitle(title: "Orders Summary"),
            const SizedBox(height: 10),
            const _StatsGrid(),
            const SizedBox(height: 16),

            const _SectionTitle(title: "Linked Campaigns"),
            const SizedBox(height: 10),
            const _CampaignsCard(),
            const SizedBox(height: 16),

            const _SectionTitle(title: "Settings"),
            const SizedBox(height: 10),
            _SettingsCard(
              notificationsEnabled: notificationsEnabled,
              language: language,
              onNotificationsChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
              onLanguageTap: _changeLanguage,
            ),
            const SizedBox(height: 22),

            const _LogoutButton(),
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
  final String serviceType;

  const _ProfileHeaderCard({
    required this.providerName,
    required this.providerId,
    required this.serviceType,
  });

  @override
  Widget build(BuildContext context) {
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
                        "Provider ID: ${providerId.isEmpty ? 'Not Available' : providerId}",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.82),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Service: ${serviceType.isEmpty ? 'Not Available' : serviceType}",
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
                        child: const Text(
                          "Verified Account",
                          style: TextStyle(
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
  final String location;
  final String serviceType;

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  final VoidCallback onEditTap;
  final VoidCallback onCancelTap;
  final VoidCallback onChangePassword;
  final bool isChangingPassword;
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSavePassword;

  const _InfoCard({
    required this.isEditing,
    required this.providerName,
    required this.providerId,
    required this.email,
    required this.phone,
    required this.location,
    required this.serviceType,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.onEditTap,
    required this.onCancelTap,
    required this.onChangePassword,
    required this.isChangingPassword,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.onSavePassword,
  });

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: [
          _CardHeader(
            title: "Provider Details",
            actionText: isEditing ? "Save" : "Edit",
            onActionTap: onEditTap,
            showCancel: isEditing,
            onCancelTap: onCancelTap,
          ),
          const SizedBox(height: 10),
          if (isEditing) ...[
            _EditableField(
              icon: Icons.storefront_outlined,
              label: "Provider Name",
              controller: nameController,
            ),
            const SizedBox(height: 14),
            _EditableField(
              icon: Icons.email_outlined,
              label: "Email",
              controller: emailController,
            ),
            const SizedBox(height: 14),
            _EditableField(
              icon: Icons.phone_outlined,
              label: "Phone",
              controller: phoneController,
            ),
            const SizedBox(height: 14),
            _InfoRow(
              icon: Icons.lock_outline_rounded,
              title: "Password",
              value: "Change Password",
              valueColor: ProviderProfilePage.primary,
              onTap: onChangePassword,
            ),
          ] else ...[
            _InfoRow(
              icon: Icons.storefront_outlined,
              title: "Provider Name",
              value: providerName,
            ),
            const Divider(height: 22),
            _InfoRow(
              icon: Icons.badge_outlined,
              title: "Provider ID",
              value: providerId,
            ),
            const Divider(height: 22),
            _InfoRow(icon: Icons.email_outlined, title: "Email", value: email),
            const Divider(height: 22),
            _InfoRow(icon: Icons.phone_outlined, title: "Phone", value: phone),
            const Divider(height: 22),
            _InfoRow(
              icon: Icons.location_on_outlined,
              title: "Location",
              value: location,
            ),
            const Divider(height: 22),
            _InfoRow(
              icon: Icons.room_service_outlined,
              title: "Service Type",
              value: serviceType,
            ),
            const Divider(height: 22),
            _InfoRow(
              icon: Icons.lock_outline_rounded,
              title: "Password",
              value: "Change Password",
              valueColor: ProviderProfilePage.primary,
              onTap: onChangePassword,
            ),
          ],
          if (isChangingPassword) ...[
            const SizedBox(height: 14),
            _EditableField(
              icon: Icons.lock_outline_rounded,
              label: "Current Password",
              controller: currentPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            _EditableField(
              icon: Icons.lock_reset_rounded,
              label: "New Password",
              controller: newPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            _EditableField(
              icon: Icons.lock_person_rounded,
              label: "Confirm New Password",
              controller: confirmPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSavePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ProviderProfilePage.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Save New Password",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
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

  const _EditableField({
    required this.icon,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
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
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            decoration: InputDecoration(
              labelText: label,
              isDense: true,
              filled: true,
              fillColor: const Color(0xFFF8FAFA),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
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
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
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
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: "Total Orders",
                value: "145",
                icon: Icons.receipt_long_rounded,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: "Accepted",
                value: "120",
                icon: Icons.check_circle_outline_rounded,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: "Rejected",
                value: "25",
                icon: Icons.cancel_outlined,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: "Campaigns",
                value: "3",
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
  const _CampaignsCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: const [
          _CampaignTile(
            title: "Al Noor Hajj Campaign",
            campaignId: "CN-1001",
            pilgrimsCount: "45 pilgrims",
            arrivalDay: "Monday",
            arrivalDate: "25/05/2026",
            arrivalTime: "2:30 PM",
            fromCountry: "Indonesia",
          ),
          SizedBox(height: 12),
          _CampaignTile(
            title: "Rahma Hajj Campaign",
            campaignId: "CN-1002",
            pilgrimsCount: "38 pilgrims",
            arrivalDay: "Wednesday",
            arrivalDate: "27/05/2026",
            arrivalTime: "11:00 AM",
            fromCountry: "Turkey",
          ),
          SizedBox(height: 12),
          _CampaignTile(
            title: "Al Huda Hajj Campaign",
            campaignId: "CN-1003",
            pilgrimsCount: "52 pilgrims",
            arrivalDay: "Friday",
            arrivalDate: "29/05/2026",
            arrivalTime: "4:15 PM",
            fromCountry: "Malaysia",
          ),
        ],
      ),
    );
  }
}

class _CampaignTile extends StatelessWidget {
  final String title;
  final String campaignId;
  final String pilgrimsCount;
  final String arrivalDay;
  final String arrivalDate;
  final String arrivalTime;
  final String fromCountry;

  const _CampaignTile({
    required this.title,
    required this.campaignId,
    required this.pilgrimsCount,
    required this.arrivalDay,
    required this.arrivalDate,
    required this.arrivalTime,
    required this.fromCountry,
  });

  void _showCampaignDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAF8),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 8,
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8ED8C0),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF133B33),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F4EE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.campaign_rounded,
                              color: Color(0xFF2D6B5F),
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 10,
                                  children: [
                                    _DialogBadge(text: campaignId),
                                    _DialogBadge(text: pilgrimsCount),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                _DialogDetailRow(
                                  icon: Icons.calendar_today_outlined,
                                  text:
                                      "Arrival Day: $arrivalDay • $arrivalDate",
                                ),
                                const SizedBox(height: 10),
                                _DialogDetailRow(
                                  icon: Icons.access_time_rounded,
                                  text:
                                      "Arrival Time: $arrivalTime • From $fromCountry",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Close",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                title,
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
    return _WhiteCard(
      child: Column(
        children: [
          _SwitchSettingRow(
            icon: Icons.notifications_none_rounded,
            title: "Notification",
            value: notificationsEnabled,
            onChanged: onNotificationsChanged,
          ),
          const Divider(height: 22),
          _SettingRow(
            icon: Icons.language_rounded,
            title: "Language",
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
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          side: BorderSide(color: Colors.red.withOpacity(0.22)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: Colors.white,
        ),
        icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
        label: const Text(
          "Log Out",
          style: TextStyle(
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
