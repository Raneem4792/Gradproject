import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../models/admin_account_tree.dart';
import '../services/admin_service.dart';
import '../session/user_session.dart';
import '../widgets/admin_bottom_nav.dart';
import 'admin_dashboard_page.dart';

class AdminManageAccountsPage extends StatefulWidget {
  static const String routeName = '/admin-manage-accounts';

  const AdminManageAccountsPage({super.key});

  @override
  State<AdminManageAccountsPage> createState() =>
      _AdminManageAccountsPageState();
}

class _AdminManageAccountsPageState extends State<AdminManageAccountsPage> {
  final AdminService _adminService = AdminService();

  late Future<List<AdminProviderAccount>> _accountsFuture;

  static const Color bg = Color(0xFFF3F6F5);
  static const Color primary = Color(0xFF0D4C4A);

  @override
  void initState() {
    super.initState();
    _accountsFuture = _adminService.getAccountsTree();
  }

  Future<void> _refreshAccounts() async {
    setState(() {
      _accountsFuture = _adminService.getAccountsTree();
    });
    await _accountsFuture;
  }

  Future<void> _changeAccountStatus({
    required String accountType,
    required String accountID,
    required String currentStatus,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    final isActive = currentStatus.toLowerCase() == 'active';
    final newStatus = isActive ? 'inactive' : 'active';

    try {
      await _adminService.updateAccountStatus(
        accountType: accountType,
        accountID: accountID,
        status: newStatus,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus == 'active'
                ? l10n.accountActivatedSuccessfully
                : l10n.accountDeactivatedSuccessfully,
          ),
          backgroundColor: primary,
        ),
      );

      await _refreshAccounts();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.failedToUpdateAccountStatus),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String? _validateAccountInfo({
    required String name,
    required String email,
    required String phone,
  }) {
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    final phoneRegex = RegExp(r'^(05\d{8}|\+9665\d{8})$');
    final nameRegex = RegExp(r"^[a-zA-Z\u0600-\u06FF\s'-]{3,80}$");

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      return 'Please fill all fields';
    }

    if (!nameRegex.hasMatch(name)) {
      return 'Full name must be 3-80 letters only';
    }

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    if (!phoneRegex.hasMatch(phone)) {
      return 'Phone number must be Saudi format: 05xxxxxxxx or +9665xxxxxxxx';
    }

    return null;
  }

  Future<void> _editAccountInfo({
    required String accountType,
    required String accountID,
    required String currentName,
    required String currentEmail,
    required String currentPhone,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(text: currentName);
    final emailController = TextEditingController(text: currentEmail);
    final phoneController = TextEditingController(text: currentPhone);

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            l10n.editAccount,
            style: const TextStyle(color: primary, fontWeight: FontWeight.w900),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l10n.fullName,
                      prefixIcon: const Icon(Icons.person_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    validator: (value) {
                      final name = value?.trim() ?? '';
                      final nameRegex = RegExp(r"^[a-zA-Z\u0600-\u06FF\s'-]{3,80}$");

                      if (name.isEmpty) {
                        return 'Full name is required';
                      }

                      if (!nameRegex.hasMatch(name)) {
                        return 'Full name must be 3-80 letters only';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      prefixIcon: const Icon(Icons.email_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');

                      if (email.isEmpty) {
                        return 'Email is required';
                      }

                      if (!emailRegex.hasMatch(email)) {
                        return 'Please enter a valid email address';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.phoneNumber,
                      prefixIcon: const Icon(Icons.phone_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    validator: (value) {
                      final phone = value?.trim() ?? '';
                      final phoneRegex = RegExp(r'^(05\d{8}|\+9665\d{8})$');

                      if (phone.isEmpty) {
                        return 'Phone number is required';
                      }

                      if (!phoneRegex.hasMatch(phone)) {
                        return 'Phone must be 05xxxxxxxx or +9665xxxxxxxx';
                      }

                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                Navigator.pop(context, true);
              },
              icon: const Icon(Icons.save_rounded, size: 17),
              label: Text(l10n.save),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (saved != true) return;

    final newName = nameController.text.trim();
    final newEmail = emailController.text.trim();
    final newPhone = phoneController.text.trim();

    try {
      await _adminService.updateAccountInfo(
        accountType: accountType,
        accountID: accountID,
        fullName: newName,
        email: newEmail,
        phoneNumber: newPhone,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.accountInformationUpdatedSuccessfully),
          backgroundColor: primary,
        ),
      );

      await _refreshAccounts();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.failedToUpdateAccountInformation),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sendSpecificNotification({
    required String recipientType,
    required String recipientUserID,
    required String recipientName,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();

    final titleArController = TextEditingController();
    final titleEnController = TextEditingController();
    final messageArController = TextEditingController();
    final messageEnController = TextEditingController();

    String notificationType = 'alert';

    final sent = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                '${l10n.sendNotificationTo} $recipientName',
                style: const TextStyle(
                  color: primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: notificationType,
                        decoration: InputDecoration(
                          labelText: l10n.notificationType,
                          prefixIcon: const Icon(Icons.notifications_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'alert',
                            child: Text(l10n.alert),
                          ),
                          DropdownMenuItem(
                            value: 'announcement',
                            child: Text(l10n.announcement),
                          ),
                          DropdownMenuItem(
                            value: 'reminder',
                            child: Text(l10n.reminder),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;

                          setDialogState(() {
                            notificationType = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: titleArController,
                        textDirection: TextDirection.rtl,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: l10n.arabicTitle,
                          prefixIcon: const Icon(Icons.title_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        validator: (value) {
                          final title = value?.trim() ?? '';

                          if (title.isEmpty) {
                            return 'Arabic title is required';
                          }

                          if (title.length > 255) {
                            return 'Arabic title must be less than 255 characters';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: titleEnController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: l10n.englishTitle,
                          prefixIcon: const Icon(Icons.title_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        validator: (value) {
                          final title = value?.trim() ?? '';

                          if (title.isEmpty) {
                            return 'English title is required';
                          }

                          if (title.length > 255) {
                            return 'English title must be less than 255 characters';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: messageArController,
                        textDirection: TextDirection.rtl,
                        minLines: 3,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: l10n.arabicMessage,
                          prefixIcon: const Icon(Icons.message_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        validator: (value) {
                          final message = value?.trim() ?? '';

                          if (message.isEmpty) {
                            return 'Arabic message is required';
                          }

                          if (message.length > 1000) {
                            return 'Arabic message must be less than 1000 characters';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: messageEnController,
                        minLines: 3,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: l10n.englishMessage,
                          prefixIcon: const Icon(Icons.message_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        validator: (value) {
                          final message = value?.trim() ?? '';

                          if (message.isEmpty) {
                            return 'English message is required';
                          }

                          if (message.length > 1000) {
                            return 'English message must be less than 1000 characters';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l10n.cancel),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    Navigator.pop(context, true);
                  },
                  icon: const Icon(Icons.send_rounded, size: 17),
                  label: Text(l10n.send),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (sent != true) return;

    final titleAr = titleArController.text.trim();
    final titleEn = titleEnController.text.trim();
    final messageAr = messageArController.text.trim();
    final messageEn = messageEnController.text.trim();

    try {
      await _adminService.createNotification(
        titleAr: titleAr,
        titleEn: titleEn,
        messageAr: messageAr,
        messageEn: messageEn,
        notificationType: notificationType,
        recipientType: recipientType,
        recipientUserID: recipientUserID,
        createdByAdminID: UserSession.userId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.notificationSentSuccessfully),
          backgroundColor: primary,
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.failedToSendNotification),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: bg,
      appBar: const _AdminAccountsAppBar(),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 1),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          color: primary,
          onRefresh: _refreshAccounts,
          child: FutureBuilder<List<AdminProviderAccount>>(
            future: _accountsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: primary),
                );
              }

              if (snapshot.hasError) {
                return _ErrorState(
                  message: l10n.failedToLoadAccounts,
                  onRetry: _refreshAccounts,
                );
              }

              final providers = snapshot.data ?? [];

              if (providers.isEmpty) {
                return const _EmptyState();
              }

              final totalCampaigns = providers.fold<int>(
                0,
                (sum, provider) => sum + provider.campaigns.length,
              );

              final totalPilgrims = providers.fold<int>(
                0,
                (sum, provider) =>
                    sum +
                    provider.campaigns.fold<int>(
                      0,
                      (innerSum, campaign) =>
                          innerSum + campaign.pilgrims.length,
                    ),
              );

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
                children: [
                  _AccountsTopBlock(
                    providersCount: providers.length,
                    campaignsCount: totalCampaigns,
                    pilgrimsCount: totalPilgrims,
                  ),
                  const SizedBox(height: 18),
                  _SectionLabel(title: l10n.registeredProviders),
                  const SizedBox(height: 12),
                  ...providers.map(
                    (provider) => _ProviderCard(
                      provider: provider,
                      onStatusChanged: _changeAccountStatus,
                      onEditAccount: _editAccountInfo,
                      onSendSpecificNotification: _sendSpecificNotification,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AdminAccountsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _AdminAccountsAppBar();

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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              AdminDashboardPage.routeName,
            );
          },
        ),
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
      ),
    );
  }
}

class _AccountsTopBlock extends StatelessWidget {
  final int providersCount;
  final int campaignsCount;
  final int pilgrimsCount;

  const _AccountsTopBlock({
    required this.providersCount,
    required this.campaignsCount,
    required this.pilgrimsCount,
  });

  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color mint = Color(0xFF9FE5C9);

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
            Positioned(
              right: -36,
              top: -44,
              child: Container(
                width: 132,
                height: 132,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: mint.withOpacity(0.14),
                ),
              ),
            ),
            Positioned(
              left: -44,
              bottom: -50,
              child: Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.10),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryDark, primary, primaryMid],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.26),
                          ),
                        ),
                        child: const Icon(
                          Icons.manage_accounts_rounded,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.manageAccounts,
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
                              l10n.providersCampaignsAndPilgrims,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _StatPill(
                          title: l10n.providers,
                          value: providersCount.toString(),
                          icon: Icons.storefront_rounded,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StatPill(
                          title: l10n.campaigns,
                          value: campaignsCount.toString(),
                          icon: Icons.flag_rounded,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StatPill(
                          title: l10n.pilgrims,
                          value: pilgrimsCount.toString(),
                          icon: Icons.groups_rounded,
                        ),
                      ),
                    ],
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

class _StatPill extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatPill({
    required this.title,
    required this.value,
    required this.icon,
  });

  static const Color mint = Color(0xFF9FE5C9);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.11),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Column(
        children: [
          Icon(icon, color: mint, size: 21),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.78),
              fontSize: 11.2,
              fontWeight: FontWeight.w700,
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
        color: Colors.black.withOpacity(0.78),
      ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  final AdminProviderAccount provider;
  final Future<void> Function({
    required String accountType,
    required String accountID,
    required String currentStatus,
  })
  onStatusChanged;
  final Future<void> Function({
    required String accountType,
    required String accountID,
    required String currentName,
    required String currentEmail,
    required String currentPhone,
  })
  onEditAccount;
  final Future<void> Function({
    required String recipientType,
    required String recipientUserID,
    required String recipientName,
  })
  onSendSpecificNotification;

  const _ProviderCard({
    required this.provider,
    required this.onStatusChanged,
    required this.onEditAccount,
    required this.onSendSpecificNotification,
  });

  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color softMint = Color(0xFFF0F6F4);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final campaignsCount = provider.campaigns.length;
    final pilgrimsCount = provider.campaigns.fold<int>(
      0,
      (sum, campaign) => sum + campaign.pilgrims.length,
    );

    final providerStatus = provider.providerStatus;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 12),
            color: Colors.black.withOpacity(0.045),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(
          context,
        ).copyWith(dividerColor: Colors.transparent, splashColor: softMint),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          leading: CircleAvatar(
            radius: 23,
            backgroundColor: mint.withOpacity(0.45),
            child: Text(
              provider.providerName.isNotEmpty
                  ? provider.providerName[0].toUpperCase()
                  : 'P',
              style: const TextStyle(
                color: primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  provider.providerName,
                  style: const TextStyle(
                    color: primaryDark,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _StatusChip(status: providerStatus),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoLine(
                  icon: Icons.email_rounded,
                  text: provider.providerEmail,
                ),
                if (provider.providerPhone != null &&
                    provider.providerPhone!.isNotEmpty)
                  _InfoLine(
                    icon: Icons.phone_rounded,
                    text: provider.providerPhone!,
                  ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 7,
                  runSpacing: 6,
                  children: [
                    _SmallChip(
                      text: '$campaignsCount ${l10n.campaigns}',
                      icon: Icons.flag_rounded,
                    ),
                    _SmallChip(
                      text: '$pilgrimsCount ${l10n.pilgrims}',
                      icon: Icons.groups_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _AccountActionButton(
                      label: l10n.edit,
                      icon: Icons.edit_rounded,
                      foregroundColor: primary,
                      backgroundColor: softMint,
                      borderColor: softMint,
                      onPressed: () {
                        onEditAccount(
                          accountType: 'provider',
                          accountID: provider.providerID,
                          currentName: provider.providerName,
                          currentEmail: provider.providerEmail,
                          currentPhone: provider.providerPhone ?? '',
                        );
                      },
                    ),
                    _AccountActionButton(
                      label: l10n.notify,
                      icon: Icons.notifications_active_rounded,
                      foregroundColor: primary,
                      backgroundColor: const Color(0xFFE8F6EF),
                      borderColor: const Color(0xFFCFEEDF),
                      onPressed: () {
                        onSendSpecificNotification(
                          recipientType: 'provider',
                          recipientUserID: provider.providerID,
                          recipientName: provider.providerName,
                        );
                      },
                    ),
                    _AccountActionButton(
                      label: providerStatus == 'active'
                          ? l10n.deactivate
                          : l10n.activate,
                      icon: providerStatus == 'active'
                          ? Icons.block_rounded
                          : Icons.check_circle_rounded,
                      foregroundColor: providerStatus == 'active'
                          ? Colors.red
                          : primary,
                      backgroundColor: providerStatus == 'active'
                          ? const Color(0xFFFFEEEE)
                          : const Color(0xFFE8F6EF),
                      borderColor: providerStatus == 'active'
                          ? const Color(0xFFFFD6D6)
                          : const Color(0xFFCFEEDF),
                      onPressed: () {
                        onStatusChanged(
                          accountType: 'provider',
                          accountID: provider.providerID,
                          currentStatus: providerStatus,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          children: [
            if (provider.campaigns.isEmpty)
              _SmallEmptyMessage(
                text: l10n.noCampaignsRegisteredForThisProvider,
              )
            else
              ...provider.campaigns.map(
                (campaign) => _CampaignTile(
                  campaign: campaign,
                  onStatusChanged: onStatusChanged,
                  onEditAccount: onEditAccount,
                  onSendSpecificNotification: onSendSpecificNotification,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CampaignTile extends StatelessWidget {
  final AdminCampaign campaign;
  final Future<void> Function({
    required String accountType,
    required String accountID,
    required String currentStatus,
  })
  onStatusChanged;
  final Future<void> Function({
    required String accountType,
    required String accountID,
    required String currentName,
    required String currentEmail,
    required String currentPhone,
  })
  onEditAccount;
  final Future<void> Function({
    required String recipientType,
    required String recipientUserID,
    required String recipientName,
  })
  onSendSpecificNotification;

  const _CampaignTile({
    required this.campaign,
    required this.onStatusChanged,
    required this.onEditAccount,
    required this.onSendSpecificNotification,
  });

  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color softMint = Color(0xFFF0F6F4);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFCFB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: softMint),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          leading: CircleAvatar(
            radius: 19,
            backgroundColor: mint.withOpacity(0.45),
            child: const Icon(Icons.flag_rounded, color: primary, size: 19),
          ),
          title: Text(
            campaign.campaignName,
            style: const TextStyle(
              color: primaryDark,
              fontWeight: FontWeight.w900,
              fontSize: 14.5,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Wrap(
              spacing: 7,
              runSpacing: 6,
              children: [
                if (campaign.campaignNumber != null &&
                    campaign.campaignNumber!.isNotEmpty)
                  _SmallChip(
                    text: '${l10n.no} ${campaign.campaignNumber}',
                    icon: Icons.confirmation_number_rounded,
                  ),
                _SmallChip(
                  text: '${campaign.numberOfPilgrims} ${l10n.expected}',
                  icon: Icons.people_alt_rounded,
                ),
                _SmallChip(
                  text: '${campaign.pilgrims.length} ${l10n.registered}',
                  icon: Icons.verified_user_rounded,
                ),
              ],
            ),
          ),
          children: [
            if (campaign.arrivalDetails != null &&
                campaign.arrivalDetails!.isNotEmpty)
              _ArrivalBox(text: campaign.arrivalDetails!),
            if (campaign.pilgrims.isEmpty)
              _SmallEmptyMessage(
                text: l10n.noPilgrimsRegisteredUnderThisCampaign,
              )
            else
              ...campaign.pilgrims.map(
                (pilgrim) => _PilgrimCard(
                  pilgrim: pilgrim,
                  onStatusChanged: onStatusChanged,
                  onEditAccount: onEditAccount,
                  onSendSpecificNotification: onSendSpecificNotification,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PilgrimCard extends StatelessWidget {
  final AdminPilgrim pilgrim;
  final Future<void> Function({
    required String accountType,
    required String accountID,
    required String currentStatus,
  })
  onStatusChanged;
  final Future<void> Function({
    required String accountType,
    required String accountID,
    required String currentName,
    required String currentEmail,
    required String currentPhone,
  })
  onEditAccount;
  final Future<void> Function({
    required String recipientType,
    required String recipientUserID,
    required String recipientName,
  })
  onSendSpecificNotification;

  const _PilgrimCard({
    required this.pilgrim,
    required this.onStatusChanged,
    required this.onEditAccount,
    required this.onSendSpecificNotification,
  });

  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color softMint = Color(0xFFF0F6F4);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pilgrimStatus = pilgrim.pilgrimStatus;

    return Container(
      margin: const EdgeInsets.only(top: 9),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: softMint),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 19,
            backgroundColor: softMint,
            child: Text(
              pilgrim.pilgrimName.isNotEmpty
                  ? pilgrim.pilgrimName[0].toUpperCase()
                  : 'H',
              style: const TextStyle(
                color: primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        pilgrim.pilgrimName,
                        style: const TextStyle(
                          color: primaryDark,
                          fontWeight: FontWeight.w800,
                          fontSize: 14.2,
                        ),
                      ),
                    ),
                    _StatusChip(status: pilgrimStatus),
                  ],
                ),
                const SizedBox(height: 4),
                _InfoLine(
                  icon: Icons.email_rounded,
                  text: pilgrim.pilgrimEmail,
                ),
                if (pilgrim.pilgrimPhone != null &&
                    pilgrim.pilgrimPhone!.isNotEmpty)
                  _InfoLine(
                    icon: Icons.phone_rounded,
                    text: pilgrim.pilgrimPhone!,
                  ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _AccountActionButton(
                      label: l10n.edit,
                      icon: Icons.edit_rounded,
                      foregroundColor: primary,
                      backgroundColor: softMint,
                      borderColor: softMint,
                      onPressed: () {
                        onEditAccount(
                          accountType: 'pilgrim',
                          accountID: pilgrim.pilgrimID,
                          currentName: pilgrim.pilgrimName,
                          currentEmail: pilgrim.pilgrimEmail,
                          currentPhone: pilgrim.pilgrimPhone ?? '',
                        );
                      },
                    ),
                    _AccountActionButton(
                      label: l10n.notify,
                      icon: Icons.notifications_active_rounded,
                      foregroundColor: primary,
                      backgroundColor: const Color(0xFFE8F6EF),
                      borderColor: const Color(0xFFCFEEDF),
                      onPressed: () {
                        onSendSpecificNotification(
                          recipientType: 'pilgrim',
                          recipientUserID: pilgrim.pilgrimID,
                          recipientName: pilgrim.pilgrimName,
                        );
                      },
                    ),
                    _AccountActionButton(
                      label: pilgrimStatus == 'active'
                          ? l10n.deactivate
                          : l10n.activate,
                      icon: pilgrimStatus == 'active'
                          ? Icons.block_rounded
                          : Icons.check_circle_rounded,
                      foregroundColor: pilgrimStatus == 'active'
                          ? Colors.red
                          : primary,
                      backgroundColor: pilgrimStatus == 'active'
                          ? const Color(0xFFFFEEEE)
                          : const Color(0xFFE8F6EF),
                      borderColor: pilgrimStatus == 'active'
                          ? const Color(0xFFFFD6D6)
                          : const Color(0xFFCFEEDF),
                      onPressed: () {
                        onStatusChanged(
                          accountType: 'pilgrim',
                          accountID: pilgrim.pilgrimID,
                          currentStatus: pilgrimStatus,
                        );
                      },
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

class _AccountActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback onPressed;

  const _AccountActionButton({
    required this.label,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 15),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor),
          elevation: 0,
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 0),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isActive = status.toLowerCase() == 'active';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE8F6EF) : const Color(0xFFFFEEEE),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isActive ? l10n.active : l10n.inactive,
        style: TextStyle(
          color: isActive ? const Color(0xFF0D4C4A) : Colors.red,
          fontSize: 11.2,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _ArrivalBox extends StatelessWidget {
  final String text;

  const _ArrivalBox({required this.text});

  static const Color primary = Color(0xFF0D4C4A);
  static const Color softMint = Color(0xFFF0F6F4);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: softMint.withOpacity(0.8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.flight_land_rounded, color: primary, size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: primary,
                fontSize: 12.6,
                height: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLine({required this.icon, required this.text});

  static const Color primary = Color(0xFF0D4C4A);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: primary.withOpacity(0.75)),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black.withOpacity(0.55),
                fontSize: 12.3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallChip extends StatelessWidget {
  final String text;
  final IconData icon;

  const _SmallChip({required this.text, required this.icon});

  static const Color primary = Color(0xFF0D4C4A);
  static const Color softMint = Color(0xFFF0F6F4);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: softMint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: primary, size: 13.5),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: primary,
              fontSize: 11.2,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallEmptyMessage extends StatelessWidget {
  final String text;

  const _SmallEmptyMessage({required this.text});

  static const Color primary = Color(0xFF0D4C4A);
  static const Color softMint = Color(0xFFF0F6F4);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: softMint.withOpacity(0.8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: primary,
          fontWeight: FontWeight.w800,
          fontSize: 12.6,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  static const Color primary = Color(0xFF0D4C4A);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 120),
        const Icon(Icons.manage_accounts_rounded, color: primary, size: 58),
        const SizedBox(height: 14),
        Center(
          child: Text(
            l10n.noAccountsFound,
            style: const TextStyle(
              color: primary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            l10n.registeredAccountsWillAppearHere,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, height: 1.4),
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  static const Color primary = Color(0xFF0D4C4A);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 120),
        const Icon(Icons.error_outline_rounded, color: primary, size: 58),
        const SizedBox(height: 14),
        Center(
          child: Text(
            message,
            style: const TextStyle(
              color: primary,
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
              backgroundColor: primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
