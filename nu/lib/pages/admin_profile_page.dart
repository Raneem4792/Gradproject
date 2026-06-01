import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../l10n/app_localizations.dart';
import '../session/user_session.dart';
import '../widgets/admin_bottom_nav.dart';
import 'login_page.dart';

class AdminProfilePage extends StatefulWidget {
  static const String routeName = '/admin-profile';

  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  late Future<AdminProfile> _profileFuture;

  static const Color bg = Color(0xFFF3F6F5);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color softMint = Color(0xFFEAF5F2);
  static const Color gold = Color(0xFFF0E0C0);

  String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000/api';
    return 'http://10.0.2.2:3000/api';
  }

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadAdminProfile();
  }

  Future<AdminProfile> _loadAdminProfile() async {
    final adminId = UserSession.userId;

    print('ADMIN ID: $adminId');

    final response = await http.get(
      Uri.parse('$baseUrl/admin/profile/$adminId'),
    );

    print(response.body);

    if (response.statusCode == 200) {
      return AdminProfile.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to load admin profile');
  }

  Future<void> _refreshProfile() async {
    setState(() {
      _profileFuture = _loadAdminProfile();
    });

    await _profileFuture;
  }

  Future<void> _logout() async {
    final l10n = AppLocalizations.of(context)!;

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            l10n.logOut,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
          content: Text(
            l10n.logoutConfirmMessage,
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
                  color: primary,
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
        );
      },
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: bg,
      appBar: const _AdminProfileAppBar(),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 3),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          color: primary,
          onRefresh: _refreshProfile,
          child: FutureBuilder<AdminProfile>(
            future: _profileFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: primary),
                );
              }

              if (snapshot.hasError) {
                return _ErrorState(onRetry: _refreshProfile);
              }

              final admin = snapshot.data!;

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
                children: [
                  _ProfileHeaderCard(admin: admin),
                  const SizedBox(height: 18),
                  _SectionTitle(title: l10n.basicInformation),
                  const SizedBox(height: 10),
                  _AdminInfoCard(admin: admin),
                  const SizedBox(height: 16),
                  _SectionTitle(title: l10n.account),
                  const SizedBox(height: 10),
                  _AccountCard(admin: admin),
                  const SizedBox(height: 22),
                  _LogoutButton(onTap: _logout),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class AdminProfile {
  final String adminID;
  final String fullName;
  final String email;
  final String phoneNumber;

  AdminProfile({
    required this.adminID,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  factory AdminProfile.fromJson(Map<String, dynamic> json) {
    return AdminProfile(
      adminID: json['adminID']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
    );
  }
}

class _AdminProfileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _AdminProfileAppBar();

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
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final AdminProfile admin;

  const _ProfileHeaderCard({required this.admin});

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
                  colors: [
                    _AdminProfilePageState.primaryDark,
                    _AdminProfilePageState.primary,
                    _AdminProfilePageState.primaryMid,
                  ],
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
                      Icons.admin_panel_settings_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          admin.fullName.isEmpty ? l10n.admin : admin.fullName,
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
                          l10n.systemAdmin,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.86),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _HeaderChip(text: '${l10n.id}: ${admin.adminID}'),
                            _HeaderChip(text: l10n.verifiedAccount),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: -55,
              top: -45,
              child: Container(
                width: 132,
                height: 132,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.07),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final String text;

  const _HeaderChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.86),
          fontSize: 11.2,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _AdminInfoCard extends StatelessWidget {
  final AdminProfile admin;

  const _AdminInfoCard({required this.admin});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _WhiteCard(
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.person_outline_rounded,
            title: l10n.fullName,
            value: admin.fullName,
          ),
          const Divider(height: 22),
          _InfoRow(
            icon: Icons.badge_outlined,
            title: l10n.adminId,
            value: admin.adminID,
          ),
          const Divider(height: 22),
          _InfoRow(
            icon: Icons.email_outlined,
            title: l10n.email,
            value: admin.email,
          ),
          const Divider(height: 22),
          _InfoRow(
            icon: Icons.phone_outlined,
            title: l10n.phoneNumber,
            value: admin.phoneNumber,
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final AdminProfile admin;

  const _AccountCard({required this.admin});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _WhiteCard(
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.security_rounded,
            title: l10n.role,
            value: l10n.administrator,
          ),
          const Divider(height: 22),
          _InfoRow(
            icon: Icons.verified_user_outlined,
            title: l10n.status,
            value: l10n.active,
          ),
          const Divider(height: 22),
          const _LanguageRow(),
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLang = Localizations.localeOf(context).languageCode;

    final shownLanguage = currentLang == 'ar' ? l10n.arabic : l10n.english;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _showLanguageSheet(context),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _AdminProfilePageState.softMint,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.language_rounded,
              color: _AdminProfilePageState.primary,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.language,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.black.withOpacity(0.55),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  shownLanguage,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: _AdminProfilePageState.primary,
          ),
        ],
      ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLang = Localizations.localeOf(context).languageCode;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    l10n.chooseLanguage,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _LanguageOptionTile(
                  title: l10n.arabic,
                  selected: currentLang == 'ar',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    NusuqApp.of(context).setLocale(const Locale('ar'));
                  },
                ),
                _LanguageOptionTile(
                  title: l10n.english,
                  selected: currentLang == 'en',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    NusuqApp.of(context).setLocale(const Locale('en'));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOptionTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w800,
          color: Colors.black87,
        ),
      ),
      trailing: selected
          ? const Icon(
              Icons.check_rounded,
              color: _AdminProfilePageState.primary,
            )
          : null,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shownValue = value.isEmpty ? l10n.notAvailable : value;

    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _AdminProfilePageState.softMint,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: _AdminProfilePageState.primary, size: 21),
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
                shownValue,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
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
        fontSize: 13.5,
        fontWeight: FontWeight.w900,
        color: Colors.black.withOpacity(0.8),
      ),
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
            borderRadius: BorderRadius.circular(20),
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

class _ErrorState extends StatelessWidget {
  final Future<void> Function() onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 120),
        const Icon(
          Icons.error_outline_rounded,
          color: _AdminProfilePageState.primary,
          size: 58,
        ),
        const SizedBox(height: 14),
        Center(
          child: Text(
            l10n.failedToLoadAdminProfile,
            style: const TextStyle(
              color: _AdminProfilePageState.primary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Center(
          child: ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(l10n.tryAgain),
            style: ElevatedButton.styleFrom(
              backgroundColor: _AdminProfilePageState.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
