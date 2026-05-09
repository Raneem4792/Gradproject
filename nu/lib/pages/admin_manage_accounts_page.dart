import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/admin_account_tree.dart';
import '../services/admin_service.dart';
import '../widgets/admin_bottom_nav.dart';

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

  @override
  Widget build(BuildContext context) {
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
                  message: 'Failed to load accounts.',
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
                  const _SectionLabel(title: 'Registered Providers'),
                  const SizedBox(height: 12),
                  ...providers.map(
                    (provider) => _ProviderCard(provider: provider),
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
                            const Text(
                              'Manage Accounts',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Providers, campaigns, and pilgrims',
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
                          title: 'Providers',
                          value: providersCount.toString(),
                          icon: Icons.storefront_rounded,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StatPill(
                          title: 'Campaigns',
                          value: campaignsCount.toString(),
                          icon: Icons.flag_rounded,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StatPill(
                          title: 'Pilgrims',
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

  const _ProviderCard({required this.provider});

  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color softMint = Color(0xFFF0F6F4);

  @override
  Widget build(BuildContext context) {
    final campaignsCount = provider.campaigns.length;
    final pilgrimsCount = provider.campaigns.fold<int>(
      0,
      (sum, campaign) => sum + campaign.pilgrims.length,
    );

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
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: softMint,
        ),
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
          title: Text(
            provider.providerName,
            style: const TextStyle(
              color: primaryDark,
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
            ),
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
                      text: '$campaignsCount campaigns',
                      icon: Icons.flag_rounded,
                    ),
                    _SmallChip(
                      text: '$pilgrimsCount pilgrims',
                      icon: Icons.groups_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
          children: [
            if (provider.campaigns.isEmpty)
              const _SmallEmptyMessage(
                text: 'No campaigns registered for this provider.',
              )
            else
              ...provider.campaigns.map(
                (campaign) => _CampaignTile(campaign: campaign),
              ),
          ],
        ),
      ),
    );
  }
}

class _CampaignTile extends StatelessWidget {
  final AdminCampaign campaign;

  const _CampaignTile({required this.campaign});

  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color softMint = Color(0xFFF0F6F4);

  @override
  Widget build(BuildContext context) {
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
            child: const Icon(
              Icons.flag_rounded,
              color: primary,
              size: 19,
            ),
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
                    text: 'No. ${campaign.campaignNumber}',
                    icon: Icons.confirmation_number_rounded,
                  ),
                _SmallChip(
                  text: '${campaign.numberOfPilgrims} expected',
                  icon: Icons.people_alt_rounded,
                ),
                _SmallChip(
                  text: '${campaign.pilgrims.length} registered',
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
              const _SmallEmptyMessage(
                text: 'No pilgrims registered under this campaign.',
              )
            else
              ...campaign.pilgrims.map(
                (pilgrim) => _PilgrimCard(pilgrim: pilgrim),
              ),
          ],
        ),
      ),
    );
  }
}

class _PilgrimCard extends StatelessWidget {
  final AdminPilgrim pilgrim;

  const _PilgrimCard({required this.pilgrim});

  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color softMint = Color(0xFFF0F6F4);

  @override
  Widget build(BuildContext context) {
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
                Text(
                  pilgrim.pilgrimName,
                  style: const TextStyle(
                    color: primaryDark,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.2,
                  ),
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
              ],
            ),
          ),
        ],
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

  const _InfoLine({
    required this.icon,
    required this.text,
  });

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

  const _SmallChip({
    required this.text,
    required this.icon,
  });

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
    return ListView(
      padding: const EdgeInsets.all(24),
      children: const [
        SizedBox(height: 120),
        Icon(Icons.manage_accounts_rounded, color: primary, size: 58),
        SizedBox(height: 14),
        Center(
          child: Text(
            'No accounts found',
            style: TextStyle(
              color: primary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        SizedBox(height: 6),
        Center(
          child: Text(
            'Registered providers, campaigns, and pilgrims will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, height: 1.4),
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  static const Color primary = Color(0xFF0D4C4A);

  @override
  Widget build(BuildContext context) {
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
            label: const Text('Try again'),
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