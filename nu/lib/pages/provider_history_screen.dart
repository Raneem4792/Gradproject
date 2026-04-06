import 'package:flutter/material.dart';
import '../models/meal_order.dart';
import '../services/meal_service.dart';
import '../session/user_session.dart';
import '../widgets/provider_bottom_nav.dart';
import 'provider_home_screen.dart';
import 'incoming_meal_requests_page.dart';
import 'provider_notifications_page.dart';

class ProviderHistoryScreen extends StatefulWidget {
  const ProviderHistoryScreen({super.key});
  static const routeName = '/provider-history';

  @override
  State<ProviderHistoryScreen> createState() => _ProviderHistoryScreenState();
}

class _ProviderHistoryScreenState extends State<ProviderHistoryScreen> {
  static const Color bg = Color(0xFFF1F6F4);
  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  final MealService _mealService = MealService();

  bool _isLoading = true;
  String? _error;

  List<MealOrder> _allOrders = [];
  List<MealOrder> _filteredOrders = [];
  List<Map<String, dynamic>> _campaigns = [];

  DateTime? selectedDateValue;
  String? selectedCampaignId;
  String? selectedCampaignLabel;
  String? selectedMealTypeValue;
  String? selectedStatusValue;

  String selectedDate = 'Date';
  String selectedCampaign = 'Campaign';
  String selectedMealType = 'Meal';
  String selectedStatus = 'Status';

  int _navIndex = 2;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData({String? campaignID}) async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final providerID = UserSession.userId ?? '';
      if (providerID.isEmpty) {
        throw Exception('Provider ID not found in session');
      }

      final campaigns = await _mealService.getProviderCampaigns(providerID);
      final orders = await _mealService.getOrdersByProvider(
        providerID,
        campaignID: campaignID,
      );

      setState(() {
        _campaigns = campaigns;
        _allOrders = orders;
        _filteredOrders = List<MealOrder>.from(orders);
        _isLoading = false;
      });

      _applyLocalFilters();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _openNotificationsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProviderNotificationsPage()),
    );
  }

  void _handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProviderHomeScreen()),
      );
    }
  }

  void _handleBottomNavTap(int i) {
    if (i == _navIndex) return;

    setState(() => _navIndex = i);

    if (i == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProviderHomeScreen()),
      );
    } else if (i == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IncomingMealRequestsPage()),
      );
    } else if (i == 3) {
      Navigator.pushReplacementNamed(context, '/providerProfile');
    }
  }

  String _mealTypeLabel(String value) {
    final v = value.toLowerCase().trim();

    if (v == 'breakfast') return 'Breakfast';
    if (v == 'lunch') return 'Lunch';
    if (v == 'dinner') return 'Dinner';
    if (v == 'healthy') return 'Healthy';

    return value.isEmpty ? 'Meal' : value;
  }

  String _statusLabel(String value) {
    final v = value.toLowerCase().trim();

    if (v == 'completed') return 'Completed';
    if (v == 'rejected') return 'Rejected';
    if (v == 'pending') return 'Pending';
    if (v == 'accepted') return 'Accepted';

    return value.isEmpty ? 'Status' : value;
  }

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  void _applyLocalFilters() {
    final result = _allOrders.where((order) {
      final okDate = selectedDateValue == null
          ? true
          : order.requestDate.year == selectedDateValue!.year &&
              order.requestDate.month == selectedDateValue!.month &&
              order.requestDate.day == selectedDateValue!.day;

      final okMealType = selectedMealTypeValue == null
          ? true
          : order.mealType.toLowerCase() ==
              selectedMealTypeValue!.toLowerCase();

      final okStatus = selectedStatusValue == null
          ? true
          : order.status.toLowerCase() ==
              selectedStatusValue!.toLowerCase();

      return okDate && okMealType && okStatus;
    }).toList();

    setState(() {
      _filteredOrders = result;
    });
  }

  Future<void> clearFilters() async {
    setState(() {
      selectedDateValue = null;
      selectedCampaignId = null;
      selectedCampaignLabel = null;
      selectedMealTypeValue = null;
      selectedStatusValue = null;

      selectedDate = 'Date';
      selectedCampaign = 'Campaign';
      selectedMealType = 'Meal';
      selectedStatus = 'Status';
    });

    await _loadData();
  }

  Future<void> pickDateFilter() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDateValue ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked == null) return;

    final clean = DateTime(picked.year, picked.month, picked.day);

    setState(() {
      selectedDateValue = clean;
      selectedDate = _formatDate(clean);
    });

    _applyLocalFilters();
  }

  Future<void> pickCampaignFilter() async {
    final picked = await showModalBottomSheet<Map<String, dynamic>?>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Select Campaign",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
            ListTile(
              title: const Text("All Campaigns"),
              onTap: () => Navigator.pop(ctx, null),
            ),
            ..._campaigns.map(
              (c) => ListTile(
                title: Text(c['campaignName']?.toString() ?? 'Campaign'),
                subtitle: Text(c['campaignNumber']?.toString() ?? ''),
                onTap: () => Navigator.pop(ctx, c),
              ),
            ),
          ],
        ),
      ),
    );

    if (picked == null) {
      setState(() {
        selectedCampaignId = null;
        selectedCampaignLabel = null;
        selectedCampaign = 'Campaign';
      });
      await _loadData();
      return;
    }

    final campaignID = picked['campaignID']?.toString();
    final campaignName = picked['campaignName']?.toString() ?? 'Campaign';
    final campaignNumber = picked['campaignNumber']?.toString() ?? '';

    setState(() {
      selectedCampaignId = campaignID;
      selectedCampaignLabel = campaignName;
      selectedCampaign = campaignNumber.isEmpty
          ? campaignName
          : '$campaignName • $campaignNumber';
    });

    await _loadData(campaignID: selectedCampaignId);
  }

  Future<void> pickMealTypeFilter() async {
    final mealTypes = _allOrders
        .map((e) => e.mealType.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    final picked = await showModalBottomSheet<String?>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Select Meal Type",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
            ListTile(
              title: const Text("All"),
              onTap: () => Navigator.pop(ctx, null),
            ),
            ...mealTypes.map(
              (type) => ListTile(
                title: Text(_mealTypeLabel(type)),
                onTap: () => Navigator.pop(ctx, type),
              ),
            ),
          ],
        ),
      ),
    );

    setState(() {
      selectedMealTypeValue = picked;
      selectedMealType = picked == null ? 'Meal' : _mealTypeLabel(picked);
    });

    _applyLocalFilters();
  }

  Future<void> pickStatusFilter() async {
    final statuses = _allOrders
        .map((e) => e.status.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    final picked = await showModalBottomSheet<String?>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Select Status",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
            ListTile(
              title: const Text("All"),
              onTap: () => Navigator.pop(ctx, null),
            ),
            ...statuses.map(
              (status) => ListTile(
                title: Text(_statusLabel(status)),
                onTap: () => Navigator.pop(ctx, status),
              ),
            ),
          ],
        ),
      ),
    );

    setState(() {
      selectedStatusValue = picked;
      selectedStatus = picked == null ? 'Status' : _statusLabel(picked);
    });

    _applyLocalFilters();
  }

  void _openAllReviews() {
    final reviewedOrders = _allOrders.where((e) => e.isReviewed).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProviderAllReviewsScreen(orders: reviewedOrders),
      ),
    );
  }

  void _openReviewBottomSheet(MealOrder order) {
    if (!order.isReviewed || order.reviewRating == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => _ReviewViewSheet(order: order),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: _HistoryMainAppBar(
        onBack: _handleBack,
        onTapNotifications: _openNotificationsPage,
      ),
      body: SafeArea(
        top: false,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HistoryHeaderCard(
                          title: "Order History",
                          badgeText: "${_filteredOrders.length} orders",
                          onAllReviews: _openAllReviews,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _DropdownChip(
                                label: selectedDate,
                                onTap: pickDateFilter,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _DropdownChip(
                                label: selectedCampaign,
                                onTap: pickCampaignFilter,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _DropdownChip(
                                label: selectedMealType,
                                onTap: pickMealTypeFilter,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _DropdownChip(
                                label: selectedStatus,
                                onTap: pickStatusFilter,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: clearFilters,
                            child: const Text(
                              "Clear",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._filteredOrders.map((e) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _HistoryCard(
                              order: e,
                              onViewReview: e.isReviewed
                                  ? () => _openReviewBottomSheet(e)
                                  : null,
                            ),
                          );
                        }),
                        if (_filteredOrders.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: Center(
                              child: Text(
                                "No orders found",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
      ),
      bottomNavigationBar: ProviderBottomNav(
        currentIndex: _navIndex,
        onTap: _handleBottomNavTap,
      ),
    );
  }
}

class _HistoryMainAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBack;
  final VoidCallback onTapNotifications;

  const _HistoryMainAppBar({
    required this.onBack,
    required this.onTapNotifications,
  });

  @override
  Size get preferredSize => const Size.fromHeight(58);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.6,
      shadowColor: Colors.black.withOpacity(0.08),
      surfaceTintColor: Colors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 4,
      title: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
              size: 20,
            ),
          ),
          const SizedBox(width: 2),
          const Text(
            "NUSUQ",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
      actions: [
        const SizedBox(width: 6),
      ],
    );
  }
}

class _HistoryHeaderCard extends StatelessWidget {
  final String title;
  final String badgeText;
  final VoidCallback onAllReviews;

  const _HistoryHeaderCard({
    required this.title,
    required this.badgeText,
    required this.onAllReviews,
  });

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryDark, primary, primaryMid],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            offset: const Offset(0, 14),
            color: primary.withOpacity(0.24),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.16)),
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: mint.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: mint.withOpacity(0.45)),
                ),
                child: Text(
                  badgeText,
                  style: const TextStyle(
                    fontSize: 11.8,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onAllReviews,
                borderRadius: BorderRadius.circular(16),
                child: Ink(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.16)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_border_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "All Reviews",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownChip extends StatelessWidget {
  const _DropdownChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primary.withOpacity(0.10)),
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              offset: const Offset(0, 8),
              color: primary.withOpacity(0.06),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: softMint,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: mint.withOpacity(0.50)),
              ),
              child: Icon(
                Icons.tune_rounded,
                size: 15,
                color: primary.withOpacity(0.78),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.72),
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: primary.withOpacity(0.72),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.order,
    required this.onViewReview,
  });

  final MealOrder order;
  final VoidCallback? onViewReview;

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    final pill = _StatusPill.from(order.status);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF9FCFB)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primary.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 12),
            color: primary.withOpacity(0.08),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [mint.withOpacity(0.95), primaryMid.withOpacity(0.75)],
              ),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "#${order.orderID}",
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w900,
                            color: primary.withOpacity(0.82),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          order.mealName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: primaryDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.pilgrimName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.black.withOpacity(0.70),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${order.campaignName} • ${order.campaignNumber}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black.withOpacity(0.55),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: softMint,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: mint.withOpacity(0.55),
                                ),
                              ),
                              child: Text(
                                order.formattedRequestDate,
                                style: TextStyle(
                                  fontSize: 11.8,
                                  color: primary.withOpacity(0.85),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: primary.withOpacity(0.16),
                                ),
                              ),
                              child: Text(
                                order.mealType,
                                style: TextStyle(
                                  fontSize: 11.8,
                                  color: primary.withOpacity(0.85),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 112,
                        height: 34,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: pill.bg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: pill.border),
                          ),
                          child: Text(
                            pill.text,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: pill.fg,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (order.isReviewed)
                        SizedBox(
                          width: 112,
                          height: 34,
                          child: InkWell(
                            onTap: onViewReview,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: primary,
                                  width: 1.3,
                                ),
                              ),
                              child: const Text(
                                "View Review",
                                style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill {
  final String text;
  final Color bg;
  final Color fg;
  final Color border;

  const _StatusPill({
    required this.text,
    required this.bg,
    required this.fg,
    required this.border,
  });

  static _StatusPill from(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const _StatusPill(
          text: "Completed",
          bg: Color(0xFFE7F6ED),
          fg: Color(0xFF1E7A3A),
          border: Color(0xFFCBEBD6),
        );
      case 'rejected':
        return const _StatusPill(
          text: "Rejected",
          bg: Color(0xFFFFE9E9),
          fg: Color(0xFFB3261E),
          border: Color(0xFFFFC7C7),
        );
      case 'pending':
        return const _StatusPill(
          text: "Pending",
          bg: Color(0xFFFFF6E5),
          fg: Color(0xFF9A6700),
          border: Color(0xFFFFE2A8),
        );
      case 'accepted':
        return const _StatusPill(
          text: "Accepted",
          bg: Color(0xFFE8F1FF),
          fg: Color(0xFF2457C5),
          border: Color(0xFFCFE0FF),
        );
      default:
        return const _StatusPill(
          text: "Unknown",
          bg: Color(0xFFF1F1F1),
          fg: Color(0xFF666666),
          border: Color(0xFFE0E0E0),
        );
    }
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.rating});
  final int rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating;
        return Icon(
          filled ? Icons.star : Icons.star_border,
          size: 18,
          color: filled ? const Color(0xFFF4D03F) : Colors.black38,
        );
      }),
    );
  }
}

class _ReviewViewSheet extends StatelessWidget {
  const _ReviewViewSheet({required this.order});

  final MealOrder order;

  static const Color primaryDark = Color(0xFF052720);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 44,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            Text(
              "Review • #${order.orderID}",
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: primaryDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              order.mealName,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black.withOpacity(0.70),
              ),
            ),
            const SizedBox(height: 12),
            _Stars(rating: order.reviewRating ?? 0),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: softMint,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: mint.withOpacity(0.55)),
              ),
              child: Text(
                "This order was reviewed with ${order.reviewRating ?? 0} stars.",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProviderAllReviewsScreen extends StatelessWidget {
  const ProviderAllReviewsScreen({super.key, required this.orders});

  final List<MealOrder> orders;

  static const Color bg = Color(0xFFF1F6F4);
  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    final reviewedOrders = List<MealOrder>.from(orders)
      ..sort((a, b) => b.requestDate.compareTo(a.requestDate));

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.6,
        shadowColor: Colors.black.withOpacity(0.08),
        automaticallyImplyLeading: false,
        titleSpacing: 4,
        title: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black87,
                size: 20,
              ),
            ),
            const SizedBox(width: 2),
            const Text(
              "All Reviews",
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
      body: reviewedOrders.isEmpty
          ? const Center(
              child: Text(
                "No reviews yet",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black45,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reviewedOrders.length,
              itemBuilder: (context, i) {
                final order = reviewedOrders[i];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Color(0xFFF9FCFB)],
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: primary.withOpacity(0.10)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 22,
                        offset: const Offset(0, 12),
                        color: primary.withOpacity(0.08),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 8,
                          height: 110,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                mint.withOpacity(0.95),
                                primaryMid.withOpacity(0.75),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "#${order.orderID}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: primary.withOpacity(0.82),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                order.mealName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                  color: primaryDark,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _Stars(rating: order.reviewRating ?? 0),
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: softMint,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: mint.withOpacity(0.55),
                                  ),
                                ),
                                child: Text(
                                  "${order.pilgrimName} • ${order.campaignName}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
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
            ),
    );
  }
}