import 'package:flutter/material.dart';

import '../models/admin_orders_monitor.dart';
import '../services/admin_service.dart';
import '../widgets/admin_bottom_nav.dart';

class AdminMonitorOrdersPage extends StatefulWidget {
  static const String routeName = '/admin-monitor-orders';

  const AdminMonitorOrdersPage({super.key});

  @override
  State<AdminMonitorOrdersPage> createState() =>
      _AdminMonitorOrdersPageState();
}

class _AdminMonitorOrdersPageState extends State<AdminMonitorOrdersPage> {
  final AdminService _adminService = AdminService();

  late Future<List<AdminOrdersCampaign>> _ordersFuture;

  static const Color bg = Color(0xFFF1F7F4);
  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);

  @override
  void initState() {
    super.initState();
    _ordersFuture = _adminService.getOrdersMonitor();
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _ordersFuture = _adminService.getOrdersMonitor();
    });
    await _ordersFuture;
  }

  int _totalOrders(List<AdminOrdersCampaign> campaigns) {
    return campaigns.fold<int>(
      0,
      (sum, campaign) => sum + campaign.orders.length,
    );
  }

  int _activeOrders(List<AdminOrdersCampaign> campaigns) {
    return campaigns.fold<int>(
      0,
      (sum, campaign) =>
          sum +
          campaign.orders.where((order) {
            final status = order.status.toLowerCase();
            return status == 'pending' || status == 'accepted';
          }).length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: const _AdminOrdersAppBar(),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 2),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          color: primary,
          onRefresh: _refreshOrders,
          child: FutureBuilder<List<AdminOrdersCampaign>>(
            future: _ordersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: primary),
                );
              }

              if (snapshot.hasError) {
                return _ErrorState(
                  message: 'Failed to load orders.',
                  onRetry: _refreshOrders,
                );
              }

              final campaigns = snapshot.data ?? [];

              if (campaigns.isEmpty) {
                return const _EmptyState();
              }

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
                children: [
                  _OrdersTopBlock(
                    campaignsCount: campaigns.length,
                    totalOrders: _totalOrders(campaigns),
                    activeOrders: _activeOrders(campaigns),
                  ),
                  const SizedBox(height: 18),
                  const _SectionLabel(title: 'Campaign Orders'),
                  const SizedBox(height: 12),
                  ...campaigns.map(
                    (campaign) => _CampaignOrdersCard(campaign: campaign),
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

class _AdminOrdersAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AdminOrdersAppBar();

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

class _OrdersTopBlock extends StatelessWidget {
  final int campaignsCount;
  final int totalOrders;
  final int activeOrders;

  const _OrdersTopBlock({
    required this.campaignsCount,
    required this.totalOrders,
    required this.activeOrders,
  });

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color gold = Color(0xFFF0E0C0);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryDark, primary, primaryMid],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Monitor Orders',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'View all meal orders grouped by campaigns and their assigned providers.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.86),
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
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
                        title: 'Orders',
                        value: totalOrders.toString(),
                        icon: Icons.shopping_bag_rounded,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatPill(
                        title: 'Active',
                        value: activeOrders.toString(),
                        icon: Icons.timelapse_rounded,
                      ),
                    ),
                  ],
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

  static const Color mint = Color(0xFFA8E7CF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
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
              fontWeight: FontWeight.w900,
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

class _CampaignOrdersCard extends StatelessWidget {
  final AdminOrdersCampaign campaign;

  const _CampaignOrdersCard({required this.campaign});

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE8F3F1);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          leading: CircleAvatar(
            radius: 23,
            backgroundColor: mint.withOpacity(0.45),
            child: const Icon(Icons.flag_rounded, color: primary),
          ),
          title: Text(
            campaign.campaignName,
            style: const TextStyle(
              color: primaryDark,
              fontSize: 15.5,
              fontWeight: FontWeight.w900,
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
                  text: campaign.provider.providerName,
                  icon: Icons.storefront_rounded,
                ),
                _SmallChip(
                  text: '${campaign.orders.length} orders',
                  icon: Icons.receipt_long_rounded,
                ),
              ],
            ),
          ),
          children: [
            _ProviderBox(provider: campaign.provider),
            if (campaign.orders.isEmpty)
              const _SmallEmptyMessage(
                text: 'No orders found under this campaign.',
              )
            else
              ...campaign.orders.map(
                (order) => _OrderCard(order: order),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProviderBox extends StatelessWidget {
  final AdminOrdersProvider provider;

  const _ProviderBox({required this.provider});

  static const Color primary = Color(0xFF0B4A40);
  static const Color softMint = Color(0xFFE8F3F1);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: softMint.withOpacity(0.8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.storefront_rounded, color: primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${provider.providerName} • ${provider.providerEmail}',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: primary,
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final AdminOrderItem order;

  const _OrderCard({required this.order});

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color softMint = Color(0xFFE8F3F1);

  Color _statusColor(String status) {
    final value = status.toLowerCase();

    if (value == 'completed') return const Color(0xFF157347);
    if (value == 'accepted') return const Color(0xFF0D6EFD);
    if (value == 'rejected' || value == 'cancelled') {
      return const Color(0xFFB42318);
    }

    return const Color(0xFFC78200);
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return 'No date';

    final date = DateTime.tryParse(value);
    if (date == null) return value;

    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(order.status);

    return Container(
      margin: const EdgeInsets.only(top: 9),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: softMint),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: softMint,
                child: Text(
                  '#${order.orderID}',
                  style: const TextStyle(
                    color: primary,
                    fontSize: 10.5,
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
                      order.mealName,
                      style: const TextStyle(
                        color: primaryDark,
                        fontWeight: FontWeight.w900,
                        fontSize: 14.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${order.mealType} • ${order.calories} calories',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.55),
                        fontWeight: FontWeight.w600,
                        fontSize: 12.2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 11.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _InfoLine(
            icon: Icons.person_rounded,
            text: order.pilgrimName,
          ),
          _InfoLine(
            icon: Icons.email_rounded,
            text: order.pilgrimEmail,
          ),
          _InfoLine(
            icon: Icons.calendar_month_rounded,
            text: _formatDate(order.requestDate),
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

  static const Color primary = Color(0xFF0B4A40);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
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

  static const Color primary = Color(0xFF0B4A40);
  static const Color softMint = Color(0xFFE8F3F1);

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

  static const Color primary = Color(0xFF0B4A40);
  static const Color softMint = Color(0xFFE8F3F1);

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

  static const Color primary = Color(0xFF0B4A40);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: const [
        SizedBox(height: 120),
        Icon(Icons.receipt_long_rounded, color: primary, size: 58),
        SizedBox(height: 14),
        Center(
          child: Text(
            'No orders found',
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
            'Meal orders will appear here grouped by campaign and provider.',
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

  static const Color primary = Color(0xFF0B4A40);

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